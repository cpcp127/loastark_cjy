// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterEquipment _$CharacterEquipmentFromJson(Map<String, dynamic> json) =>
    CharacterEquipment(
      type: json['Type'] as String,
      name: json['Name'] as String,
      icon: json['Icon'] as String,
      grade: json['Grade'] as String,
      tooltip: CharacterEquipment._tooltipFromJson(json['Tooltip']),
    );

Map<String, dynamic> _$CharacterEquipmentToJson(CharacterEquipment instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Name': instance.name,
      'Icon': instance.icon,
      'Grade': instance.grade,
      'Tooltip': CharacterEquipment._tooltipToJson(instance.tooltip),
    };
