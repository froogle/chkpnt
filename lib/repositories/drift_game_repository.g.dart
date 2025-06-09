// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_game_repository.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastStatusChangeMeta = const VerificationMeta(
    'lastStatusChange',
  );
  @override
  late final GeneratedColumn<DateTime> lastStatusChange =
      GeneratedColumn<DateTime>(
        'last_status_change',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteImageUrlMeta = const VerificationMeta(
    'remoteImageUrl',
  );
  @override
  late final GeneratedColumn<String> remoteImageUrl = GeneratedColumn<String>(
    'remote_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    platform,
    status,
    lastModified,
    lastStatusChange,
    imagePath,
    remoteImageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('last_status_change')) {
      context.handle(
        _lastStatusChangeMeta,
        lastStatusChange.isAcceptableOrUnknown(
          data['last_status_change']!,
          _lastStatusChangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastStatusChangeMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('remote_image_url')) {
      context.handle(
        _remoteImageUrlMeta,
        remoteImageUrl.isAcceptableOrUnknown(
          data['remote_image_url']!,
          _remoteImageUrlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      platform:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}platform'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}status'],
          )!,
      lastModified:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_modified'],
          )!,
      lastStatusChange:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_status_change'],
          )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      remoteImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_image_url'],
      ),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final String id;
  final String title;
  final String platform;
  final int status;
  final DateTime lastModified;
  final DateTime lastStatusChange;
  final String? imagePath;
  final String? remoteImageUrl;
  const Game({
    required this.id,
    required this.title,
    required this.platform,
    required this.status,
    required this.lastModified,
    required this.lastStatusChange,
    this.imagePath,
    this.remoteImageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['platform'] = Variable<String>(platform);
    map['status'] = Variable<int>(status);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['last_status_change'] = Variable<DateTime>(lastStatusChange);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || remoteImageUrl != null) {
      map['remote_image_url'] = Variable<String>(remoteImageUrl);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      title: Value(title),
      platform: Value(platform),
      status: Value(status),
      lastModified: Value(lastModified),
      lastStatusChange: Value(lastStatusChange),
      imagePath:
          imagePath == null && nullToAbsent
              ? const Value.absent()
              : Value(imagePath),
      remoteImageUrl:
          remoteImageUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(remoteImageUrl),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      platform: serializer.fromJson<String>(json['platform']),
      status: serializer.fromJson<int>(json['status']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      lastStatusChange: serializer.fromJson<DateTime>(json['lastStatusChange']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      remoteImageUrl: serializer.fromJson<String?>(json['remoteImageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'platform': serializer.toJson<String>(platform),
      'status': serializer.toJson<int>(status),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'lastStatusChange': serializer.toJson<DateTime>(lastStatusChange),
      'imagePath': serializer.toJson<String?>(imagePath),
      'remoteImageUrl': serializer.toJson<String?>(remoteImageUrl),
    };
  }

  Game copyWith({
    String? id,
    String? title,
    String? platform,
    int? status,
    DateTime? lastModified,
    DateTime? lastStatusChange,
    Value<String?> imagePath = const Value.absent(),
    Value<String?> remoteImageUrl = const Value.absent(),
  }) => Game(
    id: id ?? this.id,
    title: title ?? this.title,
    platform: platform ?? this.platform,
    status: status ?? this.status,
    lastModified: lastModified ?? this.lastModified,
    lastStatusChange: lastStatusChange ?? this.lastStatusChange,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    remoteImageUrl:
        remoteImageUrl.present ? remoteImageUrl.value : this.remoteImageUrl,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      platform: data.platform.present ? data.platform.value : this.platform,
      status: data.status.present ? data.status.value : this.status,
      lastModified:
          data.lastModified.present
              ? data.lastModified.value
              : this.lastModified,
      lastStatusChange:
          data.lastStatusChange.present
              ? data.lastStatusChange.value
              : this.lastStatusChange,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      remoteImageUrl:
          data.remoteImageUrl.present
              ? data.remoteImageUrl.value
              : this.remoteImageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('platform: $platform, ')
          ..write('status: $status, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastStatusChange: $lastStatusChange, ')
          ..write('imagePath: $imagePath, ')
          ..write('remoteImageUrl: $remoteImageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    platform,
    status,
    lastModified,
    lastStatusChange,
    imagePath,
    remoteImageUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.title == this.title &&
          other.platform == this.platform &&
          other.status == this.status &&
          other.lastModified == this.lastModified &&
          other.lastStatusChange == this.lastStatusChange &&
          other.imagePath == this.imagePath &&
          other.remoteImageUrl == this.remoteImageUrl);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> platform;
  final Value<int> status;
  final Value<DateTime> lastModified;
  final Value<DateTime> lastStatusChange;
  final Value<String?> imagePath;
  final Value<String?> remoteImageUrl;
  final Value<int> rowid;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.platform = const Value.absent(),
    this.status = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastStatusChange = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.remoteImageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCompanion.insert({
    required String id,
    required String title,
    required String platform,
    required int status,
    required DateTime lastModified,
    required DateTime lastStatusChange,
    this.imagePath = const Value.absent(),
    this.remoteImageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       platform = Value(platform),
       status = Value(status),
       lastModified = Value(lastModified),
       lastStatusChange = Value(lastStatusChange);
  static Insertable<Game> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? platform,
    Expression<int>? status,
    Expression<DateTime>? lastModified,
    Expression<DateTime>? lastStatusChange,
    Expression<String>? imagePath,
    Expression<String>? remoteImageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (platform != null) 'platform': platform,
      if (status != null) 'status': status,
      if (lastModified != null) 'last_modified': lastModified,
      if (lastStatusChange != null) 'last_status_change': lastStatusChange,
      if (imagePath != null) 'image_path': imagePath,
      if (remoteImageUrl != null) 'remote_image_url': remoteImageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? platform,
    Value<int>? status,
    Value<DateTime>? lastModified,
    Value<DateTime>? lastStatusChange,
    Value<String?>? imagePath,
    Value<String?>? remoteImageUrl,
    Value<int>? rowid,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      lastModified: lastModified ?? this.lastModified,
      lastStatusChange: lastStatusChange ?? this.lastStatusChange,
      imagePath: imagePath ?? this.imagePath,
      remoteImageUrl: remoteImageUrl ?? this.remoteImageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (lastStatusChange.present) {
      map['last_status_change'] = Variable<DateTime>(lastStatusChange.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (remoteImageUrl.present) {
      map['remote_image_url'] = Variable<String>(remoteImageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('platform: $platform, ')
          ..write('status: $status, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastStatusChange: $lastStatusChange, ')
          ..write('imagePath: $imagePath, ')
          ..write('remoteImageUrl: $remoteImageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$GameDatabase extends GeneratedDatabase {
  _$GameDatabase(QueryExecutor e) : super(e);
  $GameDatabaseManager get managers => $GameDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [games];
}

typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      required String id,
      required String title,
      required String platform,
      required int status,
      required DateTime lastModified,
      required DateTime lastStatusChange,
      Value<String?> imagePath,
      Value<String?> remoteImageUrl,
      Value<int> rowid,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> platform,
      Value<int> status,
      Value<DateTime> lastModified,
      Value<DateTime> lastStatusChange,
      Value<String?> imagePath,
      Value<String?> remoteImageUrl,
      Value<int> rowid,
    });

class $$GamesTableFilterComposer extends Composer<_$GameDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastStatusChange => $composableBuilder(
    column: $table.lastStatusChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteImageUrl => $composableBuilder(
    column: $table.remoteImageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GamesTableOrderingComposer
    extends Composer<_$GameDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastStatusChange => $composableBuilder(
    column: $table.lastStatusChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteImageUrl => $composableBuilder(
    column: $table.remoteImageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$GameDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastStatusChange => $composableBuilder(
    column: $table.lastStatusChange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get remoteImageUrl => $composableBuilder(
    column: $table.remoteImageUrl,
    builder: (column) => column,
  );
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$GameDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, BaseReferences<_$GameDatabase, $GamesTable, Game>),
          Game,
          PrefetchHooks Function()
        > {
  $$GamesTableTableManager(_$GameDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<DateTime> lastStatusChange = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> remoteImageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                title: title,
                platform: platform,
                status: status,
                lastModified: lastModified,
                lastStatusChange: lastStatusChange,
                imagePath: imagePath,
                remoteImageUrl: remoteImageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String platform,
                required int status,
                required DateTime lastModified,
                required DateTime lastStatusChange,
                Value<String?> imagePath = const Value.absent(),
                Value<String?> remoteImageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                title: title,
                platform: platform,
                status: status,
                lastModified: lastModified,
                lastStatusChange: lastStatusChange,
                imagePath: imagePath,
                remoteImageUrl: remoteImageUrl,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$GameDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, BaseReferences<_$GameDatabase, $GamesTable, Game>),
      Game,
      PrefetchHooks Function()
    >;

class $GameDatabaseManager {
  final _$GameDatabase _db;
  $GameDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
}
