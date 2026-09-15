import 'dart:async';
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

  @override
  Future<void> addGame(GameItem game) async {
    _seededGames.add(game);
    state = List.from(_seededGames);
  }
}

class FakeGameImageService implements GameImageService {
  FakeGameImageService({
    this.permission = CameraPermissionResult.granted,
    this.gate,
  });

  final CameraPermissionResult permission;
  final Completer<void>? gate;
  int permissionRequests = 0;

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
  Future<CameraPermissionResult> checkAndRequestCameraPermission() async {
    permissionRequests += 1;
    await gate?.future;
    return permission;
  }

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
  FakeGameImageService? imageService,
}) {
  return ProviderContainer(
    overrides: [
      gameListProvider.overrideWith(() => SeededGameListNotifier()),
      gameImageServiceProvider.overrideWithValue(
        imageService ?? FakeGameImageService(permission: permission),
      ),
      barcodeLookupServiceProvider.overrideWithValue(
        BarcodeLookupService(client: lookupClient.client),
      ),
    ],
  );
}

final Finder _textButtons = find.byWidgetPredicate(
  (widget) => widget is TextButton,
  description: 'a TextButton or any subclass of one',
);

final Finder _smallScanButton = find.descendant(
  of: _textButtons,
  matching: find.byIcon(Icons.qr_code_scanner),
);

final Finder _scanPrimaryButton = find.widgetWithText(
  ElevatedButton,
  'Scan Barcode',
);

final Finder _addPrimaryButton = find.widgetWithText(
  ElevatedButton,
  'Add Game',
);

final Finder _savePrimaryButton = find.widgetWithText(
  ElevatedButton,
  'Save Changes',
);

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
  await tester.tap(_smallScanButton);
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
      expect(_smallScanButton, findsOneWidget);

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

      expect(_smallScanButton, findsNothing);
    });

    testWidgets('the scan button declares explicit colours', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);

      final label = tester.widget<Text>(
        find.descendant(of: _textButtons, matching: find.text('Scan Barcode')),
      );
      expect(label.style, EditScreenStyles.scanBarcodeTextStyle);

      final icon = tester.widget<Icon>(_smallScanButton);
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
      expect(find.text('Game Found'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('the scan offer never claims the game was saved', (
      tester,
    ) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      expect(find.textContaining('Saved'), findsNothing);
      expect(find.textContaining('has been added'), findsNothing);
      expect(
        find.text(
          'Red Dead Redemption has been found and the details filled in. '
          'Would you like to search for box art?',
        ),
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
      await tester.tap(_smallScanButton);
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
      await tester.tap(_smallScanButton);
      await _pumpFrames(tester);

      expect(find.byType(BarcodeScannerScreen), findsNothing);
      expect(find.text('Camera Permission Required'), findsOneWidget);
      expect(lookupClient.requestedBarcodes, isEmpty);
    });
  });

  group('GameEditScreen primary button', () {
    testWidgets('offers a scan before any details are entered', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);

      expect(_scanPrimaryButton, findsOneWidget);
      expect(_addPrimaryButton, findsNothing);
      expect(
        tester.widget<Icon>(
          find.descendant(
            of: _scanPrimaryButton,
            matching: find.byType(Icon),
          ),
        ).icon,
        Icons.qr_code_scanner,
      );
    });

    testWidgets('opens the scanner when it offers a scan', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await tester.tap(_scanPrimaryButton);
      await _pumpFrames(tester);

      expect(find.byType(BarcodeScannerScreen), findsOneWidget);
    });

    testWidgets('becomes Add Game once a title and platform are given', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await tester.enterText(find.byType(TextField).first, 'Elden Ring');
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updatePlatform('PS5');
      await tester.pump();

      expect(_addPrimaryButton, findsOneWidget);
      expect(_scanPrimaryButton, findsNothing);
      expect(
        tester.widget<Icon>(
          find.descendant(
            of: _addPrimaryButton,
            matching: find.byType(Icon),
          ),
        ).icon,
        Icons.save,
      );
    });

    testWidgets('still offers a scan after only a platform choice', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updatePlatform('PS5');
      await tester.pump();

      expect(_scanPrimaryButton, findsOneWidget);
    });

    testWidgets('still offers a scan after only a title', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await tester.enterText(find.byType(TextField).first, 'Elden Ring');
      await tester.pump();

      expect(_scanPrimaryButton, findsOneWidget);
    });

    testWidgets('still offers a scan after only a status change', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updateStatus(GameStatus.playing);
      await tester.pump();

      expect(_scanPrimaryButton, findsOneWidget);
    });

    testWidgets('still offers a scan after only a physical toggle', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updateIsPhysical(true);
      await tester.pump();

      expect(_scanPrimaryButton, findsOneWidget);
    });

    testWidgets('becomes Add Game after a successful scan', (tester) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');
      await tester.tap(find.text('No'));
      await _pumpFrames(tester);

      expect(_addPrimaryButton, findsOneWidget);
    });

    testWidgets('becomes Add Game when a scan finds no matching platform', (
      tester,
    ) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'PC'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');
      await tester.tap(find.text('No'));
      await _pumpFrames(tester);

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.title, 'Red Dead Redemption');
      expect(state.platform, isEmpty);
      expect(_addPrimaryButton, findsOneWidget);
    });

    testWidgets('still offers a scan after a failed lookup', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5060990241239');

      expect(_scanPrimaryButton, findsOneWidget);
      expect(
        container.read(gameEditStateProvider(addContext)).barcode,
        '5060990241239',
      );
    });

    testWidgets('cannot save once the title is cleared back to the default', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await tester.enterText(find.byType(TextField).first, 'Elden Ring');
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updatePlatform('PS5');
      await tester.pump();
      await tester.enterText(find.byType(TextField).first, kDefaultAddGameTitle);
      await tester.pump();

      await tester.tap(_addPrimaryButton);
      await _pumpFrames(tester);

      expect(
        tester.widget<ElevatedButton>(_addPrimaryButton).onPressed,
        isNull,
      );
      expect(container.read(gameListProvider), isEmpty);
    });

    testWidgets('cannot save with a whitespace-only title', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await tester.enterText(find.byType(TextField).first, 'Elden Ring');
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updatePlatform('PS5');
      await tester.pump();
      await tester.enterText(find.byType(TextField).first, '   ');
      await tester.pump();

      await tester.tap(_addPrimaryButton);
      await _pumpFrames(tester);

      expect(container.read(gameListProvider), isEmpty);
    });

    testWidgets('editing an existing game is never blocked by the title', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: GameEditScreen.edit(
              game: TestHelpers.createTestGame(title: kDefaultAddGameTitle),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        tester.widget<ElevatedButton>(_savePrimaryButton).onPressed,
        isNotNull,
      );
    });

    testWidgets('never reverts once the title is cleared again', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await tester.enterText(find.byType(TextField).first, 'Elden Ring');
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updatePlatform('PS5');
      await tester.pump();
      await tester.enterText(find.byType(TextField).first, 'New Game');
      await tester.pump();

      expect(_addPrimaryButton, findsOneWidget);
      expect(_scanPrimaryButton, findsNothing);
    });

    testWidgets('saves the game once it reads Add Game', (tester) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await tester.enterText(find.byType(TextField).first, 'Elden Ring');
      container
          .read(gameEditStateProvider(addContext).notifier)
          .updatePlatform('PS5');
      await tester.pump();

      await tester.tap(_addPrimaryButton);
      await _pumpFrames(tester);

      final saved = container.read(gameListProvider).last;

      expect(saved.title, 'Elden Ring');
      expect(saved.platform, 'PS5');
      expect(saved.status, GameStatus.backlog);
    });

    testWidgets('ignores a second tap while a scan is already starting', (
      tester,
    ) async {
      final gate = Completer<void>();
      final imageService = FakeGameImageService(gate: gate);
      container = _createContainer(
        lookupClient: lookupClient,
        imageService: imageService,
      );

      await _openAddForm(tester, container);
      await tester.tap(_scanPrimaryButton);
      await tester.pump();
      await tester.tap(_scanPrimaryButton);
      await tester.pump();

      expect(imageService.permissionRequests, 1);

      gate.complete();
      await _pumpFrames(tester);

      expect(find.byType(BarcodeScannerScreen), findsOneWidget);
    });

    testWidgets('ignores a second tap on the button beneath the image', (
      tester,
    ) async {
      final gate = Completer<void>();
      final imageService = FakeGameImageService(gate: gate);
      container = _createContainer(
        lookupClient: lookupClient,
        imageService: imageService,
      );

      await _openAddForm(tester, container);
      await tester.tap(_smallScanButton);
      await tester.pump();
      await tester.tap(_smallScanButton);
      await tester.pump();

      expect(imageService.permissionRequests, 1);

      gate.complete();
      await _pumpFrames(tester);
    });

    testWidgets('saves nothing while it still reads Scan Barcode', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await tester.tap(_scanPrimaryButton);
      await _pumpFrames(tester);

      expect(find.byType(BarcodeScannerScreen), findsOneWidget);
      expect(container.read(gameListProvider), isEmpty);
    });

    testWidgets('never offers a scan when editing an existing game', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

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

      expect(_savePrimaryButton, findsOneWidget);
      expect(_scanPrimaryButton, findsNothing);
    });
  });

  group('GameEditScreen cover art offer', () {
    testWidgets('a found game is announced in a dialog, not a snack bar', (
      tester,
    ) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('Game Found'), findsOneWidget);
    });

    testWidgets('the dialog declares explicit colours', (tester) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');

      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(dialog.backgroundColor, AppDialogStyles.backgroundColor);
      expect(dialog.surfaceTintColor, AppDialogStyles.surfaceTintColor);

      final title = tester.widget<Text>(find.text('Game Found'));
      expect(title.style, AppDialogStyles.titleTextStyle);
    });

    testWidgets('answering yes opens the image search', (tester) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');
      await tester.tap(find.text('Yes'));
      await _pumpFrames(tester);

      expect(find.byType(ImageSearchScreen), findsOneWidget);
    });

    testWidgets('answering no leaves the pre-filled form alone', (
      tester,
    ) async {
      _seededGames.add(TestHelpers.createTestGame(platform: 'Xbox 360'));
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5026555248082');
      await tester.tap(find.text('No'));
      await _pumpFrames(tester);

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(ImageSearchScreen), findsNothing);
      expect(find.byType(GameEditScreen), findsOneWidget);
      expect(
        container.read(gameEditStateProvider(addContext)).title,
        'Red Dead Redemption',
      );
    });

    testWidgets('a failed lookup gets a snack bar, not a dialog', (
      tester,
    ) async {
      container = _createContainer(lookupClient: lookupClient);

      await _openAddForm(tester, container);
      await _scanBarcode(tester, '5060990241239');

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
