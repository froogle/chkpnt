# Full Backup/Restore Implementation Phases

## Overview

This document breaks down the implementation of the full database and image backup/restore feature into four manageable phases, following ChkPnt's production-ready architecture patterns.

## Phase 1: Foundation - Core Data Models and Dependencies

### 1.1 Add Dependencies
**File:** `pubspec.yaml`
**Priority:** High - Required for all subsequent work

```yaml
dependencies:
  archive: ^3.4.10  # ZIP file creation and extraction
  # file_picker already exists for image selection
```

**Tasks:**
- [ ] Add `archive: ^3.4.10` to pubspec.yaml dependencies
- [ ] Run `flutter pub get` to install dependencies
- [ ] Run `dart run build_runner build` to regenerate code
- [ ] Verify archive package works with basic test

### 1.2 Create Backup Metadata Model
**File:** `lib/models/backup_models.dart`
**Priority:** High - Foundation for all backup operations

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_models.freezed.dart';
part 'backup_models.g.dart';

@freezed
class BackupMetadata with _$BackupMetadata {
  const factory BackupMetadata({
    required String version,
    required DateTime createdAt,
    required int gameCount,
    required int imageCount,
    required List<String> includedImages,
  }) = _BackupMetadata;

  factory BackupMetadata.fromJson(Map<String, dynamic> json) => 
    _$BackupMetadataFromJson(json);
}

@freezed  
class BackupValidationResult with _$BackupValidationResult {
  const factory BackupValidationResult.valid(BackupMetadata metadata) = _Valid;
  const factory BackupValidationResult.invalid(String reason) = _Invalid;
  const factory BackupValidationResult.corrupted(String details) = _Corrupted;
}
```

**Tasks:**
- [ ] Create `lib/models/backup_models.dart` with Freezed models
- [ ] Add to `lib/models/game_models.dart` exports if needed
- [ ] Run `dart run build_runner build` to generate code
- [ ] Write basic unit tests for model serialization

### 1.3 Core Backup Service Foundation
**File:** `lib/services/full_backup_service.dart`
**Priority:** High - Core business logic

**Tasks:**
- [ ] Create service class with dependency injection (repository, storage, image service)
- [ ] Implement image collection logic (scan game_images directory)
- [ ] Implement backup validation (ZIP structure and content validation)
- [ ] Add basic error handling and logging
- [ ] Create service provider for Riverpod integration

**Initial Implementation Focus:**
```dart
class FullBackupService {
  final GameRepository _repository;
  final StorageService _storageService;
  final GameImageService _gameImageService;

  // Phase 1: Focus on validation and image collection
  Future<List<File>> collectAllImages();
  Future<BackupValidationResult> validateBackupFile(String filePath);
  Future<BackupMetadata> createBackupMetadata(List<File> images);
}
```

### 1.4 Phase 1 Testing
**Files:** `test/models/backup_models_test.dart`, `test/services/full_backup_service_test.dart`
**Priority:** High - Ensure foundation is solid

**Tasks:**
- [ ] Unit tests for backup metadata serialization/deserialization
- [ ] Unit tests for image collection logic
- [ ] Unit tests for backup validation logic
- [ ] Mock tests for service dependencies
- [ ] Run `flutter test` to ensure all tests pass

**Quality Gates:**
- [ ] All tests pass
- [ ] `flutter analyze` shows no warnings
- [ ] Code coverage >90% for core logic

---

## Phase 2: Core Backup Operations

### 2.1 Backup Creation Implementation
**File:** `lib/services/full_backup_service.dart` (extend)
**Priority:** High - Core functionality

```dart
// Add to FullBackupService
Future<File> createFullBackup(String destinationDirectory) async {
  // 1. Export database to JSON
  // 2. Collect all image files
  // 3. Create temporary staging directory
  // 4. Create metadata
  // 5. Build ZIP archive
  // 6. Write to destination
  // 7. Clean up temporary files
}

Stream<double> createFullBackupWithProgress(String destinationDirectory);
```

**Tasks:**
- [ ] Implement database export integration
- [ ] Implement temporary directory management
- [ ] Implement ZIP archive creation using `archive` package
- [ ] Add progress tracking with streams
- [ ] Add comprehensive error handling
- [ ] Add file cleanup logic (temporary files)

### 2.2 Backup Restoration Implementation
**File:** `lib/services/full_backup_service.dart` (extend)
**Priority:** High - Core functionality

```dart
// Add to FullBackupService  
Future<void> restoreFromFullBackup(String backupFilePath) async {
  // 1. Validate backup file
  // 2. Extract to temporary directory
  // 3. Validate extracted content
  // 4. Import database
  // 5. Restore images
  // 6. Clean up temporary files
}

Stream<double> restoreFromFullBackupWithProgress(String backupFilePath);
```

**Tasks:**
- [ ] Implement ZIP extraction logic
- [ ] Implement database restoration (clear + import)
- [ ] Implement image restoration (clear + copy)
- [ ] Add atomic operation logic (all-or-nothing)
- [ ] Add rollback capability for failed restores
- [ ] Add progress tracking for restore operations

### 2.3 File System Integration
**File:** `lib/services/full_backup_service.dart` (extend)
**Priority:** Medium - Supporting functionality

**Tasks:**
- [ ] Directory selection using `FilePicker.platform.getDirectoryPath()`
- [ ] Backup file selection with `.zip` filtering
- [ ] Cross-platform path handling using `path` package
- [ ] Storage space validation before operations
- [ ] File permission handling

### 2.4 Phase 2 Testing
**Files:** `test/services/full_backup_service_test.dart` (extend)
**Priority:** High - Critical functionality validation

**Tasks:**
- [ ] Integration tests for complete backup → restore cycle
- [ ] Tests for ZIP file structure and content
- [ ] Tests for database integrity after restore
- [ ] Tests for image integrity after restore
- [ ] Error handling tests (corrupt files, insufficient space, etc.)
- [ ] Progress tracking tests
- [ ] Temporary file cleanup tests

**Quality Gates:**
- [ ] Full backup/restore cycle works end-to-end
- [ ] All error scenarios handled gracefully
- [ ] No memory leaks during large operations
- [ ] Cross-platform compatibility verified

---

## Phase 3: State Management and User Interface

### 3.1 Backup State Provider
**File:** `lib/providers/backup_state_provider.dart`
**Priority:** High - UI state management

```dart
@riverpod
class BackupState extends _$BackupState {
  @override
  BackupOperationState build() => const BackupOperationState.idle();
  
  Future<void> createFullBackup(String destinationPath);
  Future<void> restoreFullBackup(String backupPath);
  void reset();
}

@freezed
class BackupOperationState with _$BackupOperationState {
  const factory BackupOperationState.idle() = _Idle;
  const factory BackupOperationState.creatingBackup(double progress) = _CreatingBackup;
  const factory BackupOperationState.restoringBackup(double progress) = _RestoringBackup;  
  const factory BackupOperationState.success(String message) = _Success;
  const factory BackupOperationState.error(String error) = _Error;
}
```

**Tasks:**
- [ ] Create Riverpod state provider with Freezed states
- [ ] Integrate with `FullBackupService` progress streams  
- [ ] Add error handling and user-friendly messages
- [ ] Add operation cancellation capability
- [ ] Generate code with `dart run build_runner build`

### 3.2 Profile Backup Section Widget
**File:** `lib/screens/profile/widgets/profile_backup_section.dart`
**Priority:** High - Primary user interface

```dart
class ProfileBackupSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProfileBackupSection> createState() => _ProfileBackupSectionState();
}

class _ProfileBackupSectionState extends ConsumerState<ProfileBackupSection> {
  Widget _buildSectionHeader();
  Widget _buildBackupButton();
  Widget _buildRestoreButton();
  Widget _buildProgressIndicator();
  Widget _buildStatusMessage();
}
```

**Tasks:**
- [ ] Create widget following existing profile screen patterns
- [ ] Implement backup button with directory picker
- [ ] Implement restore button with file picker
- [ ] Add progress indicators matching app design
- [ ] Add success/error message display
- [ ] Use explicit styling (Android 13 compatibility)
- [ ] Add loading states and button disabling

### 3.3 Confirmation Dialogs
**File:** `lib/screens/profile/widgets/backup_confirmation_dialog.dart`
**Priority:** Medium - User safety

**Tasks:**
- [ ] Create backup preview dialog (shows what will be backed up)
- [ ] Create restore confirmation dialog (shows backup details and warnings)
- [ ] Use existing dialog patterns from the app
- [ ] Add backup metadata display (date, game count, image count)
- [ ] Add clear warnings about restore being destructive

### 3.4 Profile Screen Integration
**File:** `lib/screens/profile/profile_screen.dart` (extend)
**Priority:** High - UI integration

**Tasks:**
- [ ] Add `ProfileBackupSection` to existing profile layout
- [ ] Ensure responsive design for portrait/landscape
- [ ] Maintain existing profile screen styling
- [ ] Add to both portrait and landscape layout methods
- [ ] Test scrolling behavior with new section

### 3.5 Phase 3 Testing
**Files:** `test/providers/backup_state_provider_test.dart`, `test/screens/profile/widgets/profile_backup_section_test.dart`
**Priority:** High - UI and state management validation

**Tasks:**
- [ ] Provider state transition tests
- [ ] Widget interaction tests (button taps, progress display)
- [ ] File picker integration tests
- [ ] Confirmation dialog tests
- [ ] Error state display tests
- [ ] Progress indicator tests
- [ ] Integration with existing profile screen tests

**Quality Gates:**
- [ ] All UI states handled correctly
- [ ] Error messages are user-friendly
- [ ] No UI breaking changes to existing profile screen
- [ ] Accessibility compliance maintained

---

## Phase 4: Polish, Testing and Quality Assurance

### 4.1 Comprehensive Error Handling
**Files:** Various service and UI files
**Priority:** High - Production readiness

**Tasks:**
- [ ] Add comprehensive error categories and messages
- [ ] Implement retry logic for transient failures
- [ ] Add logging for debugging backup/restore issues
- [ ] Handle platform-specific errors (Android permissions, iOS sandbox)
- [ ] Add graceful degradation for edge cases
- [ ] Implement operation cancellation

### 4.2 Performance Optimization
**Files:** `lib/services/full_backup_service.dart` (optimize)
**Priority:** Medium - User experience

**Tasks:**
- [ ] Optimize memory usage for large backups
- [ ] Add streaming operations for large files
- [ ] Implement background processing where possible
- [ ] Optimize ZIP compression settings
- [ ] Add progress granularity for better user feedback

### 4.3 Cross-Platform Validation
**Priority:** High - Compatibility assurance

**Tasks:**
- [ ] Test on Android (multiple API levels)
- [ ] Test on iOS (multiple versions)
- [ ] Test on macOS (if applicable)
- [ ] Validate file picker behavior across platforms
- [ ] Test backup file compatibility across platforms
- [ ] Verify storage location behavior

### 4.4 Integration Testing
**Files:** `test/integration/backup_integration_test.dart`
**Priority:** High - End-to-end validation

**Tasks:**
- [ ] Complete user workflow tests (backup → restore)
- [ ] Test with various data sizes (empty, small, large databases)
- [ ] Test with missing images, corrupt files
- [ ] Test interruption and recovery scenarios
- [ ] Performance testing with large datasets
- [ ] Memory leak testing

### 4.5 Documentation and Code Quality
**Priority:** Medium - Maintainability

**Tasks:**
- [ ] Add comprehensive code documentation
- [ ] Update README if needed
- [ ] Add inline code comments for complex logic
- [ ] Ensure British English spellings throughout
- [ ] Final code review and cleanup
- [ ] Update CLAUDE.md with new patterns if needed

### 4.6 Quality Gates and Final Testing
**Priority:** Critical - Release readiness

**Mandatory Checks:**
- [ ] `flutter analyze` passes with zero warnings
- [ ] All unit tests pass (`flutter test`)
- [ ] All integration tests pass
- [ ] Code coverage >85% for new code
- [ ] Manual testing on primary platforms (Android/iOS)
- [ ] Performance testing with realistic data
- [ ] Security review of file operations
- [ ] User acceptance testing (if applicable)

---

## Implementation Order and Dependencies

### Critical Path Dependencies:
1. **Phase 1** must complete fully before Phase 2
2. **Phase 2** core operations must work before Phase 3 UI
3. **Phase 3** UI can be developed in parallel with Phase 2 testing
4. **Phase 4** activities can start once Phase 3 core UI is complete

### Parallel Development Opportunities:
- **Models and Testing** can be developed in parallel within each phase
- **UI and State Management** can be developed in parallel in Phase 3
- **Documentation and Polish** can be done throughout all phases

### Risk Mitigation:
- Complete testing at each phase before proceeding
- Maintain working app functionality throughout development
- Create feature branch for all backup/restore work
- Regular integration with main branch to avoid conflicts

## Quality Standards

### Code Quality:
- Follow existing ChkPnt architecture patterns
- Use explicit styling (Android 13 compatibility)
- British English spellings throughout
- Comprehensive error handling
- Riverpod streaming patterns
- Freezed for data models

### Testing Requirements:
- >85% code coverage for new functionality
- Unit tests for all service methods
- Widget tests for all UI components
- Integration tests for complete workflows
- Platform-specific testing

### Performance Standards:
- Backup/restore operations complete within reasonable time
- UI remains responsive during operations
- Memory usage remains stable during large operations
- No significant impact on app startup time

This phased approach ensures steady progress while maintaining code quality and the production-ready standards of the ChkPnt application.