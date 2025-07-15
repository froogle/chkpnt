import 'package:http/http.dart' as http;

class WebImageSearchService {
  /// Searches Bing Images for the given query and returns a list of image URLs.
  Future<List<String>> searchImages(String query) async {
    final headers = {
      'User-Agent':
          'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9',
    };
    try {
      final urls = await _searchBingImages(query, headers);
      if (urls.isNotEmpty) return urls;
      // ignore: avoid_print
      print('[ImageSearch] Bing returned no images. Falling back to Qwant.');
      return await _searchQwantImages(query, headers);
    } catch (e) {
      // ignore: avoid_print
      print('[ImageSearch] Bing error: $e. Falling back to Qwant.');
      return await _searchQwantImages(query, headers);
    }
  }

  Future<List<String>> _searchBingImages(
    String query,
    Map<String, String> headers,
  ) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url =
        'https://www.bing.com/images/search?q=$encodedQuery&form=HDRSC2&first=1&tsc=ImageBasicHover';
    try {
      final res = await http.get(Uri.parse(url), headers: headers);
      // ignore: avoid_print
      print('[ImageSearch] Bing HTML length: ${res.body.length}');
      // Extract image URLs from Bing HTML
      final matches = RegExp(
        r'murl&quot;:&quot;(https://[^&]+)&quot;',
      ).allMatches(res.body);
      final urls = <String>[];
      for (final match in matches) {
        final url = match.group(1);
        if (url != null) urls.add(url);
      }
      // ignore: avoid_print
      print('[ImageSearch] Bing found ${urls.length} images.');
      return urls.take(9).toList();
    } catch (e) {
      // ignore: avoid_print
      print('[ImageSearch] Bing error: $e');
      return [];
    }
  }

  Future<List<String>> _searchQwantImages(
    String query,
    Map<String, String> headers,
  ) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = 'https://www.qwant.com/?q=$encodedQuery&t=images';
    try {
      final res = await http.get(Uri.parse(url), headers: headers);
      // ignore: avoid_print
      print('[ImageSearch] Qwant HTML length: ${res.body.length}');
      // Qwant image URLs are in data-src attributes of <img> tags
      final matches = RegExp(
        r'<img[^>]+data-src="(https://[^"\s]+)"',
      ).allMatches(res.body);
      final urls = <String>[];
      for (final match in matches) {
        final url = match.group(1);
        if (url != null) urls.add(url);
      }
      // ignore: avoid_print
      print('[ImageSearch] Qwant found ${urls.length} images.');
      return urls.take(9).toList();
    } catch (e) {
      // ignore: avoid_print
      print('[ImageSearch] Qwant error: $e');
      return [];
    }
  }
}
