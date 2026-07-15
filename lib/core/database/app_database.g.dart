// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientProfilesTable extends PatientProfiles
    with TableInfo<$PatientProfilesTable, PatientProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _injuryIdMeta =
      const VerificationMeta('injuryId');
  @override
  late final GeneratedColumn<int> injuryId = GeneratedColumn<int>(
      'injury_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _painLevelMeta =
      const VerificationMeta('painLevel');
  @override
  late final GeneratedColumn<int> painLevel = GeneratedColumn<int>(
      'pain_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hasMedicalIndicationMeta =
      const VerificationMeta('hasMedicalIndication');
  @override
  late final GeneratedColumn<bool> hasMedicalIndication = GeneratedColumn<bool>(
      'has_medical_indication', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_medical_indication" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _daysSinceInjuryMeta =
      const VerificationMeta('daysSinceInjury');
  @override
  late final GeneratedColumn<int> daysSinceInjury = GeneratedColumn<int>(
      'days_since_injury', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hadPriorTherapyMeta =
      const VerificationMeta('hadPriorTherapy');
  @override
  late final GeneratedColumn<bool> hadPriorTherapy = GeneratedColumn<bool>(
      'had_prior_therapy', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("had_prior_therapy" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _textScaleFactorMeta =
      const VerificationMeta('textScaleFactor');
  @override
  late final GeneratedColumn<double> textScaleFactor = GeneratedColumn<double>(
      'text_scale_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _currentPhaseMeta =
      const VerificationMeta('currentPhase');
  @override
  late final GeneratedColumn<int> currentPhase = GeneratedColumn<int>(
      'current_phase', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        age,
        weightKg,
        email,
        injuryId,
        painLevel,
        hasMedicalIndication,
        daysSinceInjury,
        hadPriorTherapy,
        textScaleFactor,
        currentPhase,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<PatientProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('injury_id')) {
      context.handle(_injuryIdMeta,
          injuryId.isAcceptableOrUnknown(data['injury_id']!, _injuryIdMeta));
    }
    if (data.containsKey('pain_level')) {
      context.handle(_painLevelMeta,
          painLevel.isAcceptableOrUnknown(data['pain_level']!, _painLevelMeta));
    }
    if (data.containsKey('has_medical_indication')) {
      context.handle(
          _hasMedicalIndicationMeta,
          hasMedicalIndication.isAcceptableOrUnknown(
              data['has_medical_indication']!, _hasMedicalIndicationMeta));
    }
    if (data.containsKey('days_since_injury')) {
      context.handle(
          _daysSinceInjuryMeta,
          daysSinceInjury.isAcceptableOrUnknown(
              data['days_since_injury']!, _daysSinceInjuryMeta));
    }
    if (data.containsKey('had_prior_therapy')) {
      context.handle(
          _hadPriorTherapyMeta,
          hadPriorTherapy.isAcceptableOrUnknown(
              data['had_prior_therapy']!, _hadPriorTherapyMeta));
    }
    if (data.containsKey('text_scale_factor')) {
      context.handle(
          _textScaleFactorMeta,
          textScaleFactor.isAcceptableOrUnknown(
              data['text_scale_factor']!, _textScaleFactorMeta));
    }
    if (data.containsKey('current_phase')) {
      context.handle(
          _currentPhaseMeta,
          currentPhase.isAcceptableOrUnknown(
              data['current_phase']!, _currentPhaseMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      injuryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}injury_id']),
      painLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pain_level'])!,
      hasMedicalIndication: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_medical_indication'])!,
      daysSinceInjury: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days_since_injury'])!,
      hadPriorTherapy: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}had_prior_therapy'])!,
      textScaleFactor: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}text_scale_factor'])!,
      currentPhase: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_phase'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PatientProfilesTable createAlias(String alias) {
    return $PatientProfilesTable(attachedDatabase, alias);
  }
}

class PatientProfile extends DataClass implements Insertable<PatientProfile> {
  final int id;
  final String name;
  final int age;
  final double weightKg;
  final String? email;
  final int? injuryId;
  final int painLevel;
  final bool hasMedicalIndication;
  final int daysSinceInjury;
  final bool hadPriorTherapy;
  final double textScaleFactor;
  final int currentPhase;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PatientProfile(
      {required this.id,
      required this.name,
      required this.age,
      required this.weightKg,
      this.email,
      this.injuryId,
      required this.painLevel,
      required this.hasMedicalIndication,
      required this.daysSinceInjury,
      required this.hadPriorTherapy,
      required this.textScaleFactor,
      required this.currentPhase,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || injuryId != null) {
      map['injury_id'] = Variable<int>(injuryId);
    }
    map['pain_level'] = Variable<int>(painLevel);
    map['has_medical_indication'] = Variable<bool>(hasMedicalIndication);
    map['days_since_injury'] = Variable<int>(daysSinceInjury);
    map['had_prior_therapy'] = Variable<bool>(hadPriorTherapy);
    map['text_scale_factor'] = Variable<double>(textScaleFactor);
    map['current_phase'] = Variable<int>(currentPhase);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PatientProfilesCompanion toCompanion(bool nullToAbsent) {
    return PatientProfilesCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      weightKg: Value(weightKg),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      injuryId: injuryId == null && nullToAbsent
          ? const Value.absent()
          : Value(injuryId),
      painLevel: Value(painLevel),
      hasMedicalIndication: Value(hasMedicalIndication),
      daysSinceInjury: Value(daysSinceInjury),
      hadPriorTherapy: Value(hadPriorTherapy),
      textScaleFactor: Value(textScaleFactor),
      currentPhase: Value(currentPhase),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PatientProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      email: serializer.fromJson<String?>(json['email']),
      injuryId: serializer.fromJson<int?>(json['injuryId']),
      painLevel: serializer.fromJson<int>(json['painLevel']),
      hasMedicalIndication:
          serializer.fromJson<bool>(json['hasMedicalIndication']),
      daysSinceInjury: serializer.fromJson<int>(json['daysSinceInjury']),
      hadPriorTherapy: serializer.fromJson<bool>(json['hadPriorTherapy']),
      textScaleFactor: serializer.fromJson<double>(json['textScaleFactor']),
      currentPhase: serializer.fromJson<int>(json['currentPhase']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'weightKg': serializer.toJson<double>(weightKg),
      'email': serializer.toJson<String?>(email),
      'injuryId': serializer.toJson<int?>(injuryId),
      'painLevel': serializer.toJson<int>(painLevel),
      'hasMedicalIndication': serializer.toJson<bool>(hasMedicalIndication),
      'daysSinceInjury': serializer.toJson<int>(daysSinceInjury),
      'hadPriorTherapy': serializer.toJson<bool>(hadPriorTherapy),
      'textScaleFactor': serializer.toJson<double>(textScaleFactor),
      'currentPhase': serializer.toJson<int>(currentPhase),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PatientProfile copyWith(
          {int? id,
          String? name,
          int? age,
          double? weightKg,
          Value<String?> email = const Value.absent(),
          Value<int?> injuryId = const Value.absent(),
          int? painLevel,
          bool? hasMedicalIndication,
          int? daysSinceInjury,
          bool? hadPriorTherapy,
          double? textScaleFactor,
          int? currentPhase,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PatientProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        weightKg: weightKg ?? this.weightKg,
        email: email.present ? email.value : this.email,
        injuryId: injuryId.present ? injuryId.value : this.injuryId,
        painLevel: painLevel ?? this.painLevel,
        hasMedicalIndication: hasMedicalIndication ?? this.hasMedicalIndication,
        daysSinceInjury: daysSinceInjury ?? this.daysSinceInjury,
        hadPriorTherapy: hadPriorTherapy ?? this.hadPriorTherapy,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        currentPhase: currentPhase ?? this.currentPhase,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PatientProfile copyWithCompanion(PatientProfilesCompanion data) {
    return PatientProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      email: data.email.present ? data.email.value : this.email,
      injuryId: data.injuryId.present ? data.injuryId.value : this.injuryId,
      painLevel: data.painLevel.present ? data.painLevel.value : this.painLevel,
      hasMedicalIndication: data.hasMedicalIndication.present
          ? data.hasMedicalIndication.value
          : this.hasMedicalIndication,
      daysSinceInjury: data.daysSinceInjury.present
          ? data.daysSinceInjury.value
          : this.daysSinceInjury,
      hadPriorTherapy: data.hadPriorTherapy.present
          ? data.hadPriorTherapy.value
          : this.hadPriorTherapy,
      textScaleFactor: data.textScaleFactor.present
          ? data.textScaleFactor.value
          : this.textScaleFactor,
      currentPhase: data.currentPhase.present
          ? data.currentPhase.value
          : this.currentPhase,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('weightKg: $weightKg, ')
          ..write('email: $email, ')
          ..write('injuryId: $injuryId, ')
          ..write('painLevel: $painLevel, ')
          ..write('hasMedicalIndication: $hasMedicalIndication, ')
          ..write('daysSinceInjury: $daysSinceInjury, ')
          ..write('hadPriorTherapy: $hadPriorTherapy, ')
          ..write('textScaleFactor: $textScaleFactor, ')
          ..write('currentPhase: $currentPhase, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      age,
      weightKg,
      email,
      injuryId,
      painLevel,
      hasMedicalIndication,
      daysSinceInjury,
      hadPriorTherapy,
      textScaleFactor,
      currentPhase,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.weightKg == this.weightKg &&
          other.email == this.email &&
          other.injuryId == this.injuryId &&
          other.painLevel == this.painLevel &&
          other.hasMedicalIndication == this.hasMedicalIndication &&
          other.daysSinceInjury == this.daysSinceInjury &&
          other.hadPriorTherapy == this.hadPriorTherapy &&
          other.textScaleFactor == this.textScaleFactor &&
          other.currentPhase == this.currentPhase &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PatientProfilesCompanion extends UpdateCompanion<PatientProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  final Value<double> weightKg;
  final Value<String?> email;
  final Value<int?> injuryId;
  final Value<int> painLevel;
  final Value<bool> hasMedicalIndication;
  final Value<int> daysSinceInjury;
  final Value<bool> hadPriorTherapy;
  final Value<double> textScaleFactor;
  final Value<int> currentPhase;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PatientProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.email = const Value.absent(),
    this.injuryId = const Value.absent(),
    this.painLevel = const Value.absent(),
    this.hasMedicalIndication = const Value.absent(),
    this.daysSinceInjury = const Value.absent(),
    this.hadPriorTherapy = const Value.absent(),
    this.textScaleFactor = const Value.absent(),
    this.currentPhase = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PatientProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int age,
    required double weightKg,
    this.email = const Value.absent(),
    this.injuryId = const Value.absent(),
    this.painLevel = const Value.absent(),
    this.hasMedicalIndication = const Value.absent(),
    this.daysSinceInjury = const Value.absent(),
    this.hadPriorTherapy = const Value.absent(),
    this.textScaleFactor = const Value.absent(),
    this.currentPhase = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        age = Value(age),
        weightKg = Value(weightKg);
  static Insertable<PatientProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<double>? weightKg,
    Expression<String>? email,
    Expression<int>? injuryId,
    Expression<int>? painLevel,
    Expression<bool>? hasMedicalIndication,
    Expression<int>? daysSinceInjury,
    Expression<bool>? hadPriorTherapy,
    Expression<double>? textScaleFactor,
    Expression<int>? currentPhase,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (weightKg != null) 'weight_kg': weightKg,
      if (email != null) 'email': email,
      if (injuryId != null) 'injury_id': injuryId,
      if (painLevel != null) 'pain_level': painLevel,
      if (hasMedicalIndication != null)
        'has_medical_indication': hasMedicalIndication,
      if (daysSinceInjury != null) 'days_since_injury': daysSinceInjury,
      if (hadPriorTherapy != null) 'had_prior_therapy': hadPriorTherapy,
      if (textScaleFactor != null) 'text_scale_factor': textScaleFactor,
      if (currentPhase != null) 'current_phase': currentPhase,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PatientProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? age,
      Value<double>? weightKg,
      Value<String?>? email,
      Value<int?>? injuryId,
      Value<int>? painLevel,
      Value<bool>? hasMedicalIndication,
      Value<int>? daysSinceInjury,
      Value<bool>? hadPriorTherapy,
      Value<double>? textScaleFactor,
      Value<int>? currentPhase,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return PatientProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      email: email ?? this.email,
      injuryId: injuryId ?? this.injuryId,
      painLevel: painLevel ?? this.painLevel,
      hasMedicalIndication: hasMedicalIndication ?? this.hasMedicalIndication,
      daysSinceInjury: daysSinceInjury ?? this.daysSinceInjury,
      hadPriorTherapy: hadPriorTherapy ?? this.hadPriorTherapy,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      currentPhase: currentPhase ?? this.currentPhase,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (injuryId.present) {
      map['injury_id'] = Variable<int>(injuryId.value);
    }
    if (painLevel.present) {
      map['pain_level'] = Variable<int>(painLevel.value);
    }
    if (hasMedicalIndication.present) {
      map['has_medical_indication'] =
          Variable<bool>(hasMedicalIndication.value);
    }
    if (daysSinceInjury.present) {
      map['days_since_injury'] = Variable<int>(daysSinceInjury.value);
    }
    if (hadPriorTherapy.present) {
      map['had_prior_therapy'] = Variable<bool>(hadPriorTherapy.value);
    }
    if (textScaleFactor.present) {
      map['text_scale_factor'] = Variable<double>(textScaleFactor.value);
    }
    if (currentPhase.present) {
      map['current_phase'] = Variable<int>(currentPhase.value);
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
    return (StringBuffer('PatientProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('weightKg: $weightKg, ')
          ..write('email: $email, ')
          ..write('injuryId: $injuryId, ')
          ..write('painLevel: $painLevel, ')
          ..write('hasMedicalIndication: $hasMedicalIndication, ')
          ..write('daysSinceInjury: $daysSinceInjury, ')
          ..write('hadPriorTherapy: $hadPriorTherapy, ')
          ..write('textScaleFactor: $textScaleFactor, ')
          ..write('currentPhase: $currentPhase, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InjuriesTable extends Injuries with TableInfo<$InjuriesTable, Injury> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InjuriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyRegionMeta =
      const VerificationMeta('bodyRegion');
  @override
  late final GeneratedColumn<String> bodyRegion = GeneratedColumn<String>(
      'body_region', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _focusDescriptionMeta =
      const VerificationMeta('focusDescription');
  @override
  late final GeneratedColumn<String> focusDescription = GeneratedColumn<String>(
      'focus_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _redFlagsTextMeta =
      const VerificationMeta('redFlagsText');
  @override
  late final GeneratedColumn<String> redFlagsText = GeneratedColumn<String>(
      'red_flags_text', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(
          'Detén el ejercicio si sientes dolor agudo o punzante superior a 4/10, '
          'inflamación súbita de la articulación o mareos.'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, bodyRegion, focusDescription, redFlagsText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'injuries';
  @override
  VerificationContext validateIntegrity(Insertable<Injury> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('body_region')) {
      context.handle(
          _bodyRegionMeta,
          bodyRegion.isAcceptableOrUnknown(
              data['body_region']!, _bodyRegionMeta));
    } else if (isInserting) {
      context.missing(_bodyRegionMeta);
    }
    if (data.containsKey('focus_description')) {
      context.handle(
          _focusDescriptionMeta,
          focusDescription.isAcceptableOrUnknown(
              data['focus_description']!, _focusDescriptionMeta));
    } else if (isInserting) {
      context.missing(_focusDescriptionMeta);
    }
    if (data.containsKey('red_flags_text')) {
      context.handle(
          _redFlagsTextMeta,
          redFlagsText.isAcceptableOrUnknown(
              data['red_flags_text']!, _redFlagsTextMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Injury map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Injury(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      bodyRegion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body_region'])!,
      focusDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}focus_description'])!,
      redFlagsText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}red_flags_text'])!,
    );
  }

  @override
  $InjuriesTable createAlias(String alias) {
    return $InjuriesTable(attachedDatabase, alias);
  }
}

class Injury extends DataClass implements Insertable<Injury> {
  final int id;
  final String name;
  final String bodyRegion;
  final String focusDescription;
  final String redFlagsText;
  const Injury(
      {required this.id,
      required this.name,
      required this.bodyRegion,
      required this.focusDescription,
      required this.redFlagsText});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['body_region'] = Variable<String>(bodyRegion);
    map['focus_description'] = Variable<String>(focusDescription);
    map['red_flags_text'] = Variable<String>(redFlagsText);
    return map;
  }

  InjuriesCompanion toCompanion(bool nullToAbsent) {
    return InjuriesCompanion(
      id: Value(id),
      name: Value(name),
      bodyRegion: Value(bodyRegion),
      focusDescription: Value(focusDescription),
      redFlagsText: Value(redFlagsText),
    );
  }

  factory Injury.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Injury(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bodyRegion: serializer.fromJson<String>(json['bodyRegion']),
      focusDescription: serializer.fromJson<String>(json['focusDescription']),
      redFlagsText: serializer.fromJson<String>(json['redFlagsText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bodyRegion': serializer.toJson<String>(bodyRegion),
      'focusDescription': serializer.toJson<String>(focusDescription),
      'redFlagsText': serializer.toJson<String>(redFlagsText),
    };
  }

  Injury copyWith(
          {int? id,
          String? name,
          String? bodyRegion,
          String? focusDescription,
          String? redFlagsText}) =>
      Injury(
        id: id ?? this.id,
        name: name ?? this.name,
        bodyRegion: bodyRegion ?? this.bodyRegion,
        focusDescription: focusDescription ?? this.focusDescription,
        redFlagsText: redFlagsText ?? this.redFlagsText,
      );
  Injury copyWithCompanion(InjuriesCompanion data) {
    return Injury(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bodyRegion:
          data.bodyRegion.present ? data.bodyRegion.value : this.bodyRegion,
      focusDescription: data.focusDescription.present
          ? data.focusDescription.value
          : this.focusDescription,
      redFlagsText: data.redFlagsText.present
          ? data.redFlagsText.value
          : this.redFlagsText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Injury(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bodyRegion: $bodyRegion, ')
          ..write('focusDescription: $focusDescription, ')
          ..write('redFlagsText: $redFlagsText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, bodyRegion, focusDescription, redFlagsText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Injury &&
          other.id == this.id &&
          other.name == this.name &&
          other.bodyRegion == this.bodyRegion &&
          other.focusDescription == this.focusDescription &&
          other.redFlagsText == this.redFlagsText);
}

class InjuriesCompanion extends UpdateCompanion<Injury> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> bodyRegion;
  final Value<String> focusDescription;
  final Value<String> redFlagsText;
  const InjuriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bodyRegion = const Value.absent(),
    this.focusDescription = const Value.absent(),
    this.redFlagsText = const Value.absent(),
  });
  InjuriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String bodyRegion,
    required String focusDescription,
    this.redFlagsText = const Value.absent(),
  })  : name = Value(name),
        bodyRegion = Value(bodyRegion),
        focusDescription = Value(focusDescription);
  static Insertable<Injury> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bodyRegion,
    Expression<String>? focusDescription,
    Expression<String>? redFlagsText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bodyRegion != null) 'body_region': bodyRegion,
      if (focusDescription != null) 'focus_description': focusDescription,
      if (redFlagsText != null) 'red_flags_text': redFlagsText,
    });
  }

  InjuriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? bodyRegion,
      Value<String>? focusDescription,
      Value<String>? redFlagsText}) {
    return InjuriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      focusDescription: focusDescription ?? this.focusDescription,
      redFlagsText: redFlagsText ?? this.redFlagsText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bodyRegion.present) {
      map['body_region'] = Variable<String>(bodyRegion.value);
    }
    if (focusDescription.present) {
      map['focus_description'] = Variable<String>(focusDescription.value);
    }
    if (redFlagsText.present) {
      map['red_flags_text'] = Variable<String>(redFlagsText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InjuriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bodyRegion: $bodyRegion, ')
          ..write('focusDescription: $focusDescription, ')
          ..write('redFlagsText: $redFlagsText')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _injuryIdMeta =
      const VerificationMeta('injuryId');
  @override
  late final GeneratedColumn<int> injuryId = GeneratedColumn<int>(
      'injury_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<int> phase = GeneratedColumn<int>(
      'phase', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dosageTypeMeta =
      const VerificationMeta('dosageType');
  @override
  late final GeneratedColumn<String> dosageType = GeneratedColumn<String>(
      'dosage_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
      'sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _holdSecondsMeta =
      const VerificationMeta('holdSeconds');
  @override
  late final GeneratedColumn<int> holdSeconds = GeneratedColumn<int>(
      'hold_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _imageAssetMeta =
      const VerificationMeta('imageAsset');
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
      'image_asset', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usesCameraTrackingMeta =
      const VerificationMeta('usesCameraTracking');
  @override
  late final GeneratedColumn<bool> usesCameraTracking = GeneratedColumn<bool>(
      'uses_camera_tracking', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("uses_camera_tracking" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        injuryId,
        phase,
        orderIndex,
        name,
        instructions,
        dosageType,
        sets,
        reps,
        holdSeconds,
        imageAsset,
        usesCameraTracking
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('injury_id')) {
      context.handle(_injuryIdMeta,
          injuryId.isAcceptableOrUnknown(data['injury_id']!, _injuryIdMeta));
    } else if (isInserting) {
      context.missing(_injuryIdMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
          _phaseMeta, phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta));
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('dosage_type')) {
      context.handle(
          _dosageTypeMeta,
          dosageType.isAcceptableOrUnknown(
              data['dosage_type']!, _dosageTypeMeta));
    } else if (isInserting) {
      context.missing(_dosageTypeMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
          _setsMeta, sets.isAcceptableOrUnknown(data['sets']!, _setsMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('hold_seconds')) {
      context.handle(
          _holdSecondsMeta,
          holdSeconds.isAcceptableOrUnknown(
              data['hold_seconds']!, _holdSecondsMeta));
    }
    if (data.containsKey('image_asset')) {
      context.handle(
          _imageAssetMeta,
          imageAsset.isAcceptableOrUnknown(
              data['image_asset']!, _imageAssetMeta));
    }
    if (data.containsKey('uses_camera_tracking')) {
      context.handle(
          _usesCameraTrackingMeta,
          usesCameraTracking.isAcceptableOrUnknown(
              data['uses_camera_tracking']!, _usesCameraTrackingMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      injuryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}injury_id'])!,
      phase: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}phase'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions'])!,
      dosageType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage_type'])!,
      sets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sets']),
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps']),
      holdSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hold_seconds']),
      imageAsset: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_asset']),
      usesCameraTracking: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}uses_camera_tracking'])!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final int injuryId;
  final int phase;
  final int orderIndex;
  final String name;
  final String instructions;
  final String dosageType;
  final int? sets;
  final int? reps;
  final int? holdSeconds;
  final String? imageAsset;
  final bool usesCameraTracking;
  const Exercise(
      {required this.id,
      required this.injuryId,
      required this.phase,
      required this.orderIndex,
      required this.name,
      required this.instructions,
      required this.dosageType,
      this.sets,
      this.reps,
      this.holdSeconds,
      this.imageAsset,
      required this.usesCameraTracking});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['injury_id'] = Variable<int>(injuryId);
    map['phase'] = Variable<int>(phase);
    map['order_index'] = Variable<int>(orderIndex);
    map['name'] = Variable<String>(name);
    map['instructions'] = Variable<String>(instructions);
    map['dosage_type'] = Variable<String>(dosageType);
    if (!nullToAbsent || sets != null) {
      map['sets'] = Variable<int>(sets);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || holdSeconds != null) {
      map['hold_seconds'] = Variable<int>(holdSeconds);
    }
    if (!nullToAbsent || imageAsset != null) {
      map['image_asset'] = Variable<String>(imageAsset);
    }
    map['uses_camera_tracking'] = Variable<bool>(usesCameraTracking);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      injuryId: Value(injuryId),
      phase: Value(phase),
      orderIndex: Value(orderIndex),
      name: Value(name),
      instructions: Value(instructions),
      dosageType: Value(dosageType),
      sets: sets == null && nullToAbsent ? const Value.absent() : Value(sets),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      holdSeconds: holdSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(holdSeconds),
      imageAsset: imageAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAsset),
      usesCameraTracking: Value(usesCameraTracking),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      injuryId: serializer.fromJson<int>(json['injuryId']),
      phase: serializer.fromJson<int>(json['phase']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      name: serializer.fromJson<String>(json['name']),
      instructions: serializer.fromJson<String>(json['instructions']),
      dosageType: serializer.fromJson<String>(json['dosageType']),
      sets: serializer.fromJson<int?>(json['sets']),
      reps: serializer.fromJson<int?>(json['reps']),
      holdSeconds: serializer.fromJson<int?>(json['holdSeconds']),
      imageAsset: serializer.fromJson<String?>(json['imageAsset']),
      usesCameraTracking: serializer.fromJson<bool>(json['usesCameraTracking']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'injuryId': serializer.toJson<int>(injuryId),
      'phase': serializer.toJson<int>(phase),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'name': serializer.toJson<String>(name),
      'instructions': serializer.toJson<String>(instructions),
      'dosageType': serializer.toJson<String>(dosageType),
      'sets': serializer.toJson<int?>(sets),
      'reps': serializer.toJson<int?>(reps),
      'holdSeconds': serializer.toJson<int?>(holdSeconds),
      'imageAsset': serializer.toJson<String?>(imageAsset),
      'usesCameraTracking': serializer.toJson<bool>(usesCameraTracking),
    };
  }

  Exercise copyWith(
          {int? id,
          int? injuryId,
          int? phase,
          int? orderIndex,
          String? name,
          String? instructions,
          String? dosageType,
          Value<int?> sets = const Value.absent(),
          Value<int?> reps = const Value.absent(),
          Value<int?> holdSeconds = const Value.absent(),
          Value<String?> imageAsset = const Value.absent(),
          bool? usesCameraTracking}) =>
      Exercise(
        id: id ?? this.id,
        injuryId: injuryId ?? this.injuryId,
        phase: phase ?? this.phase,
        orderIndex: orderIndex ?? this.orderIndex,
        name: name ?? this.name,
        instructions: instructions ?? this.instructions,
        dosageType: dosageType ?? this.dosageType,
        sets: sets.present ? sets.value : this.sets,
        reps: reps.present ? reps.value : this.reps,
        holdSeconds: holdSeconds.present ? holdSeconds.value : this.holdSeconds,
        imageAsset: imageAsset.present ? imageAsset.value : this.imageAsset,
        usesCameraTracking: usesCameraTracking ?? this.usesCameraTracking,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      injuryId: data.injuryId.present ? data.injuryId.value : this.injuryId,
      phase: data.phase.present ? data.phase.value : this.phase,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      name: data.name.present ? data.name.value : this.name,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      dosageType:
          data.dosageType.present ? data.dosageType.value : this.dosageType,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      holdSeconds:
          data.holdSeconds.present ? data.holdSeconds.value : this.holdSeconds,
      imageAsset:
          data.imageAsset.present ? data.imageAsset.value : this.imageAsset,
      usesCameraTracking: data.usesCameraTracking.present
          ? data.usesCameraTracking.value
          : this.usesCameraTracking,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('injuryId: $injuryId, ')
          ..write('phase: $phase, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions, ')
          ..write('dosageType: $dosageType, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('holdSeconds: $holdSeconds, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('usesCameraTracking: $usesCameraTracking')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      injuryId,
      phase,
      orderIndex,
      name,
      instructions,
      dosageType,
      sets,
      reps,
      holdSeconds,
      imageAsset,
      usesCameraTracking);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.injuryId == this.injuryId &&
          other.phase == this.phase &&
          other.orderIndex == this.orderIndex &&
          other.name == this.name &&
          other.instructions == this.instructions &&
          other.dosageType == this.dosageType &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.holdSeconds == this.holdSeconds &&
          other.imageAsset == this.imageAsset &&
          other.usesCameraTracking == this.usesCameraTracking);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<int> injuryId;
  final Value<int> phase;
  final Value<int> orderIndex;
  final Value<String> name;
  final Value<String> instructions;
  final Value<String> dosageType;
  final Value<int?> sets;
  final Value<int?> reps;
  final Value<int?> holdSeconds;
  final Value<String?> imageAsset;
  final Value<bool> usesCameraTracking;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.injuryId = const Value.absent(),
    this.phase = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.instructions = const Value.absent(),
    this.dosageType = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.holdSeconds = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.usesCameraTracking = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int injuryId,
    required int phase,
    required int orderIndex,
    required String name,
    required String instructions,
    required String dosageType,
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.holdSeconds = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.usesCameraTracking = const Value.absent(),
  })  : injuryId = Value(injuryId),
        phase = Value(phase),
        orderIndex = Value(orderIndex),
        name = Value(name),
        instructions = Value(instructions),
        dosageType = Value(dosageType);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<int>? injuryId,
    Expression<int>? phase,
    Expression<int>? orderIndex,
    Expression<String>? name,
    Expression<String>? instructions,
    Expression<String>? dosageType,
    Expression<int>? sets,
    Expression<int>? reps,
    Expression<int>? holdSeconds,
    Expression<String>? imageAsset,
    Expression<bool>? usesCameraTracking,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (injuryId != null) 'injury_id': injuryId,
      if (phase != null) 'phase': phase,
      if (orderIndex != null) 'order_index': orderIndex,
      if (name != null) 'name': name,
      if (instructions != null) 'instructions': instructions,
      if (dosageType != null) 'dosage_type': dosageType,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (holdSeconds != null) 'hold_seconds': holdSeconds,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (usesCameraTracking != null)
        'uses_camera_tracking': usesCameraTracking,
    });
  }

  ExercisesCompanion copyWith(
      {Value<int>? id,
      Value<int>? injuryId,
      Value<int>? phase,
      Value<int>? orderIndex,
      Value<String>? name,
      Value<String>? instructions,
      Value<String>? dosageType,
      Value<int?>? sets,
      Value<int?>? reps,
      Value<int?>? holdSeconds,
      Value<String?>? imageAsset,
      Value<bool>? usesCameraTracking}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      injuryId: injuryId ?? this.injuryId,
      phase: phase ?? this.phase,
      orderIndex: orderIndex ?? this.orderIndex,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      dosageType: dosageType ?? this.dosageType,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      holdSeconds: holdSeconds ?? this.holdSeconds,
      imageAsset: imageAsset ?? this.imageAsset,
      usesCameraTracking: usesCameraTracking ?? this.usesCameraTracking,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (injuryId.present) {
      map['injury_id'] = Variable<int>(injuryId.value);
    }
    if (phase.present) {
      map['phase'] = Variable<int>(phase.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (dosageType.present) {
      map['dosage_type'] = Variable<String>(dosageType.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (holdSeconds.present) {
      map['hold_seconds'] = Variable<int>(holdSeconds.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (usesCameraTracking.present) {
      map['uses_camera_tracking'] = Variable<bool>(usesCameraTracking.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('injuryId: $injuryId, ')
          ..write('phase: $phase, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions, ')
          ..write('dosageType: $dosageType, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('holdSeconds: $holdSeconds, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('usesCameraTracking: $usesCameraTracking')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _exercisesCompletedMeta =
      const VerificationMeta('exercisesCompleted');
  @override
  late final GeneratedColumn<int> exercisesCompleted = GeneratedColumn<int>(
      'exercises_completed', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _exercisesTotalMeta =
      const VerificationMeta('exercisesTotal');
  @override
  late final GeneratedColumn<int> exercisesTotal = GeneratedColumn<int>(
      'exercises_total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        date,
        durationMinutes,
        exercisesCompleted,
        exercisesTotal,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('exercises_completed')) {
      context.handle(
          _exercisesCompletedMeta,
          exercisesCompleted.isAcceptableOrUnknown(
              data['exercises_completed']!, _exercisesCompletedMeta));
    } else if (isInserting) {
      context.missing(_exercisesCompletedMeta);
    }
    if (data.containsKey('exercises_total')) {
      context.handle(
          _exercisesTotalMeta,
          exercisesTotal.isAcceptableOrUnknown(
              data['exercises_total']!, _exercisesTotalMeta));
    } else if (isInserting) {
      context.missing(_exercisesTotalMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      exercisesCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}exercises_completed'])!,
      exercisesTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercises_total'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int profileId;
  final DateTime date;
  final int durationMinutes;
  final int exercisesCompleted;
  final int exercisesTotal;
  final String? notes;
  const Session(
      {required this.id,
      required this.profileId,
      required this.date,
      required this.durationMinutes,
      required this.exercisesCompleted,
      required this.exercisesTotal,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['date'] = Variable<DateTime>(date);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['exercises_completed'] = Variable<int>(exercisesCompleted);
    map['exercises_total'] = Variable<int>(exercisesTotal);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      date: Value(date),
      durationMinutes: Value(durationMinutes),
      exercisesCompleted: Value(exercisesCompleted),
      exercisesTotal: Value(exercisesTotal),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      date: serializer.fromJson<DateTime>(json['date']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      exercisesCompleted: serializer.fromJson<int>(json['exercisesCompleted']),
      exercisesTotal: serializer.fromJson<int>(json['exercisesTotal']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'date': serializer.toJson<DateTime>(date),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'exercisesCompleted': serializer.toJson<int>(exercisesCompleted),
      'exercisesTotal': serializer.toJson<int>(exercisesTotal),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Session copyWith(
          {int? id,
          int? profileId,
          DateTime? date,
          int? durationMinutes,
          int? exercisesCompleted,
          int? exercisesTotal,
          Value<String?> notes = const Value.absent()}) =>
      Session(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        date: date ?? this.date,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
        exercisesTotal: exercisesTotal ?? this.exercisesTotal,
        notes: notes.present ? notes.value : this.notes,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      date: data.date.present ? data.date.value : this.date,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      exercisesCompleted: data.exercisesCompleted.present
          ? data.exercisesCompleted.value
          : this.exercisesCompleted,
      exercisesTotal: data.exercisesTotal.present
          ? data.exercisesTotal.value
          : this.exercisesTotal,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('exercisesCompleted: $exercisesCompleted, ')
          ..write('exercisesTotal: $exercisesTotal, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, date, durationMinutes,
      exercisesCompleted, exercisesTotal, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.date == this.date &&
          other.durationMinutes == this.durationMinutes &&
          other.exercisesCompleted == this.exercisesCompleted &&
          other.exercisesTotal == this.exercisesTotal &&
          other.notes == this.notes);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<DateTime> date;
  final Value<int> durationMinutes;
  final Value<int> exercisesCompleted;
  final Value<int> exercisesTotal;
  final Value<String?> notes;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.date = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.exercisesCompleted = const Value.absent(),
    this.exercisesTotal = const Value.absent(),
    this.notes = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    this.date = const Value.absent(),
    required int durationMinutes,
    required int exercisesCompleted,
    required int exercisesTotal,
    this.notes = const Value.absent(),
  })  : profileId = Value(profileId),
        durationMinutes = Value(durationMinutes),
        exercisesCompleted = Value(exercisesCompleted),
        exercisesTotal = Value(exercisesTotal);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<DateTime>? date,
    Expression<int>? durationMinutes,
    Expression<int>? exercisesCompleted,
    Expression<int>? exercisesTotal,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (date != null) 'date': date,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (exercisesCompleted != null) 'exercises_completed': exercisesCompleted,
      if (exercisesTotal != null) 'exercises_total': exercisesTotal,
      if (notes != null) 'notes': notes,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? profileId,
      Value<DateTime>? date,
      Value<int>? durationMinutes,
      Value<int>? exercisesCompleted,
      Value<int>? exercisesTotal,
      Value<String?>? notes}) {
    return SessionsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      exercisesTotal: exercisesTotal ?? this.exercisesTotal,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (exercisesCompleted.present) {
      map['exercises_completed'] = Variable<int>(exercisesCompleted.value);
    }
    if (exercisesTotal.present) {
      map['exercises_total'] = Variable<int>(exercisesTotal.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('exercisesCompleted: $exercisesCompleted, ')
          ..write('exercisesTotal: $exercisesTotal, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SessionExerciseLogsTable extends SessionExerciseLogs
    with TableInfo<$SessionExerciseLogsTable, SessionExerciseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExerciseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedSetsMeta =
      const VerificationMeta('completedSets');
  @override
  late final GeneratedColumn<int> completedSets = GeneratedColumn<int>(
      'completed_sets', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedRepsMeta =
      const VerificationMeta('completedReps');
  @override
  late final GeneratedColumn<int> completedReps = GeneratedColumn<int>(
      'completed_reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _postureCorrectPercentageMeta =
      const VerificationMeta('postureCorrectPercentage');
  @override
  late final GeneratedColumn<double> postureCorrectPercentage =
      GeneratedColumn<double>('posture_correct_percentage', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        exerciseId,
        completedSets,
        completedReps,
        postureCorrectPercentage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercise_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SessionExerciseLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('completed_sets')) {
      context.handle(
          _completedSetsMeta,
          completedSets.isAcceptableOrUnknown(
              data['completed_sets']!, _completedSetsMeta));
    }
    if (data.containsKey('completed_reps')) {
      context.handle(
          _completedRepsMeta,
          completedReps.isAcceptableOrUnknown(
              data['completed_reps']!, _completedRepsMeta));
    }
    if (data.containsKey('posture_correct_percentage')) {
      context.handle(
          _postureCorrectPercentageMeta,
          postureCorrectPercentage.isAcceptableOrUnknown(
              data['posture_correct_percentage']!,
              _postureCorrectPercentageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionExerciseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExerciseLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_id'])!,
      completedSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_sets'])!,
      completedReps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_reps'])!,
      postureCorrectPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}posture_correct_percentage']),
    );
  }

  @override
  $SessionExerciseLogsTable createAlias(String alias) {
    return $SessionExerciseLogsTable(attachedDatabase, alias);
  }
}

class SessionExerciseLog extends DataClass
    implements Insertable<SessionExerciseLog> {
  final int id;
  final int sessionId;
  final int exerciseId;
  final int completedSets;
  final int completedReps;
  final double? postureCorrectPercentage;
  const SessionExerciseLog(
      {required this.id,
      required this.sessionId,
      required this.exerciseId,
      required this.completedSets,
      required this.completedReps,
      this.postureCorrectPercentage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['completed_sets'] = Variable<int>(completedSets);
    map['completed_reps'] = Variable<int>(completedReps);
    if (!nullToAbsent || postureCorrectPercentage != null) {
      map['posture_correct_percentage'] =
          Variable<double>(postureCorrectPercentage);
    }
    return map;
  }

  SessionExerciseLogsCompanion toCompanion(bool nullToAbsent) {
    return SessionExerciseLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      completedSets: Value(completedSets),
      completedReps: Value(completedReps),
      postureCorrectPercentage: postureCorrectPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(postureCorrectPercentage),
    );
  }

  factory SessionExerciseLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExerciseLog(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      completedSets: serializer.fromJson<int>(json['completedSets']),
      completedReps: serializer.fromJson<int>(json['completedReps']),
      postureCorrectPercentage:
          serializer.fromJson<double?>(json['postureCorrectPercentage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'completedSets': serializer.toJson<int>(completedSets),
      'completedReps': serializer.toJson<int>(completedReps),
      'postureCorrectPercentage':
          serializer.toJson<double?>(postureCorrectPercentage),
    };
  }

  SessionExerciseLog copyWith(
          {int? id,
          int? sessionId,
          int? exerciseId,
          int? completedSets,
          int? completedReps,
          Value<double?> postureCorrectPercentage = const Value.absent()}) =>
      SessionExerciseLog(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        exerciseId: exerciseId ?? this.exerciseId,
        completedSets: completedSets ?? this.completedSets,
        completedReps: completedReps ?? this.completedReps,
        postureCorrectPercentage: postureCorrectPercentage.present
            ? postureCorrectPercentage.value
            : this.postureCorrectPercentage,
      );
  SessionExerciseLog copyWithCompanion(SessionExerciseLogsCompanion data) {
    return SessionExerciseLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      completedSets: data.completedSets.present
          ? data.completedSets.value
          : this.completedSets,
      completedReps: data.completedReps.present
          ? data.completedReps.value
          : this.completedReps,
      postureCorrectPercentage: data.postureCorrectPercentage.present
          ? data.postureCorrectPercentage.value
          : this.postureCorrectPercentage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExerciseLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('completedSets: $completedSets, ')
          ..write('completedReps: $completedReps, ')
          ..write('postureCorrectPercentage: $postureCorrectPercentage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, exerciseId, completedSets,
      completedReps, postureCorrectPercentage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExerciseLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.completedSets == this.completedSets &&
          other.completedReps == this.completedReps &&
          other.postureCorrectPercentage == this.postureCorrectPercentage);
}

class SessionExerciseLogsCompanion extends UpdateCompanion<SessionExerciseLog> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> exerciseId;
  final Value<int> completedSets;
  final Value<int> completedReps;
  final Value<double?> postureCorrectPercentage;
  const SessionExerciseLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.completedSets = const Value.absent(),
    this.completedReps = const Value.absent(),
    this.postureCorrectPercentage = const Value.absent(),
  });
  SessionExerciseLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int exerciseId,
    this.completedSets = const Value.absent(),
    this.completedReps = const Value.absent(),
    this.postureCorrectPercentage = const Value.absent(),
  })  : sessionId = Value(sessionId),
        exerciseId = Value(exerciseId);
  static Insertable<SessionExerciseLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? exerciseId,
    Expression<int>? completedSets,
    Expression<int>? completedReps,
    Expression<double>? postureCorrectPercentage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (completedSets != null) 'completed_sets': completedSets,
      if (completedReps != null) 'completed_reps': completedReps,
      if (postureCorrectPercentage != null)
        'posture_correct_percentage': postureCorrectPercentage,
    });
  }

  SessionExerciseLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? exerciseId,
      Value<int>? completedSets,
      Value<int>? completedReps,
      Value<double?>? postureCorrectPercentage}) {
    return SessionExerciseLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      completedSets: completedSets ?? this.completedSets,
      completedReps: completedReps ?? this.completedReps,
      postureCorrectPercentage:
          postureCorrectPercentage ?? this.postureCorrectPercentage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (completedSets.present) {
      map['completed_sets'] = Variable<int>(completedSets.value);
    }
    if (completedReps.present) {
      map['completed_reps'] = Variable<int>(completedReps.value);
    }
    if (postureCorrectPercentage.present) {
      map['posture_correct_percentage'] =
          Variable<double>(postureCorrectPercentage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExerciseLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('completedSets: $completedSets, ')
          ..write('completedReps: $completedReps, ')
          ..write('postureCorrectPercentage: $postureCorrectPercentage')
          ..write(')'))
        .toString();
  }
}

class $PainLogsTable extends PainLogs with TableInfo<$PainLogsTable, PainLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PainLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _painLevelMeta =
      const VerificationMeta('painLevel');
  @override
  late final GeneratedColumn<int> painLevel = GeneratedColumn<int>(
      'pain_level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, profileId, date, painLevel, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pain_logs';
  @override
  VerificationContext validateIntegrity(Insertable<PainLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('pain_level')) {
      context.handle(_painLevelMeta,
          painLevel.isAcceptableOrUnknown(data['pain_level']!, _painLevelMeta));
    } else if (isInserting) {
      context.missing(_painLevelMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PainLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PainLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      painLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pain_level'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $PainLogsTable createAlias(String alias) {
    return $PainLogsTable(attachedDatabase, alias);
  }
}

class PainLog extends DataClass implements Insertable<PainLog> {
  final int id;
  final int profileId;
  final DateTime date;
  final int painLevel;
  final String? note;
  const PainLog(
      {required this.id,
      required this.profileId,
      required this.date,
      required this.painLevel,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['date'] = Variable<DateTime>(date);
    map['pain_level'] = Variable<int>(painLevel);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PainLogsCompanion toCompanion(bool nullToAbsent) {
    return PainLogsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      date: Value(date),
      painLevel: Value(painLevel),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PainLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PainLog(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      date: serializer.fromJson<DateTime>(json['date']),
      painLevel: serializer.fromJson<int>(json['painLevel']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'date': serializer.toJson<DateTime>(date),
      'painLevel': serializer.toJson<int>(painLevel),
      'note': serializer.toJson<String?>(note),
    };
  }

  PainLog copyWith(
          {int? id,
          int? profileId,
          DateTime? date,
          int? painLevel,
          Value<String?> note = const Value.absent()}) =>
      PainLog(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        date: date ?? this.date,
        painLevel: painLevel ?? this.painLevel,
        note: note.present ? note.value : this.note,
      );
  PainLog copyWithCompanion(PainLogsCompanion data) {
    return PainLog(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      date: data.date.present ? data.date.value : this.date,
      painLevel: data.painLevel.present ? data.painLevel.value : this.painLevel,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PainLog(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('painLevel: $painLevel, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, date, painLevel, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PainLog &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.date == this.date &&
          other.painLevel == this.painLevel &&
          other.note == this.note);
}

class PainLogsCompanion extends UpdateCompanion<PainLog> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<DateTime> date;
  final Value<int> painLevel;
  final Value<String?> note;
  const PainLogsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.date = const Value.absent(),
    this.painLevel = const Value.absent(),
    this.note = const Value.absent(),
  });
  PainLogsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    this.date = const Value.absent(),
    required int painLevel,
    this.note = const Value.absent(),
  })  : profileId = Value(profileId),
        painLevel = Value(painLevel);
  static Insertable<PainLog> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<DateTime>? date,
    Expression<int>? painLevel,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (date != null) 'date': date,
      if (painLevel != null) 'pain_level': painLevel,
      if (note != null) 'note': note,
    });
  }

  PainLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? profileId,
      Value<DateTime>? date,
      Value<int>? painLevel,
      Value<String?>? note}) {
    return PainLogsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      date: date ?? this.date,
      painLevel: painLevel ?? this.painLevel,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (painLevel.present) {
      map['pain_level'] = Variable<int>(painLevel.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PainLogsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('painLevel: $painLevel, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientProfilesTable patientProfiles =
      $PatientProfilesTable(this);
  late final $InjuriesTable injuries = $InjuriesTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionExerciseLogsTable sessionExerciseLogs =
      $SessionExerciseLogsTable(this);
  late final $PainLogsTable painLogs = $PainLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        patientProfiles,
        injuries,
        exercises,
        sessions,
        sessionExerciseLogs,
        painLogs
      ];
}

typedef $$PatientProfilesTableCreateCompanionBuilder = PatientProfilesCompanion
    Function({
  Value<int> id,
  required String name,
  required int age,
  required double weightKg,
  Value<String?> email,
  Value<int?> injuryId,
  Value<int> painLevel,
  Value<bool> hasMedicalIndication,
  Value<int> daysSinceInjury,
  Value<bool> hadPriorTherapy,
  Value<double> textScaleFactor,
  Value<int> currentPhase,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$PatientProfilesTableUpdateCompanionBuilder = PatientProfilesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> age,
  Value<double> weightKg,
  Value<String?> email,
  Value<int?> injuryId,
  Value<int> painLevel,
  Value<bool> hasMedicalIndication,
  Value<int> daysSinceInjury,
  Value<bool> hadPriorTherapy,
  Value<double> textScaleFactor,
  Value<int> currentPhase,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$PatientProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get injuryId => $composableBuilder(
      column: $table.injuryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get painLevel => $composableBuilder(
      column: $table.painLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasMedicalIndication => $composableBuilder(
      column: $table.hasMedicalIndication,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get daysSinceInjury => $composableBuilder(
      column: $table.daysSinceInjury,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hadPriorTherapy => $composableBuilder(
      column: $table.hadPriorTherapy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get textScaleFactor => $composableBuilder(
      column: $table.textScaleFactor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentPhase => $composableBuilder(
      column: $table.currentPhase, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PatientProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get injuryId => $composableBuilder(
      column: $table.injuryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get painLevel => $composableBuilder(
      column: $table.painLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasMedicalIndication => $composableBuilder(
      column: $table.hasMedicalIndication,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get daysSinceInjury => $composableBuilder(
      column: $table.daysSinceInjury,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hadPriorTherapy => $composableBuilder(
      column: $table.hadPriorTherapy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get textScaleFactor => $composableBuilder(
      column: $table.textScaleFactor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentPhase => $composableBuilder(
      column: $table.currentPhase,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PatientProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get injuryId =>
      $composableBuilder(column: $table.injuryId, builder: (column) => column);

  GeneratedColumn<int> get painLevel =>
      $composableBuilder(column: $table.painLevel, builder: (column) => column);

  GeneratedColumn<bool> get hasMedicalIndication => $composableBuilder(
      column: $table.hasMedicalIndication, builder: (column) => column);

  GeneratedColumn<int> get daysSinceInjury => $composableBuilder(
      column: $table.daysSinceInjury, builder: (column) => column);

  GeneratedColumn<bool> get hadPriorTherapy => $composableBuilder(
      column: $table.hadPriorTherapy, builder: (column) => column);

  GeneratedColumn<double> get textScaleFactor => $composableBuilder(
      column: $table.textScaleFactor, builder: (column) => column);

  GeneratedColumn<int> get currentPhase => $composableBuilder(
      column: $table.currentPhase, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PatientProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientProfilesTable,
    PatientProfile,
    $$PatientProfilesTableFilterComposer,
    $$PatientProfilesTableOrderingComposer,
    $$PatientProfilesTableAnnotationComposer,
    $$PatientProfilesTableCreateCompanionBuilder,
    $$PatientProfilesTableUpdateCompanionBuilder,
    (
      PatientProfile,
      BaseReferences<_$AppDatabase, $PatientProfilesTable, PatientProfile>
    ),
    PatientProfile,
    PrefetchHooks Function()> {
  $$PatientProfilesTableTableManager(
      _$AppDatabase db, $PatientProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> age = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<int?> injuryId = const Value.absent(),
            Value<int> painLevel = const Value.absent(),
            Value<bool> hasMedicalIndication = const Value.absent(),
            Value<int> daysSinceInjury = const Value.absent(),
            Value<bool> hadPriorTherapy = const Value.absent(),
            Value<double> textScaleFactor = const Value.absent(),
            Value<int> currentPhase = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PatientProfilesCompanion(
            id: id,
            name: name,
            age: age,
            weightKg: weightKg,
            email: email,
            injuryId: injuryId,
            painLevel: painLevel,
            hasMedicalIndication: hasMedicalIndication,
            daysSinceInjury: daysSinceInjury,
            hadPriorTherapy: hadPriorTherapy,
            textScaleFactor: textScaleFactor,
            currentPhase: currentPhase,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int age,
            required double weightKg,
            Value<String?> email = const Value.absent(),
            Value<int?> injuryId = const Value.absent(),
            Value<int> painLevel = const Value.absent(),
            Value<bool> hasMedicalIndication = const Value.absent(),
            Value<int> daysSinceInjury = const Value.absent(),
            Value<bool> hadPriorTherapy = const Value.absent(),
            Value<double> textScaleFactor = const Value.absent(),
            Value<int> currentPhase = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PatientProfilesCompanion.insert(
            id: id,
            name: name,
            age: age,
            weightKg: weightKg,
            email: email,
            injuryId: injuryId,
            painLevel: painLevel,
            hasMedicalIndication: hasMedicalIndication,
            daysSinceInjury: daysSinceInjury,
            hadPriorTherapy: hadPriorTherapy,
            textScaleFactor: textScaleFactor,
            currentPhase: currentPhase,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PatientProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientProfilesTable,
    PatientProfile,
    $$PatientProfilesTableFilterComposer,
    $$PatientProfilesTableOrderingComposer,
    $$PatientProfilesTableAnnotationComposer,
    $$PatientProfilesTableCreateCompanionBuilder,
    $$PatientProfilesTableUpdateCompanionBuilder,
    (
      PatientProfile,
      BaseReferences<_$AppDatabase, $PatientProfilesTable, PatientProfile>
    ),
    PatientProfile,
    PrefetchHooks Function()>;
typedef $$InjuriesTableCreateCompanionBuilder = InjuriesCompanion Function({
  Value<int> id,
  required String name,
  required String bodyRegion,
  required String focusDescription,
  Value<String> redFlagsText,
});
typedef $$InjuriesTableUpdateCompanionBuilder = InjuriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> bodyRegion,
  Value<String> focusDescription,
  Value<String> redFlagsText,
});

class $$InjuriesTableFilterComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bodyRegion => $composableBuilder(
      column: $table.bodyRegion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get focusDescription => $composableBuilder(
      column: $table.focusDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get redFlagsText => $composableBuilder(
      column: $table.redFlagsText, builder: (column) => ColumnFilters(column));
}

class $$InjuriesTableOrderingComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bodyRegion => $composableBuilder(
      column: $table.bodyRegion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get focusDescription => $composableBuilder(
      column: $table.focusDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get redFlagsText => $composableBuilder(
      column: $table.redFlagsText,
      builder: (column) => ColumnOrderings(column));
}

class $$InjuriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bodyRegion => $composableBuilder(
      column: $table.bodyRegion, builder: (column) => column);

  GeneratedColumn<String> get focusDescription => $composableBuilder(
      column: $table.focusDescription, builder: (column) => column);

  GeneratedColumn<String> get redFlagsText => $composableBuilder(
      column: $table.redFlagsText, builder: (column) => column);
}

class $$InjuriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InjuriesTable,
    Injury,
    $$InjuriesTableFilterComposer,
    $$InjuriesTableOrderingComposer,
    $$InjuriesTableAnnotationComposer,
    $$InjuriesTableCreateCompanionBuilder,
    $$InjuriesTableUpdateCompanionBuilder,
    (Injury, BaseReferences<_$AppDatabase, $InjuriesTable, Injury>),
    Injury,
    PrefetchHooks Function()> {
  $$InjuriesTableTableManager(_$AppDatabase db, $InjuriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InjuriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InjuriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InjuriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> bodyRegion = const Value.absent(),
            Value<String> focusDescription = const Value.absent(),
            Value<String> redFlagsText = const Value.absent(),
          }) =>
              InjuriesCompanion(
            id: id,
            name: name,
            bodyRegion: bodyRegion,
            focusDescription: focusDescription,
            redFlagsText: redFlagsText,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String bodyRegion,
            required String focusDescription,
            Value<String> redFlagsText = const Value.absent(),
          }) =>
              InjuriesCompanion.insert(
            id: id,
            name: name,
            bodyRegion: bodyRegion,
            focusDescription: focusDescription,
            redFlagsText: redFlagsText,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InjuriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InjuriesTable,
    Injury,
    $$InjuriesTableFilterComposer,
    $$InjuriesTableOrderingComposer,
    $$InjuriesTableAnnotationComposer,
    $$InjuriesTableCreateCompanionBuilder,
    $$InjuriesTableUpdateCompanionBuilder,
    (Injury, BaseReferences<_$AppDatabase, $InjuriesTable, Injury>),
    Injury,
    PrefetchHooks Function()>;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required int injuryId,
  required int phase,
  required int orderIndex,
  required String name,
  required String instructions,
  required String dosageType,
  Value<int?> sets,
  Value<int?> reps,
  Value<int?> holdSeconds,
  Value<String?> imageAsset,
  Value<bool> usesCameraTracking,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<int> injuryId,
  Value<int> phase,
  Value<int> orderIndex,
  Value<String> name,
  Value<String> instructions,
  Value<String> dosageType,
  Value<int?> sets,
  Value<int?> reps,
  Value<int?> holdSeconds,
  Value<String?> imageAsset,
  Value<bool> usesCameraTracking,
});

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get injuryId => $composableBuilder(
      column: $table.injuryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosageType => $composableBuilder(
      column: $table.dosageType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get holdSeconds => $composableBuilder(
      column: $table.holdSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageAsset => $composableBuilder(
      column: $table.imageAsset, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get usesCameraTracking => $composableBuilder(
      column: $table.usesCameraTracking,
      builder: (column) => ColumnFilters(column));
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get injuryId => $composableBuilder(
      column: $table.injuryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosageType => $composableBuilder(
      column: $table.dosageType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get holdSeconds => $composableBuilder(
      column: $table.holdSeconds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageAsset => $composableBuilder(
      column: $table.imageAsset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get usesCameraTracking => $composableBuilder(
      column: $table.usesCameraTracking,
      builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get injuryId =>
      $composableBuilder(column: $table.injuryId, builder: (column) => column);

  GeneratedColumn<int> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<String> get dosageType => $composableBuilder(
      column: $table.dosageType, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get holdSeconds => $composableBuilder(
      column: $table.holdSeconds, builder: (column) => column);

  GeneratedColumn<String> get imageAsset => $composableBuilder(
      column: $table.imageAsset, builder: (column) => column);

  GeneratedColumn<bool> get usesCameraTracking => $composableBuilder(
      column: $table.usesCameraTracking, builder: (column) => column);
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
    Exercise,
    PrefetchHooks Function()> {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> injuryId = const Value.absent(),
            Value<int> phase = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> instructions = const Value.absent(),
            Value<String> dosageType = const Value.absent(),
            Value<int?> sets = const Value.absent(),
            Value<int?> reps = const Value.absent(),
            Value<int?> holdSeconds = const Value.absent(),
            Value<String?> imageAsset = const Value.absent(),
            Value<bool> usesCameraTracking = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            injuryId: injuryId,
            phase: phase,
            orderIndex: orderIndex,
            name: name,
            instructions: instructions,
            dosageType: dosageType,
            sets: sets,
            reps: reps,
            holdSeconds: holdSeconds,
            imageAsset: imageAsset,
            usesCameraTracking: usesCameraTracking,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int injuryId,
            required int phase,
            required int orderIndex,
            required String name,
            required String instructions,
            required String dosageType,
            Value<int?> sets = const Value.absent(),
            Value<int?> reps = const Value.absent(),
            Value<int?> holdSeconds = const Value.absent(),
            Value<String?> imageAsset = const Value.absent(),
            Value<bool> usesCameraTracking = const Value.absent(),
          }) =>
              ExercisesCompanion.insert(
            id: id,
            injuryId: injuryId,
            phase: phase,
            orderIndex: orderIndex,
            name: name,
            instructions: instructions,
            dosageType: dosageType,
            sets: sets,
            reps: reps,
            holdSeconds: holdSeconds,
            imageAsset: imageAsset,
            usesCameraTracking: usesCameraTracking,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
    Exercise,
    PrefetchHooks Function()>;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required int profileId,
  Value<DateTime> date,
  required int durationMinutes,
  required int exercisesCompleted,
  required int exercisesTotal,
  Value<String?> notes,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<DateTime> date,
  Value<int> durationMinutes,
  Value<int> exercisesCompleted,
  Value<int> exercisesTotal,
  Value<String?> notes,
});

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exercisesCompleted => $composableBuilder(
      column: $table.exercisesCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exercisesTotal => $composableBuilder(
      column: $table.exercisesTotal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exercisesCompleted => $composableBuilder(
      column: $table.exercisesCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exercisesTotal => $composableBuilder(
      column: $table.exercisesTotal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<int> get exercisesCompleted => $composableBuilder(
      column: $table.exercisesCompleted, builder: (column) => column);

  GeneratedColumn<int> get exercisesTotal => $composableBuilder(
      column: $table.exercisesTotal, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
    Session,
    PrefetchHooks Function()> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> profileId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<int> exercisesCompleted = const Value.absent(),
            Value<int> exercisesTotal = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            profileId: profileId,
            date: date,
            durationMinutes: durationMinutes,
            exercisesCompleted: exercisesCompleted,
            exercisesTotal: exercisesTotal,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int profileId,
            Value<DateTime> date = const Value.absent(),
            required int durationMinutes,
            required int exercisesCompleted,
            required int exercisesTotal,
            Value<String?> notes = const Value.absent(),
          }) =>
              SessionsCompanion.insert(
            id: id,
            profileId: profileId,
            date: date,
            durationMinutes: durationMinutes,
            exercisesCompleted: exercisesCompleted,
            exercisesTotal: exercisesTotal,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
    Session,
    PrefetchHooks Function()>;
typedef $$SessionExerciseLogsTableCreateCompanionBuilder
    = SessionExerciseLogsCompanion Function({
  Value<int> id,
  required int sessionId,
  required int exerciseId,
  Value<int> completedSets,
  Value<int> completedReps,
  Value<double?> postureCorrectPercentage,
});
typedef $$SessionExerciseLogsTableUpdateCompanionBuilder
    = SessionExerciseLogsCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> exerciseId,
  Value<int> completedSets,
  Value<int> completedReps,
  Value<double?> postureCorrectPercentage,
});

class $$SessionExerciseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExerciseLogsTable> {
  $$SessionExerciseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedSets => $composableBuilder(
      column: $table.completedSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedReps => $composableBuilder(
      column: $table.completedReps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get postureCorrectPercentage => $composableBuilder(
      column: $table.postureCorrectPercentage,
      builder: (column) => ColumnFilters(column));
}

class $$SessionExerciseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExerciseLogsTable> {
  $$SessionExerciseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedSets => $composableBuilder(
      column: $table.completedSets,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedReps => $composableBuilder(
      column: $table.completedReps,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get postureCorrectPercentage => $composableBuilder(
      column: $table.postureCorrectPercentage,
      builder: (column) => ColumnOrderings(column));
}

class $$SessionExerciseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExerciseLogsTable> {
  $$SessionExerciseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<int> get completedSets => $composableBuilder(
      column: $table.completedSets, builder: (column) => column);

  GeneratedColumn<int> get completedReps => $composableBuilder(
      column: $table.completedReps, builder: (column) => column);

  GeneratedColumn<double> get postureCorrectPercentage => $composableBuilder(
      column: $table.postureCorrectPercentage, builder: (column) => column);
}

class $$SessionExerciseLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionExerciseLogsTable,
    SessionExerciseLog,
    $$SessionExerciseLogsTableFilterComposer,
    $$SessionExerciseLogsTableOrderingComposer,
    $$SessionExerciseLogsTableAnnotationComposer,
    $$SessionExerciseLogsTableCreateCompanionBuilder,
    $$SessionExerciseLogsTableUpdateCompanionBuilder,
    (
      SessionExerciseLog,
      BaseReferences<_$AppDatabase, $SessionExerciseLogsTable,
          SessionExerciseLog>
    ),
    SessionExerciseLog,
    PrefetchHooks Function()> {
  $$SessionExerciseLogsTableTableManager(
      _$AppDatabase db, $SessionExerciseLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExerciseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionExerciseLogsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionExerciseLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> exerciseId = const Value.absent(),
            Value<int> completedSets = const Value.absent(),
            Value<int> completedReps = const Value.absent(),
            Value<double?> postureCorrectPercentage = const Value.absent(),
          }) =>
              SessionExerciseLogsCompanion(
            id: id,
            sessionId: sessionId,
            exerciseId: exerciseId,
            completedSets: completedSets,
            completedReps: completedReps,
            postureCorrectPercentage: postureCorrectPercentage,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int exerciseId,
            Value<int> completedSets = const Value.absent(),
            Value<int> completedReps = const Value.absent(),
            Value<double?> postureCorrectPercentage = const Value.absent(),
          }) =>
              SessionExerciseLogsCompanion.insert(
            id: id,
            sessionId: sessionId,
            exerciseId: exerciseId,
            completedSets: completedSets,
            completedReps: completedReps,
            postureCorrectPercentage: postureCorrectPercentage,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionExerciseLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionExerciseLogsTable,
    SessionExerciseLog,
    $$SessionExerciseLogsTableFilterComposer,
    $$SessionExerciseLogsTableOrderingComposer,
    $$SessionExerciseLogsTableAnnotationComposer,
    $$SessionExerciseLogsTableCreateCompanionBuilder,
    $$SessionExerciseLogsTableUpdateCompanionBuilder,
    (
      SessionExerciseLog,
      BaseReferences<_$AppDatabase, $SessionExerciseLogsTable,
          SessionExerciseLog>
    ),
    SessionExerciseLog,
    PrefetchHooks Function()>;
typedef $$PainLogsTableCreateCompanionBuilder = PainLogsCompanion Function({
  Value<int> id,
  required int profileId,
  Value<DateTime> date,
  required int painLevel,
  Value<String?> note,
});
typedef $$PainLogsTableUpdateCompanionBuilder = PainLogsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<DateTime> date,
  Value<int> painLevel,
  Value<String?> note,
});

class $$PainLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PainLogsTable> {
  $$PainLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get painLevel => $composableBuilder(
      column: $table.painLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$PainLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PainLogsTable> {
  $$PainLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get painLevel => $composableBuilder(
      column: $table.painLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$PainLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PainLogsTable> {
  $$PainLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get painLevel =>
      $composableBuilder(column: $table.painLevel, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PainLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PainLogsTable,
    PainLog,
    $$PainLogsTableFilterComposer,
    $$PainLogsTableOrderingComposer,
    $$PainLogsTableAnnotationComposer,
    $$PainLogsTableCreateCompanionBuilder,
    $$PainLogsTableUpdateCompanionBuilder,
    (PainLog, BaseReferences<_$AppDatabase, $PainLogsTable, PainLog>),
    PainLog,
    PrefetchHooks Function()> {
  $$PainLogsTableTableManager(_$AppDatabase db, $PainLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PainLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PainLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PainLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> profileId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> painLevel = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              PainLogsCompanion(
            id: id,
            profileId: profileId,
            date: date,
            painLevel: painLevel,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int profileId,
            Value<DateTime> date = const Value.absent(),
            required int painLevel,
            Value<String?> note = const Value.absent(),
          }) =>
              PainLogsCompanion.insert(
            id: id,
            profileId: profileId,
            date: date,
            painLevel: painLevel,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PainLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PainLogsTable,
    PainLog,
    $$PainLogsTableFilterComposer,
    $$PainLogsTableOrderingComposer,
    $$PainLogsTableAnnotationComposer,
    $$PainLogsTableCreateCompanionBuilder,
    $$PainLogsTableUpdateCompanionBuilder,
    (PainLog, BaseReferences<_$AppDatabase, $PainLogsTable, PainLog>),
    PainLog,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientProfilesTableTableManager get patientProfiles =>
      $$PatientProfilesTableTableManager(_db, _db.patientProfiles);
  $$InjuriesTableTableManager get injuries =>
      $$InjuriesTableTableManager(_db, _db.injuries);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionExerciseLogsTableTableManager get sessionExerciseLogs =>
      $$SessionExerciseLogsTableTableManager(_db, _db.sessionExerciseLogs);
  $$PainLogsTableTableManager get painLogs =>
      $$PainLogsTableTableManager(_db, _db.painLogs);
}
