import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'storage_service.dart';

enum GameImageSource { camera, gallery, files }

enum CameraPermissionResult { granted, denied, openedSettings }

final gameImageServiceProvider = Provider<GameImageService>((ref) {
  return GameImageService(ref.read(storageServiceProvider));
});

class GameImageService {
  static const int maxImageSize = 256;
  static const String imageDirectory = 'game_images';
  static const List<String> supportedExtensions = ['jpg', 'jpeg', 'png'];

  final StorageService _storageService;
  final ImagePicker _imagePicker = ImagePicker();

  GameImageService(this._storageService);

  /// Selects an image from the specified source
  Future<String?> selectAndSaveImage(GameImageSource source) async {
    try {
      final File? imageFile = await _selectImageFile(source);
      if (imageFile == null) return null;

      final String? savedPath = await _processAndSaveImage(imageFile);
      return savedPath;
    } catch (e) {
      debugPrint('Error selecting image: $e');
      return null;
    }
  }

  Future<CameraPermissionResult> checkAndRequestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return CameraPermissionResult.granted;
    }

    if (status.isPermanentlyDenied) {
      return CameraPermissionResult.denied;
    }

    final PermissionStatus result = await Permission.camera.request();
    if (result.isGranted) {
      return CameraPermissionResult.granted;
    }

    return CameraPermissionResult.denied;
  }

  Future<bool> openCameraSettings() async {
    return await openAppSettings();
  }

  /// Deletes a game image from storage
  Future<bool> deleteImage(String imagePath) async {
    try {
      final File imageFile = await _getImageFile(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Gets the full file path for an image using persistent storage
  Future<File> _getImageFile(String imagePath) async {
    final Directory appDir =
        await _storageService.getPersistentStorageDirectory();
    return File(path.join(appDir.path, imagePath));
  }

  /// Checks if an image file exists
  Future<bool> imageExists(String imagePath) async {
    try {
      final File imageFile = await _getImageFile(imagePath);
      return await imageFile.exists();
    } catch (e) {
      debugPrint('Error checking if image exists: $e');
      return false;
    }
  }

  /// Gets the full file path for display
  Future<String> getImagePath(String imagePath) async {
    final Directory appDir =
        await _storageService.getPersistentStorageDirectory();
    // If imagePath already includes game_images directory, use it as-is
    // Otherwise, construct the full path with game_images subdirectory
    if (imagePath.startsWith(imageDirectory)) {
      return path.join(appDir.path, imagePath);
    } else {
      return path.join(appDir.path, imageDirectory, imagePath);
    }
  }

  /// Selects image file from the specified source
  Future<File?> _selectImageFile(GameImageSource source) async {
    switch (source) {
      case GameImageSource.camera:
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: maxImageSize.toDouble(),
          maxHeight: maxImageSize.toDouble(),
          imageQuality: 85,
        );
        return pickedFile != null ? File(pickedFile.path) : null;

      case GameImageSource.gallery:
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: maxImageSize.toDouble(),
          maxHeight: maxImageSize.toDouble(),
          imageQuality: 85,
        );
        return pickedFile != null ? File(pickedFile.path) : null;

      case GameImageSource.files:
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: supportedExtensions,
        );

        if (result != null && result.files.single.path != null) {
          return File(result.files.single.path!);
        }
        return null;
    }
  }

  /// Processes and saves image to persistent storage
  Future<String?> _processAndSaveImage(File imageFile) async {
    try {
      // Read and validate image bytes
      final Uint8List imageBytes = await imageFile.readAsBytes();
      
      if (imageBytes.isEmpty) {
        debugPrint('Image file is empty');
        return null;
      }

      // Decode image with detailed error handling
      img.Image? originalImage;
      try {
        debugPrint('[ImageProcessing] Starting image decode, bytes length: ${imageBytes.length}');
        originalImage = img.decodeImage(imageBytes);
        if (originalImage != null) {
          debugPrint('[ImageProcessing] Successfully decoded image: ${originalImage.width}x${originalImage.height}, format: ${originalImage.format}, channels: ${originalImage.numChannels}');
        }
      } catch (e, stackTrace) {
        debugPrint('[ImageProcessing] DECODE ERROR: $e');
        debugPrint('[ImageProcessing] Stack trace: $stackTrace');
        debugPrint('[ImageProcessing] Image bytes length: ${imageBytes.length}');
        debugPrint('[ImageProcessing] First 20 bytes: ${imageBytes.take(20).toList()}');
        return null;
      }

      if (originalImage == null) {
        debugPrint('[ImageProcessing] Image decoding returned null - unsupported format');
        debugPrint('[ImageProcessing] Image bytes length: ${imageBytes.length}');
        debugPrint('[ImageProcessing] First 20 bytes: ${imageBytes.take(20).toList()}');
        return null;
      }

      debugPrint('[ImageProcessing] Original image details:');
      debugPrint('[ImageProcessing] - Dimensions: ${originalImage.width}x${originalImage.height}');
      debugPrint('[ImageProcessing] - Format: ${originalImage.format}');
      debugPrint('[ImageProcessing] - Channels: ${originalImage.numChannels}');
      debugPrint('[ImageProcessing] - Max image size limit: $maxImageSize');

      // Validate image dimensions
      if (originalImage.width <= 0 || originalImage.height <= 0) {
        debugPrint('[ImageProcessing] INVALID DIMENSIONS: ${originalImage.width}x${originalImage.height}');
        return null;
      }

      // Check for extremely large images that might cause memory issues
      if (originalImage.width > 20000 || originalImage.height > 20000) {
        debugPrint('[ImageProcessing] IMAGE TOO LARGE: ${originalImage.width}x${originalImage.height}');
        return null;
      }

      // Resize image if needed
      img.Image processedImage = originalImage;
      if (originalImage.width > maxImageSize ||
          originalImage.height > maxImageSize) {
        debugPrint('[ImageProcessing] Image needs resizing from ${originalImage.width}x${originalImage.height} to max $maxImageSize');
        
        // Calculate target dimensions
        int? targetWidth;
        int? targetHeight;
        
        if (originalImage.width > originalImage.height) {
          targetWidth = maxImageSize;
          targetHeight = null;
          debugPrint('[ImageProcessing] Landscape image - targeting width: $targetWidth');
        } else {
          targetWidth = null;
          targetHeight = maxImageSize;
          debugPrint('[ImageProcessing] Portrait/Square image - targeting height: $targetHeight');
        }
        
        try {
          debugPrint('[ImageProcessing] Starting resize operation...');
          processedImage = img.copyResize(
            originalImage,
            width: targetWidth,
            height: targetHeight,
          );
          debugPrint('[ImageProcessing] Resize successful! New dimensions: ${processedImage.width}x${processedImage.height}');
        } catch (e, stackTrace) {
          debugPrint('[ImageProcessing] RESIZE ERROR: $e');
          debugPrint('[ImageProcessing] Stack trace: $stackTrace');
          debugPrint('[ImageProcessing] Original image: ${originalImage.width}x${originalImage.height}');
          debugPrint('[ImageProcessing] Target width: $targetWidth, Target height: $targetHeight');
          debugPrint('[ImageProcessing] Image format: ${originalImage.format}');
          debugPrint('[ImageProcessing] Image channels: ${originalImage.numChannels}');
          return null;
        }
      } else {
        debugPrint('[ImageProcessing] Image does not need resizing');
      }

      // Encode as JPEG with compression
      Uint8List processedBytes;
      try {
        debugPrint('[ImageProcessing] Starting JPEG encoding...');
        debugPrint('[ImageProcessing] Processed image: ${processedImage.width}x${processedImage.height}');
        debugPrint('[ImageProcessing] Image format: ${processedImage.format}, channels: ${processedImage.numChannels}');
        
        processedBytes = Uint8List.fromList(
          img.encodeJpg(processedImage, quality: 85),
        );
        debugPrint('[ImageProcessing] JPEG encoding successful! Output size: ${processedBytes.length} bytes');
      } catch (e, stackTrace) {
        debugPrint('[ImageProcessing] JPEG ENCODING ERROR: $e');
        debugPrint('[ImageProcessing] Stack trace: $stackTrace');
        debugPrint('[ImageProcessing] Image being encoded: ${processedImage.width}x${processedImage.height}');
        debugPrint('[ImageProcessing] Image format: ${processedImage.format}');
        debugPrint('[ImageProcessing] Image channels: ${processedImage.numChannels}');
        return null;
      }

      if (processedBytes.isEmpty) {
        debugPrint('[ImageProcessing] JPEG encoding produced empty result');
        debugPrint('[ImageProcessing] Input image: ${processedImage.width}x${processedImage.height}');
        return null;
      }

      return await _saveImageBytes(processedBytes);
    } catch (e) {
      debugPrint('Error processing image: $e');
      return null;
    }
  }

  /// Downloads an image from a URL and saves it to persistent storage
  Future<String?> downloadAndSaveImageFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Validate the image data before processing
        if (response.bodyBytes.isEmpty) {
          debugPrint('Downloaded image is empty');
          return null;
        }

        // Try to decode the image first to validate it's a valid image
        try {
          debugPrint('[ImageDownload] Validating downloaded image, bytes: ${response.bodyBytes.length}');
          final img.Image? testImage = img.decodeImage(response.bodyBytes);
          if (testImage == null) {
            debugPrint('[ImageDownload] Downloaded data is not a valid image format');
            debugPrint('[ImageDownload] First 20 bytes: ${response.bodyBytes.take(20).toList()}');
            return null;
          }
          
          debugPrint('[ImageDownload] Downloaded image validated: ${testImage.width}x${testImage.height}');
          
          // Check for reasonable image dimensions
          if (testImage.width <= 0 || testImage.height <= 0 || 
              testImage.width > 10000 || testImage.height > 10000) {
            debugPrint('[ImageDownload] Image has invalid dimensions: ${testImage.width}x${testImage.height}');
            return null;
          }
        } catch (e, stackTrace) {
          debugPrint('[ImageDownload] Error validating downloaded image: $e');
          debugPrint('[ImageDownload] Stack trace: $stackTrace');
          debugPrint('[ImageDownload] Response bytes length: ${response.bodyBytes.length}');
          debugPrint('[ImageDownload] First 20 bytes: ${response.bodyBytes.take(20).toList()}');
          return null;
        }

        // Create a temporary file with the downloaded bytes
        final Directory tempDir = Directory.systemTemp;
        final String tempFileName = 'temp_download_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File tempFile = File('${tempDir.path}/$tempFileName');
        await tempFile.writeAsBytes(response.bodyBytes);
        
        // Use the existing processing logic
        final String? result = await _processAndSaveImage(tempFile);
        
        // Clean up temporary file
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
        
        return result;
      } else {
        debugPrint('Failed to download image: HTTP ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  /// Save image bytes to persistent storage and return relative path
  Future<String> _saveImageBytes(Uint8List imageBytes) async {
    // Create unique filename
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String randomSuffix = Random()
        .nextInt(1000)
        .toString()
        .padLeft(3, '0');
    final String filename = 'game_${timestamp}_$randomSuffix.jpg';

    // Ensure directory exists using persistent storage
    final Directory appDir =
        await _storageService.getPersistentStorageDirectory();
    final Directory imageDir = Directory(
      path.join(appDir.path, imageDirectory),
    );
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    // Save file
    final String fullPath = path.join(imageDir.path, filename);
    final File imageFile = File(fullPath);
    await imageFile.writeAsBytes(imageBytes);

    // Return relative path for storage in model
    return path.join(imageDirectory, filename);
  }
}
