// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_database.dart';

// ignore_for_file: type=lint
class $DataImportEntriesTable extends DataImportEntries
    with TableInfo<$DataImportEntriesTable, DataImportEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DataImportEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ImportSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ImportSource>($DataImportEntriesTable.$convertersource);
  static const VerificationMeta _sourceVersionMeta = const VerificationMeta(
    'sourceVersion',
  );
  @override
  late final GeneratedColumn<String> sourceVersion = GeneratedColumn<String>(
    'source_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ImportStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(
          const ImportStatusConverter().toSql(ImportStatus.pending),
        ),
      ).withConverter<ImportStatus>($DataImportEntriesTable.$converterstatus);
  static const VerificationMeta _recordCountMeta = const VerificationMeta(
    'recordCount',
  );
  @override
  late final GeneratedColumn<int> recordCount = GeneratedColumn<int>(
    'record_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingestedAtMeta = const VerificationMeta(
    'ingestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> ingestedAt = GeneratedColumn<DateTime>(
    'ingested_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
    'processed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  metadata =
      GeneratedColumn<String>(
        'metadata',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Map<String, Object?>?>(
        $DataImportEntriesTable.$convertermetadata,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    sourceVersion,
    status,
    recordCount,
    startedAt,
    ingestedAt,
    processedAt,
    errorMessage,
    metadata,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'data_import_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DataImportEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_version')) {
      context.handle(
        _sourceVersionMeta,
        sourceVersion.isAcceptableOrUnknown(
          data['source_version']!,
          _sourceVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceVersionMeta);
    }
    if (data.containsKey('record_count')) {
      context.handle(
        _recordCountMeta,
        recordCount.isAcceptableOrUnknown(
          data['record_count']!,
          _recordCountMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ingested_at')) {
      context.handle(
        _ingestedAtMeta,
        ingestedAt.isAcceptableOrUnknown(data['ingested_at']!, _ingestedAtMeta),
      );
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DataImportEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DataImportEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      source: $DataImportEntriesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      sourceVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_version'],
      )!,
      status: $DataImportEntriesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      recordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_count'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      ingestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ingested_at'],
      ),
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}processed_at'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      metadata: $DataImportEntriesTable.$convertermetadata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metadata'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DataImportEntriesTable createAlias(String alias) {
    return $DataImportEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<ImportSource, String> $convertersource =
      const ImportSourceConverter();
  static TypeConverter<ImportStatus, String> $converterstatus =
      const ImportStatusConverter();
  static TypeConverter<Map<String, Object?>?, String?> $convertermetadata =
      const JsonMapConverter();
}

class DataImportEntry extends DataClass implements Insertable<DataImportEntry> {
  final int id;
  final ImportSource source;
  final String sourceVersion;
  final ImportStatus status;
  final int? recordCount;
  final DateTime startedAt;
  final DateTime? ingestedAt;
  final DateTime? processedAt;
  final String? errorMessage;
  final Map<String, Object?>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DataImportEntry({
    required this.id,
    required this.source,
    required this.sourceVersion,
    required this.status,
    this.recordCount,
    required this.startedAt,
    this.ingestedAt,
    this.processedAt,
    this.errorMessage,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['source'] = Variable<String>(
        $DataImportEntriesTable.$convertersource.toSql(source),
      );
    }
    map['source_version'] = Variable<String>(sourceVersion);
    {
      map['status'] = Variable<String>(
        $DataImportEntriesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || recordCount != null) {
      map['record_count'] = Variable<int>(recordCount);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || ingestedAt != null) {
      map['ingested_at'] = Variable<DateTime>(ingestedAt);
    }
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(
        $DataImportEntriesTable.$convertermetadata.toSql(metadata),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DataImportEntriesCompanion toCompanion(bool nullToAbsent) {
    return DataImportEntriesCompanion(
      id: Value(id),
      source: Value(source),
      sourceVersion: Value(sourceVersion),
      status: Value(status),
      recordCount: recordCount == null && nullToAbsent
          ? const Value.absent()
          : Value(recordCount),
      startedAt: Value(startedAt),
      ingestedAt: ingestedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(ingestedAt),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DataImportEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DataImportEntry(
      id: serializer.fromJson<int>(json['id']),
      source: serializer.fromJson<ImportSource>(json['source']),
      sourceVersion: serializer.fromJson<String>(json['sourceVersion']),
      status: serializer.fromJson<ImportStatus>(json['status']),
      recordCount: serializer.fromJson<int?>(json['recordCount']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      ingestedAt: serializer.fromJson<DateTime?>(json['ingestedAt']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      metadata: serializer.fromJson<Map<String, Object?>?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'source': serializer.toJson<ImportSource>(source),
      'sourceVersion': serializer.toJson<String>(sourceVersion),
      'status': serializer.toJson<ImportStatus>(status),
      'recordCount': serializer.toJson<int?>(recordCount),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'ingestedAt': serializer.toJson<DateTime?>(ingestedAt),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'metadata': serializer.toJson<Map<String, Object?>?>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DataImportEntry copyWith({
    int? id,
    ImportSource? source,
    String? sourceVersion,
    ImportStatus? status,
    Value<int?> recordCount = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> ingestedAt = const Value.absent(),
    Value<DateTime?> processedAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    Value<Map<String, Object?>?> metadata = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DataImportEntry(
    id: id ?? this.id,
    source: source ?? this.source,
    sourceVersion: sourceVersion ?? this.sourceVersion,
    status: status ?? this.status,
    recordCount: recordCount.present ? recordCount.value : this.recordCount,
    startedAt: startedAt ?? this.startedAt,
    ingestedAt: ingestedAt.present ? ingestedAt.value : this.ingestedAt,
    processedAt: processedAt.present ? processedAt.value : this.processedAt,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DataImportEntry copyWithCompanion(DataImportEntriesCompanion data) {
    return DataImportEntry(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      sourceVersion: data.sourceVersion.present
          ? data.sourceVersion.value
          : this.sourceVersion,
      status: data.status.present ? data.status.value : this.status,
      recordCount: data.recordCount.present
          ? data.recordCount.value
          : this.recordCount,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      ingestedAt: data.ingestedAt.present
          ? data.ingestedAt.value
          : this.ingestedAt,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DataImportEntry(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('sourceVersion: $sourceVersion, ')
          ..write('status: $status, ')
          ..write('recordCount: $recordCount, ')
          ..write('startedAt: $startedAt, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('processedAt: $processedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    source,
    sourceVersion,
    status,
    recordCount,
    startedAt,
    ingestedAt,
    processedAt,
    errorMessage,
    metadata,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataImportEntry &&
          other.id == this.id &&
          other.source == this.source &&
          other.sourceVersion == this.sourceVersion &&
          other.status == this.status &&
          other.recordCount == this.recordCount &&
          other.startedAt == this.startedAt &&
          other.ingestedAt == this.ingestedAt &&
          other.processedAt == this.processedAt &&
          other.errorMessage == this.errorMessage &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DataImportEntriesCompanion extends UpdateCompanion<DataImportEntry> {
  final Value<int> id;
  final Value<ImportSource> source;
  final Value<String> sourceVersion;
  final Value<ImportStatus> status;
  final Value<int?> recordCount;
  final Value<DateTime> startedAt;
  final Value<DateTime?> ingestedAt;
  final Value<DateTime?> processedAt;
  final Value<String?> errorMessage;
  final Value<Map<String, Object?>?> metadata;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DataImportEntriesCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.recordCount = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.ingestedAt = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DataImportEntriesCompanion.insert({
    this.id = const Value.absent(),
    required ImportSource source,
    required String sourceVersion,
    this.status = const Value.absent(),
    this.recordCount = const Value.absent(),
    required DateTime startedAt,
    this.ingestedAt = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.metadata = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : source = Value(source),
       sourceVersion = Value(sourceVersion),
       startedAt = Value(startedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DataImportEntry> custom({
    Expression<int>? id,
    Expression<String>? source,
    Expression<String>? sourceVersion,
    Expression<String>? status,
    Expression<int>? recordCount,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? ingestedAt,
    Expression<DateTime>? processedAt,
    Expression<String>? errorMessage,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (sourceVersion != null) 'source_version': sourceVersion,
      if (status != null) 'status': status,
      if (recordCount != null) 'record_count': recordCount,
      if (startedAt != null) 'started_at': startedAt,
      if (ingestedAt != null) 'ingested_at': ingestedAt,
      if (processedAt != null) 'processed_at': processedAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DataImportEntriesCompanion copyWith({
    Value<int>? id,
    Value<ImportSource>? source,
    Value<String>? sourceVersion,
    Value<ImportStatus>? status,
    Value<int?>? recordCount,
    Value<DateTime>? startedAt,
    Value<DateTime?>? ingestedAt,
    Value<DateTime?>? processedAt,
    Value<String?>? errorMessage,
    Value<Map<String, Object?>?>? metadata,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DataImportEntriesCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      sourceVersion: sourceVersion ?? this.sourceVersion,
      status: status ?? this.status,
      recordCount: recordCount ?? this.recordCount,
      startedAt: startedAt ?? this.startedAt,
      ingestedAt: ingestedAt ?? this.ingestedAt,
      processedAt: processedAt ?? this.processedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $DataImportEntriesTable.$convertersource.toSql(source.value),
      );
    }
    if (sourceVersion.present) {
      map['source_version'] = Variable<String>(sourceVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DataImportEntriesTable.$converterstatus.toSql(status.value),
      );
    }
    if (recordCount.present) {
      map['record_count'] = Variable<int>(recordCount.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (ingestedAt.present) {
      map['ingested_at'] = Variable<DateTime>(ingestedAt.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
        $DataImportEntriesTable.$convertermetadata.toSql(metadata.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DataImportEntriesCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('sourceVersion: $sourceVersion, ')
          ..write('status: $status, ')
          ..write('recordCount: $recordCount, ')
          ..write('startedAt: $startedAt, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('processedAt: $processedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RawKanjiVgEntriesTable extends RawKanjiVgEntries
    with TableInfo<$RawKanjiVgEntriesTable, RawKanjiVgEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawKanjiVgEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _importIdMeta = const VerificationMeta(
    'importId',
  );
  @override
  late final GeneratedColumn<int> importId = GeneratedColumn<int>(
    'import_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES data_import_entries (id)',
    ),
  );
  static const VerificationMeta _characterMeta = const VerificationMeta(
    'character',
  );
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
    'character',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unicodeHexMeta = const VerificationMeta(
    'unicodeHex',
  );
  @override
  late final GeneratedColumn<String> unicodeHex = GeneratedColumn<String>(
    'unicode_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _viewBoxMeta = const VerificationMeta(
    'viewBox',
  );
  @override
  late final GeneratedColumn<String> viewBox = GeneratedColumn<String>(
    'view_box',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strokeCountMeta = const VerificationMeta(
    'strokeCount',
  );
  @override
  late final GeneratedColumn<int> strokeCount = GeneratedColumn<int>(
    'stroke_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<KanjiVgStroke>, String>
  strokes =
      GeneratedColumn<String>(
        'strokes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<KanjiVgStroke>>(
        $RawKanjiVgEntriesTable.$converterstrokes,
      );
  @override
  late final GeneratedColumnWithTypeConverter<KanjiVgComponent, String>
  components =
      GeneratedColumn<String>(
        'components',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<KanjiVgComponent>(
        $RawKanjiVgEntriesTable.$convertercomponents,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    importId,
    character,
    unicodeHex,
    viewBox,
    strokeCount,
    strokes,
    components,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_kanji_vg_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawKanjiVgEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('import_id')) {
      context.handle(
        _importIdMeta,
        importId.isAcceptableOrUnknown(data['import_id']!, _importIdMeta),
      );
    } else if (isInserting) {
      context.missing(_importIdMeta);
    }
    if (data.containsKey('character')) {
      context.handle(
        _characterMeta,
        character.isAcceptableOrUnknown(data['character']!, _characterMeta),
      );
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('unicode_hex')) {
      context.handle(
        _unicodeHexMeta,
        unicodeHex.isAcceptableOrUnknown(data['unicode_hex']!, _unicodeHexMeta),
      );
    } else if (isInserting) {
      context.missing(_unicodeHexMeta);
    }
    if (data.containsKey('view_box')) {
      context.handle(
        _viewBoxMeta,
        viewBox.isAcceptableOrUnknown(data['view_box']!, _viewBoxMeta),
      );
    } else if (isInserting) {
      context.missing(_viewBoxMeta);
    }
    if (data.containsKey('stroke_count')) {
      context.handle(
        _strokeCountMeta,
        strokeCount.isAcceptableOrUnknown(
          data['stroke_count']!,
          _strokeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_strokeCountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {importId, character};
  @override
  RawKanjiVgEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawKanjiVgEntry(
      importId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}import_id'],
      )!,
      character: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character'],
      )!,
      unicodeHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unicode_hex'],
      )!,
      viewBox: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}view_box'],
      )!,
      strokeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stroke_count'],
      )!,
      strokes: $RawKanjiVgEntriesTable.$converterstrokes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}strokes'],
        )!,
      ),
      components: $RawKanjiVgEntriesTable.$convertercomponents.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}components'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RawKanjiVgEntriesTable createAlias(String alias) {
    return $RawKanjiVgEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<KanjiVgStroke>, String> $converterstrokes =
      const KanjiVgStrokesConverter();
  static TypeConverter<KanjiVgComponent, String> $convertercomponents =
      const KanjiVgComponentConverter();
}

class RawKanjiVgEntry extends DataClass implements Insertable<RawKanjiVgEntry> {
  final int importId;
  final String character;
  final String unicodeHex;
  final String viewBox;
  final int strokeCount;
  final List<KanjiVgStroke> strokes;
  final KanjiVgComponent components;
  final DateTime createdAt;
  const RawKanjiVgEntry({
    required this.importId,
    required this.character,
    required this.unicodeHex,
    required this.viewBox,
    required this.strokeCount,
    required this.strokes,
    required this.components,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['import_id'] = Variable<int>(importId);
    map['character'] = Variable<String>(character);
    map['unicode_hex'] = Variable<String>(unicodeHex);
    map['view_box'] = Variable<String>(viewBox);
    map['stroke_count'] = Variable<int>(strokeCount);
    {
      map['strokes'] = Variable<String>(
        $RawKanjiVgEntriesTable.$converterstrokes.toSql(strokes),
      );
    }
    {
      map['components'] = Variable<String>(
        $RawKanjiVgEntriesTable.$convertercomponents.toSql(components),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RawKanjiVgEntriesCompanion toCompanion(bool nullToAbsent) {
    return RawKanjiVgEntriesCompanion(
      importId: Value(importId),
      character: Value(character),
      unicodeHex: Value(unicodeHex),
      viewBox: Value(viewBox),
      strokeCount: Value(strokeCount),
      strokes: Value(strokes),
      components: Value(components),
      createdAt: Value(createdAt),
    );
  }

  factory RawKanjiVgEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawKanjiVgEntry(
      importId: serializer.fromJson<int>(json['importId']),
      character: serializer.fromJson<String>(json['character']),
      unicodeHex: serializer.fromJson<String>(json['unicodeHex']),
      viewBox: serializer.fromJson<String>(json['viewBox']),
      strokeCount: serializer.fromJson<int>(json['strokeCount']),
      strokes: serializer.fromJson<List<KanjiVgStroke>>(json['strokes']),
      components: serializer.fromJson<KanjiVgComponent>(json['components']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'importId': serializer.toJson<int>(importId),
      'character': serializer.toJson<String>(character),
      'unicodeHex': serializer.toJson<String>(unicodeHex),
      'viewBox': serializer.toJson<String>(viewBox),
      'strokeCount': serializer.toJson<int>(strokeCount),
      'strokes': serializer.toJson<List<KanjiVgStroke>>(strokes),
      'components': serializer.toJson<KanjiVgComponent>(components),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RawKanjiVgEntry copyWith({
    int? importId,
    String? character,
    String? unicodeHex,
    String? viewBox,
    int? strokeCount,
    List<KanjiVgStroke>? strokes,
    KanjiVgComponent? components,
    DateTime? createdAt,
  }) => RawKanjiVgEntry(
    importId: importId ?? this.importId,
    character: character ?? this.character,
    unicodeHex: unicodeHex ?? this.unicodeHex,
    viewBox: viewBox ?? this.viewBox,
    strokeCount: strokeCount ?? this.strokeCount,
    strokes: strokes ?? this.strokes,
    components: components ?? this.components,
    createdAt: createdAt ?? this.createdAt,
  );
  RawKanjiVgEntry copyWithCompanion(RawKanjiVgEntriesCompanion data) {
    return RawKanjiVgEntry(
      importId: data.importId.present ? data.importId.value : this.importId,
      character: data.character.present ? data.character.value : this.character,
      unicodeHex: data.unicodeHex.present
          ? data.unicodeHex.value
          : this.unicodeHex,
      viewBox: data.viewBox.present ? data.viewBox.value : this.viewBox,
      strokeCount: data.strokeCount.present
          ? data.strokeCount.value
          : this.strokeCount,
      strokes: data.strokes.present ? data.strokes.value : this.strokes,
      components: data.components.present
          ? data.components.value
          : this.components,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawKanjiVgEntry(')
          ..write('importId: $importId, ')
          ..write('character: $character, ')
          ..write('unicodeHex: $unicodeHex, ')
          ..write('viewBox: $viewBox, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('strokes: $strokes, ')
          ..write('components: $components, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    importId,
    character,
    unicodeHex,
    viewBox,
    strokeCount,
    strokes,
    components,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawKanjiVgEntry &&
          other.importId == this.importId &&
          other.character == this.character &&
          other.unicodeHex == this.unicodeHex &&
          other.viewBox == this.viewBox &&
          other.strokeCount == this.strokeCount &&
          other.strokes == this.strokes &&
          other.components == this.components &&
          other.createdAt == this.createdAt);
}

class RawKanjiVgEntriesCompanion extends UpdateCompanion<RawKanjiVgEntry> {
  final Value<int> importId;
  final Value<String> character;
  final Value<String> unicodeHex;
  final Value<String> viewBox;
  final Value<int> strokeCount;
  final Value<List<KanjiVgStroke>> strokes;
  final Value<KanjiVgComponent> components;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RawKanjiVgEntriesCompanion({
    this.importId = const Value.absent(),
    this.character = const Value.absent(),
    this.unicodeHex = const Value.absent(),
    this.viewBox = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.strokes = const Value.absent(),
    this.components = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RawKanjiVgEntriesCompanion.insert({
    required int importId,
    required String character,
    required String unicodeHex,
    required String viewBox,
    required int strokeCount,
    required List<KanjiVgStroke> strokes,
    required KanjiVgComponent components,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : importId = Value(importId),
       character = Value(character),
       unicodeHex = Value(unicodeHex),
       viewBox = Value(viewBox),
       strokeCount = Value(strokeCount),
       strokes = Value(strokes),
       components = Value(components);
  static Insertable<RawKanjiVgEntry> custom({
    Expression<int>? importId,
    Expression<String>? character,
    Expression<String>? unicodeHex,
    Expression<String>? viewBox,
    Expression<int>? strokeCount,
    Expression<String>? strokes,
    Expression<String>? components,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (importId != null) 'import_id': importId,
      if (character != null) 'character': character,
      if (unicodeHex != null) 'unicode_hex': unicodeHex,
      if (viewBox != null) 'view_box': viewBox,
      if (strokeCount != null) 'stroke_count': strokeCount,
      if (strokes != null) 'strokes': strokes,
      if (components != null) 'components': components,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RawKanjiVgEntriesCompanion copyWith({
    Value<int>? importId,
    Value<String>? character,
    Value<String>? unicodeHex,
    Value<String>? viewBox,
    Value<int>? strokeCount,
    Value<List<KanjiVgStroke>>? strokes,
    Value<KanjiVgComponent>? components,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RawKanjiVgEntriesCompanion(
      importId: importId ?? this.importId,
      character: character ?? this.character,
      unicodeHex: unicodeHex ?? this.unicodeHex,
      viewBox: viewBox ?? this.viewBox,
      strokeCount: strokeCount ?? this.strokeCount,
      strokes: strokes ?? this.strokes,
      components: components ?? this.components,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (importId.present) {
      map['import_id'] = Variable<int>(importId.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (unicodeHex.present) {
      map['unicode_hex'] = Variable<String>(unicodeHex.value);
    }
    if (viewBox.present) {
      map['view_box'] = Variable<String>(viewBox.value);
    }
    if (strokeCount.present) {
      map['stroke_count'] = Variable<int>(strokeCount.value);
    }
    if (strokes.present) {
      map['strokes'] = Variable<String>(
        $RawKanjiVgEntriesTable.$converterstrokes.toSql(strokes.value),
      );
    }
    if (components.present) {
      map['components'] = Variable<String>(
        $RawKanjiVgEntriesTable.$convertercomponents.toSql(components.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawKanjiVgEntriesCompanion(')
          ..write('importId: $importId, ')
          ..write('character: $character, ')
          ..write('unicodeHex: $unicodeHex, ')
          ..write('viewBox: $viewBox, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('strokes: $strokes, ')
          ..write('components: $components, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RawKanjidicEntriesTable extends RawKanjidicEntries
    with TableInfo<$RawKanjidicEntriesTable, RawKanjidicEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawKanjidicEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _importIdMeta = const VerificationMeta(
    'importId',
  );
  @override
  late final GeneratedColumn<int> importId = GeneratedColumn<int>(
    'import_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES data_import_entries (id)',
    ),
  );
  static const VerificationMeta _literalMeta = const VerificationMeta(
    'literal',
  );
  @override
  late final GeneratedColumn<String> literal = GeneratedColumn<String>(
    'literal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strokeCountMeta = const VerificationMeta(
    'strokeCount',
  );
  @override
  late final GeneratedColumn<int> strokeCount = GeneratedColumn<int>(
    'stroke_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<int>?, String>
  strokeCountMisstrokes =
      GeneratedColumn<String>(
        'stroke_count_misstrokes',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<int>?>(
        $RawKanjidicEntriesTable.$converterstrokeCountMisstrokes,
      );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jlptMeta = const VerificationMeta('jlpt');
  @override
  late final GeneratedColumn<int> jlpt = GeneratedColumn<int>(
    'jlpt',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
    'frequency',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<KanjidicCodepoints, String>
  codepoints =
      GeneratedColumn<String>(
        'codepoints',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<KanjidicCodepoints>(
        $RawKanjidicEntriesTable.$convertercodepoints,
      );
  @override
  late final GeneratedColumnWithTypeConverter<KanjidicRadicals, String>
  radicals =
      GeneratedColumn<String>(
        'radicals',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<KanjidicRadicals>(
        $RawKanjidicEntriesTable.$converterradicals,
      );
  @override
  late final GeneratedColumnWithTypeConverter<KanjidicDictRefs?, String>
  dictRefs =
      GeneratedColumn<String>(
        'dict_refs',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<KanjidicDictRefs?>(
        $RawKanjidicEntriesTable.$converterdictRefs,
      );
  @override
  late final GeneratedColumnWithTypeConverter<KanjidicQueryCodes?, String>
  queryCodes =
      GeneratedColumn<String>(
        'query_codes',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<KanjidicQueryCodes?>(
        $RawKanjidicEntriesTable.$converterqueryCodes,
      );
  @override
  late final GeneratedColumnWithTypeConverter<KanjidicReadings, String>
  readings =
      GeneratedColumn<String>(
        'readings',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<KanjidicReadings>(
        $RawKanjidicEntriesTable.$converterreadings,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String> nanori =
      GeneratedColumn<String>(
        'nanori',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<String>?>($RawKanjidicEntriesTable.$converternanori);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, List<String>>, String>
  meanings =
      GeneratedColumn<String>(
        'meanings',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Map<String, List<String>>>(
        $RawKanjidicEntriesTable.$convertermeanings,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<KanjidicVariant>?, String>
  variants =
      GeneratedColumn<String>(
        'variants',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<KanjidicVariant>?>(
        $RawKanjidicEntriesTable.$convertervariants,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
  radicalNames =
      GeneratedColumn<String>(
        'radical_names',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<String>?>(
        $RawKanjidicEntriesTable.$converterradicalNames,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    importId,
    literal,
    strokeCount,
    strokeCountMisstrokes,
    grade,
    jlpt,
    frequency,
    codepoints,
    radicals,
    dictRefs,
    queryCodes,
    readings,
    nanori,
    meanings,
    variants,
    radicalNames,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_kanjidic_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawKanjidicEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('import_id')) {
      context.handle(
        _importIdMeta,
        importId.isAcceptableOrUnknown(data['import_id']!, _importIdMeta),
      );
    } else if (isInserting) {
      context.missing(_importIdMeta);
    }
    if (data.containsKey('literal')) {
      context.handle(
        _literalMeta,
        literal.isAcceptableOrUnknown(data['literal']!, _literalMeta),
      );
    } else if (isInserting) {
      context.missing(_literalMeta);
    }
    if (data.containsKey('stroke_count')) {
      context.handle(
        _strokeCountMeta,
        strokeCount.isAcceptableOrUnknown(
          data['stroke_count']!,
          _strokeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_strokeCountMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    }
    if (data.containsKey('jlpt')) {
      context.handle(
        _jlptMeta,
        jlpt.isAcceptableOrUnknown(data['jlpt']!, _jlptMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {importId, literal};
  @override
  RawKanjidicEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawKanjidicEntry(
      importId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}import_id'],
      )!,
      literal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}literal'],
      )!,
      strokeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stroke_count'],
      )!,
      strokeCountMisstrokes: $RawKanjidicEntriesTable
          .$converterstrokeCountMisstrokes
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}stroke_count_misstrokes'],
            ),
          ),
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      ),
      jlpt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jlpt'],
      ),
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency'],
      ),
      codepoints: $RawKanjidicEntriesTable.$convertercodepoints.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}codepoints'],
        )!,
      ),
      radicals: $RawKanjidicEntriesTable.$converterradicals.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}radicals'],
        )!,
      ),
      dictRefs: $RawKanjidicEntriesTable.$converterdictRefs.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}dict_refs'],
        ),
      ),
      queryCodes: $RawKanjidicEntriesTable.$converterqueryCodes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}query_codes'],
        ),
      ),
      readings: $RawKanjidicEntriesTable.$converterreadings.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}readings'],
        )!,
      ),
      nanori: $RawKanjidicEntriesTable.$converternanori.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}nanori'],
        ),
      ),
      meanings: $RawKanjidicEntriesTable.$convertermeanings.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}meanings'],
        )!,
      ),
      variants: $RawKanjidicEntriesTable.$convertervariants.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}variants'],
        ),
      ),
      radicalNames: $RawKanjidicEntriesTable.$converterradicalNames.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}radical_names'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RawKanjidicEntriesTable createAlias(String alias) {
    return $RawKanjidicEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>?, String?> $converterstrokeCountMisstrokes =
      const IntListConverter();
  static TypeConverter<KanjidicCodepoints, String> $convertercodepoints =
      const KanjidicCodepointsConverter();
  static TypeConverter<KanjidicRadicals, String> $converterradicals =
      const KanjidicRadicalsConverter();
  static TypeConverter<KanjidicDictRefs?, String?> $converterdictRefs =
      const KanjidicDictRefsConverter();
  static TypeConverter<KanjidicQueryCodes?, String?> $converterqueryCodes =
      const KanjidicQueryCodesConverter();
  static TypeConverter<KanjidicReadings, String> $converterreadings =
      const KanjidicReadingsConverter();
  static TypeConverter<List<String>?, String?> $converternanori =
      const StringListConverter();
  static TypeConverter<Map<String, List<String>>, String> $convertermeanings =
      const MeaningsConverter();
  static TypeConverter<List<KanjidicVariant>?, String?> $convertervariants =
      const KanjidicVariantsConverter();
  static TypeConverter<List<String>?, String?> $converterradicalNames =
      const StringListConverter();
}

class RawKanjidicEntry extends DataClass
    implements Insertable<RawKanjidicEntry> {
  final int importId;
  final String literal;
  final int strokeCount;
  final List<int>? strokeCountMisstrokes;
  final int? grade;
  final int? jlpt;
  final int? frequency;
  final KanjidicCodepoints codepoints;
  final KanjidicRadicals radicals;
  final KanjidicDictRefs? dictRefs;
  final KanjidicQueryCodes? queryCodes;
  final KanjidicReadings readings;
  final List<String>? nanori;
  final Map<String, List<String>> meanings;
  final List<KanjidicVariant>? variants;
  final List<String>? radicalNames;
  final DateTime createdAt;
  const RawKanjidicEntry({
    required this.importId,
    required this.literal,
    required this.strokeCount,
    this.strokeCountMisstrokes,
    this.grade,
    this.jlpt,
    this.frequency,
    required this.codepoints,
    required this.radicals,
    this.dictRefs,
    this.queryCodes,
    required this.readings,
    this.nanori,
    required this.meanings,
    this.variants,
    this.radicalNames,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['import_id'] = Variable<int>(importId);
    map['literal'] = Variable<String>(literal);
    map['stroke_count'] = Variable<int>(strokeCount);
    if (!nullToAbsent || strokeCountMisstrokes != null) {
      map['stroke_count_misstrokes'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterstrokeCountMisstrokes.toSql(
          strokeCountMisstrokes,
        ),
      );
    }
    if (!nullToAbsent || grade != null) {
      map['grade'] = Variable<int>(grade);
    }
    if (!nullToAbsent || jlpt != null) {
      map['jlpt'] = Variable<int>(jlpt);
    }
    if (!nullToAbsent || frequency != null) {
      map['frequency'] = Variable<int>(frequency);
    }
    {
      map['codepoints'] = Variable<String>(
        $RawKanjidicEntriesTable.$convertercodepoints.toSql(codepoints),
      );
    }
    {
      map['radicals'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterradicals.toSql(radicals),
      );
    }
    if (!nullToAbsent || dictRefs != null) {
      map['dict_refs'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterdictRefs.toSql(dictRefs),
      );
    }
    if (!nullToAbsent || queryCodes != null) {
      map['query_codes'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterqueryCodes.toSql(queryCodes),
      );
    }
    {
      map['readings'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterreadings.toSql(readings),
      );
    }
    if (!nullToAbsent || nanori != null) {
      map['nanori'] = Variable<String>(
        $RawKanjidicEntriesTable.$converternanori.toSql(nanori),
      );
    }
    {
      map['meanings'] = Variable<String>(
        $RawKanjidicEntriesTable.$convertermeanings.toSql(meanings),
      );
    }
    if (!nullToAbsent || variants != null) {
      map['variants'] = Variable<String>(
        $RawKanjidicEntriesTable.$convertervariants.toSql(variants),
      );
    }
    if (!nullToAbsent || radicalNames != null) {
      map['radical_names'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterradicalNames.toSql(radicalNames),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RawKanjidicEntriesCompanion toCompanion(bool nullToAbsent) {
    return RawKanjidicEntriesCompanion(
      importId: Value(importId),
      literal: Value(literal),
      strokeCount: Value(strokeCount),
      strokeCountMisstrokes: strokeCountMisstrokes == null && nullToAbsent
          ? const Value.absent()
          : Value(strokeCountMisstrokes),
      grade: grade == null && nullToAbsent
          ? const Value.absent()
          : Value(grade),
      jlpt: jlpt == null && nullToAbsent ? const Value.absent() : Value(jlpt),
      frequency: frequency == null && nullToAbsent
          ? const Value.absent()
          : Value(frequency),
      codepoints: Value(codepoints),
      radicals: Value(radicals),
      dictRefs: dictRefs == null && nullToAbsent
          ? const Value.absent()
          : Value(dictRefs),
      queryCodes: queryCodes == null && nullToAbsent
          ? const Value.absent()
          : Value(queryCodes),
      readings: Value(readings),
      nanori: nanori == null && nullToAbsent
          ? const Value.absent()
          : Value(nanori),
      meanings: Value(meanings),
      variants: variants == null && nullToAbsent
          ? const Value.absent()
          : Value(variants),
      radicalNames: radicalNames == null && nullToAbsent
          ? const Value.absent()
          : Value(radicalNames),
      createdAt: Value(createdAt),
    );
  }

  factory RawKanjidicEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawKanjidicEntry(
      importId: serializer.fromJson<int>(json['importId']),
      literal: serializer.fromJson<String>(json['literal']),
      strokeCount: serializer.fromJson<int>(json['strokeCount']),
      strokeCountMisstrokes: serializer.fromJson<List<int>?>(
        json['strokeCountMisstrokes'],
      ),
      grade: serializer.fromJson<int?>(json['grade']),
      jlpt: serializer.fromJson<int?>(json['jlpt']),
      frequency: serializer.fromJson<int?>(json['frequency']),
      codepoints: serializer.fromJson<KanjidicCodepoints>(json['codepoints']),
      radicals: serializer.fromJson<KanjidicRadicals>(json['radicals']),
      dictRefs: serializer.fromJson<KanjidicDictRefs?>(json['dictRefs']),
      queryCodes: serializer.fromJson<KanjidicQueryCodes?>(json['queryCodes']),
      readings: serializer.fromJson<KanjidicReadings>(json['readings']),
      nanori: serializer.fromJson<List<String>?>(json['nanori']),
      meanings: serializer.fromJson<Map<String, List<String>>>(
        json['meanings'],
      ),
      variants: serializer.fromJson<List<KanjidicVariant>?>(json['variants']),
      radicalNames: serializer.fromJson<List<String>?>(json['radicalNames']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'importId': serializer.toJson<int>(importId),
      'literal': serializer.toJson<String>(literal),
      'strokeCount': serializer.toJson<int>(strokeCount),
      'strokeCountMisstrokes': serializer.toJson<List<int>?>(
        strokeCountMisstrokes,
      ),
      'grade': serializer.toJson<int?>(grade),
      'jlpt': serializer.toJson<int?>(jlpt),
      'frequency': serializer.toJson<int?>(frequency),
      'codepoints': serializer.toJson<KanjidicCodepoints>(codepoints),
      'radicals': serializer.toJson<KanjidicRadicals>(radicals),
      'dictRefs': serializer.toJson<KanjidicDictRefs?>(dictRefs),
      'queryCodes': serializer.toJson<KanjidicQueryCodes?>(queryCodes),
      'readings': serializer.toJson<KanjidicReadings>(readings),
      'nanori': serializer.toJson<List<String>?>(nanori),
      'meanings': serializer.toJson<Map<String, List<String>>>(meanings),
      'variants': serializer.toJson<List<KanjidicVariant>?>(variants),
      'radicalNames': serializer.toJson<List<String>?>(radicalNames),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RawKanjidicEntry copyWith({
    int? importId,
    String? literal,
    int? strokeCount,
    Value<List<int>?> strokeCountMisstrokes = const Value.absent(),
    Value<int?> grade = const Value.absent(),
    Value<int?> jlpt = const Value.absent(),
    Value<int?> frequency = const Value.absent(),
    KanjidicCodepoints? codepoints,
    KanjidicRadicals? radicals,
    Value<KanjidicDictRefs?> dictRefs = const Value.absent(),
    Value<KanjidicQueryCodes?> queryCodes = const Value.absent(),
    KanjidicReadings? readings,
    Value<List<String>?> nanori = const Value.absent(),
    Map<String, List<String>>? meanings,
    Value<List<KanjidicVariant>?> variants = const Value.absent(),
    Value<List<String>?> radicalNames = const Value.absent(),
    DateTime? createdAt,
  }) => RawKanjidicEntry(
    importId: importId ?? this.importId,
    literal: literal ?? this.literal,
    strokeCount: strokeCount ?? this.strokeCount,
    strokeCountMisstrokes: strokeCountMisstrokes.present
        ? strokeCountMisstrokes.value
        : this.strokeCountMisstrokes,
    grade: grade.present ? grade.value : this.grade,
    jlpt: jlpt.present ? jlpt.value : this.jlpt,
    frequency: frequency.present ? frequency.value : this.frequency,
    codepoints: codepoints ?? this.codepoints,
    radicals: radicals ?? this.radicals,
    dictRefs: dictRefs.present ? dictRefs.value : this.dictRefs,
    queryCodes: queryCodes.present ? queryCodes.value : this.queryCodes,
    readings: readings ?? this.readings,
    nanori: nanori.present ? nanori.value : this.nanori,
    meanings: meanings ?? this.meanings,
    variants: variants.present ? variants.value : this.variants,
    radicalNames: radicalNames.present ? radicalNames.value : this.radicalNames,
    createdAt: createdAt ?? this.createdAt,
  );
  RawKanjidicEntry copyWithCompanion(RawKanjidicEntriesCompanion data) {
    return RawKanjidicEntry(
      importId: data.importId.present ? data.importId.value : this.importId,
      literal: data.literal.present ? data.literal.value : this.literal,
      strokeCount: data.strokeCount.present
          ? data.strokeCount.value
          : this.strokeCount,
      strokeCountMisstrokes: data.strokeCountMisstrokes.present
          ? data.strokeCountMisstrokes.value
          : this.strokeCountMisstrokes,
      grade: data.grade.present ? data.grade.value : this.grade,
      jlpt: data.jlpt.present ? data.jlpt.value : this.jlpt,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      codepoints: data.codepoints.present
          ? data.codepoints.value
          : this.codepoints,
      radicals: data.radicals.present ? data.radicals.value : this.radicals,
      dictRefs: data.dictRefs.present ? data.dictRefs.value : this.dictRefs,
      queryCodes: data.queryCodes.present
          ? data.queryCodes.value
          : this.queryCodes,
      readings: data.readings.present ? data.readings.value : this.readings,
      nanori: data.nanori.present ? data.nanori.value : this.nanori,
      meanings: data.meanings.present ? data.meanings.value : this.meanings,
      variants: data.variants.present ? data.variants.value : this.variants,
      radicalNames: data.radicalNames.present
          ? data.radicalNames.value
          : this.radicalNames,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawKanjidicEntry(')
          ..write('importId: $importId, ')
          ..write('literal: $literal, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('strokeCountMisstrokes: $strokeCountMisstrokes, ')
          ..write('grade: $grade, ')
          ..write('jlpt: $jlpt, ')
          ..write('frequency: $frequency, ')
          ..write('codepoints: $codepoints, ')
          ..write('radicals: $radicals, ')
          ..write('dictRefs: $dictRefs, ')
          ..write('queryCodes: $queryCodes, ')
          ..write('readings: $readings, ')
          ..write('nanori: $nanori, ')
          ..write('meanings: $meanings, ')
          ..write('variants: $variants, ')
          ..write('radicalNames: $radicalNames, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    importId,
    literal,
    strokeCount,
    strokeCountMisstrokes,
    grade,
    jlpt,
    frequency,
    codepoints,
    radicals,
    dictRefs,
    queryCodes,
    readings,
    nanori,
    meanings,
    variants,
    radicalNames,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawKanjidicEntry &&
          other.importId == this.importId &&
          other.literal == this.literal &&
          other.strokeCount == this.strokeCount &&
          other.strokeCountMisstrokes == this.strokeCountMisstrokes &&
          other.grade == this.grade &&
          other.jlpt == this.jlpt &&
          other.frequency == this.frequency &&
          other.codepoints == this.codepoints &&
          other.radicals == this.radicals &&
          other.dictRefs == this.dictRefs &&
          other.queryCodes == this.queryCodes &&
          other.readings == this.readings &&
          other.nanori == this.nanori &&
          other.meanings == this.meanings &&
          other.variants == this.variants &&
          other.radicalNames == this.radicalNames &&
          other.createdAt == this.createdAt);
}

class RawKanjidicEntriesCompanion extends UpdateCompanion<RawKanjidicEntry> {
  final Value<int> importId;
  final Value<String> literal;
  final Value<int> strokeCount;
  final Value<List<int>?> strokeCountMisstrokes;
  final Value<int?> grade;
  final Value<int?> jlpt;
  final Value<int?> frequency;
  final Value<KanjidicCodepoints> codepoints;
  final Value<KanjidicRadicals> radicals;
  final Value<KanjidicDictRefs?> dictRefs;
  final Value<KanjidicQueryCodes?> queryCodes;
  final Value<KanjidicReadings> readings;
  final Value<List<String>?> nanori;
  final Value<Map<String, List<String>>> meanings;
  final Value<List<KanjidicVariant>?> variants;
  final Value<List<String>?> radicalNames;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RawKanjidicEntriesCompanion({
    this.importId = const Value.absent(),
    this.literal = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.strokeCountMisstrokes = const Value.absent(),
    this.grade = const Value.absent(),
    this.jlpt = const Value.absent(),
    this.frequency = const Value.absent(),
    this.codepoints = const Value.absent(),
    this.radicals = const Value.absent(),
    this.dictRefs = const Value.absent(),
    this.queryCodes = const Value.absent(),
    this.readings = const Value.absent(),
    this.nanori = const Value.absent(),
    this.meanings = const Value.absent(),
    this.variants = const Value.absent(),
    this.radicalNames = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RawKanjidicEntriesCompanion.insert({
    required int importId,
    required String literal,
    required int strokeCount,
    this.strokeCountMisstrokes = const Value.absent(),
    this.grade = const Value.absent(),
    this.jlpt = const Value.absent(),
    this.frequency = const Value.absent(),
    required KanjidicCodepoints codepoints,
    required KanjidicRadicals radicals,
    this.dictRefs = const Value.absent(),
    this.queryCodes = const Value.absent(),
    required KanjidicReadings readings,
    this.nanori = const Value.absent(),
    required Map<String, List<String>> meanings,
    this.variants = const Value.absent(),
    this.radicalNames = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : importId = Value(importId),
       literal = Value(literal),
       strokeCount = Value(strokeCount),
       codepoints = Value(codepoints),
       radicals = Value(radicals),
       readings = Value(readings),
       meanings = Value(meanings);
  static Insertable<RawKanjidicEntry> custom({
    Expression<int>? importId,
    Expression<String>? literal,
    Expression<int>? strokeCount,
    Expression<String>? strokeCountMisstrokes,
    Expression<int>? grade,
    Expression<int>? jlpt,
    Expression<int>? frequency,
    Expression<String>? codepoints,
    Expression<String>? radicals,
    Expression<String>? dictRefs,
    Expression<String>? queryCodes,
    Expression<String>? readings,
    Expression<String>? nanori,
    Expression<String>? meanings,
    Expression<String>? variants,
    Expression<String>? radicalNames,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (importId != null) 'import_id': importId,
      if (literal != null) 'literal': literal,
      if (strokeCount != null) 'stroke_count': strokeCount,
      if (strokeCountMisstrokes != null)
        'stroke_count_misstrokes': strokeCountMisstrokes,
      if (grade != null) 'grade': grade,
      if (jlpt != null) 'jlpt': jlpt,
      if (frequency != null) 'frequency': frequency,
      if (codepoints != null) 'codepoints': codepoints,
      if (radicals != null) 'radicals': radicals,
      if (dictRefs != null) 'dict_refs': dictRefs,
      if (queryCodes != null) 'query_codes': queryCodes,
      if (readings != null) 'readings': readings,
      if (nanori != null) 'nanori': nanori,
      if (meanings != null) 'meanings': meanings,
      if (variants != null) 'variants': variants,
      if (radicalNames != null) 'radical_names': radicalNames,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RawKanjidicEntriesCompanion copyWith({
    Value<int>? importId,
    Value<String>? literal,
    Value<int>? strokeCount,
    Value<List<int>?>? strokeCountMisstrokes,
    Value<int?>? grade,
    Value<int?>? jlpt,
    Value<int?>? frequency,
    Value<KanjidicCodepoints>? codepoints,
    Value<KanjidicRadicals>? radicals,
    Value<KanjidicDictRefs?>? dictRefs,
    Value<KanjidicQueryCodes?>? queryCodes,
    Value<KanjidicReadings>? readings,
    Value<List<String>?>? nanori,
    Value<Map<String, List<String>>>? meanings,
    Value<List<KanjidicVariant>?>? variants,
    Value<List<String>?>? radicalNames,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RawKanjidicEntriesCompanion(
      importId: importId ?? this.importId,
      literal: literal ?? this.literal,
      strokeCount: strokeCount ?? this.strokeCount,
      strokeCountMisstrokes:
          strokeCountMisstrokes ?? this.strokeCountMisstrokes,
      grade: grade ?? this.grade,
      jlpt: jlpt ?? this.jlpt,
      frequency: frequency ?? this.frequency,
      codepoints: codepoints ?? this.codepoints,
      radicals: radicals ?? this.radicals,
      dictRefs: dictRefs ?? this.dictRefs,
      queryCodes: queryCodes ?? this.queryCodes,
      readings: readings ?? this.readings,
      nanori: nanori ?? this.nanori,
      meanings: meanings ?? this.meanings,
      variants: variants ?? this.variants,
      radicalNames: radicalNames ?? this.radicalNames,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (importId.present) {
      map['import_id'] = Variable<int>(importId.value);
    }
    if (literal.present) {
      map['literal'] = Variable<String>(literal.value);
    }
    if (strokeCount.present) {
      map['stroke_count'] = Variable<int>(strokeCount.value);
    }
    if (strokeCountMisstrokes.present) {
      map['stroke_count_misstrokes'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterstrokeCountMisstrokes.toSql(
          strokeCountMisstrokes.value,
        ),
      );
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (jlpt.present) {
      map['jlpt'] = Variable<int>(jlpt.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (codepoints.present) {
      map['codepoints'] = Variable<String>(
        $RawKanjidicEntriesTable.$convertercodepoints.toSql(codepoints.value),
      );
    }
    if (radicals.present) {
      map['radicals'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterradicals.toSql(radicals.value),
      );
    }
    if (dictRefs.present) {
      map['dict_refs'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterdictRefs.toSql(dictRefs.value),
      );
    }
    if (queryCodes.present) {
      map['query_codes'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterqueryCodes.toSql(queryCodes.value),
      );
    }
    if (readings.present) {
      map['readings'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterreadings.toSql(readings.value),
      );
    }
    if (nanori.present) {
      map['nanori'] = Variable<String>(
        $RawKanjidicEntriesTable.$converternanori.toSql(nanori.value),
      );
    }
    if (meanings.present) {
      map['meanings'] = Variable<String>(
        $RawKanjidicEntriesTable.$convertermeanings.toSql(meanings.value),
      );
    }
    if (variants.present) {
      map['variants'] = Variable<String>(
        $RawKanjidicEntriesTable.$convertervariants.toSql(variants.value),
      );
    }
    if (radicalNames.present) {
      map['radical_names'] = Variable<String>(
        $RawKanjidicEntriesTable.$converterradicalNames.toSql(
          radicalNames.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawKanjidicEntriesCompanion(')
          ..write('importId: $importId, ')
          ..write('literal: $literal, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('strokeCountMisstrokes: $strokeCountMisstrokes, ')
          ..write('grade: $grade, ')
          ..write('jlpt: $jlpt, ')
          ..write('frequency: $frequency, ')
          ..write('codepoints: $codepoints, ')
          ..write('radicals: $radicals, ')
          ..write('dictRefs: $dictRefs, ')
          ..write('queryCodes: $queryCodes, ')
          ..write('readings: $readings, ')
          ..write('nanori: $nanori, ')
          ..write('meanings: $meanings, ')
          ..write('variants: $variants, ')
          ..write('radicalNames: $radicalNames, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RawJmdictEntriesTable extends RawJmdictEntries
    with TableInfo<$RawJmdictEntriesTable, RawJmdictEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawJmdictEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _importIdMeta = const VerificationMeta(
    'importId',
  );
  @override
  late final GeneratedColumn<int> importId = GeneratedColumn<int>(
    'import_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES data_import_entries (id)',
    ),
  );
  static const VerificationMeta _entSeqMeta = const VerificationMeta('entSeq');
  @override
  late final GeneratedColumn<int> entSeq = GeneratedColumn<int>(
    'ent_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<JmdictKanjiElement>?, String>
  kanjiElements =
      GeneratedColumn<String>(
        'kanji_elements',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<JmdictKanjiElement>?>(
        $RawJmdictEntriesTable.$converterkanjiElements,
      );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<JmdictReadingElement>,
    String
  >
  readingElements =
      GeneratedColumn<String>(
        'reading_elements',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<JmdictReadingElement>>(
        $RawJmdictEntriesTable.$converterreadingElements,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<JmdictSense>, String>
  senses = GeneratedColumn<String>(
    'senses',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<JmdictSense>>($RawJmdictEntriesTable.$convertersenses);
  @override
  late final GeneratedColumnWithTypeConverter<List<JmdictExample>?, String>
  examples =
      GeneratedColumn<String>(
        'examples',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<JmdictExample>?>(
        $RawJmdictEntriesTable.$converterexamples,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    importId,
    entSeq,
    kanjiElements,
    readingElements,
    senses,
    examples,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_jmdict_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawJmdictEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('import_id')) {
      context.handle(
        _importIdMeta,
        importId.isAcceptableOrUnknown(data['import_id']!, _importIdMeta),
      );
    } else if (isInserting) {
      context.missing(_importIdMeta);
    }
    if (data.containsKey('ent_seq')) {
      context.handle(
        _entSeqMeta,
        entSeq.isAcceptableOrUnknown(data['ent_seq']!, _entSeqMeta),
      );
    } else if (isInserting) {
      context.missing(_entSeqMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {importId, entSeq};
  @override
  RawJmdictEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawJmdictEntry(
      importId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}import_id'],
      )!,
      entSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ent_seq'],
      )!,
      kanjiElements: $RawJmdictEntriesTable.$converterkanjiElements.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kanji_elements'],
        ),
      ),
      readingElements: $RawJmdictEntriesTable.$converterreadingElements.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reading_elements'],
        )!,
      ),
      senses: $RawJmdictEntriesTable.$convertersenses.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}senses'],
        )!,
      ),
      examples: $RawJmdictEntriesTable.$converterexamples.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}examples'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RawJmdictEntriesTable createAlias(String alias) {
    return $RawJmdictEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<JmdictKanjiElement>?, String?>
  $converterkanjiElements = const JmdictKanjiElementsConverter();
  static TypeConverter<List<JmdictReadingElement>, String>
  $converterreadingElements = const JmdictReadingElementsConverter();
  static TypeConverter<List<JmdictSense>, String> $convertersenses =
      const JmdictSensesConverter();
  static TypeConverter<List<JmdictExample>?, String?> $converterexamples =
      const JmdictExamplesConverter();
}

class RawJmdictEntry extends DataClass implements Insertable<RawJmdictEntry> {
  final int importId;
  final int entSeq;
  final List<JmdictKanjiElement>? kanjiElements;
  final List<JmdictReadingElement> readingElements;
  final List<JmdictSense> senses;
  final List<JmdictExample>? examples;
  final DateTime createdAt;
  const RawJmdictEntry({
    required this.importId,
    required this.entSeq,
    this.kanjiElements,
    required this.readingElements,
    required this.senses,
    this.examples,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['import_id'] = Variable<int>(importId);
    map['ent_seq'] = Variable<int>(entSeq);
    if (!nullToAbsent || kanjiElements != null) {
      map['kanji_elements'] = Variable<String>(
        $RawJmdictEntriesTable.$converterkanjiElements.toSql(kanjiElements),
      );
    }
    {
      map['reading_elements'] = Variable<String>(
        $RawJmdictEntriesTable.$converterreadingElements.toSql(readingElements),
      );
    }
    {
      map['senses'] = Variable<String>(
        $RawJmdictEntriesTable.$convertersenses.toSql(senses),
      );
    }
    if (!nullToAbsent || examples != null) {
      map['examples'] = Variable<String>(
        $RawJmdictEntriesTable.$converterexamples.toSql(examples),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RawJmdictEntriesCompanion toCompanion(bool nullToAbsent) {
    return RawJmdictEntriesCompanion(
      importId: Value(importId),
      entSeq: Value(entSeq),
      kanjiElements: kanjiElements == null && nullToAbsent
          ? const Value.absent()
          : Value(kanjiElements),
      readingElements: Value(readingElements),
      senses: Value(senses),
      examples: examples == null && nullToAbsent
          ? const Value.absent()
          : Value(examples),
      createdAt: Value(createdAt),
    );
  }

  factory RawJmdictEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawJmdictEntry(
      importId: serializer.fromJson<int>(json['importId']),
      entSeq: serializer.fromJson<int>(json['entSeq']),
      kanjiElements: serializer.fromJson<List<JmdictKanjiElement>?>(
        json['kanjiElements'],
      ),
      readingElements: serializer.fromJson<List<JmdictReadingElement>>(
        json['readingElements'],
      ),
      senses: serializer.fromJson<List<JmdictSense>>(json['senses']),
      examples: serializer.fromJson<List<JmdictExample>?>(json['examples']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'importId': serializer.toJson<int>(importId),
      'entSeq': serializer.toJson<int>(entSeq),
      'kanjiElements': serializer.toJson<List<JmdictKanjiElement>?>(
        kanjiElements,
      ),
      'readingElements': serializer.toJson<List<JmdictReadingElement>>(
        readingElements,
      ),
      'senses': serializer.toJson<List<JmdictSense>>(senses),
      'examples': serializer.toJson<List<JmdictExample>?>(examples),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RawJmdictEntry copyWith({
    int? importId,
    int? entSeq,
    Value<List<JmdictKanjiElement>?> kanjiElements = const Value.absent(),
    List<JmdictReadingElement>? readingElements,
    List<JmdictSense>? senses,
    Value<List<JmdictExample>?> examples = const Value.absent(),
    DateTime? createdAt,
  }) => RawJmdictEntry(
    importId: importId ?? this.importId,
    entSeq: entSeq ?? this.entSeq,
    kanjiElements: kanjiElements.present
        ? kanjiElements.value
        : this.kanjiElements,
    readingElements: readingElements ?? this.readingElements,
    senses: senses ?? this.senses,
    examples: examples.present ? examples.value : this.examples,
    createdAt: createdAt ?? this.createdAt,
  );
  RawJmdictEntry copyWithCompanion(RawJmdictEntriesCompanion data) {
    return RawJmdictEntry(
      importId: data.importId.present ? data.importId.value : this.importId,
      entSeq: data.entSeq.present ? data.entSeq.value : this.entSeq,
      kanjiElements: data.kanjiElements.present
          ? data.kanjiElements.value
          : this.kanjiElements,
      readingElements: data.readingElements.present
          ? data.readingElements.value
          : this.readingElements,
      senses: data.senses.present ? data.senses.value : this.senses,
      examples: data.examples.present ? data.examples.value : this.examples,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawJmdictEntry(')
          ..write('importId: $importId, ')
          ..write('entSeq: $entSeq, ')
          ..write('kanjiElements: $kanjiElements, ')
          ..write('readingElements: $readingElements, ')
          ..write('senses: $senses, ')
          ..write('examples: $examples, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    importId,
    entSeq,
    kanjiElements,
    readingElements,
    senses,
    examples,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawJmdictEntry &&
          other.importId == this.importId &&
          other.entSeq == this.entSeq &&
          other.kanjiElements == this.kanjiElements &&
          other.readingElements == this.readingElements &&
          other.senses == this.senses &&
          other.examples == this.examples &&
          other.createdAt == this.createdAt);
}

class RawJmdictEntriesCompanion extends UpdateCompanion<RawJmdictEntry> {
  final Value<int> importId;
  final Value<int> entSeq;
  final Value<List<JmdictKanjiElement>?> kanjiElements;
  final Value<List<JmdictReadingElement>> readingElements;
  final Value<List<JmdictSense>> senses;
  final Value<List<JmdictExample>?> examples;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RawJmdictEntriesCompanion({
    this.importId = const Value.absent(),
    this.entSeq = const Value.absent(),
    this.kanjiElements = const Value.absent(),
    this.readingElements = const Value.absent(),
    this.senses = const Value.absent(),
    this.examples = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RawJmdictEntriesCompanion.insert({
    required int importId,
    required int entSeq,
    this.kanjiElements = const Value.absent(),
    required List<JmdictReadingElement> readingElements,
    required List<JmdictSense> senses,
    this.examples = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : importId = Value(importId),
       entSeq = Value(entSeq),
       readingElements = Value(readingElements),
       senses = Value(senses);
  static Insertable<RawJmdictEntry> custom({
    Expression<int>? importId,
    Expression<int>? entSeq,
    Expression<String>? kanjiElements,
    Expression<String>? readingElements,
    Expression<String>? senses,
    Expression<String>? examples,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (importId != null) 'import_id': importId,
      if (entSeq != null) 'ent_seq': entSeq,
      if (kanjiElements != null) 'kanji_elements': kanjiElements,
      if (readingElements != null) 'reading_elements': readingElements,
      if (senses != null) 'senses': senses,
      if (examples != null) 'examples': examples,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RawJmdictEntriesCompanion copyWith({
    Value<int>? importId,
    Value<int>? entSeq,
    Value<List<JmdictKanjiElement>?>? kanjiElements,
    Value<List<JmdictReadingElement>>? readingElements,
    Value<List<JmdictSense>>? senses,
    Value<List<JmdictExample>?>? examples,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RawJmdictEntriesCompanion(
      importId: importId ?? this.importId,
      entSeq: entSeq ?? this.entSeq,
      kanjiElements: kanjiElements ?? this.kanjiElements,
      readingElements: readingElements ?? this.readingElements,
      senses: senses ?? this.senses,
      examples: examples ?? this.examples,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (importId.present) {
      map['import_id'] = Variable<int>(importId.value);
    }
    if (entSeq.present) {
      map['ent_seq'] = Variable<int>(entSeq.value);
    }
    if (kanjiElements.present) {
      map['kanji_elements'] = Variable<String>(
        $RawJmdictEntriesTable.$converterkanjiElements.toSql(
          kanjiElements.value,
        ),
      );
    }
    if (readingElements.present) {
      map['reading_elements'] = Variable<String>(
        $RawJmdictEntriesTable.$converterreadingElements.toSql(
          readingElements.value,
        ),
      );
    }
    if (senses.present) {
      map['senses'] = Variable<String>(
        $RawJmdictEntriesTable.$convertersenses.toSql(senses.value),
      );
    }
    if (examples.present) {
      map['examples'] = Variable<String>(
        $RawJmdictEntriesTable.$converterexamples.toSql(examples.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawJmdictEntriesCompanion(')
          ..write('importId: $importId, ')
          ..write('entSeq: $entSeq, ')
          ..write('kanjiElements: $kanjiElements, ')
          ..write('readingElements: $readingElements, ')
          ..write('senses: $senses, ')
          ..write('examples: $examples, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KanjiComponentReviewEntriesTable extends KanjiComponentReviewEntries
    with
        TableInfo<
          $KanjiComponentReviewEntriesTable,
          KanjiComponentReviewEntry
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiComponentReviewEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kanjiComponentIdMeta = const VerificationMeta(
    'kanjiComponentId',
  );
  @override
  late final GeneratedColumn<int> kanjiComponentId = GeneratedColumn<int>(
    'kanji_component_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<VerificationStatus, String>
  verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<VerificationStatus>(
        $KanjiComponentReviewEntriesTable.$converterverificationStatus,
      );
  static const VerificationMeta _aiConfidenceMeta = const VerificationMeta(
    'aiConfidence',
  );
  @override
  late final GeneratedColumn<double> aiConfidence = GeneratedColumn<double>(
    'ai_confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kanjiComponentId,
    verificationStatus,
    aiConfidence,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_component_review_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanjiComponentReviewEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kanji_component_id')) {
      context.handle(
        _kanjiComponentIdMeta,
        kanjiComponentId.isAcceptableOrUnknown(
          data['kanji_component_id']!,
          _kanjiComponentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kanjiComponentIdMeta);
    }
    if (data.containsKey('ai_confidence')) {
      context.handle(
        _aiConfidenceMeta,
        aiConfidence.isAcceptableOrUnknown(
          data['ai_confidence']!,
          _aiConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KanjiComponentReviewEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiComponentReviewEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kanjiComponentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kanji_component_id'],
      )!,
      verificationStatus: $KanjiComponentReviewEntriesTable
          .$converterverificationStatus
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}verification_status'],
            )!,
          ),
      aiConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ai_confidence'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KanjiComponentReviewEntriesTable createAlias(String alias) {
    return $KanjiComponentReviewEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<VerificationStatus, String>
  $converterverificationStatus = const VerificationStatusConverter();
}

class KanjiComponentReviewEntry extends DataClass
    implements Insertable<KanjiComponentReviewEntry> {
  final int id;
  final int kanjiComponentId;
  final VerificationStatus verificationStatus;
  final double? aiConfidence;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KanjiComponentReviewEntry({
    required this.id,
    required this.kanjiComponentId,
    required this.verificationStatus,
    this.aiConfidence,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kanji_component_id'] = Variable<int>(kanjiComponentId);
    {
      map['verification_status'] = Variable<String>(
        $KanjiComponentReviewEntriesTable.$converterverificationStatus.toSql(
          verificationStatus,
        ),
      );
    }
    if (!nullToAbsent || aiConfidence != null) {
      map['ai_confidence'] = Variable<double>(aiConfidence);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KanjiComponentReviewEntriesCompanion toCompanion(bool nullToAbsent) {
    return KanjiComponentReviewEntriesCompanion(
      id: Value(id),
      kanjiComponentId: Value(kanjiComponentId),
      verificationStatus: Value(verificationStatus),
      aiConfidence: aiConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(aiConfidence),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KanjiComponentReviewEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiComponentReviewEntry(
      id: serializer.fromJson<int>(json['id']),
      kanjiComponentId: serializer.fromJson<int>(json['kanjiComponentId']),
      verificationStatus: serializer.fromJson<VerificationStatus>(
        json['verificationStatus'],
      ),
      aiConfidence: serializer.fromJson<double?>(json['aiConfidence']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kanjiComponentId': serializer.toJson<int>(kanjiComponentId),
      'verificationStatus': serializer.toJson<VerificationStatus>(
        verificationStatus,
      ),
      'aiConfidence': serializer.toJson<double?>(aiConfidence),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KanjiComponentReviewEntry copyWith({
    int? id,
    int? kanjiComponentId,
    VerificationStatus? verificationStatus,
    Value<double?> aiConfidence = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KanjiComponentReviewEntry(
    id: id ?? this.id,
    kanjiComponentId: kanjiComponentId ?? this.kanjiComponentId,
    verificationStatus: verificationStatus ?? this.verificationStatus,
    aiConfidence: aiConfidence.present ? aiConfidence.value : this.aiConfidence,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KanjiComponentReviewEntry copyWithCompanion(
    KanjiComponentReviewEntriesCompanion data,
  ) {
    return KanjiComponentReviewEntry(
      id: data.id.present ? data.id.value : this.id,
      kanjiComponentId: data.kanjiComponentId.present
          ? data.kanjiComponentId.value
          : this.kanjiComponentId,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
      aiConfidence: data.aiConfidence.present
          ? data.aiConfidence.value
          : this.aiConfidence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiComponentReviewEntry(')
          ..write('id: $id, ')
          ..write('kanjiComponentId: $kanjiComponentId, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('aiConfidence: $aiConfidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kanjiComponentId,
    verificationStatus,
    aiConfidence,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiComponentReviewEntry &&
          other.id == this.id &&
          other.kanjiComponentId == this.kanjiComponentId &&
          other.verificationStatus == this.verificationStatus &&
          other.aiConfidence == this.aiConfidence &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KanjiComponentReviewEntriesCompanion
    extends UpdateCompanion<KanjiComponentReviewEntry> {
  final Value<int> id;
  final Value<int> kanjiComponentId;
  final Value<VerificationStatus> verificationStatus;
  final Value<double?> aiConfidence;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KanjiComponentReviewEntriesCompanion({
    this.id = const Value.absent(),
    this.kanjiComponentId = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.aiConfidence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KanjiComponentReviewEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int kanjiComponentId,
    required VerificationStatus verificationStatus,
    this.aiConfidence = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : kanjiComponentId = Value(kanjiComponentId),
       verificationStatus = Value(verificationStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<KanjiComponentReviewEntry> custom({
    Expression<int>? id,
    Expression<int>? kanjiComponentId,
    Expression<String>? verificationStatus,
    Expression<double>? aiConfidence,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kanjiComponentId != null) 'kanji_component_id': kanjiComponentId,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (aiConfidence != null) 'ai_confidence': aiConfidence,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KanjiComponentReviewEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? kanjiComponentId,
    Value<VerificationStatus>? verificationStatus,
    Value<double?>? aiConfidence,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KanjiComponentReviewEntriesCompanion(
      id: id ?? this.id,
      kanjiComponentId: kanjiComponentId ?? this.kanjiComponentId,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kanjiComponentId.present) {
      map['kanji_component_id'] = Variable<int>(kanjiComponentId.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(
        $KanjiComponentReviewEntriesTable.$converterverificationStatus.toSql(
          verificationStatus.value,
        ),
      );
    }
    if (aiConfidence.present) {
      map['ai_confidence'] = Variable<double>(aiConfidence.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiComponentReviewEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kanjiComponentId: $kanjiComponentId, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('aiConfidence: $aiConfidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataEntriesTable extends SyncMetadataEntries
    with TableInfo<$SyncMetadataEntriesTable, SyncMetadataEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, lastSyncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetadataEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      )!,
    );
  }

  @override
  $SyncMetadataEntriesTable createAlias(String alias) {
    return $SyncMetadataEntriesTable(attachedDatabase, alias);
  }
}

class SyncMetadataEntry extends DataClass
    implements Insertable<SyncMetadataEntry> {
  final String key;
  final DateTime lastSyncedAt;
  const SyncMetadataEntry({required this.key, required this.lastSyncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    return map;
  }

  SyncMetadataEntriesCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataEntriesCompanion(
      key: Value(key),
      lastSyncedAt: Value(lastSyncedAt),
    );
  }

  factory SyncMetadataEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataEntry(
      key: serializer.fromJson<String>(json['key']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
    };
  }

  SyncMetadataEntry copyWith({String? key, DateTime? lastSyncedAt}) =>
      SyncMetadataEntry(
        key: key ?? this.key,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      );
  SyncMetadataEntry copyWithCompanion(SyncMetadataEntriesCompanion data) {
    return SyncMetadataEntry(
      key: data.key.present ? data.key.value : this.key,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataEntry(')
          ..write('key: $key, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataEntry &&
          other.key == this.key &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SyncMetadataEntriesCompanion extends UpdateCompanion<SyncMetadataEntry> {
  final Value<String> key;
  final Value<DateTime> lastSyncedAt;
  final Value<int> rowid;
  const SyncMetadataEntriesCompanion({
    this.key = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataEntriesCompanion.insert({
    required String key,
    required DateTime lastSyncedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       lastSyncedAt = Value(lastSyncedAt);
  static Insertable<SyncMetadataEntry> custom({
    Expression<String>? key,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataEntriesCompanion copyWith({
    Value<String>? key,
    Value<DateTime>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return SyncMetadataEntriesCompanion(
      key: key ?? this.key,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataEntriesCompanion(')
          ..write('key: $key, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceJlptLevelEntriesTable extends SourceJlptLevelEntries
    with TableInfo<$SourceJlptLevelEntriesTable, SourceJlptLevelEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceJlptLevelEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterMeta = const VerificationMeta(
    'character',
  );
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
    'character',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (level BETWEEN 1 AND 5)',
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tanos'),
  );
  @override
  List<GeneratedColumn> get $columns => [character, level, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_jlpt_level_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceJlptLevelEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character')) {
      context.handle(
        _characterMeta,
        character.isAcceptableOrUnknown(data['character']!, _characterMeta),
      );
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {character};
  @override
  SourceJlptLevelEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceJlptLevelEntry(
      character: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $SourceJlptLevelEntriesTable createAlias(String alias) {
    return $SourceJlptLevelEntriesTable(attachedDatabase, alias);
  }
}

class SourceJlptLevelEntry extends DataClass
    implements Insertable<SourceJlptLevelEntry> {
  final String character;
  final int level;
  final String source;
  const SourceJlptLevelEntry({
    required this.character,
    required this.level,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character'] = Variable<String>(character);
    map['level'] = Variable<int>(level);
    map['source'] = Variable<String>(source);
    return map;
  }

  SourceJlptLevelEntriesCompanion toCompanion(bool nullToAbsent) {
    return SourceJlptLevelEntriesCompanion(
      character: Value(character),
      level: Value(level),
      source: Value(source),
    );
  }

  factory SourceJlptLevelEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceJlptLevelEntry(
      character: serializer.fromJson<String>(json['character']),
      level: serializer.fromJson<int>(json['level']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'character': serializer.toJson<String>(character),
      'level': serializer.toJson<int>(level),
      'source': serializer.toJson<String>(source),
    };
  }

  SourceJlptLevelEntry copyWith({
    String? character,
    int? level,
    String? source,
  }) => SourceJlptLevelEntry(
    character: character ?? this.character,
    level: level ?? this.level,
    source: source ?? this.source,
  );
  SourceJlptLevelEntry copyWithCompanion(SourceJlptLevelEntriesCompanion data) {
    return SourceJlptLevelEntry(
      character: data.character.present ? data.character.value : this.character,
      level: data.level.present ? data.level.value : this.level,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceJlptLevelEntry(')
          ..write('character: $character, ')
          ..write('level: $level, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(character, level, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceJlptLevelEntry &&
          other.character == this.character &&
          other.level == this.level &&
          other.source == this.source);
}

class SourceJlptLevelEntriesCompanion
    extends UpdateCompanion<SourceJlptLevelEntry> {
  final Value<String> character;
  final Value<int> level;
  final Value<String> source;
  final Value<int> rowid;
  const SourceJlptLevelEntriesCompanion({
    this.character = const Value.absent(),
    this.level = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceJlptLevelEntriesCompanion.insert({
    required String character,
    required int level,
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : character = Value(character),
       level = Value(level);
  static Insertable<SourceJlptLevelEntry> custom({
    Expression<String>? character,
    Expression<int>? level,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (character != null) 'character': character,
      if (level != null) 'level': level,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceJlptLevelEntriesCompanion copyWith({
    Value<String>? character,
    Value<int>? level,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return SourceJlptLevelEntriesCompanion(
      character: character ?? this.character,
      level: level ?? this.level,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceJlptLevelEntriesCompanion(')
          ..write('character: $character, ')
          ..write('level: $level, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadicalEntriesTable extends RadicalEntries
    with TableInfo<$RadicalEntriesTable, RadicalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadicalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _masterSymbolMeta = const VerificationMeta(
    'masterSymbol',
  );
  @override
  late final GeneratedColumn<String> masterSymbol = GeneratedColumn<String>(
    'master_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _strokeCountMeta = const VerificationMeta(
    'strokeCount',
  );
  @override
  late final GeneratedColumn<int> strokeCount = GeneratedColumn<int>(
    'stroke_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (stroke_count > 0)',
  );
  static const VerificationMeta _impactScoreMeta = const VerificationMeta(
    'impactScore',
  );
  @override
  late final GeneratedColumn<int> impactScore = GeneratedColumn<int>(
    'impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (impact_score BETWEEN 1 AND 10)',
  );
  static const VerificationMeta _minJlptLevelMeta = const VerificationMeta(
    'minJlptLevel',
  );
  @override
  late final GeneratedColumn<int> minJlptLevel = GeneratedColumn<int>(
    'min_jlpt_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (min_jlpt_level BETWEEN 1 AND 5)',
  );
  static const VerificationMeta _minGradeMeta = const VerificationMeta(
    'minGrade',
  );
  @override
  late final GeneratedColumn<int> minGrade = GeneratedColumn<int>(
    'min_grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (min_grade BETWEEN 1 AND 8)',
  );
  static const VerificationMeta _svgFileNameMeta = const VerificationMeta(
    'svgFileName',
  );
  @override
  late final GeneratedColumn<String> svgFileName = GeneratedColumn<String>(
    'svg_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _svgFileUrlMeta = const VerificationMeta(
    'svgFileUrl',
  );
  @override
  late final GeneratedColumn<String> svgFileUrl = GeneratedColumn<String>(
    'svg_file_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _svgHashMeta = const VerificationMeta(
    'svgHash',
  );
  @override
  late final GeneratedColumn<String> svgHash = GeneratedColumn<String>(
    'svg_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOfficialMeta = const VerificationMeta(
    'isOfficial',
  );
  @override
  late final GeneratedColumn<bool> isOfficial = GeneratedColumn<bool>(
    'is_official',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_official" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    masterSymbol,
    strokeCount,
    impactScore,
    minJlptLevel,
    minGrade,
    svgFileName,
    svgFileUrl,
    svgHash,
    isOfficial,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radical_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RadicalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('master_symbol')) {
      context.handle(
        _masterSymbolMeta,
        masterSymbol.isAcceptableOrUnknown(
          data['master_symbol']!,
          _masterSymbolMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masterSymbolMeta);
    }
    if (data.containsKey('stroke_count')) {
      context.handle(
        _strokeCountMeta,
        strokeCount.isAcceptableOrUnknown(
          data['stroke_count']!,
          _strokeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_strokeCountMeta);
    }
    if (data.containsKey('impact_score')) {
      context.handle(
        _impactScoreMeta,
        impactScore.isAcceptableOrUnknown(
          data['impact_score']!,
          _impactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_impactScoreMeta);
    }
    if (data.containsKey('min_jlpt_level')) {
      context.handle(
        _minJlptLevelMeta,
        minJlptLevel.isAcceptableOrUnknown(
          data['min_jlpt_level']!,
          _minJlptLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minJlptLevelMeta);
    }
    if (data.containsKey('min_grade')) {
      context.handle(
        _minGradeMeta,
        minGrade.isAcceptableOrUnknown(data['min_grade']!, _minGradeMeta),
      );
    } else if (isInserting) {
      context.missing(_minGradeMeta);
    }
    if (data.containsKey('svg_file_name')) {
      context.handle(
        _svgFileNameMeta,
        svgFileName.isAcceptableOrUnknown(
          data['svg_file_name']!,
          _svgFileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_svgFileNameMeta);
    }
    if (data.containsKey('svg_file_url')) {
      context.handle(
        _svgFileUrlMeta,
        svgFileUrl.isAcceptableOrUnknown(
          data['svg_file_url']!,
          _svgFileUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_svgFileUrlMeta);
    }
    if (data.containsKey('svg_hash')) {
      context.handle(
        _svgHashMeta,
        svgHash.isAcceptableOrUnknown(data['svg_hash']!, _svgHashMeta),
      );
    } else if (isInserting) {
      context.missing(_svgHashMeta);
    }
    if (data.containsKey('is_official')) {
      context.handle(
        _isOfficialMeta,
        isOfficial.isAcceptableOrUnknown(data['is_official']!, _isOfficialMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RadicalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadicalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      masterSymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}master_symbol'],
      )!,
      strokeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stroke_count'],
      )!,
      impactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}impact_score'],
      )!,
      minJlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_jlpt_level'],
      )!,
      minGrade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_grade'],
      )!,
      svgFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_file_name'],
      )!,
      svgFileUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_file_url'],
      )!,
      svgHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_hash'],
      )!,
      isOfficial: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_official'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RadicalEntriesTable createAlias(String alias) {
    return $RadicalEntriesTable(attachedDatabase, alias);
  }
}

class RadicalEntry extends DataClass implements Insertable<RadicalEntry> {
  final int id;
  final String masterSymbol;
  final int strokeCount;
  final int impactScore;
  final int minJlptLevel;
  final int minGrade;
  final String svgFileName;
  final String svgFileUrl;
  final String svgHash;
  final bool isOfficial;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RadicalEntry({
    required this.id,
    required this.masterSymbol,
    required this.strokeCount,
    required this.impactScore,
    required this.minJlptLevel,
    required this.minGrade,
    required this.svgFileName,
    required this.svgFileUrl,
    required this.svgHash,
    required this.isOfficial,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['master_symbol'] = Variable<String>(masterSymbol);
    map['stroke_count'] = Variable<int>(strokeCount);
    map['impact_score'] = Variable<int>(impactScore);
    map['min_jlpt_level'] = Variable<int>(minJlptLevel);
    map['min_grade'] = Variable<int>(minGrade);
    map['svg_file_name'] = Variable<String>(svgFileName);
    map['svg_file_url'] = Variable<String>(svgFileUrl);
    map['svg_hash'] = Variable<String>(svgHash);
    map['is_official'] = Variable<bool>(isOfficial);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RadicalEntriesCompanion toCompanion(bool nullToAbsent) {
    return RadicalEntriesCompanion(
      id: Value(id),
      masterSymbol: Value(masterSymbol),
      strokeCount: Value(strokeCount),
      impactScore: Value(impactScore),
      minJlptLevel: Value(minJlptLevel),
      minGrade: Value(minGrade),
      svgFileName: Value(svgFileName),
      svgFileUrl: Value(svgFileUrl),
      svgHash: Value(svgHash),
      isOfficial: Value(isOfficial),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RadicalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadicalEntry(
      id: serializer.fromJson<int>(json['id']),
      masterSymbol: serializer.fromJson<String>(json['masterSymbol']),
      strokeCount: serializer.fromJson<int>(json['strokeCount']),
      impactScore: serializer.fromJson<int>(json['impactScore']),
      minJlptLevel: serializer.fromJson<int>(json['minJlptLevel']),
      minGrade: serializer.fromJson<int>(json['minGrade']),
      svgFileName: serializer.fromJson<String>(json['svgFileName']),
      svgFileUrl: serializer.fromJson<String>(json['svgFileUrl']),
      svgHash: serializer.fromJson<String>(json['svgHash']),
      isOfficial: serializer.fromJson<bool>(json['isOfficial']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'masterSymbol': serializer.toJson<String>(masterSymbol),
      'strokeCount': serializer.toJson<int>(strokeCount),
      'impactScore': serializer.toJson<int>(impactScore),
      'minJlptLevel': serializer.toJson<int>(minJlptLevel),
      'minGrade': serializer.toJson<int>(minGrade),
      'svgFileName': serializer.toJson<String>(svgFileName),
      'svgFileUrl': serializer.toJson<String>(svgFileUrl),
      'svgHash': serializer.toJson<String>(svgHash),
      'isOfficial': serializer.toJson<bool>(isOfficial),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RadicalEntry copyWith({
    int? id,
    String? masterSymbol,
    int? strokeCount,
    int? impactScore,
    int? minJlptLevel,
    int? minGrade,
    String? svgFileName,
    String? svgFileUrl,
    String? svgHash,
    bool? isOfficial,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RadicalEntry(
    id: id ?? this.id,
    masterSymbol: masterSymbol ?? this.masterSymbol,
    strokeCount: strokeCount ?? this.strokeCount,
    impactScore: impactScore ?? this.impactScore,
    minJlptLevel: minJlptLevel ?? this.minJlptLevel,
    minGrade: minGrade ?? this.minGrade,
    svgFileName: svgFileName ?? this.svgFileName,
    svgFileUrl: svgFileUrl ?? this.svgFileUrl,
    svgHash: svgHash ?? this.svgHash,
    isOfficial: isOfficial ?? this.isOfficial,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RadicalEntry copyWithCompanion(RadicalEntriesCompanion data) {
    return RadicalEntry(
      id: data.id.present ? data.id.value : this.id,
      masterSymbol: data.masterSymbol.present
          ? data.masterSymbol.value
          : this.masterSymbol,
      strokeCount: data.strokeCount.present
          ? data.strokeCount.value
          : this.strokeCount,
      impactScore: data.impactScore.present
          ? data.impactScore.value
          : this.impactScore,
      minJlptLevel: data.minJlptLevel.present
          ? data.minJlptLevel.value
          : this.minJlptLevel,
      minGrade: data.minGrade.present ? data.minGrade.value : this.minGrade,
      svgFileName: data.svgFileName.present
          ? data.svgFileName.value
          : this.svgFileName,
      svgFileUrl: data.svgFileUrl.present
          ? data.svgFileUrl.value
          : this.svgFileUrl,
      svgHash: data.svgHash.present ? data.svgHash.value : this.svgHash,
      isOfficial: data.isOfficial.present
          ? data.isOfficial.value
          : this.isOfficial,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadicalEntry(')
          ..write('id: $id, ')
          ..write('masterSymbol: $masterSymbol, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('impactScore: $impactScore, ')
          ..write('minJlptLevel: $minJlptLevel, ')
          ..write('minGrade: $minGrade, ')
          ..write('svgFileName: $svgFileName, ')
          ..write('svgFileUrl: $svgFileUrl, ')
          ..write('svgHash: $svgHash, ')
          ..write('isOfficial: $isOfficial, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    masterSymbol,
    strokeCount,
    impactScore,
    minJlptLevel,
    minGrade,
    svgFileName,
    svgFileUrl,
    svgHash,
    isOfficial,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadicalEntry &&
          other.id == this.id &&
          other.masterSymbol == this.masterSymbol &&
          other.strokeCount == this.strokeCount &&
          other.impactScore == this.impactScore &&
          other.minJlptLevel == this.minJlptLevel &&
          other.minGrade == this.minGrade &&
          other.svgFileName == this.svgFileName &&
          other.svgFileUrl == this.svgFileUrl &&
          other.svgHash == this.svgHash &&
          other.isOfficial == this.isOfficial &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RadicalEntriesCompanion extends UpdateCompanion<RadicalEntry> {
  final Value<int> id;
  final Value<String> masterSymbol;
  final Value<int> strokeCount;
  final Value<int> impactScore;
  final Value<int> minJlptLevel;
  final Value<int> minGrade;
  final Value<String> svgFileName;
  final Value<String> svgFileUrl;
  final Value<String> svgHash;
  final Value<bool> isOfficial;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RadicalEntriesCompanion({
    this.id = const Value.absent(),
    this.masterSymbol = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.impactScore = const Value.absent(),
    this.minJlptLevel = const Value.absent(),
    this.minGrade = const Value.absent(),
    this.svgFileName = const Value.absent(),
    this.svgFileUrl = const Value.absent(),
    this.svgHash = const Value.absent(),
    this.isOfficial = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RadicalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String masterSymbol,
    required int strokeCount,
    required int impactScore,
    required int minJlptLevel,
    required int minGrade,
    required String svgFileName,
    required String svgFileUrl,
    required String svgHash,
    this.isOfficial = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : masterSymbol = Value(masterSymbol),
       strokeCount = Value(strokeCount),
       impactScore = Value(impactScore),
       minJlptLevel = Value(minJlptLevel),
       minGrade = Value(minGrade),
       svgFileName = Value(svgFileName),
       svgFileUrl = Value(svgFileUrl),
       svgHash = Value(svgHash);
  static Insertable<RadicalEntry> custom({
    Expression<int>? id,
    Expression<String>? masterSymbol,
    Expression<int>? strokeCount,
    Expression<int>? impactScore,
    Expression<int>? minJlptLevel,
    Expression<int>? minGrade,
    Expression<String>? svgFileName,
    Expression<String>? svgFileUrl,
    Expression<String>? svgHash,
    Expression<bool>? isOfficial,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (masterSymbol != null) 'master_symbol': masterSymbol,
      if (strokeCount != null) 'stroke_count': strokeCount,
      if (impactScore != null) 'impact_score': impactScore,
      if (minJlptLevel != null) 'min_jlpt_level': minJlptLevel,
      if (minGrade != null) 'min_grade': minGrade,
      if (svgFileName != null) 'svg_file_name': svgFileName,
      if (svgFileUrl != null) 'svg_file_url': svgFileUrl,
      if (svgHash != null) 'svg_hash': svgHash,
      if (isOfficial != null) 'is_official': isOfficial,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RadicalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? masterSymbol,
    Value<int>? strokeCount,
    Value<int>? impactScore,
    Value<int>? minJlptLevel,
    Value<int>? minGrade,
    Value<String>? svgFileName,
    Value<String>? svgFileUrl,
    Value<String>? svgHash,
    Value<bool>? isOfficial,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RadicalEntriesCompanion(
      id: id ?? this.id,
      masterSymbol: masterSymbol ?? this.masterSymbol,
      strokeCount: strokeCount ?? this.strokeCount,
      impactScore: impactScore ?? this.impactScore,
      minJlptLevel: minJlptLevel ?? this.minJlptLevel,
      minGrade: minGrade ?? this.minGrade,
      svgFileName: svgFileName ?? this.svgFileName,
      svgFileUrl: svgFileUrl ?? this.svgFileUrl,
      svgHash: svgHash ?? this.svgHash,
      isOfficial: isOfficial ?? this.isOfficial,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (masterSymbol.present) {
      map['master_symbol'] = Variable<String>(masterSymbol.value);
    }
    if (strokeCount.present) {
      map['stroke_count'] = Variable<int>(strokeCount.value);
    }
    if (impactScore.present) {
      map['impact_score'] = Variable<int>(impactScore.value);
    }
    if (minJlptLevel.present) {
      map['min_jlpt_level'] = Variable<int>(minJlptLevel.value);
    }
    if (minGrade.present) {
      map['min_grade'] = Variable<int>(minGrade.value);
    }
    if (svgFileName.present) {
      map['svg_file_name'] = Variable<String>(svgFileName.value);
    }
    if (svgFileUrl.present) {
      map['svg_file_url'] = Variable<String>(svgFileUrl.value);
    }
    if (svgHash.present) {
      map['svg_hash'] = Variable<String>(svgHash.value);
    }
    if (isOfficial.present) {
      map['is_official'] = Variable<bool>(isOfficial.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadicalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('masterSymbol: $masterSymbol, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('impactScore: $impactScore, ')
          ..write('minJlptLevel: $minJlptLevel, ')
          ..write('minGrade: $minGrade, ')
          ..write('svgFileName: $svgFileName, ')
          ..write('svgFileUrl: $svgFileUrl, ')
          ..write('svgHash: $svgHash, ')
          ..write('isOfficial: $isOfficial, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RadicalI18nEntriesTable extends RadicalI18nEntries
    with TableInfo<$RadicalI18nEntriesTable, RadicalI18nEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadicalI18nEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _radicalIdMeta = const VerificationMeta(
    'radicalId',
  );
  @override
  late final GeneratedColumn<int> radicalId = GeneratedColumn<int>(
    'radical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES radical_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _langCodeMeta = const VerificationMeta(
    'langCode',
  );
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
    'lang_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systemMnemonicMeta = const VerificationMeta(
    'systemMnemonic',
  );
  @override
  late final GeneratedColumn<String> systemMnemonic = GeneratedColumn<String>(
    'system_mnemonic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> searchTags =
      GeneratedColumn<String>(
        'search_tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $RadicalI18nEntriesTable.$convertersearchTags,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    radicalId,
    langCode,
    name,
    systemMnemonic,
    searchTags,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radical_i18n_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RadicalI18nEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('radical_id')) {
      context.handle(
        _radicalIdMeta,
        radicalId.isAcceptableOrUnknown(data['radical_id']!, _radicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_radicalIdMeta);
    }
    if (data.containsKey('lang_code')) {
      context.handle(
        _langCodeMeta,
        langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('system_mnemonic')) {
      context.handle(
        _systemMnemonicMeta,
        systemMnemonic.isAcceptableOrUnknown(
          data['system_mnemonic']!,
          _systemMnemonicMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_systemMnemonicMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {radicalId, langCode},
  ];
  @override
  RadicalI18nEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadicalI18nEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      radicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}radical_id'],
      )!,
      langCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang_code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      systemMnemonic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_mnemonic'],
      )!,
      searchTags: $RadicalI18nEntriesTable.$convertersearchTags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}search_tags'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RadicalI18nEntriesTable createAlias(String alias) {
    return $RadicalI18nEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertersearchTags =
      const NonNullableStringListConverter();
}

class RadicalI18nEntry extends DataClass
    implements Insertable<RadicalI18nEntry> {
  final int id;
  final int radicalId;
  final String langCode;
  final String name;
  final String systemMnemonic;
  final List<String> searchTags;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RadicalI18nEntry({
    required this.id,
    required this.radicalId,
    required this.langCode,
    required this.name,
    required this.systemMnemonic,
    required this.searchTags,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['radical_id'] = Variable<int>(radicalId);
    map['lang_code'] = Variable<String>(langCode);
    map['name'] = Variable<String>(name);
    map['system_mnemonic'] = Variable<String>(systemMnemonic);
    {
      map['search_tags'] = Variable<String>(
        $RadicalI18nEntriesTable.$convertersearchTags.toSql(searchTags),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RadicalI18nEntriesCompanion toCompanion(bool nullToAbsent) {
    return RadicalI18nEntriesCompanion(
      id: Value(id),
      radicalId: Value(radicalId),
      langCode: Value(langCode),
      name: Value(name),
      systemMnemonic: Value(systemMnemonic),
      searchTags: Value(searchTags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RadicalI18nEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadicalI18nEntry(
      id: serializer.fromJson<int>(json['id']),
      radicalId: serializer.fromJson<int>(json['radicalId']),
      langCode: serializer.fromJson<String>(json['langCode']),
      name: serializer.fromJson<String>(json['name']),
      systemMnemonic: serializer.fromJson<String>(json['systemMnemonic']),
      searchTags: serializer.fromJson<List<String>>(json['searchTags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'radicalId': serializer.toJson<int>(radicalId),
      'langCode': serializer.toJson<String>(langCode),
      'name': serializer.toJson<String>(name),
      'systemMnemonic': serializer.toJson<String>(systemMnemonic),
      'searchTags': serializer.toJson<List<String>>(searchTags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RadicalI18nEntry copyWith({
    int? id,
    int? radicalId,
    String? langCode,
    String? name,
    String? systemMnemonic,
    List<String>? searchTags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RadicalI18nEntry(
    id: id ?? this.id,
    radicalId: radicalId ?? this.radicalId,
    langCode: langCode ?? this.langCode,
    name: name ?? this.name,
    systemMnemonic: systemMnemonic ?? this.systemMnemonic,
    searchTags: searchTags ?? this.searchTags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RadicalI18nEntry copyWithCompanion(RadicalI18nEntriesCompanion data) {
    return RadicalI18nEntry(
      id: data.id.present ? data.id.value : this.id,
      radicalId: data.radicalId.present ? data.radicalId.value : this.radicalId,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      name: data.name.present ? data.name.value : this.name,
      systemMnemonic: data.systemMnemonic.present
          ? data.systemMnemonic.value
          : this.systemMnemonic,
      searchTags: data.searchTags.present
          ? data.searchTags.value
          : this.searchTags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadicalI18nEntry(')
          ..write('id: $id, ')
          ..write('radicalId: $radicalId, ')
          ..write('langCode: $langCode, ')
          ..write('name: $name, ')
          ..write('systemMnemonic: $systemMnemonic, ')
          ..write('searchTags: $searchTags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    radicalId,
    langCode,
    name,
    systemMnemonic,
    searchTags,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadicalI18nEntry &&
          other.id == this.id &&
          other.radicalId == this.radicalId &&
          other.langCode == this.langCode &&
          other.name == this.name &&
          other.systemMnemonic == this.systemMnemonic &&
          other.searchTags == this.searchTags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RadicalI18nEntriesCompanion extends UpdateCompanion<RadicalI18nEntry> {
  final Value<int> id;
  final Value<int> radicalId;
  final Value<String> langCode;
  final Value<String> name;
  final Value<String> systemMnemonic;
  final Value<List<String>> searchTags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RadicalI18nEntriesCompanion({
    this.id = const Value.absent(),
    this.radicalId = const Value.absent(),
    this.langCode = const Value.absent(),
    this.name = const Value.absent(),
    this.systemMnemonic = const Value.absent(),
    this.searchTags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RadicalI18nEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int radicalId,
    required String langCode,
    required String name,
    required String systemMnemonic,
    required List<String> searchTags,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : radicalId = Value(radicalId),
       langCode = Value(langCode),
       name = Value(name),
       systemMnemonic = Value(systemMnemonic),
       searchTags = Value(searchTags);
  static Insertable<RadicalI18nEntry> custom({
    Expression<int>? id,
    Expression<int>? radicalId,
    Expression<String>? langCode,
    Expression<String>? name,
    Expression<String>? systemMnemonic,
    Expression<String>? searchTags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (radicalId != null) 'radical_id': radicalId,
      if (langCode != null) 'lang_code': langCode,
      if (name != null) 'name': name,
      if (systemMnemonic != null) 'system_mnemonic': systemMnemonic,
      if (searchTags != null) 'search_tags': searchTags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RadicalI18nEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? radicalId,
    Value<String>? langCode,
    Value<String>? name,
    Value<String>? systemMnemonic,
    Value<List<String>>? searchTags,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RadicalI18nEntriesCompanion(
      id: id ?? this.id,
      radicalId: radicalId ?? this.radicalId,
      langCode: langCode ?? this.langCode,
      name: name ?? this.name,
      systemMnemonic: systemMnemonic ?? this.systemMnemonic,
      searchTags: searchTags ?? this.searchTags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (radicalId.present) {
      map['radical_id'] = Variable<int>(radicalId.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (systemMnemonic.present) {
      map['system_mnemonic'] = Variable<String>(systemMnemonic.value);
    }
    if (searchTags.present) {
      map['search_tags'] = Variable<String>(
        $RadicalI18nEntriesTable.$convertersearchTags.toSql(searchTags.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadicalI18nEntriesCompanion(')
          ..write('id: $id, ')
          ..write('radicalId: $radicalId, ')
          ..write('langCode: $langCode, ')
          ..write('name: $name, ')
          ..write('systemMnemonic: $systemMnemonic, ')
          ..write('searchTags: $searchTags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RadicalVariantEntriesTable extends RadicalVariantEntries
    with TableInfo<$RadicalVariantEntriesTable, RadicalVariantEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadicalVariantEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _radicalIdMeta = const VerificationMeta(
    'radicalId',
  );
  @override
  late final GeneratedColumn<int> radicalId = GeneratedColumn<int>(
    'radical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES radical_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _shapeMeta = const VerificationMeta('shape');
  @override
  late final GeneratedColumn<String> shape = GeneratedColumn<String>(
    'shape',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Position, String> position =
      GeneratedColumn<String>(
        'position',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Position>($RadicalVariantEntriesTable.$converterposition);
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _svgFileNameMeta = const VerificationMeta(
    'svgFileName',
  );
  @override
  late final GeneratedColumn<String> svgFileName = GeneratedColumn<String>(
    'svg_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _svgFileUrlMeta = const VerificationMeta(
    'svgFileUrl',
  );
  @override
  late final GeneratedColumn<String> svgFileUrl = GeneratedColumn<String>(
    'svg_file_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _svgHashMeta = const VerificationMeta(
    'svgHash',
  );
  @override
  late final GeneratedColumn<String> svgHash = GeneratedColumn<String>(
    'svg_hash',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    radicalId,
    shape,
    position,
    isLocked,
    svgFileName,
    svgFileUrl,
    svgHash,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radical_variant_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RadicalVariantEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('radical_id')) {
      context.handle(
        _radicalIdMeta,
        radicalId.isAcceptableOrUnknown(data['radical_id']!, _radicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_radicalIdMeta);
    }
    if (data.containsKey('shape')) {
      context.handle(
        _shapeMeta,
        shape.isAcceptableOrUnknown(data['shape']!, _shapeMeta),
      );
    } else if (isInserting) {
      context.missing(_shapeMeta);
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    if (data.containsKey('svg_file_name')) {
      context.handle(
        _svgFileNameMeta,
        svgFileName.isAcceptableOrUnknown(
          data['svg_file_name']!,
          _svgFileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_svgFileNameMeta);
    }
    if (data.containsKey('svg_file_url')) {
      context.handle(
        _svgFileUrlMeta,
        svgFileUrl.isAcceptableOrUnknown(
          data['svg_file_url']!,
          _svgFileUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_svgFileUrlMeta);
    }
    if (data.containsKey('svg_hash')) {
      context.handle(
        _svgHashMeta,
        svgHash.isAcceptableOrUnknown(data['svg_hash']!, _svgHashMeta),
      );
    } else if (isInserting) {
      context.missing(_svgHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {radicalId, position},
  ];
  @override
  RadicalVariantEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadicalVariantEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      radicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}radical_id'],
      )!,
      shape: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shape'],
      )!,
      position: $RadicalVariantEntriesTable.$converterposition.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}position'],
        )!,
      ),
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
      svgFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_file_name'],
      )!,
      svgFileUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_file_url'],
      )!,
      svgHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RadicalVariantEntriesTable createAlias(String alias) {
    return $RadicalVariantEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<Position, String> $converterposition =
      const PositionConverter();
}

class RadicalVariantEntry extends DataClass
    implements Insertable<RadicalVariantEntry> {
  final int id;
  final int radicalId;
  final String shape;
  final Position position;
  final bool isLocked;
  final String svgFileName;
  final String svgFileUrl;
  final String svgHash;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RadicalVariantEntry({
    required this.id,
    required this.radicalId,
    required this.shape,
    required this.position,
    required this.isLocked,
    required this.svgFileName,
    required this.svgFileUrl,
    required this.svgHash,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['radical_id'] = Variable<int>(radicalId);
    map['shape'] = Variable<String>(shape);
    {
      map['position'] = Variable<String>(
        $RadicalVariantEntriesTable.$converterposition.toSql(position),
      );
    }
    map['is_locked'] = Variable<bool>(isLocked);
    map['svg_file_name'] = Variable<String>(svgFileName);
    map['svg_file_url'] = Variable<String>(svgFileUrl);
    map['svg_hash'] = Variable<String>(svgHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RadicalVariantEntriesCompanion toCompanion(bool nullToAbsent) {
    return RadicalVariantEntriesCompanion(
      id: Value(id),
      radicalId: Value(radicalId),
      shape: Value(shape),
      position: Value(position),
      isLocked: Value(isLocked),
      svgFileName: Value(svgFileName),
      svgFileUrl: Value(svgFileUrl),
      svgHash: Value(svgHash),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RadicalVariantEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadicalVariantEntry(
      id: serializer.fromJson<int>(json['id']),
      radicalId: serializer.fromJson<int>(json['radicalId']),
      shape: serializer.fromJson<String>(json['shape']),
      position: serializer.fromJson<Position>(json['position']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      svgFileName: serializer.fromJson<String>(json['svgFileName']),
      svgFileUrl: serializer.fromJson<String>(json['svgFileUrl']),
      svgHash: serializer.fromJson<String>(json['svgHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'radicalId': serializer.toJson<int>(radicalId),
      'shape': serializer.toJson<String>(shape),
      'position': serializer.toJson<Position>(position),
      'isLocked': serializer.toJson<bool>(isLocked),
      'svgFileName': serializer.toJson<String>(svgFileName),
      'svgFileUrl': serializer.toJson<String>(svgFileUrl),
      'svgHash': serializer.toJson<String>(svgHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RadicalVariantEntry copyWith({
    int? id,
    int? radicalId,
    String? shape,
    Position? position,
    bool? isLocked,
    String? svgFileName,
    String? svgFileUrl,
    String? svgHash,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RadicalVariantEntry(
    id: id ?? this.id,
    radicalId: radicalId ?? this.radicalId,
    shape: shape ?? this.shape,
    position: position ?? this.position,
    isLocked: isLocked ?? this.isLocked,
    svgFileName: svgFileName ?? this.svgFileName,
    svgFileUrl: svgFileUrl ?? this.svgFileUrl,
    svgHash: svgHash ?? this.svgHash,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RadicalVariantEntry copyWithCompanion(RadicalVariantEntriesCompanion data) {
    return RadicalVariantEntry(
      id: data.id.present ? data.id.value : this.id,
      radicalId: data.radicalId.present ? data.radicalId.value : this.radicalId,
      shape: data.shape.present ? data.shape.value : this.shape,
      position: data.position.present ? data.position.value : this.position,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      svgFileName: data.svgFileName.present
          ? data.svgFileName.value
          : this.svgFileName,
      svgFileUrl: data.svgFileUrl.present
          ? data.svgFileUrl.value
          : this.svgFileUrl,
      svgHash: data.svgHash.present ? data.svgHash.value : this.svgHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadicalVariantEntry(')
          ..write('id: $id, ')
          ..write('radicalId: $radicalId, ')
          ..write('shape: $shape, ')
          ..write('position: $position, ')
          ..write('isLocked: $isLocked, ')
          ..write('svgFileName: $svgFileName, ')
          ..write('svgFileUrl: $svgFileUrl, ')
          ..write('svgHash: $svgHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    radicalId,
    shape,
    position,
    isLocked,
    svgFileName,
    svgFileUrl,
    svgHash,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadicalVariantEntry &&
          other.id == this.id &&
          other.radicalId == this.radicalId &&
          other.shape == this.shape &&
          other.position == this.position &&
          other.isLocked == this.isLocked &&
          other.svgFileName == this.svgFileName &&
          other.svgFileUrl == this.svgFileUrl &&
          other.svgHash == this.svgHash &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RadicalVariantEntriesCompanion
    extends UpdateCompanion<RadicalVariantEntry> {
  final Value<int> id;
  final Value<int> radicalId;
  final Value<String> shape;
  final Value<Position> position;
  final Value<bool> isLocked;
  final Value<String> svgFileName;
  final Value<String> svgFileUrl;
  final Value<String> svgHash;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RadicalVariantEntriesCompanion({
    this.id = const Value.absent(),
    this.radicalId = const Value.absent(),
    this.shape = const Value.absent(),
    this.position = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.svgFileName = const Value.absent(),
    this.svgFileUrl = const Value.absent(),
    this.svgHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RadicalVariantEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int radicalId,
    required String shape,
    required Position position,
    this.isLocked = const Value.absent(),
    required String svgFileName,
    required String svgFileUrl,
    required String svgHash,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : radicalId = Value(radicalId),
       shape = Value(shape),
       position = Value(position),
       svgFileName = Value(svgFileName),
       svgFileUrl = Value(svgFileUrl),
       svgHash = Value(svgHash);
  static Insertable<RadicalVariantEntry> custom({
    Expression<int>? id,
    Expression<int>? radicalId,
    Expression<String>? shape,
    Expression<String>? position,
    Expression<bool>? isLocked,
    Expression<String>? svgFileName,
    Expression<String>? svgFileUrl,
    Expression<String>? svgHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (radicalId != null) 'radical_id': radicalId,
      if (shape != null) 'shape': shape,
      if (position != null) 'position': position,
      if (isLocked != null) 'is_locked': isLocked,
      if (svgFileName != null) 'svg_file_name': svgFileName,
      if (svgFileUrl != null) 'svg_file_url': svgFileUrl,
      if (svgHash != null) 'svg_hash': svgHash,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RadicalVariantEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? radicalId,
    Value<String>? shape,
    Value<Position>? position,
    Value<bool>? isLocked,
    Value<String>? svgFileName,
    Value<String>? svgFileUrl,
    Value<String>? svgHash,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RadicalVariantEntriesCompanion(
      id: id ?? this.id,
      radicalId: radicalId ?? this.radicalId,
      shape: shape ?? this.shape,
      position: position ?? this.position,
      isLocked: isLocked ?? this.isLocked,
      svgFileName: svgFileName ?? this.svgFileName,
      svgFileUrl: svgFileUrl ?? this.svgFileUrl,
      svgHash: svgHash ?? this.svgHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (radicalId.present) {
      map['radical_id'] = Variable<int>(radicalId.value);
    }
    if (shape.present) {
      map['shape'] = Variable<String>(shape.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(
        $RadicalVariantEntriesTable.$converterposition.toSql(position.value),
      );
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (svgFileName.present) {
      map['svg_file_name'] = Variable<String>(svgFileName.value);
    }
    if (svgFileUrl.present) {
      map['svg_file_url'] = Variable<String>(svgFileUrl.value);
    }
    if (svgHash.present) {
      map['svg_hash'] = Variable<String>(svgHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadicalVariantEntriesCompanion(')
          ..write('id: $id, ')
          ..write('radicalId: $radicalId, ')
          ..write('shape: $shape, ')
          ..write('position: $position, ')
          ..write('isLocked: $isLocked, ')
          ..write('svgFileName: $svgFileName, ')
          ..write('svgFileUrl: $svgFileUrl, ')
          ..write('svgHash: $svgHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KanjiEntriesTable extends KanjiEntries
    with TableInfo<$KanjiEntriesTable, KanjiEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterMeta = const VerificationMeta(
    'character',
  );
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
    'character',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _strokeCountMeta = const VerificationMeta(
    'strokeCount',
  );
  @override
  late final GeneratedColumn<int> strokeCount = GeneratedColumn<int>(
    'stroke_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (stroke_count > 0)',
  );
  static const VerificationMeta _minJlptLevelMeta = const VerificationMeta(
    'minJlptLevel',
  );
  @override
  late final GeneratedColumn<int> minJlptLevel = GeneratedColumn<int>(
    'min_jlpt_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minGradeMeta = const VerificationMeta(
    'minGrade',
  );
  @override
  late final GeneratedColumn<int> minGrade = GeneratedColumn<int>(
    'min_grade',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyRankMeta = const VerificationMeta(
    'frequencyRank',
  );
  @override
  late final GeneratedColumn<int> frequencyRank = GeneratedColumn<int>(
    'frequency_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (frequency_rank > 0)',
  );
  static const VerificationMeta _svgFileNameMeta = const VerificationMeta(
    'svgFileName',
  );
  @override
  late final GeneratedColumn<String> svgFileName = GeneratedColumn<String>(
    'svg_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _svgFileUrlMeta = const VerificationMeta(
    'svgFileUrl',
  );
  @override
  late final GeneratedColumn<String> svgFileUrl = GeneratedColumn<String>(
    'svg_file_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _svgHashMeta = const VerificationMeta(
    'svgHash',
  );
  @override
  late final GeneratedColumn<String> svgHash = GeneratedColumn<String>(
    'svg_hash',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    character,
    strokeCount,
    minJlptLevel,
    minGrade,
    frequencyRank,
    svgFileName,
    svgFileUrl,
    svgHash,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanjiEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character')) {
      context.handle(
        _characterMeta,
        character.isAcceptableOrUnknown(data['character']!, _characterMeta),
      );
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('stroke_count')) {
      context.handle(
        _strokeCountMeta,
        strokeCount.isAcceptableOrUnknown(
          data['stroke_count']!,
          _strokeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_strokeCountMeta);
    }
    if (data.containsKey('min_jlpt_level')) {
      context.handle(
        _minJlptLevelMeta,
        minJlptLevel.isAcceptableOrUnknown(
          data['min_jlpt_level']!,
          _minJlptLevelMeta,
        ),
      );
    }
    if (data.containsKey('min_grade')) {
      context.handle(
        _minGradeMeta,
        minGrade.isAcceptableOrUnknown(data['min_grade']!, _minGradeMeta),
      );
    }
    if (data.containsKey('frequency_rank')) {
      context.handle(
        _frequencyRankMeta,
        frequencyRank.isAcceptableOrUnknown(
          data['frequency_rank']!,
          _frequencyRankMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyRankMeta);
    }
    if (data.containsKey('svg_file_name')) {
      context.handle(
        _svgFileNameMeta,
        svgFileName.isAcceptableOrUnknown(
          data['svg_file_name']!,
          _svgFileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_svgFileNameMeta);
    }
    if (data.containsKey('svg_file_url')) {
      context.handle(
        _svgFileUrlMeta,
        svgFileUrl.isAcceptableOrUnknown(
          data['svg_file_url']!,
          _svgFileUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_svgFileUrlMeta);
    }
    if (data.containsKey('svg_hash')) {
      context.handle(
        _svgHashMeta,
        svgHash.isAcceptableOrUnknown(data['svg_hash']!, _svgHashMeta),
      );
    } else if (isInserting) {
      context.missing(_svgHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KanjiEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      character: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character'],
      )!,
      strokeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stroke_count'],
      )!,
      minJlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_jlpt_level'],
      ),
      minGrade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_grade'],
      ),
      frequencyRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_rank'],
      )!,
      svgFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_file_name'],
      )!,
      svgFileUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_file_url'],
      )!,
      svgHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KanjiEntriesTable createAlias(String alias) {
    return $KanjiEntriesTable(attachedDatabase, alias);
  }
}

class KanjiEntry extends DataClass implements Insertable<KanjiEntry> {
  final int id;
  final String character;
  final int strokeCount;
  final int? minJlptLevel;
  final int? minGrade;
  final int frequencyRank;
  final String svgFileName;
  final String svgFileUrl;
  final String svgHash;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KanjiEntry({
    required this.id,
    required this.character,
    required this.strokeCount,
    this.minJlptLevel,
    this.minGrade,
    required this.frequencyRank,
    required this.svgFileName,
    required this.svgFileUrl,
    required this.svgHash,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character'] = Variable<String>(character);
    map['stroke_count'] = Variable<int>(strokeCount);
    if (!nullToAbsent || minJlptLevel != null) {
      map['min_jlpt_level'] = Variable<int>(minJlptLevel);
    }
    if (!nullToAbsent || minGrade != null) {
      map['min_grade'] = Variable<int>(minGrade);
    }
    map['frequency_rank'] = Variable<int>(frequencyRank);
    map['svg_file_name'] = Variable<String>(svgFileName);
    map['svg_file_url'] = Variable<String>(svgFileUrl);
    map['svg_hash'] = Variable<String>(svgHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KanjiEntriesCompanion toCompanion(bool nullToAbsent) {
    return KanjiEntriesCompanion(
      id: Value(id),
      character: Value(character),
      strokeCount: Value(strokeCount),
      minJlptLevel: minJlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(minJlptLevel),
      minGrade: minGrade == null && nullToAbsent
          ? const Value.absent()
          : Value(minGrade),
      frequencyRank: Value(frequencyRank),
      svgFileName: Value(svgFileName),
      svgFileUrl: Value(svgFileUrl),
      svgHash: Value(svgHash),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KanjiEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiEntry(
      id: serializer.fromJson<int>(json['id']),
      character: serializer.fromJson<String>(json['character']),
      strokeCount: serializer.fromJson<int>(json['strokeCount']),
      minJlptLevel: serializer.fromJson<int?>(json['minJlptLevel']),
      minGrade: serializer.fromJson<int?>(json['minGrade']),
      frequencyRank: serializer.fromJson<int>(json['frequencyRank']),
      svgFileName: serializer.fromJson<String>(json['svgFileName']),
      svgFileUrl: serializer.fromJson<String>(json['svgFileUrl']),
      svgHash: serializer.fromJson<String>(json['svgHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'character': serializer.toJson<String>(character),
      'strokeCount': serializer.toJson<int>(strokeCount),
      'minJlptLevel': serializer.toJson<int?>(minJlptLevel),
      'minGrade': serializer.toJson<int?>(minGrade),
      'frequencyRank': serializer.toJson<int>(frequencyRank),
      'svgFileName': serializer.toJson<String>(svgFileName),
      'svgFileUrl': serializer.toJson<String>(svgFileUrl),
      'svgHash': serializer.toJson<String>(svgHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KanjiEntry copyWith({
    int? id,
    String? character,
    int? strokeCount,
    Value<int?> minJlptLevel = const Value.absent(),
    Value<int?> minGrade = const Value.absent(),
    int? frequencyRank,
    String? svgFileName,
    String? svgFileUrl,
    String? svgHash,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KanjiEntry(
    id: id ?? this.id,
    character: character ?? this.character,
    strokeCount: strokeCount ?? this.strokeCount,
    minJlptLevel: minJlptLevel.present ? minJlptLevel.value : this.minJlptLevel,
    minGrade: minGrade.present ? minGrade.value : this.minGrade,
    frequencyRank: frequencyRank ?? this.frequencyRank,
    svgFileName: svgFileName ?? this.svgFileName,
    svgFileUrl: svgFileUrl ?? this.svgFileUrl,
    svgHash: svgHash ?? this.svgHash,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KanjiEntry copyWithCompanion(KanjiEntriesCompanion data) {
    return KanjiEntry(
      id: data.id.present ? data.id.value : this.id,
      character: data.character.present ? data.character.value : this.character,
      strokeCount: data.strokeCount.present
          ? data.strokeCount.value
          : this.strokeCount,
      minJlptLevel: data.minJlptLevel.present
          ? data.minJlptLevel.value
          : this.minJlptLevel,
      minGrade: data.minGrade.present ? data.minGrade.value : this.minGrade,
      frequencyRank: data.frequencyRank.present
          ? data.frequencyRank.value
          : this.frequencyRank,
      svgFileName: data.svgFileName.present
          ? data.svgFileName.value
          : this.svgFileName,
      svgFileUrl: data.svgFileUrl.present
          ? data.svgFileUrl.value
          : this.svgFileUrl,
      svgHash: data.svgHash.present ? data.svgHash.value : this.svgHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiEntry(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('minJlptLevel: $minJlptLevel, ')
          ..write('minGrade: $minGrade, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('svgFileName: $svgFileName, ')
          ..write('svgFileUrl: $svgFileUrl, ')
          ..write('svgHash: $svgHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    character,
    strokeCount,
    minJlptLevel,
    minGrade,
    frequencyRank,
    svgFileName,
    svgFileUrl,
    svgHash,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiEntry &&
          other.id == this.id &&
          other.character == this.character &&
          other.strokeCount == this.strokeCount &&
          other.minJlptLevel == this.minJlptLevel &&
          other.minGrade == this.minGrade &&
          other.frequencyRank == this.frequencyRank &&
          other.svgFileName == this.svgFileName &&
          other.svgFileUrl == this.svgFileUrl &&
          other.svgHash == this.svgHash &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KanjiEntriesCompanion extends UpdateCompanion<KanjiEntry> {
  final Value<int> id;
  final Value<String> character;
  final Value<int> strokeCount;
  final Value<int?> minJlptLevel;
  final Value<int?> minGrade;
  final Value<int> frequencyRank;
  final Value<String> svgFileName;
  final Value<String> svgFileUrl;
  final Value<String> svgHash;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KanjiEntriesCompanion({
    this.id = const Value.absent(),
    this.character = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.minJlptLevel = const Value.absent(),
    this.minGrade = const Value.absent(),
    this.frequencyRank = const Value.absent(),
    this.svgFileName = const Value.absent(),
    this.svgFileUrl = const Value.absent(),
    this.svgHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KanjiEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String character,
    required int strokeCount,
    this.minJlptLevel = const Value.absent(),
    this.minGrade = const Value.absent(),
    required int frequencyRank,
    required String svgFileName,
    required String svgFileUrl,
    required String svgHash,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : character = Value(character),
       strokeCount = Value(strokeCount),
       frequencyRank = Value(frequencyRank),
       svgFileName = Value(svgFileName),
       svgFileUrl = Value(svgFileUrl),
       svgHash = Value(svgHash);
  static Insertable<KanjiEntry> custom({
    Expression<int>? id,
    Expression<String>? character,
    Expression<int>? strokeCount,
    Expression<int>? minJlptLevel,
    Expression<int>? minGrade,
    Expression<int>? frequencyRank,
    Expression<String>? svgFileName,
    Expression<String>? svgFileUrl,
    Expression<String>? svgHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (character != null) 'character': character,
      if (strokeCount != null) 'stroke_count': strokeCount,
      if (minJlptLevel != null) 'min_jlpt_level': minJlptLevel,
      if (minGrade != null) 'min_grade': minGrade,
      if (frequencyRank != null) 'frequency_rank': frequencyRank,
      if (svgFileName != null) 'svg_file_name': svgFileName,
      if (svgFileUrl != null) 'svg_file_url': svgFileUrl,
      if (svgHash != null) 'svg_hash': svgHash,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KanjiEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? character,
    Value<int>? strokeCount,
    Value<int?>? minJlptLevel,
    Value<int?>? minGrade,
    Value<int>? frequencyRank,
    Value<String>? svgFileName,
    Value<String>? svgFileUrl,
    Value<String>? svgHash,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KanjiEntriesCompanion(
      id: id ?? this.id,
      character: character ?? this.character,
      strokeCount: strokeCount ?? this.strokeCount,
      minJlptLevel: minJlptLevel ?? this.minJlptLevel,
      minGrade: minGrade ?? this.minGrade,
      frequencyRank: frequencyRank ?? this.frequencyRank,
      svgFileName: svgFileName ?? this.svgFileName,
      svgFileUrl: svgFileUrl ?? this.svgFileUrl,
      svgHash: svgHash ?? this.svgHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (strokeCount.present) {
      map['stroke_count'] = Variable<int>(strokeCount.value);
    }
    if (minJlptLevel.present) {
      map['min_jlpt_level'] = Variable<int>(minJlptLevel.value);
    }
    if (minGrade.present) {
      map['min_grade'] = Variable<int>(minGrade.value);
    }
    if (frequencyRank.present) {
      map['frequency_rank'] = Variable<int>(frequencyRank.value);
    }
    if (svgFileName.present) {
      map['svg_file_name'] = Variable<String>(svgFileName.value);
    }
    if (svgFileUrl.present) {
      map['svg_file_url'] = Variable<String>(svgFileUrl.value);
    }
    if (svgHash.present) {
      map['svg_hash'] = Variable<String>(svgHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiEntriesCompanion(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('minJlptLevel: $minJlptLevel, ')
          ..write('minGrade: $minGrade, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('svgFileName: $svgFileName, ')
          ..write('svgFileUrl: $svgFileUrl, ')
          ..write('svgHash: $svgHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KanjiReadingEntriesTable extends KanjiReadingEntries
    with TableInfo<$KanjiReadingEntriesTable, KanjiReadingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiReadingEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kanjiIdMeta = const VerificationMeta(
    'kanjiId',
  );
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
    'kanji_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kanji_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReadingType, String> readingType =
      GeneratedColumn<String>(
        'reading_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReadingType>(
        $KanjiReadingEntriesTable.$converterreadingType,
      );
  @override
  late final GeneratedColumnWithTypeConverter<ReadingPriority, String>
  priority =
      GeneratedColumn<String>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReadingPriority>(
        $KanjiReadingEntriesTable.$converterpriority,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kanjiId,
    reading,
    readingType,
    priority,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_reading_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanjiReadingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kanji_id')) {
      context.handle(
        _kanjiIdMeta,
        kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    } else if (isInserting) {
      context.missing(_readingMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {kanjiId, reading, readingType},
  ];
  @override
  KanjiReadingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiReadingEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kanjiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kanji_id'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      )!,
      readingType: $KanjiReadingEntriesTable.$converterreadingType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reading_type'],
        )!,
      ),
      priority: $KanjiReadingEntriesTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}priority'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KanjiReadingEntriesTable createAlias(String alias) {
    return $KanjiReadingEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<ReadingType, String> $converterreadingType =
      const ReadingTypeConverter();
  static TypeConverter<ReadingPriority, String> $converterpriority =
      const ReadingPriorityConverter();
}

class KanjiReadingEntry extends DataClass
    implements Insertable<KanjiReadingEntry> {
  final int id;
  final int kanjiId;
  final String reading;
  final ReadingType readingType;
  final ReadingPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KanjiReadingEntry({
    required this.id,
    required this.kanjiId,
    required this.reading,
    required this.readingType,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kanji_id'] = Variable<int>(kanjiId);
    map['reading'] = Variable<String>(reading);
    {
      map['reading_type'] = Variable<String>(
        $KanjiReadingEntriesTable.$converterreadingType.toSql(readingType),
      );
    }
    {
      map['priority'] = Variable<String>(
        $KanjiReadingEntriesTable.$converterpriority.toSql(priority),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KanjiReadingEntriesCompanion toCompanion(bool nullToAbsent) {
    return KanjiReadingEntriesCompanion(
      id: Value(id),
      kanjiId: Value(kanjiId),
      reading: Value(reading),
      readingType: Value(readingType),
      priority: Value(priority),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KanjiReadingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiReadingEntry(
      id: serializer.fromJson<int>(json['id']),
      kanjiId: serializer.fromJson<int>(json['kanjiId']),
      reading: serializer.fromJson<String>(json['reading']),
      readingType: serializer.fromJson<ReadingType>(json['readingType']),
      priority: serializer.fromJson<ReadingPriority>(json['priority']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kanjiId': serializer.toJson<int>(kanjiId),
      'reading': serializer.toJson<String>(reading),
      'readingType': serializer.toJson<ReadingType>(readingType),
      'priority': serializer.toJson<ReadingPriority>(priority),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KanjiReadingEntry copyWith({
    int? id,
    int? kanjiId,
    String? reading,
    ReadingType? readingType,
    ReadingPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KanjiReadingEntry(
    id: id ?? this.id,
    kanjiId: kanjiId ?? this.kanjiId,
    reading: reading ?? this.reading,
    readingType: readingType ?? this.readingType,
    priority: priority ?? this.priority,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KanjiReadingEntry copyWithCompanion(KanjiReadingEntriesCompanion data) {
    return KanjiReadingEntry(
      id: data.id.present ? data.id.value : this.id,
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      reading: data.reading.present ? data.reading.value : this.reading,
      readingType: data.readingType.present
          ? data.readingType.value
          : this.readingType,
      priority: data.priority.present ? data.priority.value : this.priority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiReadingEntry(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('reading: $reading, ')
          ..write('readingType: $readingType, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kanjiId,
    reading,
    readingType,
    priority,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiReadingEntry &&
          other.id == this.id &&
          other.kanjiId == this.kanjiId &&
          other.reading == this.reading &&
          other.readingType == this.readingType &&
          other.priority == this.priority &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KanjiReadingEntriesCompanion extends UpdateCompanion<KanjiReadingEntry> {
  final Value<int> id;
  final Value<int> kanjiId;
  final Value<String> reading;
  final Value<ReadingType> readingType;
  final Value<ReadingPriority> priority;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KanjiReadingEntriesCompanion({
    this.id = const Value.absent(),
    this.kanjiId = const Value.absent(),
    this.reading = const Value.absent(),
    this.readingType = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KanjiReadingEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int kanjiId,
    required String reading,
    required ReadingType readingType,
    required ReadingPriority priority,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : kanjiId = Value(kanjiId),
       reading = Value(reading),
       readingType = Value(readingType),
       priority = Value(priority);
  static Insertable<KanjiReadingEntry> custom({
    Expression<int>? id,
    Expression<int>? kanjiId,
    Expression<String>? reading,
    Expression<String>? readingType,
    Expression<String>? priority,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (reading != null) 'reading': reading,
      if (readingType != null) 'reading_type': readingType,
      if (priority != null) 'priority': priority,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KanjiReadingEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? kanjiId,
    Value<String>? reading,
    Value<ReadingType>? readingType,
    Value<ReadingPriority>? priority,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KanjiReadingEntriesCompanion(
      id: id ?? this.id,
      kanjiId: kanjiId ?? this.kanjiId,
      reading: reading ?? this.reading,
      readingType: readingType ?? this.readingType,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (readingType.present) {
      map['reading_type'] = Variable<String>(
        $KanjiReadingEntriesTable.$converterreadingType.toSql(
          readingType.value,
        ),
      );
    }
    if (priority.present) {
      map['priority'] = Variable<String>(
        $KanjiReadingEntriesTable.$converterpriority.toSql(priority.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiReadingEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('reading: $reading, ')
          ..write('readingType: $readingType, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KanjiI18nEntriesTable extends KanjiI18nEntries
    with TableInfo<$KanjiI18nEntriesTable, KanjiI18nEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiI18nEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kanjiIdMeta = const VerificationMeta(
    'kanjiId',
  );
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
    'kanji_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kanji_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _langCodeMeta = const VerificationMeta(
    'langCode',
  );
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
    'lang_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> meanings =
      GeneratedColumn<String>(
        'meanings',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($KanjiI18nEntriesTable.$convertermeanings);
  static const VerificationMeta _systemMnemonicMeta = const VerificationMeta(
    'systemMnemonic',
  );
  @override
  late final GeneratedColumn<String> systemMnemonic = GeneratedColumn<String>(
    'system_mnemonic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> searchTags =
      GeneratedColumn<String>(
        'search_tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $KanjiI18nEntriesTable.$convertersearchTags,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kanjiId,
    langCode,
    meanings,
    systemMnemonic,
    searchTags,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_i18n_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanjiI18nEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kanji_id')) {
      context.handle(
        _kanjiIdMeta,
        kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('lang_code')) {
      context.handle(
        _langCodeMeta,
        langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('system_mnemonic')) {
      context.handle(
        _systemMnemonicMeta,
        systemMnemonic.isAcceptableOrUnknown(
          data['system_mnemonic']!,
          _systemMnemonicMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_systemMnemonicMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {kanjiId, langCode},
  ];
  @override
  KanjiI18nEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiI18nEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kanjiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kanji_id'],
      )!,
      langCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang_code'],
      )!,
      meanings: $KanjiI18nEntriesTable.$convertermeanings.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}meanings'],
        )!,
      ),
      systemMnemonic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_mnemonic'],
      )!,
      searchTags: $KanjiI18nEntriesTable.$convertersearchTags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}search_tags'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KanjiI18nEntriesTable createAlias(String alias) {
    return $KanjiI18nEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertermeanings =
      const NonNullableStringListConverter();
  static TypeConverter<List<String>, String> $convertersearchTags =
      const NonNullableStringListConverter();
}

class KanjiI18nEntry extends DataClass implements Insertable<KanjiI18nEntry> {
  final int id;
  final int kanjiId;
  final String langCode;
  final List<String> meanings;
  final String systemMnemonic;
  final List<String> searchTags;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KanjiI18nEntry({
    required this.id,
    required this.kanjiId,
    required this.langCode,
    required this.meanings,
    required this.systemMnemonic,
    required this.searchTags,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kanji_id'] = Variable<int>(kanjiId);
    map['lang_code'] = Variable<String>(langCode);
    {
      map['meanings'] = Variable<String>(
        $KanjiI18nEntriesTable.$convertermeanings.toSql(meanings),
      );
    }
    map['system_mnemonic'] = Variable<String>(systemMnemonic);
    {
      map['search_tags'] = Variable<String>(
        $KanjiI18nEntriesTable.$convertersearchTags.toSql(searchTags),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KanjiI18nEntriesCompanion toCompanion(bool nullToAbsent) {
    return KanjiI18nEntriesCompanion(
      id: Value(id),
      kanjiId: Value(kanjiId),
      langCode: Value(langCode),
      meanings: Value(meanings),
      systemMnemonic: Value(systemMnemonic),
      searchTags: Value(searchTags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KanjiI18nEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiI18nEntry(
      id: serializer.fromJson<int>(json['id']),
      kanjiId: serializer.fromJson<int>(json['kanjiId']),
      langCode: serializer.fromJson<String>(json['langCode']),
      meanings: serializer.fromJson<List<String>>(json['meanings']),
      systemMnemonic: serializer.fromJson<String>(json['systemMnemonic']),
      searchTags: serializer.fromJson<List<String>>(json['searchTags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kanjiId': serializer.toJson<int>(kanjiId),
      'langCode': serializer.toJson<String>(langCode),
      'meanings': serializer.toJson<List<String>>(meanings),
      'systemMnemonic': serializer.toJson<String>(systemMnemonic),
      'searchTags': serializer.toJson<List<String>>(searchTags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KanjiI18nEntry copyWith({
    int? id,
    int? kanjiId,
    String? langCode,
    List<String>? meanings,
    String? systemMnemonic,
    List<String>? searchTags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KanjiI18nEntry(
    id: id ?? this.id,
    kanjiId: kanjiId ?? this.kanjiId,
    langCode: langCode ?? this.langCode,
    meanings: meanings ?? this.meanings,
    systemMnemonic: systemMnemonic ?? this.systemMnemonic,
    searchTags: searchTags ?? this.searchTags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KanjiI18nEntry copyWithCompanion(KanjiI18nEntriesCompanion data) {
    return KanjiI18nEntry(
      id: data.id.present ? data.id.value : this.id,
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      meanings: data.meanings.present ? data.meanings.value : this.meanings,
      systemMnemonic: data.systemMnemonic.present
          ? data.systemMnemonic.value
          : this.systemMnemonic,
      searchTags: data.searchTags.present
          ? data.searchTags.value
          : this.searchTags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiI18nEntry(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('langCode: $langCode, ')
          ..write('meanings: $meanings, ')
          ..write('systemMnemonic: $systemMnemonic, ')
          ..write('searchTags: $searchTags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kanjiId,
    langCode,
    meanings,
    systemMnemonic,
    searchTags,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiI18nEntry &&
          other.id == this.id &&
          other.kanjiId == this.kanjiId &&
          other.langCode == this.langCode &&
          other.meanings == this.meanings &&
          other.systemMnemonic == this.systemMnemonic &&
          other.searchTags == this.searchTags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KanjiI18nEntriesCompanion extends UpdateCompanion<KanjiI18nEntry> {
  final Value<int> id;
  final Value<int> kanjiId;
  final Value<String> langCode;
  final Value<List<String>> meanings;
  final Value<String> systemMnemonic;
  final Value<List<String>> searchTags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KanjiI18nEntriesCompanion({
    this.id = const Value.absent(),
    this.kanjiId = const Value.absent(),
    this.langCode = const Value.absent(),
    this.meanings = const Value.absent(),
    this.systemMnemonic = const Value.absent(),
    this.searchTags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KanjiI18nEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int kanjiId,
    required String langCode,
    required List<String> meanings,
    required String systemMnemonic,
    required List<String> searchTags,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : kanjiId = Value(kanjiId),
       langCode = Value(langCode),
       meanings = Value(meanings),
       systemMnemonic = Value(systemMnemonic),
       searchTags = Value(searchTags);
  static Insertable<KanjiI18nEntry> custom({
    Expression<int>? id,
    Expression<int>? kanjiId,
    Expression<String>? langCode,
    Expression<String>? meanings,
    Expression<String>? systemMnemonic,
    Expression<String>? searchTags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (langCode != null) 'lang_code': langCode,
      if (meanings != null) 'meanings': meanings,
      if (systemMnemonic != null) 'system_mnemonic': systemMnemonic,
      if (searchTags != null) 'search_tags': searchTags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KanjiI18nEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? kanjiId,
    Value<String>? langCode,
    Value<List<String>>? meanings,
    Value<String>? systemMnemonic,
    Value<List<String>>? searchTags,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KanjiI18nEntriesCompanion(
      id: id ?? this.id,
      kanjiId: kanjiId ?? this.kanjiId,
      langCode: langCode ?? this.langCode,
      meanings: meanings ?? this.meanings,
      systemMnemonic: systemMnemonic ?? this.systemMnemonic,
      searchTags: searchTags ?? this.searchTags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (meanings.present) {
      map['meanings'] = Variable<String>(
        $KanjiI18nEntriesTable.$convertermeanings.toSql(meanings.value),
      );
    }
    if (systemMnemonic.present) {
      map['system_mnemonic'] = Variable<String>(systemMnemonic.value);
    }
    if (searchTags.present) {
      map['search_tags'] = Variable<String>(
        $KanjiI18nEntriesTable.$convertersearchTags.toSql(searchTags.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiI18nEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('langCode: $langCode, ')
          ..write('meanings: $meanings, ')
          ..write('systemMnemonic: $systemMnemonic, ')
          ..write('searchTags: $searchTags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KanjiComponentEntriesTable extends KanjiComponentEntries
    with TableInfo<$KanjiComponentEntriesTable, KanjiComponentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiComponentEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kanjiIdMeta = const VerificationMeta(
    'kanjiId',
  );
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
    'kanji_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kanji_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _radicalIdMeta = const VerificationMeta(
    'radicalId',
  );
  @override
  late final GeneratedColumn<int> radicalId = GeneratedColumn<int>(
    'radical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES radical_entries (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Position, String> position =
      GeneratedColumn<String>(
        'position',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Position>($KanjiComponentEntriesTable.$converterposition);
  @override
  late final GeneratedColumnWithTypeConverter<LogicHint, String> logicHint =
      GeneratedColumn<String>(
        'logic_hint',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LogicHint>(
        $KanjiComponentEntriesTable.$converterlogicHint,
      );
  @override
  late final GeneratedColumnWithTypeConverter<RadicalType, String> radicalType =
      GeneratedColumn<String>(
        'radical_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RadicalType>(
        $KanjiComponentEntriesTable.$converterradicalType,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kanjiId,
    radicalId,
    position,
    logicHint,
    radicalType,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_component_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanjiComponentEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kanji_id')) {
      context.handle(
        _kanjiIdMeta,
        kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('radical_id')) {
      context.handle(
        _radicalIdMeta,
        radicalId.isAcceptableOrUnknown(data['radical_id']!, _radicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_radicalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {kanjiId, radicalId, position},
  ];
  @override
  KanjiComponentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiComponentEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kanjiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kanji_id'],
      )!,
      radicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}radical_id'],
      )!,
      position: $KanjiComponentEntriesTable.$converterposition.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}position'],
        )!,
      ),
      logicHint: $KanjiComponentEntriesTable.$converterlogicHint.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}logic_hint'],
        )!,
      ),
      radicalType: $KanjiComponentEntriesTable.$converterradicalType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}radical_type'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KanjiComponentEntriesTable createAlias(String alias) {
    return $KanjiComponentEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<Position, String> $converterposition =
      const PositionConverter();
  static TypeConverter<LogicHint, String> $converterlogicHint =
      const LogicHintConverter();
  static TypeConverter<RadicalType, String> $converterradicalType =
      const RadicalTypeConverter();
}

class KanjiComponentEntry extends DataClass
    implements Insertable<KanjiComponentEntry> {
  final int id;
  final int kanjiId;
  final int radicalId;
  final Position position;
  final LogicHint logicHint;
  final RadicalType radicalType;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KanjiComponentEntry({
    required this.id,
    required this.kanjiId,
    required this.radicalId,
    required this.position,
    required this.logicHint,
    required this.radicalType,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kanji_id'] = Variable<int>(kanjiId);
    map['radical_id'] = Variable<int>(radicalId);
    {
      map['position'] = Variable<String>(
        $KanjiComponentEntriesTable.$converterposition.toSql(position),
      );
    }
    {
      map['logic_hint'] = Variable<String>(
        $KanjiComponentEntriesTable.$converterlogicHint.toSql(logicHint),
      );
    }
    {
      map['radical_type'] = Variable<String>(
        $KanjiComponentEntriesTable.$converterradicalType.toSql(radicalType),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KanjiComponentEntriesCompanion toCompanion(bool nullToAbsent) {
    return KanjiComponentEntriesCompanion(
      id: Value(id),
      kanjiId: Value(kanjiId),
      radicalId: Value(radicalId),
      position: Value(position),
      logicHint: Value(logicHint),
      radicalType: Value(radicalType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KanjiComponentEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiComponentEntry(
      id: serializer.fromJson<int>(json['id']),
      kanjiId: serializer.fromJson<int>(json['kanjiId']),
      radicalId: serializer.fromJson<int>(json['radicalId']),
      position: serializer.fromJson<Position>(json['position']),
      logicHint: serializer.fromJson<LogicHint>(json['logicHint']),
      radicalType: serializer.fromJson<RadicalType>(json['radicalType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kanjiId': serializer.toJson<int>(kanjiId),
      'radicalId': serializer.toJson<int>(radicalId),
      'position': serializer.toJson<Position>(position),
      'logicHint': serializer.toJson<LogicHint>(logicHint),
      'radicalType': serializer.toJson<RadicalType>(radicalType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KanjiComponentEntry copyWith({
    int? id,
    int? kanjiId,
    int? radicalId,
    Position? position,
    LogicHint? logicHint,
    RadicalType? radicalType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KanjiComponentEntry(
    id: id ?? this.id,
    kanjiId: kanjiId ?? this.kanjiId,
    radicalId: radicalId ?? this.radicalId,
    position: position ?? this.position,
    logicHint: logicHint ?? this.logicHint,
    radicalType: radicalType ?? this.radicalType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KanjiComponentEntry copyWithCompanion(KanjiComponentEntriesCompanion data) {
    return KanjiComponentEntry(
      id: data.id.present ? data.id.value : this.id,
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      radicalId: data.radicalId.present ? data.radicalId.value : this.radicalId,
      position: data.position.present ? data.position.value : this.position,
      logicHint: data.logicHint.present ? data.logicHint.value : this.logicHint,
      radicalType: data.radicalType.present
          ? data.radicalType.value
          : this.radicalType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiComponentEntry(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('radicalId: $radicalId, ')
          ..write('position: $position, ')
          ..write('logicHint: $logicHint, ')
          ..write('radicalType: $radicalType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kanjiId,
    radicalId,
    position,
    logicHint,
    radicalType,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiComponentEntry &&
          other.id == this.id &&
          other.kanjiId == this.kanjiId &&
          other.radicalId == this.radicalId &&
          other.position == this.position &&
          other.logicHint == this.logicHint &&
          other.radicalType == this.radicalType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KanjiComponentEntriesCompanion
    extends UpdateCompanion<KanjiComponentEntry> {
  final Value<int> id;
  final Value<int> kanjiId;
  final Value<int> radicalId;
  final Value<Position> position;
  final Value<LogicHint> logicHint;
  final Value<RadicalType> radicalType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KanjiComponentEntriesCompanion({
    this.id = const Value.absent(),
    this.kanjiId = const Value.absent(),
    this.radicalId = const Value.absent(),
    this.position = const Value.absent(),
    this.logicHint = const Value.absent(),
    this.radicalType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KanjiComponentEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int kanjiId,
    required int radicalId,
    required Position position,
    required LogicHint logicHint,
    required RadicalType radicalType,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : kanjiId = Value(kanjiId),
       radicalId = Value(radicalId),
       position = Value(position),
       logicHint = Value(logicHint),
       radicalType = Value(radicalType);
  static Insertable<KanjiComponentEntry> custom({
    Expression<int>? id,
    Expression<int>? kanjiId,
    Expression<int>? radicalId,
    Expression<String>? position,
    Expression<String>? logicHint,
    Expression<String>? radicalType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (radicalId != null) 'radical_id': radicalId,
      if (position != null) 'position': position,
      if (logicHint != null) 'logic_hint': logicHint,
      if (radicalType != null) 'radical_type': radicalType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KanjiComponentEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? kanjiId,
    Value<int>? radicalId,
    Value<Position>? position,
    Value<LogicHint>? logicHint,
    Value<RadicalType>? radicalType,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KanjiComponentEntriesCompanion(
      id: id ?? this.id,
      kanjiId: kanjiId ?? this.kanjiId,
      radicalId: radicalId ?? this.radicalId,
      position: position ?? this.position,
      logicHint: logicHint ?? this.logicHint,
      radicalType: radicalType ?? this.radicalType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    if (radicalId.present) {
      map['radical_id'] = Variable<int>(radicalId.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(
        $KanjiComponentEntriesTable.$converterposition.toSql(position.value),
      );
    }
    if (logicHint.present) {
      map['logic_hint'] = Variable<String>(
        $KanjiComponentEntriesTable.$converterlogicHint.toSql(logicHint.value),
      );
    }
    if (radicalType.present) {
      map['radical_type'] = Variable<String>(
        $KanjiComponentEntriesTable.$converterradicalType.toSql(
          radicalType.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiComponentEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('radicalId: $radicalId, ')
          ..write('position: $position, ')
          ..write('logicHint: $logicHint, ')
          ..write('radicalType: $radicalType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VocabularyEntriesTable extends VocabularyEntries
    with TableInfo<$VocabularyEntriesTable, VocabularyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<VocabularySegment>, String>
  segments =
      GeneratedColumn<String>(
        'segments',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<VocabularySegment>>(
        $VocabularyEntriesTable.$convertersegments,
      );
  static const VerificationMeta _minJlptLevelMeta = const VerificationMeta(
    'minJlptLevel',
  );
  @override
  late final GeneratedColumn<int> minJlptLevel = GeneratedColumn<int>(
    'min_jlpt_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyRankMeta = const VerificationMeta(
    'frequencyRank',
  );
  @override
  late final GeneratedColumn<int> frequencyRank = GeneratedColumn<int>(
    'frequency_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (frequency_rank > 0)',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    word,
    segments,
    minJlptLevel,
    frequencyRank,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('min_jlpt_level')) {
      context.handle(
        _minJlptLevelMeta,
        minJlptLevel.isAcceptableOrUnknown(
          data['min_jlpt_level']!,
          _minJlptLevelMeta,
        ),
      );
    }
    if (data.containsKey('frequency_rank')) {
      context.handle(
        _frequencyRankMeta,
        frequencyRank.isAcceptableOrUnknown(
          data['frequency_rank']!,
          _frequencyRankMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyRankMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      segments: $VocabularyEntriesTable.$convertersegments.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}segments'],
        )!,
      ),
      minJlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_jlpt_level'],
      ),
      frequencyRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_rank'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VocabularyEntriesTable createAlias(String alias) {
    return $VocabularyEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<VocabularySegment>, String> $convertersegments =
      const VocabularySegmentListConverter();
}

class VocabularyEntry extends DataClass implements Insertable<VocabularyEntry> {
  final int id;
  final String word;
  final List<VocabularySegment> segments;
  final int? minJlptLevel;
  final int frequencyRank;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VocabularyEntry({
    required this.id,
    required this.word,
    required this.segments,
    this.minJlptLevel,
    required this.frequencyRank,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    {
      map['segments'] = Variable<String>(
        $VocabularyEntriesTable.$convertersegments.toSql(segments),
      );
    }
    if (!nullToAbsent || minJlptLevel != null) {
      map['min_jlpt_level'] = Variable<int>(minJlptLevel);
    }
    map['frequency_rank'] = Variable<int>(frequencyRank);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularyEntriesCompanion toCompanion(bool nullToAbsent) {
    return VocabularyEntriesCompanion(
      id: Value(id),
      word: Value(word),
      segments: Value(segments),
      minJlptLevel: minJlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(minJlptLevel),
      frequencyRank: Value(frequencyRank),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyEntry(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      segments: serializer.fromJson<List<VocabularySegment>>(json['segments']),
      minJlptLevel: serializer.fromJson<int?>(json['minJlptLevel']),
      frequencyRank: serializer.fromJson<int>(json['frequencyRank']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'segments': serializer.toJson<List<VocabularySegment>>(segments),
      'minJlptLevel': serializer.toJson<int?>(minJlptLevel),
      'frequencyRank': serializer.toJson<int>(frequencyRank),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularyEntry copyWith({
    int? id,
    String? word,
    List<VocabularySegment>? segments,
    Value<int?> minJlptLevel = const Value.absent(),
    int? frequencyRank,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VocabularyEntry(
    id: id ?? this.id,
    word: word ?? this.word,
    segments: segments ?? this.segments,
    minJlptLevel: minJlptLevel.present ? minJlptLevel.value : this.minJlptLevel,
    frequencyRank: frequencyRank ?? this.frequencyRank,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VocabularyEntry copyWithCompanion(VocabularyEntriesCompanion data) {
    return VocabularyEntry(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      segments: data.segments.present ? data.segments.value : this.segments,
      minJlptLevel: data.minJlptLevel.present
          ? data.minJlptLevel.value
          : this.minJlptLevel,
      frequencyRank: data.frequencyRank.present
          ? data.frequencyRank.value
          : this.frequencyRank,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyEntry(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('segments: $segments, ')
          ..write('minJlptLevel: $minJlptLevel, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    word,
    segments,
    minJlptLevel,
    frequencyRank,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyEntry &&
          other.id == this.id &&
          other.word == this.word &&
          other.segments == this.segments &&
          other.minJlptLevel == this.minJlptLevel &&
          other.frequencyRank == this.frequencyRank &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VocabularyEntriesCompanion extends UpdateCompanion<VocabularyEntry> {
  final Value<int> id;
  final Value<String> word;
  final Value<List<VocabularySegment>> segments;
  final Value<int?> minJlptLevel;
  final Value<int> frequencyRank;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VocabularyEntriesCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.segments = const Value.absent(),
    this.minJlptLevel = const Value.absent(),
    this.frequencyRank = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VocabularyEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    required List<VocabularySegment> segments,
    this.minJlptLevel = const Value.absent(),
    required int frequencyRank,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : word = Value(word),
       segments = Value(segments),
       frequencyRank = Value(frequencyRank);
  static Insertable<VocabularyEntry> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<String>? segments,
    Expression<int>? minJlptLevel,
    Expression<int>? frequencyRank,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (segments != null) 'segments': segments,
      if (minJlptLevel != null) 'min_jlpt_level': minJlptLevel,
      if (frequencyRank != null) 'frequency_rank': frequencyRank,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VocabularyEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? word,
    Value<List<VocabularySegment>>? segments,
    Value<int?>? minJlptLevel,
    Value<int>? frequencyRank,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VocabularyEntriesCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      segments: segments ?? this.segments,
      minJlptLevel: minJlptLevel ?? this.minJlptLevel,
      frequencyRank: frequencyRank ?? this.frequencyRank,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (segments.present) {
      map['segments'] = Variable<String>(
        $VocabularyEntriesTable.$convertersegments.toSql(segments.value),
      );
    }
    if (minJlptLevel.present) {
      map['min_jlpt_level'] = Variable<int>(minJlptLevel.value);
    }
    if (frequencyRank.present) {
      map['frequency_rank'] = Variable<int>(frequencyRank.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('segments: $segments, ')
          ..write('minJlptLevel: $minJlptLevel, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VocabularyReadingEntriesTable extends VocabularyReadingEntries
    with TableInfo<$VocabularyReadingEntriesTable, VocabularyReadingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyReadingEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  @override
  late final GeneratedColumn<int> vocabularyId = GeneratedColumn<int>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocabulary_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReadingPriority, String>
  priority =
      GeneratedColumn<String>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReadingPriority>(
        $VocabularyReadingEntriesTable.$converterpriority,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vocabularyId,
    reading,
    priority,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_reading_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyReadingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    } else if (isInserting) {
      context.missing(_readingMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {vocabularyId, reading},
  ];
  @override
  VocabularyReadingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyReadingEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocabulary_id'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      )!,
      priority: $VocabularyReadingEntriesTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}priority'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VocabularyReadingEntriesTable createAlias(String alias) {
    return $VocabularyReadingEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<ReadingPriority, String> $converterpriority =
      const ReadingPriorityConverter();
}

class VocabularyReadingEntry extends DataClass
    implements Insertable<VocabularyReadingEntry> {
  final int id;
  final int vocabularyId;
  final String reading;
  final ReadingPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VocabularyReadingEntry({
    required this.id,
    required this.vocabularyId,
    required this.reading,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocabulary_id'] = Variable<int>(vocabularyId);
    map['reading'] = Variable<String>(reading);
    {
      map['priority'] = Variable<String>(
        $VocabularyReadingEntriesTable.$converterpriority.toSql(priority),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularyReadingEntriesCompanion toCompanion(bool nullToAbsent) {
    return VocabularyReadingEntriesCompanion(
      id: Value(id),
      vocabularyId: Value(vocabularyId),
      reading: Value(reading),
      priority: Value(priority),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularyReadingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyReadingEntry(
      id: serializer.fromJson<int>(json['id']),
      vocabularyId: serializer.fromJson<int>(json['vocabularyId']),
      reading: serializer.fromJson<String>(json['reading']),
      priority: serializer.fromJson<ReadingPriority>(json['priority']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabularyId': serializer.toJson<int>(vocabularyId),
      'reading': serializer.toJson<String>(reading),
      'priority': serializer.toJson<ReadingPriority>(priority),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularyReadingEntry copyWith({
    int? id,
    int? vocabularyId,
    String? reading,
    ReadingPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VocabularyReadingEntry(
    id: id ?? this.id,
    vocabularyId: vocabularyId ?? this.vocabularyId,
    reading: reading ?? this.reading,
    priority: priority ?? this.priority,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VocabularyReadingEntry copyWithCompanion(
    VocabularyReadingEntriesCompanion data,
  ) {
    return VocabularyReadingEntry(
      id: data.id.present ? data.id.value : this.id,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      reading: data.reading.present ? data.reading.value : this.reading,
      priority: data.priority.present ? data.priority.value : this.priority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyReadingEntry(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('reading: $reading, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vocabularyId, reading, priority, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyReadingEntry &&
          other.id == this.id &&
          other.vocabularyId == this.vocabularyId &&
          other.reading == this.reading &&
          other.priority == this.priority &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VocabularyReadingEntriesCompanion
    extends UpdateCompanion<VocabularyReadingEntry> {
  final Value<int> id;
  final Value<int> vocabularyId;
  final Value<String> reading;
  final Value<ReadingPriority> priority;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VocabularyReadingEntriesCompanion({
    this.id = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.reading = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VocabularyReadingEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int vocabularyId,
    required String reading,
    required ReadingPriority priority,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : vocabularyId = Value(vocabularyId),
       reading = Value(reading),
       priority = Value(priority);
  static Insertable<VocabularyReadingEntry> custom({
    Expression<int>? id,
    Expression<int>? vocabularyId,
    Expression<String>? reading,
    Expression<String>? priority,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (reading != null) 'reading': reading,
      if (priority != null) 'priority': priority,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VocabularyReadingEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? vocabularyId,
    Value<String>? reading,
    Value<ReadingPriority>? priority,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VocabularyReadingEntriesCompanion(
      id: id ?? this.id,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      reading: reading ?? this.reading,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<int>(vocabularyId.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(
        $VocabularyReadingEntriesTable.$converterpriority.toSql(priority.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyReadingEntriesCompanion(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('reading: $reading, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VocabularyI18nEntriesTable extends VocabularyI18nEntries
    with TableInfo<$VocabularyI18nEntriesTable, VocabularyI18nEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyI18nEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  @override
  late final GeneratedColumn<int> vocabularyId = GeneratedColumn<int>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocabulary_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _langCodeMeta = const VerificationMeta(
    'langCode',
  );
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
    'lang_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> meanings =
      GeneratedColumn<String>(
        'meanings',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $VocabularyI18nEntriesTable.$convertermeanings,
      );
  static const VerificationMeta _systemMnemonicMeta = const VerificationMeta(
    'systemMnemonic',
  );
  @override
  late final GeneratedColumn<String> systemMnemonic = GeneratedColumn<String>(
    'system_mnemonic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> searchTags =
      GeneratedColumn<String>(
        'search_tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $VocabularyI18nEntriesTable.$convertersearchTags,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vocabularyId,
    langCode,
    meanings,
    systemMnemonic,
    searchTags,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_i18n_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyI18nEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('lang_code')) {
      context.handle(
        _langCodeMeta,
        langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('system_mnemonic')) {
      context.handle(
        _systemMnemonicMeta,
        systemMnemonic.isAcceptableOrUnknown(
          data['system_mnemonic']!,
          _systemMnemonicMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {vocabularyId, langCode},
  ];
  @override
  VocabularyI18nEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyI18nEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocabulary_id'],
      )!,
      langCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang_code'],
      )!,
      meanings: $VocabularyI18nEntriesTable.$convertermeanings.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}meanings'],
        )!,
      ),
      systemMnemonic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_mnemonic'],
      ),
      searchTags: $VocabularyI18nEntriesTable.$convertersearchTags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}search_tags'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VocabularyI18nEntriesTable createAlias(String alias) {
    return $VocabularyI18nEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertermeanings =
      const NonNullableStringListConverter();
  static TypeConverter<List<String>, String> $convertersearchTags =
      const NonNullableStringListConverter();
}

class VocabularyI18nEntry extends DataClass
    implements Insertable<VocabularyI18nEntry> {
  final int id;
  final int vocabularyId;
  final String langCode;
  final List<String> meanings;
  final String? systemMnemonic;
  final List<String> searchTags;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VocabularyI18nEntry({
    required this.id,
    required this.vocabularyId,
    required this.langCode,
    required this.meanings,
    this.systemMnemonic,
    required this.searchTags,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocabulary_id'] = Variable<int>(vocabularyId);
    map['lang_code'] = Variable<String>(langCode);
    {
      map['meanings'] = Variable<String>(
        $VocabularyI18nEntriesTable.$convertermeanings.toSql(meanings),
      );
    }
    if (!nullToAbsent || systemMnemonic != null) {
      map['system_mnemonic'] = Variable<String>(systemMnemonic);
    }
    {
      map['search_tags'] = Variable<String>(
        $VocabularyI18nEntriesTable.$convertersearchTags.toSql(searchTags),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularyI18nEntriesCompanion toCompanion(bool nullToAbsent) {
    return VocabularyI18nEntriesCompanion(
      id: Value(id),
      vocabularyId: Value(vocabularyId),
      langCode: Value(langCode),
      meanings: Value(meanings),
      systemMnemonic: systemMnemonic == null && nullToAbsent
          ? const Value.absent()
          : Value(systemMnemonic),
      searchTags: Value(searchTags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularyI18nEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyI18nEntry(
      id: serializer.fromJson<int>(json['id']),
      vocabularyId: serializer.fromJson<int>(json['vocabularyId']),
      langCode: serializer.fromJson<String>(json['langCode']),
      meanings: serializer.fromJson<List<String>>(json['meanings']),
      systemMnemonic: serializer.fromJson<String?>(json['systemMnemonic']),
      searchTags: serializer.fromJson<List<String>>(json['searchTags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabularyId': serializer.toJson<int>(vocabularyId),
      'langCode': serializer.toJson<String>(langCode),
      'meanings': serializer.toJson<List<String>>(meanings),
      'systemMnemonic': serializer.toJson<String?>(systemMnemonic),
      'searchTags': serializer.toJson<List<String>>(searchTags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularyI18nEntry copyWith({
    int? id,
    int? vocabularyId,
    String? langCode,
    List<String>? meanings,
    Value<String?> systemMnemonic = const Value.absent(),
    List<String>? searchTags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VocabularyI18nEntry(
    id: id ?? this.id,
    vocabularyId: vocabularyId ?? this.vocabularyId,
    langCode: langCode ?? this.langCode,
    meanings: meanings ?? this.meanings,
    systemMnemonic: systemMnemonic.present
        ? systemMnemonic.value
        : this.systemMnemonic,
    searchTags: searchTags ?? this.searchTags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VocabularyI18nEntry copyWithCompanion(VocabularyI18nEntriesCompanion data) {
    return VocabularyI18nEntry(
      id: data.id.present ? data.id.value : this.id,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      meanings: data.meanings.present ? data.meanings.value : this.meanings,
      systemMnemonic: data.systemMnemonic.present
          ? data.systemMnemonic.value
          : this.systemMnemonic,
      searchTags: data.searchTags.present
          ? data.searchTags.value
          : this.searchTags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyI18nEntry(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('langCode: $langCode, ')
          ..write('meanings: $meanings, ')
          ..write('systemMnemonic: $systemMnemonic, ')
          ..write('searchTags: $searchTags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vocabularyId,
    langCode,
    meanings,
    systemMnemonic,
    searchTags,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyI18nEntry &&
          other.id == this.id &&
          other.vocabularyId == this.vocabularyId &&
          other.langCode == this.langCode &&
          other.meanings == this.meanings &&
          other.systemMnemonic == this.systemMnemonic &&
          other.searchTags == this.searchTags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VocabularyI18nEntriesCompanion
    extends UpdateCompanion<VocabularyI18nEntry> {
  final Value<int> id;
  final Value<int> vocabularyId;
  final Value<String> langCode;
  final Value<List<String>> meanings;
  final Value<String?> systemMnemonic;
  final Value<List<String>> searchTags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VocabularyI18nEntriesCompanion({
    this.id = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.langCode = const Value.absent(),
    this.meanings = const Value.absent(),
    this.systemMnemonic = const Value.absent(),
    this.searchTags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VocabularyI18nEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int vocabularyId,
    required String langCode,
    required List<String> meanings,
    this.systemMnemonic = const Value.absent(),
    required List<String> searchTags,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : vocabularyId = Value(vocabularyId),
       langCode = Value(langCode),
       meanings = Value(meanings),
       searchTags = Value(searchTags);
  static Insertable<VocabularyI18nEntry> custom({
    Expression<int>? id,
    Expression<int>? vocabularyId,
    Expression<String>? langCode,
    Expression<String>? meanings,
    Expression<String>? systemMnemonic,
    Expression<String>? searchTags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (langCode != null) 'lang_code': langCode,
      if (meanings != null) 'meanings': meanings,
      if (systemMnemonic != null) 'system_mnemonic': systemMnemonic,
      if (searchTags != null) 'search_tags': searchTags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VocabularyI18nEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? vocabularyId,
    Value<String>? langCode,
    Value<List<String>>? meanings,
    Value<String?>? systemMnemonic,
    Value<List<String>>? searchTags,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VocabularyI18nEntriesCompanion(
      id: id ?? this.id,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      langCode: langCode ?? this.langCode,
      meanings: meanings ?? this.meanings,
      systemMnemonic: systemMnemonic ?? this.systemMnemonic,
      searchTags: searchTags ?? this.searchTags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<int>(vocabularyId.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (meanings.present) {
      map['meanings'] = Variable<String>(
        $VocabularyI18nEntriesTable.$convertermeanings.toSql(meanings.value),
      );
    }
    if (systemMnemonic.present) {
      map['system_mnemonic'] = Variable<String>(systemMnemonic.value);
    }
    if (searchTags.present) {
      map['search_tags'] = Variable<String>(
        $VocabularyI18nEntriesTable.$convertersearchTags.toSql(
          searchTags.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyI18nEntriesCompanion(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('langCode: $langCode, ')
          ..write('meanings: $meanings, ')
          ..write('systemMnemonic: $systemMnemonic, ')
          ..write('searchTags: $searchTags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VocabularyKanjiEntriesTable extends VocabularyKanjiEntries
    with TableInfo<$VocabularyKanjiEntriesTable, VocabularyKanjiEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyKanjiEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  @override
  late final GeneratedColumn<int> vocabularyId = GeneratedColumn<int>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocabulary_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kanjiIdMeta = const VerificationMeta(
    'kanjiId',
  );
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
    'kanji_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kanji_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (position >= 0)',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vocabularyId,
    kanjiId,
    position,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_kanji_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyKanjiEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('kanji_id')) {
      context.handle(
        _kanjiIdMeta,
        kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {vocabularyId, position},
  ];
  @override
  VocabularyKanjiEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyKanjiEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocabulary_id'],
      )!,
      kanjiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kanji_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VocabularyKanjiEntriesTable createAlias(String alias) {
    return $VocabularyKanjiEntriesTable(attachedDatabase, alias);
  }
}

class VocabularyKanjiEntry extends DataClass
    implements Insertable<VocabularyKanjiEntry> {
  final int id;
  final int vocabularyId;
  final int kanjiId;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VocabularyKanjiEntry({
    required this.id,
    required this.vocabularyId,
    required this.kanjiId,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocabulary_id'] = Variable<int>(vocabularyId);
    map['kanji_id'] = Variable<int>(kanjiId);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularyKanjiEntriesCompanion toCompanion(bool nullToAbsent) {
    return VocabularyKanjiEntriesCompanion(
      id: Value(id),
      vocabularyId: Value(vocabularyId),
      kanjiId: Value(kanjiId),
      position: Value(position),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularyKanjiEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyKanjiEntry(
      id: serializer.fromJson<int>(json['id']),
      vocabularyId: serializer.fromJson<int>(json['vocabularyId']),
      kanjiId: serializer.fromJson<int>(json['kanjiId']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabularyId': serializer.toJson<int>(vocabularyId),
      'kanjiId': serializer.toJson<int>(kanjiId),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularyKanjiEntry copyWith({
    int? id,
    int? vocabularyId,
    int? kanjiId,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VocabularyKanjiEntry(
    id: id ?? this.id,
    vocabularyId: vocabularyId ?? this.vocabularyId,
    kanjiId: kanjiId ?? this.kanjiId,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VocabularyKanjiEntry copyWithCompanion(VocabularyKanjiEntriesCompanion data) {
    return VocabularyKanjiEntry(
      id: data.id.present ? data.id.value : this.id,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyKanjiEntry(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vocabularyId, kanjiId, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyKanjiEntry &&
          other.id == this.id &&
          other.vocabularyId == this.vocabularyId &&
          other.kanjiId == this.kanjiId &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VocabularyKanjiEntriesCompanion
    extends UpdateCompanion<VocabularyKanjiEntry> {
  final Value<int> id;
  final Value<int> vocabularyId;
  final Value<int> kanjiId;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VocabularyKanjiEntriesCompanion({
    this.id = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.kanjiId = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VocabularyKanjiEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int vocabularyId,
    required int kanjiId,
    required int position,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : vocabularyId = Value(vocabularyId),
       kanjiId = Value(kanjiId),
       position = Value(position);
  static Insertable<VocabularyKanjiEntry> custom({
    Expression<int>? id,
    Expression<int>? vocabularyId,
    Expression<int>? kanjiId,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VocabularyKanjiEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? vocabularyId,
    Value<int>? kanjiId,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VocabularyKanjiEntriesCompanion(
      id: id ?? this.id,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      kanjiId: kanjiId ?? this.kanjiId,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<int>(vocabularyId.value);
    }
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyKanjiEntriesCompanion(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VocabularySentenceEntriesTable extends VocabularySentenceEntries
    with TableInfo<$VocabularySentenceEntriesTable, VocabularySentenceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularySentenceEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  @override
  late final GeneratedColumn<int> vocabularyId = GeneratedColumn<int>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocabulary_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _originalTextMeta = const VerificationMeta(
    'originalText',
  );
  @override
  late final GeneratedColumn<String> originalText = GeneratedColumn<String>(
    'original_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<VerificationStatus, String>
  verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<VerificationStatus>(
        $VocabularySentenceEntriesTable.$converterverificationStatus,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vocabularyId,
    originalText,
    verificationStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_sentence_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularySentenceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('original_text')) {
      context.handle(
        _originalTextMeta,
        originalText.isAcceptableOrUnknown(
          data['original_text']!,
          _originalTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {vocabularyId},
  ];
  @override
  VocabularySentenceEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularySentenceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocabulary_id'],
      )!,
      originalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_text'],
      )!,
      verificationStatus: $VocabularySentenceEntriesTable
          .$converterverificationStatus
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}verification_status'],
            )!,
          ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VocabularySentenceEntriesTable createAlias(String alias) {
    return $VocabularySentenceEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<VerificationStatus, String>
  $converterverificationStatus = const VerificationStatusConverter();
}

class VocabularySentenceEntry extends DataClass
    implements Insertable<VocabularySentenceEntry> {
  final int id;
  final int vocabularyId;
  final String originalText;
  final VerificationStatus verificationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VocabularySentenceEntry({
    required this.id,
    required this.vocabularyId,
    required this.originalText,
    required this.verificationStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocabulary_id'] = Variable<int>(vocabularyId);
    map['original_text'] = Variable<String>(originalText);
    {
      map['verification_status'] = Variable<String>(
        $VocabularySentenceEntriesTable.$converterverificationStatus.toSql(
          verificationStatus,
        ),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularySentenceEntriesCompanion toCompanion(bool nullToAbsent) {
    return VocabularySentenceEntriesCompanion(
      id: Value(id),
      vocabularyId: Value(vocabularyId),
      originalText: Value(originalText),
      verificationStatus: Value(verificationStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularySentenceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularySentenceEntry(
      id: serializer.fromJson<int>(json['id']),
      vocabularyId: serializer.fromJson<int>(json['vocabularyId']),
      originalText: serializer.fromJson<String>(json['originalText']),
      verificationStatus: serializer.fromJson<VerificationStatus>(
        json['verificationStatus'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabularyId': serializer.toJson<int>(vocabularyId),
      'originalText': serializer.toJson<String>(originalText),
      'verificationStatus': serializer.toJson<VerificationStatus>(
        verificationStatus,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularySentenceEntry copyWith({
    int? id,
    int? vocabularyId,
    String? originalText,
    VerificationStatus? verificationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VocabularySentenceEntry(
    id: id ?? this.id,
    vocabularyId: vocabularyId ?? this.vocabularyId,
    originalText: originalText ?? this.originalText,
    verificationStatus: verificationStatus ?? this.verificationStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VocabularySentenceEntry copyWithCompanion(
    VocabularySentenceEntriesCompanion data,
  ) {
    return VocabularySentenceEntry(
      id: data.id.present ? data.id.value : this.id,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      originalText: data.originalText.present
          ? data.originalText.value
          : this.originalText,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularySentenceEntry(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('originalText: $originalText, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vocabularyId,
    originalText,
    verificationStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularySentenceEntry &&
          other.id == this.id &&
          other.vocabularyId == this.vocabularyId &&
          other.originalText == this.originalText &&
          other.verificationStatus == this.verificationStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VocabularySentenceEntriesCompanion
    extends UpdateCompanion<VocabularySentenceEntry> {
  final Value<int> id;
  final Value<int> vocabularyId;
  final Value<String> originalText;
  final Value<VerificationStatus> verificationStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VocabularySentenceEntriesCompanion({
    this.id = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.originalText = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VocabularySentenceEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int vocabularyId,
    required String originalText,
    required VerificationStatus verificationStatus,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : vocabularyId = Value(vocabularyId),
       originalText = Value(originalText),
       verificationStatus = Value(verificationStatus);
  static Insertable<VocabularySentenceEntry> custom({
    Expression<int>? id,
    Expression<int>? vocabularyId,
    Expression<String>? originalText,
    Expression<String>? verificationStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (originalText != null) 'original_text': originalText,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VocabularySentenceEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? vocabularyId,
    Value<String>? originalText,
    Value<VerificationStatus>? verificationStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VocabularySentenceEntriesCompanion(
      id: id ?? this.id,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      originalText: originalText ?? this.originalText,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<int>(vocabularyId.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(
        $VocabularySentenceEntriesTable.$converterverificationStatus.toSql(
          verificationStatus.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularySentenceEntriesCompanion(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('originalText: $originalText, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VocabularySentenceI18nEntriesTable extends VocabularySentenceI18nEntries
    with
        TableInfo<
          $VocabularySentenceI18nEntriesTable,
          VocabularySentenceI18nEntry
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularySentenceI18nEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vocabularySentenceIdMeta =
      const VerificationMeta('vocabularySentenceId');
  @override
  late final GeneratedColumn<int> vocabularySentenceId = GeneratedColumn<int>(
    'vocabulary_sentence_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocabulary_sentence_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _langCodeMeta = const VerificationMeta(
    'langCode',
  );
  @override
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
    'lang_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceTranslatedMeta =
      const VerificationMeta('sentenceTranslated');
  @override
  late final GeneratedColumn<String> sentenceTranslated =
      GeneratedColumn<String>(
        'sentence_translated',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vocabularySentenceId,
    langCode,
    sentenceTranslated,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_sentence_i18n_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularySentenceI18nEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocabulary_sentence_id')) {
      context.handle(
        _vocabularySentenceIdMeta,
        vocabularySentenceId.isAcceptableOrUnknown(
          data['vocabulary_sentence_id']!,
          _vocabularySentenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularySentenceIdMeta);
    }
    if (data.containsKey('lang_code')) {
      context.handle(
        _langCodeMeta,
        langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('sentence_translated')) {
      context.handle(
        _sentenceTranslatedMeta,
        sentenceTranslated.isAcceptableOrUnknown(
          data['sentence_translated']!,
          _sentenceTranslatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sentenceTranslatedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {vocabularySentenceId, langCode},
  ];
  @override
  VocabularySentenceI18nEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularySentenceI18nEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vocabularySentenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocabulary_sentence_id'],
      )!,
      langCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang_code'],
      )!,
      sentenceTranslated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence_translated'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VocabularySentenceI18nEntriesTable createAlias(String alias) {
    return $VocabularySentenceI18nEntriesTable(attachedDatabase, alias);
  }
}

class VocabularySentenceI18nEntry extends DataClass
    implements Insertable<VocabularySentenceI18nEntry> {
  final int id;
  final int vocabularySentenceId;
  final String langCode;
  final String sentenceTranslated;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VocabularySentenceI18nEntry({
    required this.id,
    required this.vocabularySentenceId,
    required this.langCode,
    required this.sentenceTranslated,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocabulary_sentence_id'] = Variable<int>(vocabularySentenceId);
    map['lang_code'] = Variable<String>(langCode);
    map['sentence_translated'] = Variable<String>(sentenceTranslated);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularySentenceI18nEntriesCompanion toCompanion(bool nullToAbsent) {
    return VocabularySentenceI18nEntriesCompanion(
      id: Value(id),
      vocabularySentenceId: Value(vocabularySentenceId),
      langCode: Value(langCode),
      sentenceTranslated: Value(sentenceTranslated),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularySentenceI18nEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularySentenceI18nEntry(
      id: serializer.fromJson<int>(json['id']),
      vocabularySentenceId: serializer.fromJson<int>(
        json['vocabularySentenceId'],
      ),
      langCode: serializer.fromJson<String>(json['langCode']),
      sentenceTranslated: serializer.fromJson<String>(
        json['sentenceTranslated'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabularySentenceId': serializer.toJson<int>(vocabularySentenceId),
      'langCode': serializer.toJson<String>(langCode),
      'sentenceTranslated': serializer.toJson<String>(sentenceTranslated),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularySentenceI18nEntry copyWith({
    int? id,
    int? vocabularySentenceId,
    String? langCode,
    String? sentenceTranslated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VocabularySentenceI18nEntry(
    id: id ?? this.id,
    vocabularySentenceId: vocabularySentenceId ?? this.vocabularySentenceId,
    langCode: langCode ?? this.langCode,
    sentenceTranslated: sentenceTranslated ?? this.sentenceTranslated,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VocabularySentenceI18nEntry copyWithCompanion(
    VocabularySentenceI18nEntriesCompanion data,
  ) {
    return VocabularySentenceI18nEntry(
      id: data.id.present ? data.id.value : this.id,
      vocabularySentenceId: data.vocabularySentenceId.present
          ? data.vocabularySentenceId.value
          : this.vocabularySentenceId,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      sentenceTranslated: data.sentenceTranslated.present
          ? data.sentenceTranslated.value
          : this.sentenceTranslated,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularySentenceI18nEntry(')
          ..write('id: $id, ')
          ..write('vocabularySentenceId: $vocabularySentenceId, ')
          ..write('langCode: $langCode, ')
          ..write('sentenceTranslated: $sentenceTranslated, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vocabularySentenceId,
    langCode,
    sentenceTranslated,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularySentenceI18nEntry &&
          other.id == this.id &&
          other.vocabularySentenceId == this.vocabularySentenceId &&
          other.langCode == this.langCode &&
          other.sentenceTranslated == this.sentenceTranslated &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VocabularySentenceI18nEntriesCompanion
    extends UpdateCompanion<VocabularySentenceI18nEntry> {
  final Value<int> id;
  final Value<int> vocabularySentenceId;
  final Value<String> langCode;
  final Value<String> sentenceTranslated;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VocabularySentenceI18nEntriesCompanion({
    this.id = const Value.absent(),
    this.vocabularySentenceId = const Value.absent(),
    this.langCode = const Value.absent(),
    this.sentenceTranslated = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VocabularySentenceI18nEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int vocabularySentenceId,
    required String langCode,
    required String sentenceTranslated,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : vocabularySentenceId = Value(vocabularySentenceId),
       langCode = Value(langCode),
       sentenceTranslated = Value(sentenceTranslated);
  static Insertable<VocabularySentenceI18nEntry> custom({
    Expression<int>? id,
    Expression<int>? vocabularySentenceId,
    Expression<String>? langCode,
    Expression<String>? sentenceTranslated,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabularySentenceId != null)
        'vocabulary_sentence_id': vocabularySentenceId,
      if (langCode != null) 'lang_code': langCode,
      if (sentenceTranslated != null) 'sentence_translated': sentenceTranslated,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VocabularySentenceI18nEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? vocabularySentenceId,
    Value<String>? langCode,
    Value<String>? sentenceTranslated,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VocabularySentenceI18nEntriesCompanion(
      id: id ?? this.id,
      vocabularySentenceId: vocabularySentenceId ?? this.vocabularySentenceId,
      langCode: langCode ?? this.langCode,
      sentenceTranslated: sentenceTranslated ?? this.sentenceTranslated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabularySentenceId.present) {
      map['vocabulary_sentence_id'] = Variable<int>(vocabularySentenceId.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (sentenceTranslated.present) {
      map['sentence_translated'] = Variable<String>(sentenceTranslated.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularySentenceI18nEntriesCompanion(')
          ..write('id: $id, ')
          ..write('vocabularySentenceId: $vocabularySentenceId, ')
          ..write('langCode: $langCode, ')
          ..write('sentenceTranslated: $sentenceTranslated, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AdminDatabase extends GeneratedDatabase {
  _$AdminDatabase(QueryExecutor e) : super(e);
  late final $DataImportEntriesTable dataImportEntries =
      $DataImportEntriesTable(this);
  late final $RawKanjiVgEntriesTable rawKanjiVgEntries =
      $RawKanjiVgEntriesTable(this);
  late final $RawKanjidicEntriesTable rawKanjidicEntries =
      $RawKanjidicEntriesTable(this);
  late final $RawJmdictEntriesTable rawJmdictEntries = $RawJmdictEntriesTable(
    this,
  );
  late final $KanjiComponentReviewEntriesTable kanjiComponentReviewEntries =
      $KanjiComponentReviewEntriesTable(this);
  late final $SyncMetadataEntriesTable syncMetadataEntries =
      $SyncMetadataEntriesTable(this);
  late final $SourceJlptLevelEntriesTable sourceJlptLevelEntries =
      $SourceJlptLevelEntriesTable(this);
  late final $RadicalEntriesTable radicalEntries = $RadicalEntriesTable(this);
  late final $RadicalI18nEntriesTable radicalI18nEntries =
      $RadicalI18nEntriesTable(this);
  late final $RadicalVariantEntriesTable radicalVariantEntries =
      $RadicalVariantEntriesTable(this);
  late final $KanjiEntriesTable kanjiEntries = $KanjiEntriesTable(this);
  late final $KanjiReadingEntriesTable kanjiReadingEntries =
      $KanjiReadingEntriesTable(this);
  late final $KanjiI18nEntriesTable kanjiI18nEntries = $KanjiI18nEntriesTable(
    this,
  );
  late final $KanjiComponentEntriesTable kanjiComponentEntries =
      $KanjiComponentEntriesTable(this);
  late final $VocabularyEntriesTable vocabularyEntries =
      $VocabularyEntriesTable(this);
  late final $VocabularyReadingEntriesTable vocabularyReadingEntries =
      $VocabularyReadingEntriesTable(this);
  late final $VocabularyI18nEntriesTable vocabularyI18nEntries =
      $VocabularyI18nEntriesTable(this);
  late final $VocabularyKanjiEntriesTable vocabularyKanjiEntries =
      $VocabularyKanjiEntriesTable(this);
  late final $VocabularySentenceEntriesTable vocabularySentenceEntries =
      $VocabularySentenceEntriesTable(this);
  late final $VocabularySentenceI18nEntriesTable vocabularySentenceI18nEntries =
      $VocabularySentenceI18nEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dataImportEntries,
    rawKanjiVgEntries,
    rawKanjidicEntries,
    rawJmdictEntries,
    kanjiComponentReviewEntries,
    syncMetadataEntries,
    sourceJlptLevelEntries,
    radicalEntries,
    radicalI18nEntries,
    radicalVariantEntries,
    kanjiEntries,
    kanjiReadingEntries,
    kanjiI18nEntries,
    kanjiComponentEntries,
    vocabularyEntries,
    vocabularyReadingEntries,
    vocabularyI18nEntries,
    vocabularyKanjiEntries,
    vocabularySentenceEntries,
    vocabularySentenceI18nEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'radical_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('radical_i18n_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'radical_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('radical_variant_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kanji_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('kanji_reading_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kanji_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('kanji_i18n_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kanji_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('kanji_component_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'radical_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('kanji_component_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vocabulary_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('vocabulary_reading_entries', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vocabulary_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vocabulary_i18n_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vocabulary_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('vocabulary_kanji_entries', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kanji_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('vocabulary_kanji_entries', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vocabulary_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('vocabulary_sentence_entries', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vocabulary_sentence_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate(
          'vocabulary_sentence_i18n_entries',
          kind: UpdateKind.delete,
        ),
      ],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
