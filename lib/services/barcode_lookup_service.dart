import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:chkpnt/utils/platform_utils.dart';

enum BarcodeLookupOutcome {
  found,
  notFound,
  noNetwork,
  limitReached,
  serverError,
}

class BarcodeLookupResult {
  final BarcodeLookupOutcome outcome;
  final String title;
  final String? platform;
  final String? imageUrl;

  const BarcodeLookupResult({
    required this.outcome,
    this.title = '',
    this.platform,
    this.imageUrl,
  });
}

final barcodeLookupServiceProvider = Provider<BarcodeLookupService>((ref) {
  return BarcodeLookupService();
});

class BarcodeLookupService {
  static const String endpoint = 'https://api.upcitemdb.com/prod/trial/lookup';
  static const List<String> _noisePhrases = [
    'free shipping',
    'brand new',
    'sealed',
    'game',
    'sony',
    'nintendo',
    'microsoft',
  ];

  final http.Client _client;

  BarcodeLookupService({http.Client? client})
    : _client = client ?? http.Client();

  static String normaliseBarcode(String barcode) {
    final digits = barcode.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final withoutLeadingZeros = digits.replaceFirst(RegExp(r'^0+'), '');
    return withoutLeadingZeros.isEmpty ? digits : withoutLeadingZeros;
  }

  Future<BarcodeLookupResult> lookup(String barcode) async {
    final http.Response response;

    try {
      response = await _client.get(Uri.parse('$endpoint?upc=$barcode'));
    } catch (e) {
      return const BarcodeLookupResult(
        outcome: BarcodeLookupOutcome.noNetwork,
      );
    }

    if (response.statusCode == 429) {
      return const BarcodeLookupResult(
        outcome: BarcodeLookupOutcome.limitReached,
      );
    }

    if (response.statusCode != 200) {
      return const BarcodeLookupResult(
        outcome: BarcodeLookupOutcome.serverError,
      );
    }

    try {
      return _parseResponse(utf8.decode(response.bodyBytes, allowMalformed: true));
    } catch (e) {
      return const BarcodeLookupResult(outcome: BarcodeLookupOutcome.notFound);
    }
  }

  BarcodeLookupResult _parseResponse(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    final items = data['items'] as List? ?? const [];
    if (items.isEmpty) {
      return const BarcodeLookupResult(outcome: BarcodeLookupOutcome.notFound);
    }

    final item = items.first as Map<String, dynamic>;
    final topLevelTitle = (item['title'] as String? ?? '').trim();
    final candidates = [..._offerTitles(item), topLevelTitle]
        .where((candidate) => candidate.isNotEmpty)
        .toList();

    if (candidates.isEmpty) {
      return const BarcodeLookupResult(outcome: BarcodeLookupOutcome.notFound);
    }

    var chosen = topLevelTitle.isEmpty ? candidates.first : topLevelTitle;
    String? platform;

    for (final candidate in candidates) {
      final detected = PlatformUtils.detectPlatform(candidate);
      if (detected != null) {
        chosen = candidate;
        platform = detected;
        break;
      }
    }

    return BarcodeLookupResult(
      outcome: BarcodeLookupOutcome.found,
      title: _cleanTitle(chosen),
      platform: platform,
      imageUrl: _firstImageUrl(item),
    );
  }

  List<String> _offerTitles(Map<String, dynamic> item) {
    final offers = item['offers'] as List? ?? const [];
    return offers
        .whereType<Map>()
        .map((offer) => (offer['title'] as String? ?? '').trim())
        .where((title) => title.isNotEmpty)
        .toList();
  }

  String? _firstImageUrl(Map<String, dynamic> item) {
    final images = item['images'] as List? ?? const [];
    for (final image in images) {
      if (image is String && image.isNotEmpty) {
        return image;
      }
    }
    return null;
  }

  String _cleanTitle(String title) {
    var result = title.trim();

    while (true) {
      final stripped = _stripTrailingSegment(result);
      if (stripped == result) break;
      result = stripped.trim();
    }

    return _tidySeparators(result);
  }

  String _stripTrailingSegment(String title) {
    final withoutSeparators = _trimTrailingSeparators(title);
    if (withoutSeparators != title) return withoutSeparators;

    final bracketStart = _removableBracketStart(title);
    if (bracketStart >= 0) return title.substring(0, bracketStart);

    final noiseStart = _trailingNoiseStart(title);
    if (noiseStart >= 0) return title.substring(0, noiseStart);

    final platform = PlatformUtils.findPlatform(title);
    if (platform != null &&
        platform.start > 0 &&
        platform.end == title.length) {
      return title.substring(0, platform.start);
    }

    return title;
  }

  int _removableBracketStart(String title) {
    const closingBrackets = {')': '(', ']': '['};
    final opening = closingBrackets[title.isEmpty ? '' : title[title.length - 1]];
    if (opening == null) return -1;

    final start = title.lastIndexOf(opening);
    if (start < 0) return -1;

    final content = title.substring(start + 1, title.length - 1).trim();
    if (content.isEmpty) return start;
    if (PlatformUtils.detectPlatform(content) != null) return start;
    if (_isNoisePhrase(content)) return start;

    return -1;
  }

  bool _isNoisePhrase(String text) {
    final normalised = text.toLowerCase().trim();
    return _noisePhrases.contains(normalised);
  }

  int _trailingNoiseStart(String title) {
    for (final phrase in _noisePhrases) {
      final pattern = RegExp(
        '(?<![a-z0-9])${RegExp.escape(phrase)}\\s*\$',
        caseSensitive: false,
      );
      final match = pattern.firstMatch(title);
      if (match != null && match.start > 0) return match.start;
    }
    return -1;
  }

  String _trimTrailingSeparators(String title) {
    return title.replaceAll(RegExp(r'[\s\-&.,:/–—]+$'), '');
  }

  String _tidySeparators(String title) {
    return title
        .replaceAll(RegExp(r'\(\s*\)|\[\s*\]'), ' ')
        .replaceAll(RegExp(r'[([]\s*$'), '')
        .replaceAll(RegExp(r'^\s*[)\]]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[\s\-&.,:/–—]+'), '')
        .replaceAll(RegExp(r'[\s\-&.,:/–—]+$'), '')
        .trim();
  }
}
