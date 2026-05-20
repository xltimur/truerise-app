// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CalculationsTable extends Calculations
    with TableInfo<$CalculationsTable, CalculationEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalculationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthCityMeta = const VerificationMeta(
    'birthCity',
  );
  @override
  late final GeneratedColumn<String> birthCity = GeneratedColumn<String>(
    'birth_city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthLatitudeMeta = const VerificationMeta(
    'birthLatitude',
  );
  @override
  late final GeneratedColumn<double> birthLatitude = GeneratedColumn<double>(
    'birth_latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthLongitudeMeta = const VerificationMeta(
    'birthLongitude',
  );
  @override
  late final GeneratedColumn<double> birthLongitude = GeneratedColumn<double>(
    'birth_longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeWindowModeMeta = const VerificationMeta(
    'timeWindowMode',
  );
  @override
  late final GeneratedColumn<String> timeWindowMode = GeneratedColumn<String>(
    'time_window_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approximateTimeMeta = const VerificationMeta(
    'approximateTime',
  );
  @override
  late final GeneratedColumn<String> approximateTime = GeneratedColumn<String>(
    'approximate_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windowMinutesMeta = const VerificationMeta(
    'windowMinutes',
  );
  @override
  late final GeneratedColumn<int> windowMinutes = GeneratedColumn<int>(
    'window_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _apiCalcIdMeta = const VerificationMeta(
    'apiCalcId',
  );
  @override
  late final GeneratedColumn<String> apiCalcId = GeneratedColumn<String>(
    'api_calc_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawResponseMeta = const VerificationMeta(
    'rawResponse',
  );
  @override
  late final GeneratedColumn<String> rawResponse = GeneratedColumn<String>(
    'raw_response',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
    label,
    status,
    isDemo,
    birthDate,
    birthCity,
    birthLatitude,
    birthLongitude,
    timeWindowMode,
    approximateTime,
    windowMinutes,
    apiCalcId,
    rawResponse,
    method,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calculations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalculationEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    } else if (isInserting) {
      context.missing(_isDemoMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('birth_city')) {
      context.handle(
        _birthCityMeta,
        birthCity.isAcceptableOrUnknown(data['birth_city']!, _birthCityMeta),
      );
    } else if (isInserting) {
      context.missing(_birthCityMeta);
    }
    if (data.containsKey('birth_latitude')) {
      context.handle(
        _birthLatitudeMeta,
        birthLatitude.isAcceptableOrUnknown(
          data['birth_latitude']!,
          _birthLatitudeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_birthLatitudeMeta);
    }
    if (data.containsKey('birth_longitude')) {
      context.handle(
        _birthLongitudeMeta,
        birthLongitude.isAcceptableOrUnknown(
          data['birth_longitude']!,
          _birthLongitudeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_birthLongitudeMeta);
    }
    if (data.containsKey('time_window_mode')) {
      context.handle(
        _timeWindowModeMeta,
        timeWindowMode.isAcceptableOrUnknown(
          data['time_window_mode']!,
          _timeWindowModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeWindowModeMeta);
    }
    if (data.containsKey('approximate_time')) {
      context.handle(
        _approximateTimeMeta,
        approximateTime.isAcceptableOrUnknown(
          data['approximate_time']!,
          _approximateTimeMeta,
        ),
      );
    }
    if (data.containsKey('window_minutes')) {
      context.handle(
        _windowMinutesMeta,
        windowMinutes.isAcceptableOrUnknown(
          data['window_minutes']!,
          _windowMinutesMeta,
        ),
      );
    }
    if (data.containsKey('api_calc_id')) {
      context.handle(
        _apiCalcIdMeta,
        apiCalcId.isAcceptableOrUnknown(data['api_calc_id']!, _apiCalcIdMeta),
      );
    }
    if (data.containsKey('raw_response')) {
      context.handle(
        _rawResponseMeta,
        rawResponse.isAcceptableOrUnknown(
          data['raw_response']!,
          _rawResponseMeta,
        ),
      );
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
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
  CalculationEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalculationEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      birthCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_city'],
      )!,
      birthLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_latitude'],
      )!,
      birthLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_longitude'],
      )!,
      timeWindowMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_window_mode'],
      )!,
      approximateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approximate_time'],
      ),
      windowMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}window_minutes'],
      ),
      apiCalcId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_calc_id'],
      ),
      rawResponse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_response'],
      ),
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
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
  $CalculationsTable createAlias(String alias) {
    return $CalculationsTable(attachedDatabase, alias);
  }
}

class CalculationEntity extends DataClass
    implements Insertable<CalculationEntity> {
  final String id;
  final String? label;
  final String status;
  final bool isDemo;
  final DateTime birthDate;
  final String birthCity;
  final double birthLatitude;
  final double birthLongitude;
  final String timeWindowMode;
  final String? approximateTime;
  final int? windowMinutes;
  final String? apiCalcId;
  final String? rawResponse;
  final String? method;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CalculationEntity({
    required this.id,
    this.label,
    required this.status,
    required this.isDemo,
    required this.birthDate,
    required this.birthCity,
    required this.birthLatitude,
    required this.birthLongitude,
    required this.timeWindowMode,
    this.approximateTime,
    this.windowMinutes,
    this.apiCalcId,
    this.rawResponse,
    this.method,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['status'] = Variable<String>(status);
    map['is_demo'] = Variable<bool>(isDemo);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['birth_city'] = Variable<String>(birthCity);
    map['birth_latitude'] = Variable<double>(birthLatitude);
    map['birth_longitude'] = Variable<double>(birthLongitude);
    map['time_window_mode'] = Variable<String>(timeWindowMode);
    if (!nullToAbsent || approximateTime != null) {
      map['approximate_time'] = Variable<String>(approximateTime);
    }
    if (!nullToAbsent || windowMinutes != null) {
      map['window_minutes'] = Variable<int>(windowMinutes);
    }
    if (!nullToAbsent || apiCalcId != null) {
      map['api_calc_id'] = Variable<String>(apiCalcId);
    }
    if (!nullToAbsent || rawResponse != null) {
      map['raw_response'] = Variable<String>(rawResponse);
    }
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CalculationsCompanion toCompanion(bool nullToAbsent) {
    return CalculationsCompanion(
      id: Value(id),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      status: Value(status),
      isDemo: Value(isDemo),
      birthDate: Value(birthDate),
      birthCity: Value(birthCity),
      birthLatitude: Value(birthLatitude),
      birthLongitude: Value(birthLongitude),
      timeWindowMode: Value(timeWindowMode),
      approximateTime: approximateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(approximateTime),
      windowMinutes: windowMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(windowMinutes),
      apiCalcId: apiCalcId == null && nullToAbsent
          ? const Value.absent()
          : Value(apiCalcId),
      rawResponse: rawResponse == null && nullToAbsent
          ? const Value.absent()
          : Value(rawResponse),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CalculationEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalculationEntity(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String?>(json['label']),
      status: serializer.fromJson<String>(json['status']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      birthCity: serializer.fromJson<String>(json['birthCity']),
      birthLatitude: serializer.fromJson<double>(json['birthLatitude']),
      birthLongitude: serializer.fromJson<double>(json['birthLongitude']),
      timeWindowMode: serializer.fromJson<String>(json['timeWindowMode']),
      approximateTime: serializer.fromJson<String?>(json['approximateTime']),
      windowMinutes: serializer.fromJson<int?>(json['windowMinutes']),
      apiCalcId: serializer.fromJson<String?>(json['apiCalcId']),
      rawResponse: serializer.fromJson<String?>(json['rawResponse']),
      method: serializer.fromJson<String?>(json['method']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String?>(label),
      'status': serializer.toJson<String>(status),
      'isDemo': serializer.toJson<bool>(isDemo),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'birthCity': serializer.toJson<String>(birthCity),
      'birthLatitude': serializer.toJson<double>(birthLatitude),
      'birthLongitude': serializer.toJson<double>(birthLongitude),
      'timeWindowMode': serializer.toJson<String>(timeWindowMode),
      'approximateTime': serializer.toJson<String?>(approximateTime),
      'windowMinutes': serializer.toJson<int?>(windowMinutes),
      'apiCalcId': serializer.toJson<String?>(apiCalcId),
      'rawResponse': serializer.toJson<String?>(rawResponse),
      'method': serializer.toJson<String?>(method),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CalculationEntity copyWith({
    String? id,
    Value<String?> label = const Value.absent(),
    String? status,
    bool? isDemo,
    DateTime? birthDate,
    String? birthCity,
    double? birthLatitude,
    double? birthLongitude,
    String? timeWindowMode,
    Value<String?> approximateTime = const Value.absent(),
    Value<int?> windowMinutes = const Value.absent(),
    Value<String?> apiCalcId = const Value.absent(),
    Value<String?> rawResponse = const Value.absent(),
    Value<String?> method = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CalculationEntity(
    id: id ?? this.id,
    label: label.present ? label.value : this.label,
    status: status ?? this.status,
    isDemo: isDemo ?? this.isDemo,
    birthDate: birthDate ?? this.birthDate,
    birthCity: birthCity ?? this.birthCity,
    birthLatitude: birthLatitude ?? this.birthLatitude,
    birthLongitude: birthLongitude ?? this.birthLongitude,
    timeWindowMode: timeWindowMode ?? this.timeWindowMode,
    approximateTime: approximateTime.present
        ? approximateTime.value
        : this.approximateTime,
    windowMinutes: windowMinutes.present
        ? windowMinutes.value
        : this.windowMinutes,
    apiCalcId: apiCalcId.present ? apiCalcId.value : this.apiCalcId,
    rawResponse: rawResponse.present ? rawResponse.value : this.rawResponse,
    method: method.present ? method.value : this.method,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CalculationEntity copyWithCompanion(CalculationsCompanion data) {
    return CalculationEntity(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      status: data.status.present ? data.status.value : this.status,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      birthCity: data.birthCity.present ? data.birthCity.value : this.birthCity,
      birthLatitude: data.birthLatitude.present
          ? data.birthLatitude.value
          : this.birthLatitude,
      birthLongitude: data.birthLongitude.present
          ? data.birthLongitude.value
          : this.birthLongitude,
      timeWindowMode: data.timeWindowMode.present
          ? data.timeWindowMode.value
          : this.timeWindowMode,
      approximateTime: data.approximateTime.present
          ? data.approximateTime.value
          : this.approximateTime,
      windowMinutes: data.windowMinutes.present
          ? data.windowMinutes.value
          : this.windowMinutes,
      apiCalcId: data.apiCalcId.present ? data.apiCalcId.value : this.apiCalcId,
      rawResponse: data.rawResponse.present
          ? data.rawResponse.value
          : this.rawResponse,
      method: data.method.present ? data.method.value : this.method,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalculationEntity(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('status: $status, ')
          ..write('isDemo: $isDemo, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthCity: $birthCity, ')
          ..write('birthLatitude: $birthLatitude, ')
          ..write('birthLongitude: $birthLongitude, ')
          ..write('timeWindowMode: $timeWindowMode, ')
          ..write('approximateTime: $approximateTime, ')
          ..write('windowMinutes: $windowMinutes, ')
          ..write('apiCalcId: $apiCalcId, ')
          ..write('rawResponse: $rawResponse, ')
          ..write('method: $method, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    status,
    isDemo,
    birthDate,
    birthCity,
    birthLatitude,
    birthLongitude,
    timeWindowMode,
    approximateTime,
    windowMinutes,
    apiCalcId,
    rawResponse,
    method,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalculationEntity &&
          other.id == this.id &&
          other.label == this.label &&
          other.status == this.status &&
          other.isDemo == this.isDemo &&
          other.birthDate == this.birthDate &&
          other.birthCity == this.birthCity &&
          other.birthLatitude == this.birthLatitude &&
          other.birthLongitude == this.birthLongitude &&
          other.timeWindowMode == this.timeWindowMode &&
          other.approximateTime == this.approximateTime &&
          other.windowMinutes == this.windowMinutes &&
          other.apiCalcId == this.apiCalcId &&
          other.rawResponse == this.rawResponse &&
          other.method == this.method &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CalculationsCompanion extends UpdateCompanion<CalculationEntity> {
  final Value<String> id;
  final Value<String?> label;
  final Value<String> status;
  final Value<bool> isDemo;
  final Value<DateTime> birthDate;
  final Value<String> birthCity;
  final Value<double> birthLatitude;
  final Value<double> birthLongitude;
  final Value<String> timeWindowMode;
  final Value<String?> approximateTime;
  final Value<int?> windowMinutes;
  final Value<String?> apiCalcId;
  final Value<String?> rawResponse;
  final Value<String?> method;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CalculationsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.status = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.birthCity = const Value.absent(),
    this.birthLatitude = const Value.absent(),
    this.birthLongitude = const Value.absent(),
    this.timeWindowMode = const Value.absent(),
    this.approximateTime = const Value.absent(),
    this.windowMinutes = const Value.absent(),
    this.apiCalcId = const Value.absent(),
    this.rawResponse = const Value.absent(),
    this.method = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalculationsCompanion.insert({
    required String id,
    this.label = const Value.absent(),
    required String status,
    required bool isDemo,
    required DateTime birthDate,
    required String birthCity,
    required double birthLatitude,
    required double birthLongitude,
    required String timeWindowMode,
    this.approximateTime = const Value.absent(),
    this.windowMinutes = const Value.absent(),
    this.apiCalcId = const Value.absent(),
    this.rawResponse = const Value.absent(),
    this.method = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       isDemo = Value(isDemo),
       birthDate = Value(birthDate),
       birthCity = Value(birthCity),
       birthLatitude = Value(birthLatitude),
       birthLongitude = Value(birthLongitude),
       timeWindowMode = Value(timeWindowMode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CalculationEntity> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? status,
    Expression<bool>? isDemo,
    Expression<DateTime>? birthDate,
    Expression<String>? birthCity,
    Expression<double>? birthLatitude,
    Expression<double>? birthLongitude,
    Expression<String>? timeWindowMode,
    Expression<String>? approximateTime,
    Expression<int>? windowMinutes,
    Expression<String>? apiCalcId,
    Expression<String>? rawResponse,
    Expression<String>? method,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (status != null) 'status': status,
      if (isDemo != null) 'is_demo': isDemo,
      if (birthDate != null) 'birth_date': birthDate,
      if (birthCity != null) 'birth_city': birthCity,
      if (birthLatitude != null) 'birth_latitude': birthLatitude,
      if (birthLongitude != null) 'birth_longitude': birthLongitude,
      if (timeWindowMode != null) 'time_window_mode': timeWindowMode,
      if (approximateTime != null) 'approximate_time': approximateTime,
      if (windowMinutes != null) 'window_minutes': windowMinutes,
      if (apiCalcId != null) 'api_calc_id': apiCalcId,
      if (rawResponse != null) 'raw_response': rawResponse,
      if (method != null) 'method': method,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalculationsCompanion copyWith({
    Value<String>? id,
    Value<String?>? label,
    Value<String>? status,
    Value<bool>? isDemo,
    Value<DateTime>? birthDate,
    Value<String>? birthCity,
    Value<double>? birthLatitude,
    Value<double>? birthLongitude,
    Value<String>? timeWindowMode,
    Value<String?>? approximateTime,
    Value<int?>? windowMinutes,
    Value<String?>? apiCalcId,
    Value<String?>? rawResponse,
    Value<String?>? method,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CalculationsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      status: status ?? this.status,
      isDemo: isDemo ?? this.isDemo,
      birthDate: birthDate ?? this.birthDate,
      birthCity: birthCity ?? this.birthCity,
      birthLatitude: birthLatitude ?? this.birthLatitude,
      birthLongitude: birthLongitude ?? this.birthLongitude,
      timeWindowMode: timeWindowMode ?? this.timeWindowMode,
      approximateTime: approximateTime ?? this.approximateTime,
      windowMinutes: windowMinutes ?? this.windowMinutes,
      apiCalcId: apiCalcId ?? this.apiCalcId,
      rawResponse: rawResponse ?? this.rawResponse,
      method: method ?? this.method,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (birthCity.present) {
      map['birth_city'] = Variable<String>(birthCity.value);
    }
    if (birthLatitude.present) {
      map['birth_latitude'] = Variable<double>(birthLatitude.value);
    }
    if (birthLongitude.present) {
      map['birth_longitude'] = Variable<double>(birthLongitude.value);
    }
    if (timeWindowMode.present) {
      map['time_window_mode'] = Variable<String>(timeWindowMode.value);
    }
    if (approximateTime.present) {
      map['approximate_time'] = Variable<String>(approximateTime.value);
    }
    if (windowMinutes.present) {
      map['window_minutes'] = Variable<int>(windowMinutes.value);
    }
    if (apiCalcId.present) {
      map['api_calc_id'] = Variable<String>(apiCalcId.value);
    }
    if (rawResponse.present) {
      map['raw_response'] = Variable<String>(rawResponse.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalculationsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('status: $status, ')
          ..write('isDemo: $isDemo, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthCity: $birthCity, ')
          ..write('birthLatitude: $birthLatitude, ')
          ..write('birthLongitude: $birthLongitude, ')
          ..write('timeWindowMode: $timeWindowMode, ')
          ..write('approximateTime: $approximateTime, ')
          ..write('windowMinutes: $windowMinutes, ')
          ..write('apiCalcId: $apiCalcId, ')
          ..write('rawResponse: $rawResponse, ')
          ..write('method: $method, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LifeEventRowsTable extends LifeEventRows
    with TableInfo<$LifeEventRowsTable, LifeEventEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LifeEventRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calculationIdMeta = const VerificationMeta(
    'calculationId',
  );
  @override
  late final GeneratedColumn<String> calculationId = GeneratedColumn<String>(
    'calculation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calculations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    calculationId,
    category,
    year,
    month,
    description,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'life_event_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<LifeEventEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('calculation_id')) {
      context.handle(
        _calculationIdMeta,
        calculationId.isAcceptableOrUnknown(
          data['calculation_id']!,
          _calculationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculationIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LifeEventEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LifeEventEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      calculationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calculation_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $LifeEventRowsTable createAlias(String alias) {
    return $LifeEventRowsTable(attachedDatabase, alias);
  }
}

class LifeEventEntity extends DataClass implements Insertable<LifeEventEntity> {
  final String id;
  final String calculationId;
  final String category;
  final int year;
  final int? month;
  final String? description;
  final int sortOrder;
  const LifeEventEntity({
    required this.id,
    required this.calculationId,
    required this.category,
    required this.year,
    this.month,
    this.description,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['calculation_id'] = Variable<String>(calculationId);
    map['category'] = Variable<String>(category);
    map['year'] = Variable<int>(year);
    if (!nullToAbsent || month != null) {
      map['month'] = Variable<int>(month);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  LifeEventRowsCompanion toCompanion(bool nullToAbsent) {
    return LifeEventRowsCompanion(
      id: Value(id),
      calculationId: Value(calculationId),
      category: Value(category),
      year: Value(year),
      month: month == null && nullToAbsent
          ? const Value.absent()
          : Value(month),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
    );
  }

  factory LifeEventEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LifeEventEntity(
      id: serializer.fromJson<String>(json['id']),
      calculationId: serializer.fromJson<String>(json['calculationId']),
      category: serializer.fromJson<String>(json['category']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int?>(json['month']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'calculationId': serializer.toJson<String>(calculationId),
      'category': serializer.toJson<String>(category),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int?>(month),
      'description': serializer.toJson<String?>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LifeEventEntity copyWith({
    String? id,
    String? calculationId,
    String? category,
    int? year,
    Value<int?> month = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? sortOrder,
  }) => LifeEventEntity(
    id: id ?? this.id,
    calculationId: calculationId ?? this.calculationId,
    category: category ?? this.category,
    year: year ?? this.year,
    month: month.present ? month.value : this.month,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  LifeEventEntity copyWithCompanion(LifeEventRowsCompanion data) {
    return LifeEventEntity(
      id: data.id.present ? data.id.value : this.id,
      calculationId: data.calculationId.present
          ? data.calculationId.value
          : this.calculationId,
      category: data.category.present ? data.category.value : this.category,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LifeEventEntity(')
          ..write('id: $id, ')
          ..write('calculationId: $calculationId, ')
          ..write('category: $category, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    calculationId,
    category,
    year,
    month,
    description,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LifeEventEntity &&
          other.id == this.id &&
          other.calculationId == this.calculationId &&
          other.category == this.category &&
          other.year == this.year &&
          other.month == this.month &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder);
}

class LifeEventRowsCompanion extends UpdateCompanion<LifeEventEntity> {
  final Value<String> id;
  final Value<String> calculationId;
  final Value<String> category;
  final Value<int> year;
  final Value<int?> month;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const LifeEventRowsCompanion({
    this.id = const Value.absent(),
    this.calculationId = const Value.absent(),
    this.category = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LifeEventRowsCompanion.insert({
    required String id,
    required String calculationId,
    required String category,
    required int year,
    this.month = const Value.absent(),
    this.description = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       calculationId = Value(calculationId),
       category = Value(category),
       year = Value(year),
       sortOrder = Value(sortOrder);
  static Insertable<LifeEventEntity> custom({
    Expression<String>? id,
    Expression<String>? calculationId,
    Expression<String>? category,
    Expression<int>? year,
    Expression<int>? month,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calculationId != null) 'calculation_id': calculationId,
      if (category != null) 'category': category,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LifeEventRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? calculationId,
    Value<String>? category,
    Value<int>? year,
    Value<int?>? month,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return LifeEventRowsCompanion(
      id: id ?? this.id,
      calculationId: calculationId ?? this.calculationId,
      category: category ?? this.category,
      year: year ?? this.year,
      month: month ?? this.month,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (calculationId.present) {
      map['calculation_id'] = Variable<String>(calculationId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LifeEventRowsCompanion(')
          ..write('id: $id, ')
          ..write('calculationId: $calculationId, ')
          ..write('category: $category, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CandidateResultsTable extends CandidateResults
    with TableInfo<$CandidateResultsTable, CandidateResultEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CandidateResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calculationIdMeta = const VerificationMeta(
    'calculationId',
  );
  @override
  late final GeneratedColumn<String> calculationId = GeneratedColumn<String>(
    'calculation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calculations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthTimeMeta = const VerificationMeta(
    'birthTime',
  );
  @override
  late final GeneratedColumn<String> birthTime = GeneratedColumn<String>(
    'birth_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ascendantMeta = const VerificationMeta(
    'ascendant',
  );
  @override
  late final GeneratedColumn<String> ascendant = GeneratedColumn<String>(
    'ascendant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    calculationId,
    rank,
    birthTime,
    confidence,
    ascendant,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'candidate_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<CandidateResultEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('calculation_id')) {
      context.handle(
        _calculationIdMeta,
        calculationId.isAcceptableOrUnknown(
          data['calculation_id']!,
          _calculationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculationIdMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('birth_time')) {
      context.handle(
        _birthTimeMeta,
        birthTime.isAcceptableOrUnknown(data['birth_time']!, _birthTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_birthTimeMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('ascendant')) {
      context.handle(
        _ascendantMeta,
        ascendant.isAcceptableOrUnknown(data['ascendant']!, _ascendantMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CandidateResultEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CandidateResultEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      calculationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calculation_id'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      birthTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_time'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      ascendant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ascendant'],
      ),
    );
  }

  @override
  $CandidateResultsTable createAlias(String alias) {
    return $CandidateResultsTable(attachedDatabase, alias);
  }
}

class CandidateResultEntity extends DataClass
    implements Insertable<CandidateResultEntity> {
  final String id;
  final String calculationId;
  final int rank;
  final String birthTime;
  final double confidence;
  final String? ascendant;
  const CandidateResultEntity({
    required this.id,
    required this.calculationId,
    required this.rank,
    required this.birthTime,
    required this.confidence,
    this.ascendant,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['calculation_id'] = Variable<String>(calculationId);
    map['rank'] = Variable<int>(rank);
    map['birth_time'] = Variable<String>(birthTime);
    map['confidence'] = Variable<double>(confidence);
    if (!nullToAbsent || ascendant != null) {
      map['ascendant'] = Variable<String>(ascendant);
    }
    return map;
  }

  CandidateResultsCompanion toCompanion(bool nullToAbsent) {
    return CandidateResultsCompanion(
      id: Value(id),
      calculationId: Value(calculationId),
      rank: Value(rank),
      birthTime: Value(birthTime),
      confidence: Value(confidence),
      ascendant: ascendant == null && nullToAbsent
          ? const Value.absent()
          : Value(ascendant),
    );
  }

  factory CandidateResultEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CandidateResultEntity(
      id: serializer.fromJson<String>(json['id']),
      calculationId: serializer.fromJson<String>(json['calculationId']),
      rank: serializer.fromJson<int>(json['rank']),
      birthTime: serializer.fromJson<String>(json['birthTime']),
      confidence: serializer.fromJson<double>(json['confidence']),
      ascendant: serializer.fromJson<String?>(json['ascendant']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'calculationId': serializer.toJson<String>(calculationId),
      'rank': serializer.toJson<int>(rank),
      'birthTime': serializer.toJson<String>(birthTime),
      'confidence': serializer.toJson<double>(confidence),
      'ascendant': serializer.toJson<String?>(ascendant),
    };
  }

  CandidateResultEntity copyWith({
    String? id,
    String? calculationId,
    int? rank,
    String? birthTime,
    double? confidence,
    Value<String?> ascendant = const Value.absent(),
  }) => CandidateResultEntity(
    id: id ?? this.id,
    calculationId: calculationId ?? this.calculationId,
    rank: rank ?? this.rank,
    birthTime: birthTime ?? this.birthTime,
    confidence: confidence ?? this.confidence,
    ascendant: ascendant.present ? ascendant.value : this.ascendant,
  );
  CandidateResultEntity copyWithCompanion(CandidateResultsCompanion data) {
    return CandidateResultEntity(
      id: data.id.present ? data.id.value : this.id,
      calculationId: data.calculationId.present
          ? data.calculationId.value
          : this.calculationId,
      rank: data.rank.present ? data.rank.value : this.rank,
      birthTime: data.birthTime.present ? data.birthTime.value : this.birthTime,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      ascendant: data.ascendant.present ? data.ascendant.value : this.ascendant,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CandidateResultEntity(')
          ..write('id: $id, ')
          ..write('calculationId: $calculationId, ')
          ..write('rank: $rank, ')
          ..write('birthTime: $birthTime, ')
          ..write('confidence: $confidence, ')
          ..write('ascendant: $ascendant')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, calculationId, rank, birthTime, confidence, ascendant);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CandidateResultEntity &&
          other.id == this.id &&
          other.calculationId == this.calculationId &&
          other.rank == this.rank &&
          other.birthTime == this.birthTime &&
          other.confidence == this.confidence &&
          other.ascendant == this.ascendant);
}

class CandidateResultsCompanion extends UpdateCompanion<CandidateResultEntity> {
  final Value<String> id;
  final Value<String> calculationId;
  final Value<int> rank;
  final Value<String> birthTime;
  final Value<double> confidence;
  final Value<String?> ascendant;
  final Value<int> rowid;
  const CandidateResultsCompanion({
    this.id = const Value.absent(),
    this.calculationId = const Value.absent(),
    this.rank = const Value.absent(),
    this.birthTime = const Value.absent(),
    this.confidence = const Value.absent(),
    this.ascendant = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CandidateResultsCompanion.insert({
    required String id,
    required String calculationId,
    required int rank,
    required String birthTime,
    required double confidence,
    this.ascendant = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       calculationId = Value(calculationId),
       rank = Value(rank),
       birthTime = Value(birthTime),
       confidence = Value(confidence);
  static Insertable<CandidateResultEntity> custom({
    Expression<String>? id,
    Expression<String>? calculationId,
    Expression<int>? rank,
    Expression<String>? birthTime,
    Expression<double>? confidence,
    Expression<String>? ascendant,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calculationId != null) 'calculation_id': calculationId,
      if (rank != null) 'rank': rank,
      if (birthTime != null) 'birth_time': birthTime,
      if (confidence != null) 'confidence': confidence,
      if (ascendant != null) 'ascendant': ascendant,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CandidateResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? calculationId,
    Value<int>? rank,
    Value<String>? birthTime,
    Value<double>? confidence,
    Value<String?>? ascendant,
    Value<int>? rowid,
  }) {
    return CandidateResultsCompanion(
      id: id ?? this.id,
      calculationId: calculationId ?? this.calculationId,
      rank: rank ?? this.rank,
      birthTime: birthTime ?? this.birthTime,
      confidence: confidence ?? this.confidence,
      ascendant: ascendant ?? this.ascendant,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (calculationId.present) {
      map['calculation_id'] = Variable<String>(calculationId.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (birthTime.present) {
      map['birth_time'] = Variable<String>(birthTime.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (ascendant.present) {
      map['ascendant'] = Variable<String>(ascendant.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CandidateResultsCompanion(')
          ..write('id: $id, ')
          ..write('calculationId: $calculationId, ')
          ..write('rank: $rank, ')
          ..write('birthTime: $birthTime, ')
          ..write('confidence: $confidence, ')
          ..write('ascendant: $ascendant, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EvidenceRowsTable extends EvidenceRows
    with TableInfo<$EvidenceRowsTable, EvidenceEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calculationIdMeta = const VerificationMeta(
    'calculationId',
  );
  @override
  late final GeneratedColumn<String> calculationId = GeneratedColumn<String>(
    'calculation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calculations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lifeEventIdMeta = const VerificationMeta(
    'lifeEventId',
  );
  @override
  late final GeneratedColumn<String> lifeEventId = GeneratedColumn<String>(
    'life_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES life_event_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _matchStrengthMeta = const VerificationMeta(
    'matchStrength',
  );
  @override
  late final GeneratedColumn<String> matchStrength = GeneratedColumn<String>(
    'match_strength',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    calculationId,
    lifeEventId,
    matchStrength,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidence_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('calculation_id')) {
      context.handle(
        _calculationIdMeta,
        calculationId.isAcceptableOrUnknown(
          data['calculation_id']!,
          _calculationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculationIdMeta);
    }
    if (data.containsKey('life_event_id')) {
      context.handle(
        _lifeEventIdMeta,
        lifeEventId.isAcceptableOrUnknown(
          data['life_event_id']!,
          _lifeEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lifeEventIdMeta);
    }
    if (data.containsKey('match_strength')) {
      context.handle(
        _matchStrengthMeta,
        matchStrength.isAcceptableOrUnknown(
          data['match_strength']!,
          _matchStrengthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_matchStrengthMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EvidenceEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      calculationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calculation_id'],
      )!,
      lifeEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}life_event_id'],
      )!,
      matchStrength: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_strength'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
    );
  }

  @override
  $EvidenceRowsTable createAlias(String alias) {
    return $EvidenceRowsTable(attachedDatabase, alias);
  }
}

class EvidenceEntity extends DataClass implements Insertable<EvidenceEntity> {
  final String id;
  final String calculationId;
  final String lifeEventId;
  final String matchStrength;
  final String explanation;
  const EvidenceEntity({
    required this.id,
    required this.calculationId,
    required this.lifeEventId,
    required this.matchStrength,
    required this.explanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['calculation_id'] = Variable<String>(calculationId);
    map['life_event_id'] = Variable<String>(lifeEventId);
    map['match_strength'] = Variable<String>(matchStrength);
    map['explanation'] = Variable<String>(explanation);
    return map;
  }

  EvidenceRowsCompanion toCompanion(bool nullToAbsent) {
    return EvidenceRowsCompanion(
      id: Value(id),
      calculationId: Value(calculationId),
      lifeEventId: Value(lifeEventId),
      matchStrength: Value(matchStrength),
      explanation: Value(explanation),
    );
  }

  factory EvidenceEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceEntity(
      id: serializer.fromJson<String>(json['id']),
      calculationId: serializer.fromJson<String>(json['calculationId']),
      lifeEventId: serializer.fromJson<String>(json['lifeEventId']),
      matchStrength: serializer.fromJson<String>(json['matchStrength']),
      explanation: serializer.fromJson<String>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'calculationId': serializer.toJson<String>(calculationId),
      'lifeEventId': serializer.toJson<String>(lifeEventId),
      'matchStrength': serializer.toJson<String>(matchStrength),
      'explanation': serializer.toJson<String>(explanation),
    };
  }

  EvidenceEntity copyWith({
    String? id,
    String? calculationId,
    String? lifeEventId,
    String? matchStrength,
    String? explanation,
  }) => EvidenceEntity(
    id: id ?? this.id,
    calculationId: calculationId ?? this.calculationId,
    lifeEventId: lifeEventId ?? this.lifeEventId,
    matchStrength: matchStrength ?? this.matchStrength,
    explanation: explanation ?? this.explanation,
  );
  EvidenceEntity copyWithCompanion(EvidenceRowsCompanion data) {
    return EvidenceEntity(
      id: data.id.present ? data.id.value : this.id,
      calculationId: data.calculationId.present
          ? data.calculationId.value
          : this.calculationId,
      lifeEventId: data.lifeEventId.present
          ? data.lifeEventId.value
          : this.lifeEventId,
      matchStrength: data.matchStrength.present
          ? data.matchStrength.value
          : this.matchStrength,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceEntity(')
          ..write('id: $id, ')
          ..write('calculationId: $calculationId, ')
          ..write('lifeEventId: $lifeEventId, ')
          ..write('matchStrength: $matchStrength, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, calculationId, lifeEventId, matchStrength, explanation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceEntity &&
          other.id == this.id &&
          other.calculationId == this.calculationId &&
          other.lifeEventId == this.lifeEventId &&
          other.matchStrength == this.matchStrength &&
          other.explanation == this.explanation);
}

class EvidenceRowsCompanion extends UpdateCompanion<EvidenceEntity> {
  final Value<String> id;
  final Value<String> calculationId;
  final Value<String> lifeEventId;
  final Value<String> matchStrength;
  final Value<String> explanation;
  final Value<int> rowid;
  const EvidenceRowsCompanion({
    this.id = const Value.absent(),
    this.calculationId = const Value.absent(),
    this.lifeEventId = const Value.absent(),
    this.matchStrength = const Value.absent(),
    this.explanation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidenceRowsCompanion.insert({
    required String id,
    required String calculationId,
    required String lifeEventId,
    required String matchStrength,
    required String explanation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       calculationId = Value(calculationId),
       lifeEventId = Value(lifeEventId),
       matchStrength = Value(matchStrength),
       explanation = Value(explanation);
  static Insertable<EvidenceEntity> custom({
    Expression<String>? id,
    Expression<String>? calculationId,
    Expression<String>? lifeEventId,
    Expression<String>? matchStrength,
    Expression<String>? explanation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calculationId != null) 'calculation_id': calculationId,
      if (lifeEventId != null) 'life_event_id': lifeEventId,
      if (matchStrength != null) 'match_strength': matchStrength,
      if (explanation != null) 'explanation': explanation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidenceRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? calculationId,
    Value<String>? lifeEventId,
    Value<String>? matchStrength,
    Value<String>? explanation,
    Value<int>? rowid,
  }) {
    return EvidenceRowsCompanion(
      id: id ?? this.id,
      calculationId: calculationId ?? this.calculationId,
      lifeEventId: lifeEventId ?? this.lifeEventId,
      matchStrength: matchStrength ?? this.matchStrength,
      explanation: explanation ?? this.explanation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (calculationId.present) {
      map['calculation_id'] = Variable<String>(calculationId.value);
    }
    if (lifeEventId.present) {
      map['life_event_id'] = Variable<String>(lifeEventId.value);
    }
    if (matchStrength.present) {
      map['match_strength'] = Variable<String>(matchStrength.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceRowsCompanion(')
          ..write('id: $id, ')
          ..write('calculationId: $calculationId, ')
          ..write('lifeEventId: $lifeEventId, ')
          ..write('matchStrength: $matchStrength, ')
          ..write('explanation: $explanation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CalculationsTable calculations = $CalculationsTable(this);
  late final $LifeEventRowsTable lifeEventRows = $LifeEventRowsTable(this);
  late final $CandidateResultsTable candidateResults = $CandidateResultsTable(
    this,
  );
  late final $EvidenceRowsTable evidenceRows = $EvidenceRowsTable(this);
  late final CalculationsDao calculationsDao = CalculationsDao(
    this as AppDatabase,
  );
  late final LifeEventsDao lifeEventsDao = LifeEventsDao(this as AppDatabase);
  late final CandidateResultsDao candidateResultsDao = CandidateResultsDao(
    this as AppDatabase,
  );
  late final EvidenceDao evidenceDao = EvidenceDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    calculations,
    lifeEventRows,
    candidateResults,
    evidenceRows,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'calculations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('life_event_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'calculations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('candidate_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'calculations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('evidence_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'life_event_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('evidence_rows', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CalculationsTableCreateCompanionBuilder =
    CalculationsCompanion Function({
      required String id,
      Value<String?> label,
      required String status,
      required bool isDemo,
      required DateTime birthDate,
      required String birthCity,
      required double birthLatitude,
      required double birthLongitude,
      required String timeWindowMode,
      Value<String?> approximateTime,
      Value<int?> windowMinutes,
      Value<String?> apiCalcId,
      Value<String?> rawResponse,
      Value<String?> method,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CalculationsTableUpdateCompanionBuilder =
    CalculationsCompanion Function({
      Value<String> id,
      Value<String?> label,
      Value<String> status,
      Value<bool> isDemo,
      Value<DateTime> birthDate,
      Value<String> birthCity,
      Value<double> birthLatitude,
      Value<double> birthLongitude,
      Value<String> timeWindowMode,
      Value<String?> approximateTime,
      Value<int?> windowMinutes,
      Value<String?> apiCalcId,
      Value<String?> rawResponse,
      Value<String?> method,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CalculationsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CalculationsTable, CalculationEntity> {
  $$CalculationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LifeEventRowsTable, List<LifeEventEntity>>
  _lifeEventRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lifeEventRows,
    aliasName: $_aliasNameGenerator(
      db.calculations.id,
      db.lifeEventRows.calculationId,
    ),
  );

  $$LifeEventRowsTableProcessedTableManager get lifeEventRowsRefs {
    final manager = $$LifeEventRowsTableTableManager(
      $_db,
      $_db.lifeEventRows,
    ).filter((f) => f.calculationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lifeEventRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CandidateResultsTable,
    List<CandidateResultEntity>
  >
  _candidateResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.candidateResults,
    aliasName: $_aliasNameGenerator(
      db.calculations.id,
      db.candidateResults.calculationId,
    ),
  );

  $$CandidateResultsTableProcessedTableManager get candidateResultsRefs {
    final manager = $$CandidateResultsTableTableManager(
      $_db,
      $_db.candidateResults,
    ).filter((f) => f.calculationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _candidateResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EvidenceRowsTable, List<EvidenceEntity>>
  _evidenceRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.evidenceRows,
    aliasName: $_aliasNameGenerator(
      db.calculations.id,
      db.evidenceRows.calculationId,
    ),
  );

  $$EvidenceRowsTableProcessedTableManager get evidenceRowsRefs {
    final manager = $$EvidenceRowsTableTableManager(
      $_db,
      $_db.evidenceRows,
    ).filter((f) => f.calculationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_evidenceRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalculationsTableFilterComposer
    extends Composer<_$AppDatabase, $CalculationsTable> {
  $$CalculationsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthCity => $composableBuilder(
    column: $table.birthCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthLatitude => $composableBuilder(
    column: $table.birthLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthLongitude => $composableBuilder(
    column: $table.birthLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeWindowMode => $composableBuilder(
    column: $table.timeWindowMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approximateTime => $composableBuilder(
    column: $table.approximateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windowMinutes => $composableBuilder(
    column: $table.windowMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiCalcId => $composableBuilder(
    column: $table.apiCalcId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawResponse => $composableBuilder(
    column: $table.rawResponse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lifeEventRowsRefs(
    Expression<bool> Function($$LifeEventRowsTableFilterComposer f) f,
  ) {
    final $$LifeEventRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lifeEventRows,
      getReferencedColumn: (t) => t.calculationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LifeEventRowsTableFilterComposer(
            $db: $db,
            $table: $db.lifeEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> candidateResultsRefs(
    Expression<bool> Function($$CandidateResultsTableFilterComposer f) f,
  ) {
    final $$CandidateResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.candidateResults,
      getReferencedColumn: (t) => t.calculationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CandidateResultsTableFilterComposer(
            $db: $db,
            $table: $db.candidateResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> evidenceRowsRefs(
    Expression<bool> Function($$EvidenceRowsTableFilterComposer f) f,
  ) {
    final $$EvidenceRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evidenceRows,
      getReferencedColumn: (t) => t.calculationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceRowsTableFilterComposer(
            $db: $db,
            $table: $db.evidenceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalculationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalculationsTable> {
  $$CalculationsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthCity => $composableBuilder(
    column: $table.birthCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthLatitude => $composableBuilder(
    column: $table.birthLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthLongitude => $composableBuilder(
    column: $table.birthLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeWindowMode => $composableBuilder(
    column: $table.timeWindowMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approximateTime => $composableBuilder(
    column: $table.approximateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windowMinutes => $composableBuilder(
    column: $table.windowMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiCalcId => $composableBuilder(
    column: $table.apiCalcId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawResponse => $composableBuilder(
    column: $table.rawResponse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalculationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalculationsTable> {
  $$CalculationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get birthCity =>
      $composableBuilder(column: $table.birthCity, builder: (column) => column);

  GeneratedColumn<double> get birthLatitude => $composableBuilder(
    column: $table.birthLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get birthLongitude => $composableBuilder(
    column: $table.birthLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeWindowMode => $composableBuilder(
    column: $table.timeWindowMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approximateTime => $composableBuilder(
    column: $table.approximateTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windowMinutes => $composableBuilder(
    column: $table.windowMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get apiCalcId =>
      $composableBuilder(column: $table.apiCalcId, builder: (column) => column);

  GeneratedColumn<String> get rawResponse => $composableBuilder(
    column: $table.rawResponse,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> lifeEventRowsRefs<T extends Object>(
    Expression<T> Function($$LifeEventRowsTableAnnotationComposer a) f,
  ) {
    final $$LifeEventRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lifeEventRows,
      getReferencedColumn: (t) => t.calculationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LifeEventRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.lifeEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> candidateResultsRefs<T extends Object>(
    Expression<T> Function($$CandidateResultsTableAnnotationComposer a) f,
  ) {
    final $$CandidateResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.candidateResults,
      getReferencedColumn: (t) => t.calculationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CandidateResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.candidateResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> evidenceRowsRefs<T extends Object>(
    Expression<T> Function($$EvidenceRowsTableAnnotationComposer a) f,
  ) {
    final $$EvidenceRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evidenceRows,
      getReferencedColumn: (t) => t.calculationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.evidenceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalculationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalculationsTable,
          CalculationEntity,
          $$CalculationsTableFilterComposer,
          $$CalculationsTableOrderingComposer,
          $$CalculationsTableAnnotationComposer,
          $$CalculationsTableCreateCompanionBuilder,
          $$CalculationsTableUpdateCompanionBuilder,
          (CalculationEntity, $$CalculationsTableReferences),
          CalculationEntity,
          PrefetchHooks Function({
            bool lifeEventRowsRefs,
            bool candidateResultsRefs,
            bool evidenceRowsRefs,
          })
        > {
  $$CalculationsTableTableManager(_$AppDatabase db, $CalculationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalculationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalculationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalculationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<String> birthCity = const Value.absent(),
                Value<double> birthLatitude = const Value.absent(),
                Value<double> birthLongitude = const Value.absent(),
                Value<String> timeWindowMode = const Value.absent(),
                Value<String?> approximateTime = const Value.absent(),
                Value<int?> windowMinutes = const Value.absent(),
                Value<String?> apiCalcId = const Value.absent(),
                Value<String?> rawResponse = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalculationsCompanion(
                id: id,
                label: label,
                status: status,
                isDemo: isDemo,
                birthDate: birthDate,
                birthCity: birthCity,
                birthLatitude: birthLatitude,
                birthLongitude: birthLongitude,
                timeWindowMode: timeWindowMode,
                approximateTime: approximateTime,
                windowMinutes: windowMinutes,
                apiCalcId: apiCalcId,
                rawResponse: rawResponse,
                method: method,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> label = const Value.absent(),
                required String status,
                required bool isDemo,
                required DateTime birthDate,
                required String birthCity,
                required double birthLatitude,
                required double birthLongitude,
                required String timeWindowMode,
                Value<String?> approximateTime = const Value.absent(),
                Value<int?> windowMinutes = const Value.absent(),
                Value<String?> apiCalcId = const Value.absent(),
                Value<String?> rawResponse = const Value.absent(),
                Value<String?> method = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CalculationsCompanion.insert(
                id: id,
                label: label,
                status: status,
                isDemo: isDemo,
                birthDate: birthDate,
                birthCity: birthCity,
                birthLatitude: birthLatitude,
                birthLongitude: birthLongitude,
                timeWindowMode: timeWindowMode,
                approximateTime: approximateTime,
                windowMinutes: windowMinutes,
                apiCalcId: apiCalcId,
                rawResponse: rawResponse,
                method: method,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalculationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                lifeEventRowsRefs = false,
                candidateResultsRefs = false,
                evidenceRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lifeEventRowsRefs) db.lifeEventRows,
                    if (candidateResultsRefs) db.candidateResults,
                    if (evidenceRowsRefs) db.evidenceRows,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lifeEventRowsRefs)
                        await $_getPrefetchedData<
                          CalculationEntity,
                          $CalculationsTable,
                          LifeEventEntity
                        >(
                          currentTable: table,
                          referencedTable: $$CalculationsTableReferences
                              ._lifeEventRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CalculationsTableReferences(
                                db,
                                table,
                                p0,
                              ).lifeEventRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.calculationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (candidateResultsRefs)
                        await $_getPrefetchedData<
                          CalculationEntity,
                          $CalculationsTable,
                          CandidateResultEntity
                        >(
                          currentTable: table,
                          referencedTable: $$CalculationsTableReferences
                              ._candidateResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CalculationsTableReferences(
                                db,
                                table,
                                p0,
                              ).candidateResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.calculationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (evidenceRowsRefs)
                        await $_getPrefetchedData<
                          CalculationEntity,
                          $CalculationsTable,
                          EvidenceEntity
                        >(
                          currentTable: table,
                          referencedTable: $$CalculationsTableReferences
                              ._evidenceRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CalculationsTableReferences(
                                db,
                                table,
                                p0,
                              ).evidenceRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.calculationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CalculationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalculationsTable,
      CalculationEntity,
      $$CalculationsTableFilterComposer,
      $$CalculationsTableOrderingComposer,
      $$CalculationsTableAnnotationComposer,
      $$CalculationsTableCreateCompanionBuilder,
      $$CalculationsTableUpdateCompanionBuilder,
      (CalculationEntity, $$CalculationsTableReferences),
      CalculationEntity,
      PrefetchHooks Function({
        bool lifeEventRowsRefs,
        bool candidateResultsRefs,
        bool evidenceRowsRefs,
      })
    >;
typedef $$LifeEventRowsTableCreateCompanionBuilder =
    LifeEventRowsCompanion Function({
      required String id,
      required String calculationId,
      required String category,
      required int year,
      Value<int?> month,
      Value<String?> description,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$LifeEventRowsTableUpdateCompanionBuilder =
    LifeEventRowsCompanion Function({
      Value<String> id,
      Value<String> calculationId,
      Value<String> category,
      Value<int> year,
      Value<int?> month,
      Value<String?> description,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$LifeEventRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $LifeEventRowsTable, LifeEventEntity> {
  $$LifeEventRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CalculationsTable _calculationIdTable(_$AppDatabase db) =>
      db.calculations.createAlias(
        $_aliasNameGenerator(
          db.lifeEventRows.calculationId,
          db.calculations.id,
        ),
      );

  $$CalculationsTableProcessedTableManager get calculationId {
    final $_column = $_itemColumn<String>('calculation_id')!;

    final manager = $$CalculationsTableTableManager(
      $_db,
      $_db.calculations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calculationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EvidenceRowsTable, List<EvidenceEntity>>
  _evidenceRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.evidenceRows,
    aliasName: $_aliasNameGenerator(
      db.lifeEventRows.id,
      db.evidenceRows.lifeEventId,
    ),
  );

  $$EvidenceRowsTableProcessedTableManager get evidenceRowsRefs {
    final manager = $$EvidenceRowsTableTableManager(
      $_db,
      $_db.evidenceRows,
    ).filter((f) => f.lifeEventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_evidenceRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LifeEventRowsTableFilterComposer
    extends Composer<_$AppDatabase, $LifeEventRowsTable> {
  $$LifeEventRowsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CalculationsTableFilterComposer get calculationId {
    final $$CalculationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableFilterComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> evidenceRowsRefs(
    Expression<bool> Function($$EvidenceRowsTableFilterComposer f) f,
  ) {
    final $$EvidenceRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evidenceRows,
      getReferencedColumn: (t) => t.lifeEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceRowsTableFilterComposer(
            $db: $db,
            $table: $db.evidenceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LifeEventRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $LifeEventRowsTable> {
  $$LifeEventRowsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalculationsTableOrderingComposer get calculationId {
    final $$CalculationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableOrderingComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LifeEventRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LifeEventRowsTable> {
  $$LifeEventRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CalculationsTableAnnotationComposer get calculationId {
    final $$CalculationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableAnnotationComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> evidenceRowsRefs<T extends Object>(
    Expression<T> Function($$EvidenceRowsTableAnnotationComposer a) f,
  ) {
    final $$EvidenceRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evidenceRows,
      getReferencedColumn: (t) => t.lifeEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.evidenceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LifeEventRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LifeEventRowsTable,
          LifeEventEntity,
          $$LifeEventRowsTableFilterComposer,
          $$LifeEventRowsTableOrderingComposer,
          $$LifeEventRowsTableAnnotationComposer,
          $$LifeEventRowsTableCreateCompanionBuilder,
          $$LifeEventRowsTableUpdateCompanionBuilder,
          (LifeEventEntity, $$LifeEventRowsTableReferences),
          LifeEventEntity,
          PrefetchHooks Function({bool calculationId, bool evidenceRowsRefs})
        > {
  $$LifeEventRowsTableTableManager(_$AppDatabase db, $LifeEventRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LifeEventRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LifeEventRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LifeEventRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> calculationId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int?> month = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LifeEventRowsCompanion(
                id: id,
                calculationId: calculationId,
                category: category,
                year: year,
                month: month,
                description: description,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String calculationId,
                required String category,
                required int year,
                Value<int?> month = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => LifeEventRowsCompanion.insert(
                id: id,
                calculationId: calculationId,
                category: category,
                year: year,
                month: month,
                description: description,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LifeEventRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({calculationId = false, evidenceRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (evidenceRowsRefs) db.evidenceRows,
                  ],
                  addJoins:
                      <
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
                        if (calculationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.calculationId,
                                    referencedTable:
                                        $$LifeEventRowsTableReferences
                                            ._calculationIdTable(db),
                                    referencedColumn:
                                        $$LifeEventRowsTableReferences
                                            ._calculationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (evidenceRowsRefs)
                        await $_getPrefetchedData<
                          LifeEventEntity,
                          $LifeEventRowsTable,
                          EvidenceEntity
                        >(
                          currentTable: table,
                          referencedTable: $$LifeEventRowsTableReferences
                              ._evidenceRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LifeEventRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).evidenceRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lifeEventId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LifeEventRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LifeEventRowsTable,
      LifeEventEntity,
      $$LifeEventRowsTableFilterComposer,
      $$LifeEventRowsTableOrderingComposer,
      $$LifeEventRowsTableAnnotationComposer,
      $$LifeEventRowsTableCreateCompanionBuilder,
      $$LifeEventRowsTableUpdateCompanionBuilder,
      (LifeEventEntity, $$LifeEventRowsTableReferences),
      LifeEventEntity,
      PrefetchHooks Function({bool calculationId, bool evidenceRowsRefs})
    >;
typedef $$CandidateResultsTableCreateCompanionBuilder =
    CandidateResultsCompanion Function({
      required String id,
      required String calculationId,
      required int rank,
      required String birthTime,
      required double confidence,
      Value<String?> ascendant,
      Value<int> rowid,
    });
typedef $$CandidateResultsTableUpdateCompanionBuilder =
    CandidateResultsCompanion Function({
      Value<String> id,
      Value<String> calculationId,
      Value<int> rank,
      Value<String> birthTime,
      Value<double> confidence,
      Value<String?> ascendant,
      Value<int> rowid,
    });

final class $$CandidateResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CandidateResultsTable,
          CandidateResultEntity
        > {
  $$CandidateResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CalculationsTable _calculationIdTable(_$AppDatabase db) =>
      db.calculations.createAlias(
        $_aliasNameGenerator(
          db.candidateResults.calculationId,
          db.calculations.id,
        ),
      );

  $$CalculationsTableProcessedTableManager get calculationId {
    final $_column = $_itemColumn<String>('calculation_id')!;

    final manager = $$CalculationsTableTableManager(
      $_db,
      $_db.calculations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calculationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CandidateResultsTableFilterComposer
    extends Composer<_$AppDatabase, $CandidateResultsTable> {
  $$CandidateResultsTableFilterComposer({
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

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthTime => $composableBuilder(
    column: $table.birthTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ascendant => $composableBuilder(
    column: $table.ascendant,
    builder: (column) => ColumnFilters(column),
  );

  $$CalculationsTableFilterComposer get calculationId {
    final $$CalculationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableFilterComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidateResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $CandidateResultsTable> {
  $$CandidateResultsTableOrderingComposer({
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

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthTime => $composableBuilder(
    column: $table.birthTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ascendant => $composableBuilder(
    column: $table.ascendant,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalculationsTableOrderingComposer get calculationId {
    final $$CalculationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableOrderingComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidateResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CandidateResultsTable> {
  $$CandidateResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<String> get birthTime =>
      $composableBuilder(column: $table.birthTime, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ascendant =>
      $composableBuilder(column: $table.ascendant, builder: (column) => column);

  $$CalculationsTableAnnotationComposer get calculationId {
    final $$CalculationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableAnnotationComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidateResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CandidateResultsTable,
          CandidateResultEntity,
          $$CandidateResultsTableFilterComposer,
          $$CandidateResultsTableOrderingComposer,
          $$CandidateResultsTableAnnotationComposer,
          $$CandidateResultsTableCreateCompanionBuilder,
          $$CandidateResultsTableUpdateCompanionBuilder,
          (CandidateResultEntity, $$CandidateResultsTableReferences),
          CandidateResultEntity,
          PrefetchHooks Function({bool calculationId})
        > {
  $$CandidateResultsTableTableManager(
    _$AppDatabase db,
    $CandidateResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CandidateResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CandidateResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CandidateResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> calculationId = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<String> birthTime = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<String?> ascendant = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CandidateResultsCompanion(
                id: id,
                calculationId: calculationId,
                rank: rank,
                birthTime: birthTime,
                confidence: confidence,
                ascendant: ascendant,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String calculationId,
                required int rank,
                required String birthTime,
                required double confidence,
                Value<String?> ascendant = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CandidateResultsCompanion.insert(
                id: id,
                calculationId: calculationId,
                rank: rank,
                birthTime: birthTime,
                confidence: confidence,
                ascendant: ascendant,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CandidateResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({calculationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                    if (calculationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.calculationId,
                                referencedTable:
                                    $$CandidateResultsTableReferences
                                        ._calculationIdTable(db),
                                referencedColumn:
                                    $$CandidateResultsTableReferences
                                        ._calculationIdTable(db)
                                        .id,
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

typedef $$CandidateResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CandidateResultsTable,
      CandidateResultEntity,
      $$CandidateResultsTableFilterComposer,
      $$CandidateResultsTableOrderingComposer,
      $$CandidateResultsTableAnnotationComposer,
      $$CandidateResultsTableCreateCompanionBuilder,
      $$CandidateResultsTableUpdateCompanionBuilder,
      (CandidateResultEntity, $$CandidateResultsTableReferences),
      CandidateResultEntity,
      PrefetchHooks Function({bool calculationId})
    >;
typedef $$EvidenceRowsTableCreateCompanionBuilder =
    EvidenceRowsCompanion Function({
      required String id,
      required String calculationId,
      required String lifeEventId,
      required String matchStrength,
      required String explanation,
      Value<int> rowid,
    });
typedef $$EvidenceRowsTableUpdateCompanionBuilder =
    EvidenceRowsCompanion Function({
      Value<String> id,
      Value<String> calculationId,
      Value<String> lifeEventId,
      Value<String> matchStrength,
      Value<String> explanation,
      Value<int> rowid,
    });

final class $$EvidenceRowsTableReferences
    extends BaseReferences<_$AppDatabase, $EvidenceRowsTable, EvidenceEntity> {
  $$EvidenceRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CalculationsTable _calculationIdTable(_$AppDatabase db) =>
      db.calculations.createAlias(
        $_aliasNameGenerator(db.evidenceRows.calculationId, db.calculations.id),
      );

  $$CalculationsTableProcessedTableManager get calculationId {
    final $_column = $_itemColumn<String>('calculation_id')!;

    final manager = $$CalculationsTableTableManager(
      $_db,
      $_db.calculations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calculationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LifeEventRowsTable _lifeEventIdTable(_$AppDatabase db) =>
      db.lifeEventRows.createAlias(
        $_aliasNameGenerator(db.evidenceRows.lifeEventId, db.lifeEventRows.id),
      );

  $$LifeEventRowsTableProcessedTableManager get lifeEventId {
    final $_column = $_itemColumn<String>('life_event_id')!;

    final manager = $$LifeEventRowsTableTableManager(
      $_db,
      $_db.lifeEventRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lifeEventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EvidenceRowsTableFilterComposer
    extends Composer<_$AppDatabase, $EvidenceRowsTable> {
  $$EvidenceRowsTableFilterComposer({
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

  ColumnFilters<String> get matchStrength => $composableBuilder(
    column: $table.matchStrength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  $$CalculationsTableFilterComposer get calculationId {
    final $$CalculationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableFilterComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LifeEventRowsTableFilterComposer get lifeEventId {
    final $$LifeEventRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lifeEventId,
      referencedTable: $db.lifeEventRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LifeEventRowsTableFilterComposer(
            $db: $db,
            $table: $db.lifeEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $EvidenceRowsTable> {
  $$EvidenceRowsTableOrderingComposer({
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

  ColumnOrderings<String> get matchStrength => $composableBuilder(
    column: $table.matchStrength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalculationsTableOrderingComposer get calculationId {
    final $$CalculationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableOrderingComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LifeEventRowsTableOrderingComposer get lifeEventId {
    final $$LifeEventRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lifeEventId,
      referencedTable: $db.lifeEventRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LifeEventRowsTableOrderingComposer(
            $db: $db,
            $table: $db.lifeEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EvidenceRowsTable> {
  $$EvidenceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get matchStrength => $composableBuilder(
    column: $table.matchStrength,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  $$CalculationsTableAnnotationComposer get calculationId {
    final $$CalculationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableAnnotationComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LifeEventRowsTableAnnotationComposer get lifeEventId {
    final $$LifeEventRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lifeEventId,
      referencedTable: $db.lifeEventRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LifeEventRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.lifeEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EvidenceRowsTable,
          EvidenceEntity,
          $$EvidenceRowsTableFilterComposer,
          $$EvidenceRowsTableOrderingComposer,
          $$EvidenceRowsTableAnnotationComposer,
          $$EvidenceRowsTableCreateCompanionBuilder,
          $$EvidenceRowsTableUpdateCompanionBuilder,
          (EvidenceEntity, $$EvidenceRowsTableReferences),
          EvidenceEntity,
          PrefetchHooks Function({bool calculationId, bool lifeEventId})
        > {
  $$EvidenceRowsTableTableManager(_$AppDatabase db, $EvidenceRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidenceRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> calculationId = const Value.absent(),
                Value<String> lifeEventId = const Value.absent(),
                Value<String> matchStrength = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceRowsCompanion(
                id: id,
                calculationId: calculationId,
                lifeEventId: lifeEventId,
                matchStrength: matchStrength,
                explanation: explanation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String calculationId,
                required String lifeEventId,
                required String matchStrength,
                required String explanation,
                Value<int> rowid = const Value.absent(),
              }) => EvidenceRowsCompanion.insert(
                id: id,
                calculationId: calculationId,
                lifeEventId: lifeEventId,
                matchStrength: matchStrength,
                explanation: explanation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EvidenceRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({calculationId = false, lifeEventId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
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
                        if (calculationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.calculationId,
                                    referencedTable:
                                        $$EvidenceRowsTableReferences
                                            ._calculationIdTable(db),
                                    referencedColumn:
                                        $$EvidenceRowsTableReferences
                                            ._calculationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (lifeEventId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.lifeEventId,
                                    referencedTable:
                                        $$EvidenceRowsTableReferences
                                            ._lifeEventIdTable(db),
                                    referencedColumn:
                                        $$EvidenceRowsTableReferences
                                            ._lifeEventIdTable(db)
                                            .id,
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

typedef $$EvidenceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EvidenceRowsTable,
      EvidenceEntity,
      $$EvidenceRowsTableFilterComposer,
      $$EvidenceRowsTableOrderingComposer,
      $$EvidenceRowsTableAnnotationComposer,
      $$EvidenceRowsTableCreateCompanionBuilder,
      $$EvidenceRowsTableUpdateCompanionBuilder,
      (EvidenceEntity, $$EvidenceRowsTableReferences),
      EvidenceEntity,
      PrefetchHooks Function({bool calculationId, bool lifeEventId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CalculationsTableTableManager get calculations =>
      $$CalculationsTableTableManager(_db, _db.calculations);
  $$LifeEventRowsTableTableManager get lifeEventRows =>
      $$LifeEventRowsTableTableManager(_db, _db.lifeEventRows);
  $$CandidateResultsTableTableManager get candidateResults =>
      $$CandidateResultsTableTableManager(_db, _db.candidateResults);
  $$EvidenceRowsTableTableManager get evidenceRows =>
      $$EvidenceRowsTableTableManager(_db, _db.evidenceRows);
}

mixin _$CalculationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalculationsTable get calculations => attachedDatabase.calculations;
  CalculationsDaoManager get managers => CalculationsDaoManager(this);
}

class CalculationsDaoManager {
  final _$CalculationsDaoMixin _db;
  CalculationsDaoManager(this._db);
  $$CalculationsTableTableManager get calculations =>
      $$CalculationsTableTableManager(_db.attachedDatabase, _db.calculations);
}

mixin _$LifeEventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalculationsTable get calculations => attachedDatabase.calculations;
  $LifeEventRowsTable get lifeEventRows => attachedDatabase.lifeEventRows;
  LifeEventsDaoManager get managers => LifeEventsDaoManager(this);
}

class LifeEventsDaoManager {
  final _$LifeEventsDaoMixin _db;
  LifeEventsDaoManager(this._db);
  $$CalculationsTableTableManager get calculations =>
      $$CalculationsTableTableManager(_db.attachedDatabase, _db.calculations);
  $$LifeEventRowsTableTableManager get lifeEventRows =>
      $$LifeEventRowsTableTableManager(_db.attachedDatabase, _db.lifeEventRows);
}

mixin _$CandidateResultsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalculationsTable get calculations => attachedDatabase.calculations;
  $CandidateResultsTable get candidateResults =>
      attachedDatabase.candidateResults;
  CandidateResultsDaoManager get managers => CandidateResultsDaoManager(this);
}

class CandidateResultsDaoManager {
  final _$CandidateResultsDaoMixin _db;
  CandidateResultsDaoManager(this._db);
  $$CalculationsTableTableManager get calculations =>
      $$CalculationsTableTableManager(_db.attachedDatabase, _db.calculations);
  $$CandidateResultsTableTableManager get candidateResults =>
      $$CandidateResultsTableTableManager(
        _db.attachedDatabase,
        _db.candidateResults,
      );
}

mixin _$EvidenceDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalculationsTable get calculations => attachedDatabase.calculations;
  $LifeEventRowsTable get lifeEventRows => attachedDatabase.lifeEventRows;
  $EvidenceRowsTable get evidenceRows => attachedDatabase.evidenceRows;
  EvidenceDaoManager get managers => EvidenceDaoManager(this);
}

class EvidenceDaoManager {
  final _$EvidenceDaoMixin _db;
  EvidenceDaoManager(this._db);
  $$CalculationsTableTableManager get calculations =>
      $$CalculationsTableTableManager(_db.attachedDatabase, _db.calculations);
  $$LifeEventRowsTableTableManager get lifeEventRows =>
      $$LifeEventRowsTableTableManager(_db.attachedDatabase, _db.lifeEventRows);
  $$EvidenceRowsTableTableManager get evidenceRows =>
      $$EvidenceRowsTableTableManager(_db.attachedDatabase, _db.evidenceRows);
}
