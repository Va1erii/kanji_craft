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
    requiredDuringInsert: true,
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : importId = Value(importId),
       character = Value(character),
       unicodeHex = Value(unicodeHex),
       viewBox = Value(viewBox),
       strokeCount = Value(strokeCount),
       strokes = Value(strokes),
       components = Value(components),
       createdAt = Value(createdAt);
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
    requiredDuringInsert: true,
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : importId = Value(importId),
       literal = Value(literal),
       strokeCount = Value(strokeCount),
       codepoints = Value(codepoints),
       radicals = Value(radicals),
       readings = Value(readings),
       meanings = Value(meanings),
       createdAt = Value(createdAt);
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
  late final GeneratedColumnWithTypeConverter<List<JmdictKanjiElement>, String>
  kanjiElements =
      GeneratedColumn<String>(
        'kanji_elements',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<JmdictKanjiElement>>(
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
  @override
  List<GeneratedColumn> get $columns => [
    importId,
    entSeq,
    kanjiElements,
    readingElements,
    senses,
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
        )!,
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

  static TypeConverter<List<JmdictKanjiElement>, String>
  $converterkanjiElements = const JmdictKanjiElementsConverter();
  static TypeConverter<List<JmdictReadingElement>, String>
  $converterreadingElements = const JmdictReadingElementsConverter();
  static TypeConverter<List<JmdictSense>, String> $convertersenses =
      const JmdictSensesConverter();
}

class RawJmdictEntry extends DataClass implements Insertable<RawJmdictEntry> {
  final int importId;
  final int entSeq;
  final List<JmdictKanjiElement> kanjiElements;
  final List<JmdictReadingElement> readingElements;
  final List<JmdictSense> senses;
  final DateTime createdAt;
  const RawJmdictEntry({
    required this.importId,
    required this.entSeq,
    required this.kanjiElements,
    required this.readingElements,
    required this.senses,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['import_id'] = Variable<int>(importId);
    map['ent_seq'] = Variable<int>(entSeq);
    {
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
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RawJmdictEntriesCompanion toCompanion(bool nullToAbsent) {
    return RawJmdictEntriesCompanion(
      importId: Value(importId),
      entSeq: Value(entSeq),
      kanjiElements: Value(kanjiElements),
      readingElements: Value(readingElements),
      senses: Value(senses),
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
      kanjiElements: serializer.fromJson<List<JmdictKanjiElement>>(
        json['kanjiElements'],
      ),
      readingElements: serializer.fromJson<List<JmdictReadingElement>>(
        json['readingElements'],
      ),
      senses: serializer.fromJson<List<JmdictSense>>(json['senses']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'importId': serializer.toJson<int>(importId),
      'entSeq': serializer.toJson<int>(entSeq),
      'kanjiElements': serializer.toJson<List<JmdictKanjiElement>>(
        kanjiElements,
      ),
      'readingElements': serializer.toJson<List<JmdictReadingElement>>(
        readingElements,
      ),
      'senses': serializer.toJson<List<JmdictSense>>(senses),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RawJmdictEntry copyWith({
    int? importId,
    int? entSeq,
    List<JmdictKanjiElement>? kanjiElements,
    List<JmdictReadingElement>? readingElements,
    List<JmdictSense>? senses,
    DateTime? createdAt,
  }) => RawJmdictEntry(
    importId: importId ?? this.importId,
    entSeq: entSeq ?? this.entSeq,
    kanjiElements: kanjiElements ?? this.kanjiElements,
    readingElements: readingElements ?? this.readingElements,
    senses: senses ?? this.senses,
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
          other.createdAt == this.createdAt);
}

class RawJmdictEntriesCompanion extends UpdateCompanion<RawJmdictEntry> {
  final Value<int> importId;
  final Value<int> entSeq;
  final Value<List<JmdictKanjiElement>> kanjiElements;
  final Value<List<JmdictReadingElement>> readingElements;
  final Value<List<JmdictSense>> senses;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RawJmdictEntriesCompanion({
    this.importId = const Value.absent(),
    this.entSeq = const Value.absent(),
    this.kanjiElements = const Value.absent(),
    this.readingElements = const Value.absent(),
    this.senses = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RawJmdictEntriesCompanion.insert({
    required int importId,
    required int entSeq,
    required List<JmdictKanjiElement> kanjiElements,
    required List<JmdictReadingElement> readingElements,
    required List<JmdictSense> senses,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : importId = Value(importId),
       entSeq = Value(entSeq),
       kanjiElements = Value(kanjiElements),
       readingElements = Value(readingElements),
       senses = Value(senses),
       createdAt = Value(createdAt);
  static Insertable<RawJmdictEntry> custom({
    Expression<int>? importId,
    Expression<int>? entSeq,
    Expression<String>? kanjiElements,
    Expression<String>? readingElements,
    Expression<String>? senses,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (importId != null) 'import_id': importId,
      if (entSeq != null) 'ent_seq': entSeq,
      if (kanjiElements != null) 'kanji_elements': kanjiElements,
      if (readingElements != null) 'reading_elements': readingElements,
      if (senses != null) 'senses': senses,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RawJmdictEntriesCompanion copyWith({
    Value<int>? importId,
    Value<int>? entSeq,
    Value<List<JmdictKanjiElement>>? kanjiElements,
    Value<List<JmdictReadingElement>>? readingElements,
    Value<List<JmdictSense>>? senses,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RawJmdictEntriesCompanion(
      importId: importId ?? this.importId,
      entSeq: entSeq ?? this.entSeq,
      kanjiElements: kanjiElements ?? this.kanjiElements,
      readingElements: readingElements ?? this.readingElements,
      senses: senses ?? this.senses,
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
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
