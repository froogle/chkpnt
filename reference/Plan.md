# Full Database and Image Backup/Restore Implementation Plan

## Overview

This plan implements a complete backup and restore system for ChkPnt that creates a single ZIP file containing both the SQLite database and all game images. Users can backup their entire data set to any directory and restore from a backup file.

## Architecture Components

### 1. Enhanced Backup Service (`lib/services/full_backup_service.dart`)

A new service that extends the existing backup functionality to include images and create ZIP archives.

#### Core Responsibilities:
- Create timestamped ZIP backups containing database JSON + all images
- Restore from ZIP files by extracting database and images
- Validate backup integrity
- Handle directory selection for backup location
- Manage temporary files during backup/restore operations

#### Key Methods:
```dart
class FullBackupService {
  Future<File> createFullBackup(String destinationPath);
  Future<void> restoreFromFullBackup(String backupFilePath);
  Future<List<File>> getAvailableFullBackups(String searchDirectory);
  Future<BackupMetadata> validateBackupFile(String backupFilePath);
  Future<String> getBackupSizeString(File backupFile);
}
```

### 2. Backup Metadata Structure

Track backup contents and versioning for future compatibility.

```dart
@freezed
class BackupMetadata with _$BackupMetadata {
  const factory BackupMetadata({
    required String version,
    required DateTime createdAt,
    required int gameCount,
    required int imageCount,
    required List<String> includedImages,
  }) = _BackupMetadata;
}
```

### 3. UI Integration - Profile Screen Enhancement

Add a new section at the bottom of the profile screen with backup/restore controls.

#### New Widget: `ProfileBackupSection`
- Clean, accessible UI matching existing profile screen design
- Progress indicators for backup/restore operations
- Error handling with user-friendly messages
- Integration with existing profile screen layout

### 4. Dependencies to Add

Add to `pubspec.yaml`:
```yaml
dependencies:
  archive: ^3.4.10  # For ZIP file creation and extraction
  
# file_picker is already included for image selection
```

## Implementation Steps

### Phase 1: Core Service Implementation

#### 1.1 Create Full Backup Service
```dart
// lib/services/full_backup_service.dart
class FullBackupService {
  final GameRepository _repository;
  final StorageService _storageService;
  final GameImageService _gameImageService;

  // Core backup method
  Future<File> createFullBackup(String destinationDirectory) async {
    // 1. Export database to JSON
    // 2. Collect all image files from game_images directory
    // 3. Create temporary directory for staging
    // 4. Copy images to staging directory
    // 5. Create ZIP archive with database.json + images/
    // 6. Move ZIP to destination directory
    // 7. Clean up temporary files
  }

  // Core restore method
  Future<void> restoreFromFullBackup(String backupFilePath) async {
    // 1. Validate ZIP file format and contents
    // 2. Extract to temporary directory
    // 3. Validate database.json format
    // 4. Clear current database (with user confirmation)
    // 5. Import database from JSON
    // 6. Clear current images directory
    // 7. Restore images from backup
    // 8. Clean up temporary files
  }
}
```

#### 1.2 Backup Operations Flow
1. **Create Backup**:
   - Get current timestamp for filename
   - Export database using existing `repository.exportDatabaseToJson()`
   - Scan `game_images/` directory for all image files
   - Create temporary staging directory
   - Copy database JSON and all images to staging
   - Create ZIP archive with structure:
     ```
     chkpnt_backup_2024-01-15_14-30-45.zip
     ├── metadata.json        # Backup info and validation
     ├── database.json        # SQLite export
     └── images/             # All game images
         ├── game_001.jpg
         ├── game_002.jpg
         └── ...
     ```

2. **Restore Backup**:
   - Validate ZIP file contains required files
   - Extract to temporary directory
   - Validate metadata.json and database.json format
   - Show user confirmation dialog with backup details
   - Clear current database and images (after confirmation)
   - Import database using existing `repository.importFromJson()`
   - Copy images to `game_images/` directory
   - Clean up temporary files

#### 1.3 Error Handling Strategy
- **File Access Errors**: Graceful handling of permission issues
- **Corrupt Archives**: Validation before extraction
- **Partial Restores**: Transaction-like behavior (all-or-nothing)
- **Storage Space**: Pre-check available space before operations
- **User Cancellation**: Ability to cancel long-running operations

### Phase 2: UI Integration

#### 2.1 Create Profile Backup Section Widget
```dart
// lib/screens/profile/widgets/profile_backup_section.dart
class ProfileBackupSection extends ConsumerStatefulWidget {
  Widget _buildBackupButton();
  Widget _buildRestoreButton();
  Widget _buildProgressIndicator();
  Widget _buildStatusMessage();
}
```

#### 2.2 Profile Screen Integration
Add new section to existing profile screen layout:
```dart
// In lib/screens/profile/profile_screen.dart
Widget _buildPortraitLayout() {
  return Column(
    children: [
      ProfileHeader(),
      ProfileSubscriptionSection(),
      ProfileVisualisationSection(), 
      ProfileIncomingGamesSection(),
      ProfileBackupSection(), // NEW: Add at bottom
    ],
  );
}
```

#### 2.3 UI Flow Design
1. **Backup Flow**:
   - User taps "Backup Data" button
   - Show directory picker dialog
   - Display progress indicator during backup creation
   - Show success message with backup file location
   - Handle errors with clear error messages

2. **Restore Flow**:
   - User taps "Restore Data" button  
   - Show file picker dialog (filter for .zip files)
   - Display backup validation and contents preview
   - Show confirmation dialog with backup details
   - Display progress indicator during restore
   - Show success message or error details

### Phase 3: State Management

#### 3.1 Backup State Provider
```dart
// lib/providers/backup_state_provider.dart
@riverpod
class BackupState extends _$BackupState {
  @override
  BackupOperationState build() => const BackupOperationState.idle();
  
  Future<void> createFullBackup(String destinationPath);
  Future<void> restoreFullBackup(String backupPath);
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

### Phase 4: Testing Strategy

#### 4.1 Unit Tests
- `FullBackupService` methods with mock dependencies
- Backup validation logic
- Error handling scenarios
- File system operations

#### 4.2 Integration Tests  
- Complete backup → restore cycles
- Database integrity after restore
- Image file integrity after restore
- Cross-platform compatibility

#### 4.3 Widget Tests
- `ProfileBackupSection` UI interactions
- Progress indicator behavior
- Error state handling
- User confirmation dialogs

## Technical Implementation Details

### Backup File Structure
```
chkpnt_backup_YYYY-MM-DD_HH-MM-SS.zip
├── metadata.json      # Backup metadata and validation info
├── database.json      # Complete database export (existing format)  
└── images/           # Directory containing all game images
    ├── game_image_1.jpg
    ├── game_image_2.png
    └── ...
```

### Archive Package Integration
Using the `archive` package for ZIP operations:

```dart
// Creating ZIP backup
final archive = Archive();

// Add database file
final databaseFile = ArchiveFile('database.json', databaseJson.length, databaseJson);
archive.addFile(databaseFile);

// Add metadata
final metadataFile = ArchiveFile('metadata.json', metadataJson.length, metadataJson);  
archive.addFile(metadataFile);

// Add images
for (final imageFile in imageFiles) {
  final archiveFile = ArchiveFile.stream(
    'images/${path.basename(imageFile.path)}',
    imageFile.lengthSync(),
    imageFile.openRead(),
  );
  archive.addFile(archiveFile);
}

// Encode to ZIP
final zipData = ZipEncoder().encode(archive);
await backupFile.writeAsBytes(zipData);
```

### Directory Selection Implementation
```dart
// Using file_picker for directory selection
Future<String?> selectBackupDirectory() async {
  return await FilePicker.platform.getDirectoryPath(
    dialogTitle: 'Select Backup Location',
    lockParentWindow: true,
  );
}

// Using file_picker for backup file selection
Future<String?> selectBackupFile() async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: 'Select Backup File',
    type: FileType.custom,
    allowedExtensions: ['zip'],
  );
  return result?.files.single.path;
}
```

### Progress Tracking
```dart
// Stream-based progress reporting
Stream<double> createBackupWithProgress(String destination) async* {
  yield 0.1; // Start
  
  // Export database
  yield 0.2;
  final databaseJson = await _repository.exportDatabaseToJson();
  
  // Collect images  
  yield 0.4;
  final imageFiles = await _collectAllImages();
  
  // Create archive
  yield 0.6;
  final archive = await _createArchive(databaseJson, imageFiles);
  
  // Write file
  yield 0.8;
  await _writeBackupFile(destination, archive);
  
  yield 1.0; // Complete
}
```

## Security Considerations

### Data Protection
- Validate backup file integrity before restoration
- Clear sensitive data from temporary directories
- Handle file permissions appropriately
- Provide user confirmation before destructive operations

### Error Recovery
- Atomic restore operations (all-or-nothing)
- Backup current state before restore begins
- Rollback capability if restore fails mid-process
- Clear error messages for user guidance

## Platform Compatibility

### File System Access
- **Android**: Handle storage permissions and scoped storage
- **iOS**: Use app documents directory and Files app integration
- **macOS/Windows**: Native directory picker support
- **Web**: Limited file system access (download/upload only)

### Path Handling
- Use `path` package for cross-platform path operations
- Handle different path separators and formats
- Validate file system permissions before operations

## Testing Checklist

### Functional Tests
- [ ] Create backup with database and images
- [ ] Restore backup completely  
- [ ] Validate restored data integrity
- [ ] Handle missing images gracefully
- [ ] Handle corrupt backup files
- [ ] Test with empty database
- [ ] Test with large number of images
- [ ] Cross-platform compatibility

### UI Tests  
- [ ] Backup button interactions
- [ ] Restore button interactions
- [ ] Progress indicator display
- [ ] Error message handling
- [ ] Confirmation dialog behavior
- [ ] File picker integration

### Edge Cases
- [ ] Insufficient storage space
- [ ] File permission issues
- [ ] Network interruption (cloud storage)
- [ ] App termination during operations
- [ ] Corrupt or partial backup files

## Future Enhancements

### Phase 2 Features
- **Incremental Backups**: Only backup changed data
- **Cloud Storage Integration**: Direct backup to Google Drive/iCloud
- **Automatic Backups**: Scheduled backup creation
- **Backup Encryption**: Password-protected backup files
- **Selective Restore**: Choose which games to restore

### Performance Optimizations
- **Streaming Operations**: Handle large backups efficiently
- **Background Processing**: Use isolates for heavy operations
- **Compression Optimization**: Better compression ratios
- **Progress Granularity**: More detailed progress reporting

This implementation provides a complete backup and restore system that maintains data integrity while offering a user-friendly experience consistent with the existing ChkPnt application design.