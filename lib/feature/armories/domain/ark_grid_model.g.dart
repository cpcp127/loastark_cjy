// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ark_grid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArkGrid _$ArkGridFromJson(Map<String, dynamic> json) => ArkGrid(
  slots: (json['Slots'] as List<dynamic>)
      .map((e) => ArkSlot.fromJson(e as Map<String, dynamic>))
      .toList(),
  effects: (json['Effects'] as List<dynamic>)
      .map((e) => ArkEffect.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ArkGridToJson(ArkGrid instance) => <String, dynamic>{
  'Slots': instance.slots,
  'Effects': instance.effects,
};

ArkSlot _$ArkSlotFromJson(Map<String, dynamic> json) => ArkSlot(
  index: (json['Index'] as num).toInt(),
  icon: json['Icon'] as String,
  name: json['Name'] as String,
  point: (json['Point'] as num).toInt(),
  grade: json['Grade'] as String,
  tooltip: ArkSlot._tooltipFromJson(json['Tooltip']),
  gems: (json['Gems'] as List<dynamic>)
      .map((e) => ArkGem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ArkSlotToJson(ArkSlot instance) => <String, dynamic>{
  'Index': instance.index,
  'Icon': instance.icon,
  'Name': instance.name,
  'Point': instance.point,
  'Grade': instance.grade,
  'Tooltip': ArkSlot._tooltipToJson(instance.tooltip),
  'Gems': instance.gems,
};

ArkGem _$ArkGemFromJson(Map<String, dynamic> json) => ArkGem(
  index: (json['Index'] as num).toInt(),
  icon: json['Icon'] as String,
  isActive: json['IsActive'] as bool,
  grade: json['Grade'] as String,
  tooltip: ArkGem._tooltipFromJson(json['Tooltip']),
);

Map<String, dynamic> _$ArkGemToJson(ArkGem instance) => <String, dynamic>{
  'Index': instance.index,
  'Icon': instance.icon,
  'IsActive': instance.isActive,
  'Grade': instance.grade,
  'Tooltip': ArkGem._tooltipToJson(instance.tooltip),
};

ArkEffect _$ArkEffectFromJson(Map<String, dynamic> json) => ArkEffect(
  name: json['Name'] as String,
  level: (json['Level'] as num).toInt(),
  tooltip: ArkEffect._tooltipFromJson(json['Tooltip']),
);

Map<String, dynamic> _$ArkEffectToJson(ArkEffect instance) => <String, dynamic>{
  'Name': instance.name,
  'Level': instance.level,
  'Tooltip': ArkEffect._tooltipToJson(instance.tooltip),
};
