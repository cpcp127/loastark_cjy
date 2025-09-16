// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engravings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EngravingsModel _$EngravingsModelFromJson(Map<String, dynamic> json) =>
    EngravingsModel(
      engravings: json['Engravings'] as List<dynamic>?,
      effects: json['Effects'] as List<dynamic>?,
      arkPassiveEffects: (json['ArkPassiveEffects'] as List<dynamic>)
          .map((e) => ArkPassiveEffect.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EngravingsModelToJson(EngravingsModel instance) =>
    <String, dynamic>{
      'Engravings': instance.engravings,
      'Effects': instance.effects,
      'ArkPassiveEffects': instance.arkPassiveEffects,
    };

ArkPassiveEffect _$ArkPassiveEffectFromJson(Map<String, dynamic> json) =>
    ArkPassiveEffect(
      abilityStoneLevel: (json['AbilityStoneLevel'] as num?)?.toInt(),
      grade: json['Grade'] as String,
      level: (json['Level'] as num).toInt(),
      name: json['Name'] as String,
      description: json['Description'] as String,
    );

Map<String, dynamic> _$ArkPassiveEffectToJson(ArkPassiveEffect instance) =>
    <String, dynamic>{
      'AbilityStoneLevel': instance.abilityStoneLevel,
      'Grade': instance.grade,
      'Level': instance.level,
      'Name': instance.name,
      'Description': instance.description,
    };
