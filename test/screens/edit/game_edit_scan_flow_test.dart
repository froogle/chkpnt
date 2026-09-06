import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/image_search/image_search_screen.dart';
import 'package:chkpnt/screens/edit/widgets/barcode_scanner_screen.dart';
import 'package:chkpnt/services/barcode_lookup_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/styles/styles.dart';
import '../../test_helpers.dart';

const MethodChannel _scannerChannel = MethodChannel(
  'dev.steenbakker.mobile_scanner/scanner/method',
);

const GameEditContext addContext = GameEditContext(isAddMode: true);

final List<GameItem> _seededGames = [];

class SeededGameListNotifier extends GameList {
  @override
  List<GameItem> build() => List.from(_seededGames);
}

class FakeGameImageService implements GameImageService {
  FakeGameImageService({this.permission = CameraPermissionResult.granted});

  final CameraPermissionResult permission;

  @override
  Future<String?> selectAndSaveImage(GameImageSource source) async => null;

  @override
  Future<bool> deleteImage(String imagePath) async => true;

  @override
  Future<bool> imageExists(String imagePath) async => false;

  @override
  Future<String> getImagePath(String imagePath) async => imagePath;

  @override
  Future<String?> downloadAndSaveImageFromUrl(String imageUrl) async => null;

  @override
  Future<CameraPermissionResult> checkAndRequestCameraPermission() async =>
      permission;

  @override
  Future<bool> openCameraSettings() async => true;
}

class RecordingLookupClient {
  RecordingLookupClient({this.statusCode = 200});

  final int statusCode;
  final List<String> requestedBarcodes = [];

  http.Client get client => MockClient((request) async {
    final barcode = request.url.queryParameters['upc']!;
    requestedBarcodes.add(barcode);

    if (statusCode != 200) {
      return http.Response('Server Error', statusCode);
    }

    final file = File('test/fixtures/barcode/raw_$barcode.json');
    if (!file.existsSync()) {
      return http.Response('{"code":"OK","total":0,"items":[]}', 200);
    }
    return http.Response.bytes(file.readAsBytesSync(), 200);
  });
}

ProviderContainer _createContainer({
  required RecordingLookupClient lookupClient,
  CameraPermissionResult permission = CameraPermissionResult.granted,
}) {
  return ProviderContainer(
    overrides: [
      gameListProvider.overrideWith(() => SeededGameListNotifier()),
      gameImageServiceProvider.overrideWithValue(
        FakeGameImageService(permission: permission),
      ),
      barcodeLookupServiceProvider.overrideWithValue(
        BarcodeLookupService(client: lookupClient.client),
      ),
    ],
  );
}

Future<void> _pumpFrames(WidgetTester tester, {int frames = 8}) async {
  for (var frame = 0; frame < frames; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _openAddForm(
  WidgetTester tester,
  ProviderContainer container,
) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: GameEditScreen.add()),
    ),
  );
  await tester.pump();
}

Future<void> _scanBarcode(
  WidgetTester tester,
  String barcode, {
  int detections = 1,
}) async {
  await tester.tap(find.text('Scan Barcode'));
  await _pumpFrames(tester);

  final state = tester.state<BarcodeScannerScreenState>(
    find.byType(BarcodeScannerScreen),
  );
  for (var detection = 0; detection < detections; detection++) {
    await state.handleDetection(
      BarcodeCapture(
        barcodes: [Barcode(rawValue: barcode, format: BarcodeFormat.ean13)],
      ),
    );
  }

  await _pumpFrames(tester);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RecordingLookupClient lookupClient;
  late ProviderContainer container;

  setUp(() {
    lookupClient = RecordingLookupClient();
    _seededGames.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_scannerChannel, (call) async {
          if (call.method == 'state') return 1;
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_scannerChannel, null);
    container.dispose();
  });

  group('GameEditScreen barcode scanning', () {
    testWidgets('the scan button is only offered when adding a game', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      expect(find.text('Scan Barcode'), findsOneWidget);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: GameEditScreen.edit(
              game: TestHelpers.createTestGame(title: 'Existing Game'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Scan Barcode'), findsNothing);
    });

    testWidgets('the scan button declares explicit colours', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);

      final label = tester.widget<Text>(find.text('Scan Barcode'));
      expect(label.style, EditScreenStyles.scanBarcodeTextStyle);

      final icon = tester.widget<Icon>(find.byIcon(Icons.qr_code_scanner));
      expect(icon.color, EditScreenStyles.scanBarcodeColour);
    });

    testWidgets('a successful scan pre-fills the form as owned and physical', (
      tester,
    ) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.barcode, '5026555248082');
      expect(state.title, 'Red Dead Redemption');
      expect(state.platform, 'Xbox 360');
      expect(state.status, GameStatus.owned);
      expect(state.isPhysical, isTrue);
      expect(lookupClient.requestedBarcodes, ['5026555248082']);
    });

    testWidgets('cover art is offered, not imposed', (tester) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      expect(find.byType(ImageSearchScreen), findsNothing);
      expect(find.byType(GameEditScreen), findsOneWidget);
      expect(find.text('Find Cover'), findsOneWidget);
      expect(find.text('Red Dead Redemption'), findsOneWidget);
    });

    testWidgets('the scan offer never claims the game was saved', (
      tester,
    ) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      expect(find.textContaining('Saved'), findsNothing);
      expect(
        find.text('Found Red Dead Redemption. Add cover art?'),
        findsOneWidget,
      );
      expect(container.read(gameListProvider).length, 1);
    });

    testWidgets('a detected platform the user does not have is left empty', (
      tester,
    ) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'PC'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.title, 'Red Dead Redemption');
      expect(state.platform, isEmpty);
    });

    testWidgets('a failed lookup still captures the barcode', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5060990241239');

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.barcode, '5060990241239');
      expect(state.status, GameStatus.owned);
      expect(state.isPhysical, isTrue);
      expect(
        find.textContaining('not in the lookup service'),
        findsOneWidget,
      );
    });

    testWidgets('a title and platform the user typed survive a failed lookup', (
      tester,
    ) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'PS4'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);

      await tester.enterText(find.byType(TextField).first, 'Trails From Zero');
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updatePlatform('PS4');
      await tester.pump();

      await _scanBarcode(tester, '5060990241239');

      final state = container.read(gameEditStateProvider(addContext));
      final titleField = tester.widget<TextField>(find.byType(TextField).first);

      expect(titleField.controller!.text, 'Trails From Zero');
      expect(state.platform, 'PS4');
      expect(state.barcode, '5060990241239');
      expect(state.status, GameStatus.owned);
      expect(state.isPhysical, isTrue);
      expect(find.text('Trails From Zero'), findsOneWidget);
    });

    testWidgets('the add mode title default survives a failed lookup', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5060990241239');

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.title, 'New Game');
      expect(state.barcode, '5060990241239');
    });

    testWidgets('a server error gets its own message', (tester) async {
      lookupClient = RecordingLookupClient(statusCode: 500);
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      expect(find.textContaining('not answering'), findsOneWidget);
      expect(
        container.read(gameEditStateProvider(addContext)).barcode,
        '5026555248082',
      );
    });

    testWidgets('a UPC-A padded to EAN-13 matches the stored barcode', (
      tester,
    ) async {
      _seededGames.add(
        GameItem.create(
          title: 'Uncharted 2: Among Thieves',
          platform: 'PS3',
          status: GameStatus.owned,
          isPhysical: true,
          barcode: '711719127451',
        ),
      );
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '0711719127451');

      expect(find.text('Already In Your Collection'), findsOneWidget);
      expect(lookupClient.requestedBarcodes, isEmpty);
      expect(container.read(gameListProvider).length, 1);
    });

    testWidgets('repeated detections trigger exactly one lookup', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082', detections: 3);

      expect(lookupClient.requestedBarcodes, ['5026555248082']);
    });

    testWidgets('a barcode already on a saved game surfaces the duplicate', (
      tester,
    ) async {
      _seededGames.add(
        GameItem.create(
          title: 'Red Dead Redemption',
          platform: 'Xbox 360',
          status: GameStatus.owned,
          isPhysical: true,
          barcode: '5026555248082',
        ),
      );
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      expect(find.text('Already In Your Collection'), findsOneWidget);
      expect(find.text('Open Game'), findsOneWidget);
      expect(lookupClient.requestedBarcodes, isEmpty);
      expect(container.read(gameListProvider).length, 1);

      final state = container.read(gameEditStateProvider(addContext));
      expect(state.barcode, isNull);
      expect(state.status, isNot(GameStatus.owned));
    });

    testWidgets('a denied camera permission opens the existing dialog', (
      tester,
    ) async {
      container = _createContainer(
        lookupClient: lookupClient,
        permission: CameraPermissionResult.denied,
      );

      await _openAddForm(tester, container);
      await tester.tap(find.text('Scan Barcode'));
      await _pumpFrames(tester);

      expect(find.byType(BarcodeScannerScreen), findsNothing);
      expect(find.text('Camera Permission Required'), findsOneWidget);
      expect(find.text('Open Settings'), findsOneWidget);
      expect(lookupClient.requestedBarcodes, isEmpty);
    });

    testWidgets('an opened settings result also opens the existing dialog', (
      tester,
    ) async {
      container = _createContainer(
        lookupClient: lookupClient,
        permission: CameraPermissionResult.openedSettings,
      );

      await _openAddForm(tester, container);
      await tester.tap(find.text('Scan Barcode'));
      await _pumpFrames(tester);

      expect(find.byType(BarcodeScannerScreen), findsNothing);
      expect(find.text('Camera Permission Required'), findsOneWidget);
      expect(lookupClient.requestedBarcodes, isEmpty);
    });
  });
}
