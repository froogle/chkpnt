import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'storage_service.dart';

final guideReaderPreferencesServiceProvider =
    Provider<GuideReaderPreferencesService>((ref) {
      return GuideReaderPreferencesService(ref.read(storageServiceProvider));
    });

final guideReaderPreferencesProvider = StreamProvider<GuideReaderPreferences>((
  ref,
) {
  final service = ref.watch(guideReaderPreferencesServiceProvider);
  return service.watchPreferences();
});

class GuideReaderPreferences {
  final double fontSize;
  final bool invertedColours;

  static const double defaultFontSize = 16.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 28.0;
  static const double fontSizeStep = 2.0;

  const GuideReaderPreferences({
    this.fontSize = defaultFontSize,
    this.invertedColours = false,
  });

  GuideReaderPreferences copyWith({double? fontSize, bool? invertedColours}) {
    return GuideReaderPreferences(
      fontSize: fontSize ?? this.fontSize,
      invertedColours: invertedColours ?? this.invertedColours,
    );
  }

  Map<String, dynamic> toJson() => {
    'fontSize': fontSize,
    'invertedColours': invertedColours,
  };

  factory GuideReaderPreferences.fromJson(Map<String, dynamic> json) {
    return GuideReaderPreferences(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? defaultFontSize,
      invertedColours: json['invertedColours'] as bool? ?? false,
    );
  }

  GuideReaderPreferences increaseFontSize() {
    final newSize = (fontSize + fontSizeStep).clamp(minFontSize, maxFontSize);
    return copyWith(fontSize: newSize);
  }

  GuideReaderPreferences decreaseFontSize() {
    final newSize = (fontSize - fontSizeStep).clamp(minFontSize, maxFontSize);
    return copyWith(fontSize: newSize);
  }

  GuideReaderPreferences toggleInvertedColours() {
    return copyWith(invertedColours: !invertedColours);
  }

  bool get canIncreaseFontSize => fontSize < maxFontSize;
  bool get canDecreaseFontSize => fontSize > minFontSize;
}

class GuideReaderPreferencesService {
  static const String _preferencesFileName = 'guide_reader_preferences.json';

  final StorageService _storageService;

  GuideReaderPreferencesService(this._storageService);

  Stream<GuideReaderPreferences> watchPreferences() async* {
    yield await getPreferences();
  }

  Future<GuideReaderPreferences> getPreferences() async {
    try {
      final file = await _getPreferencesFile();

      if (!await file.exists()) {
        return const GuideReaderPreferences();
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return GuideReaderPreferences.fromJson(json);
    } catch (e) {
      return const GuideReaderPreferences();
    }
  }

  Future<void> savePreferences(GuideReaderPreferences preferences) async {
    final file = await _getPreferencesFile();
    final content = jsonEncode(preferences.toJson());
    await file.writeAsString(content);
  }

  Future<File> _getPreferencesFile() async {
    final appDir = await _storageService.getPersistentStorageDirectory();
    return File(path.join(appDir.path, _preferencesFileName));
  }
}
