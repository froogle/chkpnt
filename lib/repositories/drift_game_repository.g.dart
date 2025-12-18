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
  static const VerificationMeta _isPhysicalMeta = const VerificationMeta(
    'isPhysical',
  );
  @override
  late final GeneratedColumn<bool> isPhysical = GeneratedColumn<bool>(
    'is_physical',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_physical" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    isPhysical,
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
    if (data.containsKey('is_physical')) {
      context.handle(
        _isPhysicalMeta,
        isPhysical.isAcceptableOrUnknown(data['is_physical']!, _isPhysicalMeta),
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
      isPhysical:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_physical'],
          )!,
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
  final bool isPhysical;
  const Game({
    required this.id,
    required this.title,
    required this.platform,
    required this.status,
    required this.lastModified,
    required this.lastStatusChange,
    this.imagePath,
    this.remoteImageUrl,
    required this.isPhysical,
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
    map['is_physical'] = Variable<bool>(isPhysical);
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
      isPhysical: Value(isPhysical),
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
      isPhysical: serializer.fromJson<bool>(json['isPhysical']),
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
      'isPhysical': serializer.toJson<bool>(isPhysical),
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
    bool? isPhysical,
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
    isPhysical: isPhysical ?? this.isPhysical,
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
      isPhysical:
          data.isPhysical.present ? data.isPhysical.value : this.isPhysical,
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
          ..write('remoteImageUrl: $remoteImageUrl, ')
          ..write('isPhysical: $isPhysical')
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
    isPhysical,
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
          other.remoteImageUrl == this.remoteImageUrl &&
          other.isPhysical == this.isPhysical);
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
  final Value<bool> isPhysical;
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
    this.isPhysical = const Value.absent(),
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
    this.isPhysical = const Value.absent(),
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
    Expression<bool>? isPhysical,
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
      if (isPhysical != null) 'is_physical': isPhysical,
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
    Value<bool>? isPhysical,
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
      isPhysical: isPhysical ?? this.isPhysical,
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
    if (isPhysical.present) {
      map['is_physical'] = Variable<bool>(isPhysical.value);
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
          ..write('isPhysical: $isPhysical, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GuidesTable extends Guides with TableInfo<$GuidesTable, Guide> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuidesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
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
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReadSectionMeta = const VerificationMeta(
    'lastReadSection',
  );
  @override
  late final GeneratedColumn<int> lastReadSection = GeneratedColumn<int>(
    'last_read_section',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReadBlockMeta = const VerificationMeta(
    'lastReadBlock',
  );
  @override
  late final GeneratedColumn<int> lastReadBlock = GeneratedColumn<int>(
    'last_read_block',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasSeenAttributionMeta =
      const VerificationMeta('hasSeenAttribution');
  @override
  late final GeneratedColumn<bool> hasSeenAttribution = GeneratedColumn<bool>(
    'has_seen_attribution',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_seen_attribution" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    title,
    author,
    fileName,
    createdAt,
    lastReadSection,
    lastReadBlock,
    sourceUrl,
    hasSeenAttribution,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guides';
  @override
  VerificationContext validateIntegrity(
    Insertable<Guide> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_read_section')) {
      context.handle(
        _lastReadSectionMeta,
        lastReadSection.isAcceptableOrUnknown(
          data['last_read_section']!,
          _lastReadSectionMeta,
        ),
      );
    }
    if (data.containsKey('last_read_block')) {
      context.handle(
        _lastReadBlockMeta,
        lastReadBlock.isAcceptableOrUnknown(
          data['last_read_block']!,
          _lastReadBlockMeta,
        ),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('has_seen_attribution')) {
      context.handle(
        _hasSeenAttributionMeta,
        hasSeenAttribution.isAcceptableOrUnknown(
          data['has_seen_attribution']!,
          _hasSeenAttributionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Guide map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Guide(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      gameId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}game_id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      author:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}author'],
          )!,
      fileName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}file_name'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      lastReadSection:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}last_read_section'],
          )!,
      lastReadBlock:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}last_read_block'],
          )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      hasSeenAttribution:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}has_seen_attribution'],
          )!,
    );
  }

  @override
  $GuidesTable createAlias(String alias) {
    return $GuidesTable(attachedDatabase, alias);
  }
}

class Guide extends DataClass implements Insertable<Guide> {
  final String id;
  final String gameId;
  final String title;
  final String author;
  final String fileName;
  final DateTime createdAt;
  final int lastReadSection;
  final int lastReadBlock;
  final String? sourceUrl;
  final bool hasSeenAttribution;
  const Guide({
    required this.id,
    required this.gameId,
    required this.title,
    required this.author,
    required this.fileName,
    required this.createdAt,
    required this.lastReadSection,
    required this.lastReadBlock,
    this.sourceUrl,
    required this.hasSeenAttribution,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['file_name'] = Variable<String>(fileName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_read_section'] = Variable<int>(lastReadSection);
    map['last_read_block'] = Variable<int>(lastReadBlock);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    map['has_seen_attribution'] = Variable<bool>(hasSeenAttribution);
    return map;
  }

  GuidesCompanion toCompanion(bool nullToAbsent) {
    return GuidesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      title: Value(title),
      author: Value(author),
      fileName: Value(fileName),
      createdAt: Value(createdAt),
      lastReadSection: Value(lastReadSection),
      lastReadBlock: Value(lastReadBlock),
      sourceUrl:
          sourceUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(sourceUrl),
      hasSeenAttribution: Value(hasSeenAttribution),
    );
  }

  factory Guide.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Guide(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      fileName: serializer.fromJson<String>(json['fileName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastReadSection: serializer.fromJson<int>(json['lastReadSection']),
      lastReadBlock: serializer.fromJson<int>(json['lastReadBlock']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      hasSeenAttribution: serializer.fromJson<bool>(json['hasSeenAttribution']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'fileName': serializer.toJson<String>(fileName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastReadSection': serializer.toJson<int>(lastReadSection),
      'lastReadBlock': serializer.toJson<int>(lastReadBlock),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'hasSeenAttribution': serializer.toJson<bool>(hasSeenAttribution),
    };
  }

  Guide copyWith({
    String? id,
    String? gameId,
    String? title,
    String? author,
    String? fileName,
    DateTime? createdAt,
    int? lastReadSection,
    int? lastReadBlock,
    Value<String?> sourceUrl = const Value.absent(),
    bool? hasSeenAttribution,
  }) => Guide(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    title: title ?? this.title,
    author: author ?? this.author,
    fileName: fileName ?? this.fileName,
    createdAt: createdAt ?? this.createdAt,
    lastReadSection: lastReadSection ?? this.lastReadSection,
    lastReadBlock: lastReadBlock ?? this.lastReadBlock,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    hasSeenAttribution: hasSeenAttribution ?? this.hasSeenAttribution,
  );
  Guide copyWithCompanion(GuidesCompanion data) {
    return Guide(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastReadSection:
          data.lastReadSection.present
              ? data.lastReadSection.value
              : this.lastReadSection,
      lastReadBlock:
          data.lastReadBlock.present
              ? data.lastReadBlock.value
              : this.lastReadBlock,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      hasSeenAttribution:
          data.hasSeenAttribution.present
              ? data.hasSeenAttribution.value
              : this.hasSeenAttribution,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Guide(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('fileName: $fileName, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastReadSection: $lastReadSection, ')
          ..write('lastReadBlock: $lastReadBlock, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('hasSeenAttribution: $hasSeenAttribution')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    title,
    author,
    fileName,
    createdAt,
    lastReadSection,
    lastReadBlock,
    sourceUrl,
    hasSeenAttribution,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Guide &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.title == this.title &&
          other.author == this.author &&
          other.fileName == this.fileName &&
          other.createdAt == this.createdAt &&
          other.lastReadSection == this.lastReadSection &&
          other.lastReadBlock == this.lastReadBlock &&
          other.sourceUrl == this.sourceUrl &&
          other.hasSeenAttribution == this.hasSeenAttribution);
}

class GuidesCompanion extends UpdateCompanion<Guide> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> title;
  final Value<String> author;
  final Value<String> fileName;
  final Value<DateTime> createdAt;
  final Value<int> lastReadSection;
  final Value<int> lastReadBlock;
  final Value<String?> sourceUrl;
  final Value<bool> hasSeenAttribution;
  final Value<int> rowid;
  const GuidesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.fileName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastReadSection = const Value.absent(),
    this.lastReadBlock = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.hasSeenAttribution = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuidesCompanion.insert({
    required String id,
    required String gameId,
    required String title,
    required String author,
    required String fileName,
    required DateTime createdAt,
    this.lastReadSection = const Value.absent(),
    this.lastReadBlock = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.hasSeenAttribution = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       title = Value(title),
       author = Value(author),
       fileName = Value(fileName),
       createdAt = Value(createdAt);
  static Insertable<Guide> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? fileName,
    Expression<DateTime>? createdAt,
    Expression<int>? lastReadSection,
    Expression<int>? lastReadBlock,
    Expression<String>? sourceUrl,
    Expression<bool>? hasSeenAttribution,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (fileName != null) 'file_name': fileName,
      if (createdAt != null) 'created_at': createdAt,
      if (lastReadSection != null) 'last_read_section': lastReadSection,
      if (lastReadBlock != null) 'last_read_block': lastReadBlock,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (hasSeenAttribution != null)
        'has_seen_attribution': hasSeenAttribution,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuidesCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<String>? title,
    Value<String>? author,
    Value<String>? fileName,
    Value<DateTime>? createdAt,
    Value<int>? lastReadSection,
    Value<int>? lastReadBlock,
    Value<String?>? sourceUrl,
    Value<bool>? hasSeenAttribution,
    Value<int>? rowid,
  }) {
    return GuidesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      title: title ?? this.title,
      author: author ?? this.author,
      fileName: fileName ?? this.fileName,
      createdAt: createdAt ?? this.createdAt,
      lastReadSection: lastReadSection ?? this.lastReadSection,
      lastReadBlock: lastReadBlock ?? this.lastReadBlock,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      hasSeenAttribution: hasSeenAttribution ?? this.hasSeenAttribution,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastReadSection.present) {
      map['last_read_section'] = Variable<int>(lastReadSection.value);
    }
    if (lastReadBlock.present) {
      map['last_read_block'] = Variable<int>(lastReadBlock.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (hasSeenAttribution.present) {
      map['has_seen_attribution'] = Variable<bool>(hasSeenAttribution.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuidesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('fileName: $fileName, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastReadSection: $lastReadSection, ')
          ..write('lastReadBlock: $lastReadBlock, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('hasSeenAttribution: $hasSeenAttribution, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$GameDatabase extends GeneratedDatabase {
  _$GameDatabase(QueryExecutor e) : super(e);
  $GameDatabaseManager get managers => $GameDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $GuidesTable guides = $GuidesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [games, guides];
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
      Value<bool> isPhysical,
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
      Value<bool> isPhysical,
      Value<int> rowid,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$GameDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GuidesTable, List<Guide>> _guidesRefsTable(
    _$GameDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.guides,
    aliasName: $_aliasNameGenerator(db.games.id, db.guides.gameId),
  );

  $$GuidesTableProcessedTableManager get guidesRefs {
    final manager = $$GuidesTableTableManager(
      $_db,
      $_db.guides,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_guidesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> guidesRefs(
    Expression<bool> Function($$GuidesTableFilterComposer f) f,
  ) {
    final $$GuidesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.guides,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuidesTableFilterComposer(
            $db: $db,
            $table: $db.guides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
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

  GeneratedColumn<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
    builder: (column) => column,
  );

  Expression<T> guidesRefs<T extends Object>(
    Expression<T> Function($$GuidesTableAnnotationComposer a) f,
  ) {
    final $$GuidesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.guides,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuidesTableAnnotationComposer(
            $db: $db,
            $table: $db.guides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({bool guidesRefs})
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
                Value<bool> isPhysical = const Value.absent(),
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
                isPhysical: isPhysical,
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
                Value<bool> isPhysical = const Value.absent(),
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
                isPhysical: isPhysical,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$GamesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({guidesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (guidesRefs) db.guides],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (guidesRefs)
                    await $_getPrefetchedData<Game, $GamesTable, Guide>(
                      currentTable: table,
                      referencedTable: $$GamesTableReferences._guidesRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$GamesTableReferences(db, table, p0).guidesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.gameId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({bool guidesRefs})
    >;
typedef $$GuidesTableCreateCompanionBuilder =
    GuidesCompanion Function({
      required String id,
      required String gameId,
      required String title,
      required String author,
      required String fileName,
      required DateTime createdAt,
      Value<int> lastReadSection,
      Value<int> lastReadBlock,
      Value<String?> sourceUrl,
      Value<bool> hasSeenAttribution,
      Value<int> rowid,
    });
typedef $$GuidesTableUpdateCompanionBuilder =
    GuidesCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<String> title,
      Value<String> author,
      Value<String> fileName,
      Value<DateTime> createdAt,
      Value<int> lastReadSection,
      Value<int> lastReadBlock,
      Value<String?> sourceUrl,
      Value<bool> hasSeenAttribution,
      Value<int> rowid,
    });

final class $$GuidesTableReferences
    extends BaseReferences<_$GameDatabase, $GuidesTable, Guide> {
  $$GuidesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$GameDatabase db) =>
      db.games.createAlias($_aliasNameGenerator(db.guides.gameId, db.games.id));

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GuidesTableFilterComposer
    extends Composer<_$GameDatabase, $GuidesTable> {
  $$GuidesTableFilterComposer({
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

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReadSection => $composableBuilder(
    column: $table.lastReadSection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReadBlock => $composableBuilder(
    column: $table.lastReadBlock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSeenAttribution => $composableBuilder(
    column: $table.hasSeenAttribution,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GuidesTableOrderingComposer
    extends Composer<_$GameDatabase, $GuidesTable> {
  $$GuidesTableOrderingComposer({
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

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReadSection => $composableBuilder(
    column: $table.lastReadSection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReadBlock => $composableBuilder(
    column: $table.lastReadBlock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSeenAttribution => $composableBuilder(
    column: $table.hasSeenAttribution,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GuidesTableAnnotationComposer
    extends Composer<_$GameDatabase, $GuidesTable> {
  $$GuidesTableAnnotationComposer({
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

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get lastReadSection => $composableBuilder(
    column: $table.lastReadSection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReadBlock => $composableBuilder(
    column: $table.lastReadBlock,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<bool> get hasSeenAttribution => $composableBuilder(
    column: $table.hasSeenAttribution,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GuidesTableTableManager
    extends
        RootTableManager<
          _$GameDatabase,
          $GuidesTable,
          Guide,
          $$GuidesTableFilterComposer,
          $$GuidesTableOrderingComposer,
          $$GuidesTableAnnotationComposer,
          $$GuidesTableCreateCompanionBuilder,
          $$GuidesTableUpdateCompanionBuilder,
          (Guide, $$GuidesTableReferences),
          Guide,
          PrefetchHooks Function({bool gameId})
        > {
  $$GuidesTableTableManager(_$GameDatabase db, $GuidesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$GuidesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$GuidesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$GuidesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> lastReadSection = const Value.absent(),
                Value<int> lastReadBlock = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<bool> hasSeenAttribution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuidesCompanion(
                id: id,
                gameId: gameId,
                title: title,
                author: author,
                fileName: fileName,
                createdAt: createdAt,
                lastReadSection: lastReadSection,
                lastReadBlock: lastReadBlock,
                sourceUrl: sourceUrl,
                hasSeenAttribution: hasSeenAttribution,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required String title,
                required String author,
                required String fileName,
                required DateTime createdAt,
                Value<int> lastReadSection = const Value.absent(),
                Value<int> lastReadBlock = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<bool> hasSeenAttribution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuidesCompanion.insert(
                id: id,
                gameId: gameId,
                title: title,
                author: author,
                fileName: fileName,
                createdAt: createdAt,
                lastReadSection: lastReadSection,
                lastReadBlock: lastReadBlock,
                sourceUrl: sourceUrl,
                hasSeenAttribution: hasSeenAttribution,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$GuidesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (gameId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.gameId,
                            referencedTable: $$GuidesTableReferences
                                ._gameIdTable(db),
                            referencedColumn:
                                $$GuidesTableReferences._gameIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GuidesTableProcessedTableManager =
    ProcessedTableManager<
      _$GameDatabase,
      $GuidesTable,
      Guide,
      $$GuidesTableFilterComposer,
      $$GuidesTableOrderingComposer,
      $$GuidesTableAnnotationComposer,
      $$GuidesTableCreateCompanionBuilder,
      $$GuidesTableUpdateCompanionBuilder,
      (Guide, $$GuidesTableReferences),
      Guide,
      PrefetchHooks Function({bool gameId})
    >;

class $GameDatabaseManager {
  final _$GameDatabase _db;
  $GameDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$GuidesTableTableManager get guides =>
      $$GuidesTableTableManager(_db, _db.guides);
}
