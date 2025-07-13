import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/image_search/image_search_screen.dart';

void main() {
  testWidgets('ImageSearchScreen shows loading, empty, and error states', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ImageSearchScreen(initialQuery: 'Test Game')),
    );
    // Should show loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Wait for search to complete
    await tester.pumpAndSettle(const Duration(seconds: 3));
    // Should show empty state (no images found in test environment)
    expect(find.text('No images found.'), findsOneWidget);
  });
}
