import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'storage_service.dart';

enum GameImageSource { gallery, files }

final gameImageServiceProvider = Provider<GameImageService>((ref) {
  return GameImageService(ref.read(storageServiceProvider));
});

class GameImageService {
  static const int maxImageSize = 1024;
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
      // Read and decode image
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        debugPrint('Failed to decode image');
        return null;
      }

      // Resize image if needed
      img.Image processedImage = originalImage;
      if (originalImage.width > maxImageSize ||
          originalImage.height > maxImageSize) {
        processedImage = img.copyResize(
          originalImage,
          width:
              originalImage.width > originalImage.height ? maxImageSize : null,
          height:
              originalImage.height > originalImage.width ? maxImageSize : null,
        );
      }

      // Encode as JPEG
      final Uint8List processedBytes = Uint8List.fromList(
        img.encodeJpg(processedImage, quality: 85),
      );

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
        final Uint8List imageBytes = response.bodyBytes;
        return await _saveImageBytes(imageBytes);
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
