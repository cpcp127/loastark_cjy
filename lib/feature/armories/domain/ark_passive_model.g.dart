// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ark_passive_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArkPassiveModel _$ArkPassiveModelFromJson(Map<String, dynamic> json) =>
    ArkPassiveModel(
      isArkPassive: json['IsArkPassive'] as bool,
      points: (json['Points'] as List<dynamic>)
          .map((e) => ArkPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      effects: (json['Effects'] as List<dynamic>)
          .map((e) => ArkEffect.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArkPassiveModelToJson(ArkPassiveModel instance) =>
    <String, dynamic>{
      'IsArkPassive': instance.isArkPassive,
      'Points': instance.points,
      'Effects': instance.effects,
    };

ArkPoint _$ArkPointFromJson(Map<String, dynamic> json) => ArkPoint(
  name: json['Name'] as String,
  value: (json['Value'] as num).toInt(),
  tooltip: json['Tooltip'] as String,
  description: json['Description'] as String,
);

Map<String, dynamic> _$ArkPointToJson(ArkPoint instance) => <String, dynamic>{
  'Name': instance.name,
  'Value': instance.value,
  'Tooltip': instance.tooltip,
  'Description': instance.description,
};

ArkEffect _$ArkEffectFromJson(Map<String, dynamic> json) => ArkEffect(
  name: json['Name'] as String,
  description: json['Description'] as String,
  icon: json['Icon'] as String,
  tooltip: json['ToolTip'] as String,
);

Map<String, dynamic> _$ArkEffectToJson(ArkEffect instance) => <String, dynamic>{
  'Name': instance.name,
  'Description': instance.description,
  'Icon': instance.icon,
  'ToolTip': instance.tooltip,
};
