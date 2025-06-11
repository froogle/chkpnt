# Input Widgets

This directory contains reusable input components for the application.

## Components

### AutoFocusTextField
A text field that automatically focuses and selects text when in add mode. Now includes Android 13 full screen editor support.

**Usage:**
```dart
AutoFocusTextField(
  controller: controller,
  isAddMode: true,
  decoration: InputDecoration(hintText: 'Enter text'),
)
```

### Android13TextFieldWrapper
A wrapper that adds a "Done" button for Android 13's full screen text editor. This solves the issue where Android 13 shows a full screen text editor without a way to dismiss it.

**Features:**
- Only activates on Android 13 devices
- Adds a floating "Done" button when text field is focused
- Preserves all text field functionality
- Does not interfere with keyboard input
- Automatically hides when focus is lost

**Usage:**
```dart
Android13TextFieldWrapper(
  onDone: () => print('Done pressed'),
  child: TextField(
    decoration: InputDecoration(hintText: 'Enter text'),
  ),
)
```

**Note:** This wrapper is automatically applied to `AutoFocusTextField`, `CompactSearchBar`, and other text input widgets in the app.

### CompactSearchBar
A compact search input with modern styling and Android 13 support.

### PlatformEditDropdown
A dropdown for selecting game platforms with custom platform entry support.

### PlatformFilterDropdown
A filter dropdown for selecting platforms in lists and grids.

## Android 13 Support

All text input widgets in this directory now include automatic Android 13 full screen editor support. The wrapper:

1. **Detects Android 13** - Only activates on Android 13 devices
2. **Preserves Functionality** - Text input, keyboard, and all interactions work normally
3. **Adds Done Button** - Shows a floating "Done" button when text field is focused
4. **Auto-hides** - Button disappears when focus is lost or when pressed
5. **Customizable** - Can be disabled with `enabled: false` parameter

## Testing

The Android 13 wrapper includes comprehensive tests that verify:
- Platform detection works correctly
- Done button appears/disappears appropriately
- Text input functionality is preserved
- Focus handling works properly
- Different text field configurations are supported

Run tests with:
```bash
flutter test test/shared/widgets/inputs/
```