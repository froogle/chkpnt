import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/repositories/game_repository.dart';

void main() {
  group('DriftGameRepository', () {
    group('Repository Interface', () {
      test('should implement GameRepository interface', () {
        final repository = DriftGameRepository();
        expect(repository, isA<GameRepository>());
        repository.dispose();
      });

      test('should have required methods', () {
        final repository = DriftGameRepository();

        // Verify methods exist without calling them to avoid DB creation
        expect(repository.getAllGames, isA<Function>());
        expect(repository.watchGames, isA<Function>());
        expect(repository.createGame, isA<Function>());
        expect(repository.updateGame, isA<Function>());
        expect(repository.deleteGame, isA<Function>());
        expect(repository.exportDatabaseToJson, isA<Function>());
        expect(repository.importFromJson, isA<Function>());
        expect(repository.getDatabasePath, isA<Function>());

        repository.dispose();
      });
    });

    group('Basic Functionality', () {
      test('should be instantiable', () {
        expect(() => DriftGameRepository(), returnsNormally);
        final repository = DriftGameRepository();
        repository.dispose();
      });

      test('should be disposable', () {
        final repository = DriftGameRepository();
        expect(() => repository.dispose(), returnsNormally);
      });
    });
  });
}
