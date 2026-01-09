// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gem_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GemResponse _$GemResponseFromJson(Map<String, dynamic> json) => GemResponse(
  gems: (json['Gems'] as List<dynamic>)
      .map((e) => Gem.fromJson(e as Map<String, dynamic>))
      .toList(),
  effects: GemEffects.fromJson(json['Effects'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GemResponseToJson(GemResponse instance) =>
    <String, dynamic>{'Gems': instance.gems, 'Effects': instance.effects};

Gem _$GemFromJson(Map<String, dynamic> json) => Gem(
  slot: (json['Slot'] as num).toInt(),
  name: json['Name'] as String,
  icon: json['Icon'] as String,
  level: (json['Level'] as num).toInt(),
  grade: json['Grade'] as String,
);

Map<String, dynamic> _$GemToJson(Gem instance) => <String, dynamic>{
  'Slot': instance.slot,
  'Name': instance.name,
  'Icon': instance.icon,
  'Level': instance.level,
  'Grade': instance.grade,
};

GemEffects _$GemEffectsFromJson(Map<String, dynamic> json) => GemEffects(
  description: json['Description'] as String,
  skills: (json['Skills'] as List<dynamic>)
      .map((e) => GemSkill.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GemEffectsToJson(GemEffects instance) =>
    <String, dynamic>{
      'Description': instance.description,
      'Skills': instance.skills,
    };

GemSkill _$GemSkillFromJson(Map<String, dynamic> json) => GemSkill(
  gemSlot: (json['GemSlot'] as num).toInt(),
  name: json['Name'] as String,
  description: (json['Description'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  option: json['Option'] as String,
  icon: json['Icon'] as String,
  tooltip: json['Tooltip'] as String,
);

Map<String, dynamic> _$GemSkillToJson(GemSkill instance) => <String, dynamic>{
  'GemSlot': instance.gemSlot,
  'Name': instance.name,
  'Description': instance.description,
  'Option': instance.option,
  'Icon': instance.icon,
  'Tooltip': instance.tooltip,
};
