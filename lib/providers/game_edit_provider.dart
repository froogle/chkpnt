import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/services/barcode_lookup_service.dart';

part 'game_edit_provider.g.dart';

const String kDefaultAddGameTitle = 'New Game';

bool _isRealTitle(String title) {
  final enteredTitle = title.trim();
  return enteredTitle.isNotEmpty && enteredTitle != kDefaultAddGameTitle;
}

// Game edit context data class to identify the editing context
class GameEditContext {
  final bool isAddMode;
  final GameItem? game;
  final List<GameStatus>? availableStatuses;
  final GameStatus? defaultStatus;
  final bool defaultIsPhysical;

  const GameEditContext({
    required this.isAddMode,
    this.game,
    this.availableStatuses,
    this.defaultStatus,
    this.defaultIsPhysical = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameEditContext &&
        other.isAddMode == isAddMode &&
        other.game == game &&
        other.availableStatuses == availableStatuses &&
        other.defaultStatus == defaultStatus &&
        other.defaultIsPhysical == defaultIsPhysical;
  }

  @override
  int get hashCode =>
      Object.hash(isAddMode, game, availableStatuses, defaultStatus, defaultIsPhysical);
}

// Game edit form state data class
class GameEditFormState {
  final String title;
  final String platform;
  final GameStatus status;
  final String? imagePath;
  final bool hasUnsavedChanges;
  final bool isPhysical;
  final String? barcode;
  final bool hasStartedEntry;
  final bool isAddMode;
  final bool isLookingUpBarcode;

  const GameEditFormState({
    required this.title,
    required this.platform,
    required this.status,
    this.imagePath,
    this.hasUnsavedChanges = false,
    this.isPhysical = false,
    this.barcode,
    this.hasStartedEntry = false,
    this.isAddMode = false,
    this.isLookingUpBarcode = false,
  });

  bool get offersScan => isAddMode && !hasStartedEntry;

  bool get canSave => !isAddMode || _isRealTitle(title);

  GameEditFormState copyWith({
    String? title,
    String? platform,
    GameStatus? status,
    String? imagePath,
    bool? hasUnsavedChanges,
    bool clearImagePath = false,
    bool? isPhysical,
    String? barcode,
    bool? hasStartedEntry,
    bool? isLookingUpBarcode,
  }) {
    return GameEditFormState(
      title: title ?? this.title,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isPhysical: isPhysical ?? this.isPhysical,
      barcode: barcode ?? this.barcode,
      hasStartedEntry: hasStartedEntry ?? this.hasStartedEntry,
      isAddMode: isAddMode,
      isLookingUpBarcode: isLookingUpBarcode ?? this.isLookingUpBarcode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameEditFormState &&
        other.title == title &&
        other.platform == platform &&
        other.status == status &&
        other.imagePath == imagePath &&
        other.hasUnsavedChanges == hasUnsavedChanges &&
        other.isPhysical == isPhysical &&
        other.barcode == barcode &&
        other.hasStartedEntry == hasStartedEntry &&
        other.isAddMode == isAddMode &&
        other.isLookingUpBarcode == isLookingUpBarcode;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      platform,
      status,
      imagePath,
      hasUnsavedChanges,
      isPhysical,
      barcode,
      hasStartedEntry,
      isAddMode,
      isLookingUpBarcode,
    );
  }
}

// Game edit state provider using Family - eliminates initialization issues
@riverpod
class GameEditState extends _$GameEditState {
  bool _isClosed = false;

  @override
  GameEditFormState build(GameEditContext context) {
    _isClosed = false;
    ref.onDispose(() => _isClosed = true);

    // Initialize state based on context - no runtime modification needed
    if (context.isAddMode) {
      final defaultStatus = context.defaultStatus ?? GameStatus.backlog;
      return GameEditFormState(
        title: kDefaultAddGameTitle,
        platform: '',
        status: defaultStatus,
        imagePath: null,
        hasUnsavedChanges: false,
        isPhysical: context.defaultIsPhysical,
        hasStartedEntry: false,
        isAddMode: true,
      );
    } else {
      final game = context.game!;
      return GameEditFormState(
        title: game.title,
        platform: game.platform,
        status: game.status,
        imagePath: game.imagePath,
        hasUnsavedChanges: false,
        isPhysical: game.isPhysical,
        hasStartedEntry: true,
      );
    }
  }

  void updateTitle(String title) {
    state = state.copyWith(
      title: title,
      hasUnsavedChanges: true,
      hasStartedEntry: _latchStartedEntry(title, state.platform),
    );
  }

  void updatePlatform(String platform) {
    state = state.copyWith(
      platform: platform,
      hasUnsavedChanges: true,
      hasStartedEntry: _latchStartedEntry(state.title, platform),
    );
  }

  void updateStatus(GameStatus status) {
    state = state.copyWith(status: status, hasUnsavedChanges: true);
  }

  void updateImagePath(String? imagePath) {
    if (imagePath == null) {
      state = state.copyWith(clearImagePath: true, hasUnsavedChanges: true);
    } else {
      state = state.copyWith(imagePath: imagePath, hasUnsavedChanges: true);
    }
  }

  void updateIsPhysical(bool isPhysical) {
    state = state.copyWith(isPhysical: isPhysical, hasUnsavedChanges: true);
  }

  Future<BarcodeScan> scanBarcode(String barcode) async {
    final existingGame = _gameWithBarcode(barcode);
    if (existingGame != null) return DuplicateBarcode(existingGame);

    state = state.copyWith(isLookingUpBarcode: true);
    try {
      final result = await ref
          .read(barcodeLookupServiceProvider)
          .lookup(barcode);
      if (!_isClosed) _applyLookup(barcode, result);
      return BarcodeLookedUp(result);
    } finally {
      if (!_isClosed && state.isLookingUpBarcode) {
        state = state.copyWith(isLookingUpBarcode: false);
      }
    }
  }

  GameItem gameToSave() {
    final title = state.title.trim();

    if (state.isAddMode) {
      return GameItem.create(
        title: title,
        platform: state.platform,
        status: state.status,
        imagePath: state.imagePath,
        isPhysical: state.isPhysical,
        barcode: state.barcode,
      );
    }

    return context.game!.copyWith(
      title: title,
      platform: state.platform,
      status: state.status,
      imagePath: state.imagePath,
      isPhysical: state.isPhysical,
    );
  }

  GameItem? _gameWithBarcode(String barcode) {
    final scanned = BarcodeLookupService.normaliseBarcode(barcode);

    for (final game in ref.read(gameListProvider)) {
      final stored = game.barcode;
      if (stored != null &&
          BarcodeLookupService.normaliseBarcode(stored) == scanned) {
        return game;
      }
    }
    return null;
  }

  String? _matchingPlatform(String? detectedPlatform) {
    if (detectedPlatform == null) return null;

    for (final platform in ref.read(everyPlatformProvider)) {
      if (platform.toLowerCase() == detectedPlatform.toLowerCase()) {
        return platform;
      }
    }
    return null;
  }

  void _applyLookup(String barcode, BarcodeLookupResult result) {
    final limitsStatuses = context.availableStatuses != null;

    state = state.copyWith(
      title: result.title.isEmpty ? null : result.title,
      platform: _matchingPlatform(result.platform),
      status: limitsStatuses ? state.status : GameStatus.owned,
      isPhysical: true,
      barcode: barcode,
      isLookingUpBarcode: false,
      hasUnsavedChanges: true,
      hasStartedEntry: state.hasStartedEntry || result.title.trim().isNotEmpty,
    );
  }

  bool _latchStartedEntry(String title, String platform) {
    if (state.hasStartedEntry) return true;
    return _isRealTitle(title) && platform.isNotEmpty;
  }

  bool get hasChanges => state.hasUnsavedChanges;
}

sealed class BarcodeScan {
  const BarcodeScan();
}

class DuplicateBarcode extends BarcodeScan {
  final GameItem game;

  const DuplicateBarcode(this.game);
}

class BarcodeLookedUp extends BarcodeScan {
  final BarcodeLookupResult result;

  const BarcodeLookedUp(this.result);
}
