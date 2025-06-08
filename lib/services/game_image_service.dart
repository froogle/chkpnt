import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

enum GameImageSource { gallery, files }

final gameImageServiceProvider = Provider<GameImageService>((ref) {
  return GameImageService();
});

class GameImageService {
  static const int maxImageSize = 1024;
  static const String imageDirectory = 'game_images';
  static const List<String> supportedExtensions = ['jpg', 'jpeg', 'png'];

  final ImagePicker _imagePicker = ImagePicker();

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

  /// Gets the full file path for an image
  Future<File> _getImageFile(String imagePath) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    return File(path.join(appDir.path, imagePath));
  }

  /// Checks if an image file exists
  Future<bool> imageExists(String imagePath) async {
    try {
      final File imageFile = await _getImageFile(imagePath);
      return await imageFile.exists();
    } catch (e) {
      return false;
    }
  }

  /// Gets the image file for display
  Future<File?> getImageFile(String imagePath) async {
    try {
      final File imageFile = await _getImageFile(imagePath);
      if (await imageFile.exists()) {
        return imageFile;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Private methods

  Future<File?> _selectImageFile(GameImageSource source) async {
    switch (source) {
      case GameImageSource.gallery:
        return await _selectFromGallery();
      case GameImageSource.files:
        return await _selectFromFiles();
    }
  }

  Future<File?> _selectFromGallery() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> _selectFromFiles() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: supportedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<String?> _processAndSaveImage(File imageFile) async {
    try {
      // Read and decode the image
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      // Resize the image if necessary
      final img.Image resizedImage = _resizeImage(originalImage);

      // Encode as JPEG with 85% quality
      final Uint8List processedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: 85),
      );

      // Save to app storage
      final String savedPath = await _saveImageBytes(processedBytes);
      return savedPath;
    } catch (e) {
      debugPrint('Error processing image: $e');
      return null;
    }
  }

  img.Image _resizeImage(img.Image image) {
    // If image is already within size limits, return as-is
    if (image.width <= maxImageSize && image.height <= maxImageSize) {
      return image;
    }

    // Calculate new dimensions maintaining aspect ratio
    final double aspectRatio = image.width / image.height;
    int newWidth, newHeight;

    if (image.width > image.height) {
      newWidth = maxImageSize;
      newHeight = (maxImageSize / aspectRatio).round();
    } else {
      newHeight = maxImageSize;
      newWidth = (maxImageSize * aspectRatio).round();
    }

    return img.copyResize(image, width: newWidth, height: newHeight);
  }

  Future<String> _saveImageBytes(Uint8List imageBytes) async {
    // Create unique filename
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String randomSuffix = Random()
        .nextInt(1000)
        .toString()
        .padLeft(3, '0');
    final String filename = 'game_${timestamp}_$randomSuffix.jpg';

    // Ensure directory exists
    final Directory appDir = await getApplicationDocumentsDirectory();
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
