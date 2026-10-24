import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'storage_service.dart';

final guideStorageServiceProvider = Provider<GuideStorageService>((ref) {
  return GuideStorageService(ref.read(storageServiceProvider));
});

class GuideStorageService {
  static const String guidesDirectory = 'guides';

  final StorageService _storageService;

  GuideStorageService(this._storageService);

  Future<String> saveGuideJson(String jsonContent) async {
    final String filename = _generateUniqueFilename();

    final Directory guidesDir = await _getGuidesDirectory();
    final String fullPath = path.join(guidesDir.path, filename);
    final File guideFile = File(fullPath);
    await guideFile.writeAsString(jsonContent);

    return filename;
  }

  Future<String> loadGuideJson(String fileName) async {
    final File guideFile = await _getGuideFile(fileName);

    if (!await guideFile.exists()) {
      throw GuideFileNotFoundException(fileName);
    }

    return await guideFile.readAsString();
  }

  Future<void> deleteGuideFile(String fileName) async {
    final File guideFile = await _getGuideFile(fileName);

    if (await guideFile.exists()) {
      await guideFile.delete();
    }
  }

  Future<bool> guideFileExists(String fileName) async {
    final File guideFile = await _getGuideFile(fileName);
    return await guideFile.exists();
  }

  Future<List<File>> getAllGuideFiles() async {
    final Directory guidesDir = await _getGuidesDirectory();

    if (!await guidesDir.exists()) {
      return [];
    }

    final List<FileSystemEntity> entities = await guidesDir.list().toList();
    return entities
        .whereType<File>()
        .where((file) => file.path.endsWith('.json'))
        .toList();
  }

  Future<String> getGuideFilePath(String fileName) async {
    final Directory guidesDir = await _getGuidesDirectory();
    return path.join(guidesDir.path, fileName);
  }

  Future<Directory> _getGuidesDirectory() async {
    final Directory appDir =
        await _storageService.getPersistentStorageDirectory();
    final Directory guidesDir = Directory(
      path.join(appDir.path, guidesDirectory),
    );

    if (!await guidesDir.exists()) {
      await guidesDir.create(recursive: true);
    }

    return guidesDir;
  }

  Future<File> _getGuideFile(String fileName) async {
    final Directory guidesDir = await _getGuidesDirectory();
    return File(path.join(guidesDir.path, fileName));
  }

  String _generateUniqueFilename() {
    final String uuid = const Uuid().v4();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'guide_${timestamp}_$uuid.json';
  }
}

class GuideFileNotFoundException implements Exception {
  final String fileName;

  GuideFileNotFoundException(this.fileName);

  @override
  String toString() => 'Guide file not found: $fileName';
}
