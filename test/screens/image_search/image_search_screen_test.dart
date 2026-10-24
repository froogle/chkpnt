import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/image_search/image_search_screen.dart';
import 'package:chkpnt/services/web_image_search_service.dart';

class StubImageSearchService extends WebImageSearchService {
  StubImageSearchService(this.results);

  final List<String> results;
  final List<String> queries = [];

  @override
  Future<List<String>> searchImages(String query) async {
    queries.add(query);
    return results;
  }
}

class FailingImageSearchService extends WebImageSearchService {
  @override
  Future<List<String>> searchImages(String query) async {
    throw Exception('search unavailable');
  }
}

void main() {
  testWidgets('ImageSearchScreen shows loading, empty, and error states', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          webImageSearchServiceProvider.overrideWithValue(
            StubImageSearchService(const []),
          ),
        ],
        child: MaterialApp(home: ImageSearchScreen(initialQuery: 'Test Game')),
      ),
    );
    // Should show loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Wait for search to complete
    await tester.pumpAndSettle(const Duration(seconds: 3));
    // Should show empty state (no images found in test environment)
    expect(find.text('No images found.'), findsOneWidget);
  });

  testWidgets('ImageSearchScreen shows an error when the search fails', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          webImageSearchServiceProvider.overrideWithValue(
            FailingImageSearchService(),
          ),
        ],
        child: MaterialApp(home: ImageSearchScreen(initialQuery: 'Test Game')),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Failed to load images.'), findsOneWidget);
  });

  testWidgets('ImageSearchScreen offers suggested images before results', (
    WidgetTester tester,
  ) async {
    final service = StubImageSearchService(const [
      'https://example.com/result-one.jpg',
      'https://example.com/result-two.jpg',
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [webImageSearchServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          home: ImageSearchScreen(
            initialQuery: 'Red Dead Redemption Xbox 360',
            suggestedImageUrls: const ['https://example.com/suggested.jpg'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(service.queries, ['Red Dead Redemption Xbox 360']);
    expect(find.byType(Image), findsNWidgets(3));

    final firstImage = tester.widget<Image>(find.byType(Image).first);
    expect(
      (firstImage.image as NetworkImage).url,
      'https://example.com/suggested.jpg',
    );
  });

  testWidgets('ImageSearchScreen keeps a suggestion when the search fails', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          webImageSearchServiceProvider.overrideWithValue(
            FailingImageSearchService(),
          ),
        ],
        child: MaterialApp(
          home: ImageSearchScreen(
            initialQuery: 'Red Dead Redemption Xbox 360',
            suggestedImageUrls: const ['https://example.com/suggested.jpg'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Failed to load images.'), findsNothing);
    expect(find.byType(Image), findsOneWidget);
  });
}
