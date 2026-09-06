import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:chkpnt/services/barcode_lookup_service.dart';

String _fixture(String barcode) {
  return File('test/fixtures/barcode/raw_$barcode.json').readAsStringSync();
}

BarcodeLookupService _serviceReturning(String body, {int statusCode = 200}) {
  return BarcodeLookupService(
    client: MockClient(
      (request) async => http.Response.bytes(utf8.encode(body), statusCode),
    ),
  );
}

Future<BarcodeLookupResult> _lookupRetailTitle(String retailTitle) {
  final payload = jsonEncode({
    'code': 'OK',
    'total': 1,
    'items': [
      {'title': retailTitle},
    ],
  });
  return _serviceReturning(payload).lookup('123');
}

BarcodeLookupService _serviceForFixtures() {
  return BarcodeLookupService(
    client: MockClient((request) async {
      final barcode = request.url.queryParameters['upc']!;
      return http.Response.bytes(utf8.encode(_fixture(barcode)), 200);
    }),
  );
}

void main() {
  group('BarcodeLookupService fixture parsing', () {
    late BarcodeLookupService service;

    setUp(() {
      service = _serviceForFixtures();
    });

    test('4012927064528 resolves Metal Gear Solid on PSP', () async {
      final result = await service.lookup('4012927064528');

      expect(result.outcome, BarcodeLookupOutcome.found);
      expect(result.title, 'Metal Gear Solid - Peace Walker');
      expect(result.platform, 'PSP');
    });

    test('5026555248082 resolves Red Dead Redemption on Xbox 360', () async {
      final result = await service.lookup('5026555248082');

      expect(result.outcome, BarcodeLookupOutcome.found);
      expect(result.title, 'Red Dead Redemption');
      expect(result.platform, 'Xbox 360');
    });

    test('5055277016211 resolves Virtua Tennis 4 on PS Vita', () async {
      final result = await service.lookup('5055277016211');

      expect(result.outcome, BarcodeLookupOutcome.found);
      expect(result.title, contains('Virtua Tennis 4'));
      expect(result.platform, 'PS Vita');
    });

    test(
      '711719127451 prefers the offer title over the top level title',
      () async {
        final result = await service.lookup('711719127451');

        expect(result.outcome, BarcodeLookupOutcome.found);
        expect(result.title, 'Uncharted 2: Among Thieves');
        expect(result.platform, 'PS3');
      },
    );

    test('0810023037910 is not found without throwing', () async {
      final result = await service.lookup('0810023037910');

      expect(result.outcome, BarcodeLookupOutcome.notFound);
      expect(result.title, '');
      expect(result.platform, isNull);
    });

    test('5060990241239 is not found without throwing', () async {
      final result = await service.lookup('5060990241239');

      expect(result.outcome, BarcodeLookupOutcome.notFound);
      expect(result.title, '');
      expect(result.platform, isNull);
    });
  });

  group('BarcodeLookupService title selection', () {
    test('offer title wins when it names a different game', () async {
      final payload = jsonEncode({
        'code': 'OK',
        'total': 1,
        'items': [
          {
            'title': 'Uncharted Drakes Fortune Sony Ps3 Playstation 3 Game',
            'brand': 'Sony',
            'offers': [
              {'title': 'Uncharted 2: Among Thieves (PS3)'},
            ],
          },
        ],
      });

      final result = await _serviceReturning(payload).lookup('711719127451');

      expect(result.title, 'Uncharted 2: Among Thieves');
      expect(result.title, isNot(contains('Drakes')));
    });

    test('falls back to the top level title when no platform is found', () async {
      final payload = jsonEncode({
        'code': 'OK',
        'total': 1,
        'items': [
          {
            'title': 'Trails From Zero. Free Shipping. Brand New.',
            'offers': [
              {'title': 'Trails From Zero Boxed Copy'},
            ],
          },
        ],
      });

      final result = await _serviceReturning(payload).lookup('123');

      expect(result.outcome, BarcodeLookupOutcome.found);
      expect(result.title, 'Trails From Zero');
      expect(result.platform, isNull);
    });

    test('brand is never used to populate a field', () async {
      final result = await _serviceForFixtures().lookup('5055277016211');

      expect(result.title, isNot(contains('Seasonic')));
      expect(result.platform, isNot('Seasonic'));
      expect(result.imageUrl, isNot(contains('Seasonic')));
    });

    test('returns the first item image when present', () async {
      final result = await _serviceForFixtures().lookup('4012927064528');

      expect(
        result.imageUrl,
        'https://i20.onbuy.com/product/3979b4e4e05c4e899de992198ad2f5be-l2053803.jpg',
      );
    });
  });

  group('BarcodeLookupService retail title formats', () {
    final expectations = <String, String>{
      'Mario Kart 8 Deluxe (Nintendo Switch)': 'Mario Kart 8 Deluxe',
      'Halo Infinite (Xbox Series X)': 'Halo Infinite',
      'Wii Sports Resort (Nintendo Wii)': 'Wii Sports Resort',
      'Nintendo Switch Sports (Nintendo Switch)': 'Nintendo Switch Sports',
      'PC Building Simulator (Nintendo Switch)': 'PC Building Simulator',
      'Nintendo Land (Wii U)': 'Nintendo Land',
      'Wii Play': 'Wii Play',
      'Game Dev Tycoon (PC)': 'Game Dev Tycoon',
    };

    expectations.forEach((retailTitle, expectedTitle) {
      test('parses "$retailTitle"', () async {
        final result = await _lookupRetailTitle(retailTitle);

        expect(result.title, expectedTitle);
      });
    });

    test('never strips a platform word from the middle of a title', () async {
      expect(
        (await _lookupRetailTitle('Xbox Fitness Adventure Pack')).title,
        'Xbox Fitness Adventure Pack',
      );
      expect(
        (await _lookupRetailTitle('Wii Sports Resort')).title,
        'Wii Sports Resort',
      );
    });

    test('strips a trailing platform segment without brackets', () async {
      final result = await _lookupRetailTitle(
        'Virtua Tennis 4: World Tour Edition PS Vita Game',
      );

      expect(result.title, 'Virtua Tennis 4: World Tour Edition');
      expect(result.platform, 'PS Vita');
    });

    test('strips a repeated long and short platform name', () async {
      final result = await _lookupRetailTitle(
        'Uncharted Drakes Fortune Sony Ps3 Playstation 3 Game - & Sealed',
      );

      expect(result.title, 'Uncharted Drakes Fortune');
      expect(result.platform, 'PS3');
    });

    test('detects and strips a bracketed short platform', () async {
      final pc = await _lookupRetailTitle('Elden Ring (PC)');
      expect(pc.title, 'Elden Ring');
      expect(pc.platform, 'PC');

      final ds = await _lookupRetailTitle('Pokemon Black (DS)');
      expect(ds.title, 'Pokemon Black');
      expect(ds.platform, 'DS');

      final gb = await _lookupRetailTitle('Tetris (GB)');
      expect(gb.title, 'Tetris');
      expect(gb.platform, 'GB');
    });

    test('treats en and em dashes as separators', () async {
      expect(
        (await _lookupRetailTitle('Doom Eternal — PS4')).title,
        'Doom Eternal',
      );
      expect(
        (await _lookupRetailTitle('Doom Eternal – PS4')).title,
        'Doom Eternal',
      );
      expect(
        (await _lookupRetailTitle('Hades — Nintendo Switch — Brand New')).title,
        'Hades',
      );
    });

    test('keeps accented characters intact', () async {
      final result = await _lookupRetailTitle('Pokémon Snap (DS)');

      expect(result.title, 'Pokémon Snap');
      expect(result.platform, 'DS');
    });

    test('a title that is only a platform is left alone', () async {
      final result = await _lookupRetailTitle('PlayStation 5');

      expect(result.title, 'PlayStation 5');
      expect(result.platform, 'PS5');
    });

    test('leaves no stranded brackets behind', () async {
      for (final retailTitle in expectations.keys) {
        final title = (await _lookupRetailTitle(retailTitle)).title;
        expect(title, isNot(contains('(')));
        expect(title, isNot(contains(')')));
      }
    });
  });

  group('BarcodeLookupService outcomes', () {
    test('a server error is reported separately from a network failure', () async {
      final result = await _serviceReturning(
        'Server Error',
        statusCode: 500,
      ).lookup('123');

      expect(result.outcome, BarcodeLookupOutcome.serverError);
    });

    test('a rate limited response is reported as limit reached', () async {
      final result = await _serviceReturning(
        '{"code":"EXCEED_LIMIT"}',
        statusCode: 429,
      ).lookup('123');

      expect(result.outcome, BarcodeLookupOutcome.limitReached);
    });

    test('empty items are reported as not found', () async {
      final result = await _serviceReturning(
        '{"code":"OK","total":0,"items":[]}',
      ).lookup('123');

      expect(result.outcome, BarcodeLookupOutcome.notFound);
    });

    test('a request failure does not escape the service', () async {
      final service = BarcodeLookupService(
        client: MockClient((request) async {
          throw const SocketException('no route to host');
        }),
      );

      await expectLater(service.lookup('123'), completes);
      expect((await service.lookup('123')).outcome,
          BarcodeLookupOutcome.noNetwork);
    });

    test('malformed json does not escape the service', () async {
      final result = await _serviceReturning('not json at all').lookup('123');

      expect(result.outcome, BarcodeLookupOutcome.notFound);
    });
  });

  group('BarcodeLookupService.normaliseBarcode', () {
    test('an EAN-13 padded UPC-A matches the bare UPC-A', () {
      expect(
        BarcodeLookupService.normaliseBarcode('0711719127451'),
        BarcodeLookupService.normaliseBarcode('711719127451'),
      );
    });

    test('leaves a full EAN-13 alone', () {
      expect(
        BarcodeLookupService.normaliseBarcode('5026555248082'),
        '5026555248082',
      );
    });

    test('keeps different barcodes distinct', () {
      expect(
        BarcodeLookupService.normaliseBarcode('5026555248082'),
        isNot(BarcodeLookupService.normaliseBarcode('5055277016211')),
      );
    });
  });
}
