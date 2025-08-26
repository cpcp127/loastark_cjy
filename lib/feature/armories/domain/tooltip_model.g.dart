// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TooltipModel _$TooltipModelFromJson(Map<String, dynamic> json) => TooltipModel(
  element000: json['Element_000'] == null
      ? null
      : TooltipElement.fromJson(json['Element_000'] as Map<String, dynamic>),
  element001: json['Element_001'] == null
      ? null
      : TooltipElement.fromJson(json['Element_001'] as Map<String, dynamic>),
  element002: json['Element_002'] == null
      ? null
      : TooltipElement.fromJson(json['Element_002'] as Map<String, dynamic>),
  element003: json['Element_003'] == null
      ? null
      : TooltipElement.fromJson(json['Element_003'] as Map<String, dynamic>),
  element004: json['Element_004'] == null
      ? null
      : TooltipElement.fromJson(json['Element_004'] as Map<String, dynamic>),
  element005: json['Element_005'] == null
      ? null
      : TooltipElement.fromJson(json['Element_005'] as Map<String, dynamic>),
  element006: json['Element_006'] == null
      ? null
      : TooltipElement.fromJson(json['Element_006'] as Map<String, dynamic>),
  element007: json['Element_007'] == null
      ? null
      : TooltipElement.fromJson(json['Element_007'] as Map<String, dynamic>),
  element008: json['Element_008'] == null
      ? null
      : TooltipElement.fromJson(json['Element_008'] as Map<String, dynamic>),
  element009: json['Element_009'] == null
      ? null
      : TooltipElement.fromJson(json['Element_009'] as Map<String, dynamic>),
  element010: json['Element_010'] == null
      ? null
      : TooltipElement.fromJson(json['Element_010'] as Map<String, dynamic>),
  element011: json['Element_011'] == null
      ? null
      : TooltipElement.fromJson(json['Element_011'] as Map<String, dynamic>),
  element012: json['Element_012'] == null
      ? null
      : TooltipElement.fromJson(json['Element_012'] as Map<String, dynamic>),
  element013: json['Element_013'] == null
      ? null
      : TooltipElement.fromJson(json['Element_013'] as Map<String, dynamic>),
  element014: json['Element_014'] == null
      ? null
      : TooltipElement.fromJson(json['Element_014'] as Map<String, dynamic>),
  element015: json['Element_015'] == null
      ? null
      : TooltipElement.fromJson(json['Element_015'] as Map<String, dynamic>),
  element016: json['Element_016'] == null
      ? null
      : TooltipElement.fromJson(json['Element_016'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TooltipModelToJson(TooltipModel instance) =>
    <String, dynamic>{
      'Element_000': instance.element000?.toJson(),
      'Element_001': instance.element001?.toJson(),
      'Element_002': instance.element002?.toJson(),
      'Element_003': instance.element003?.toJson(),
      'Element_004': instance.element004?.toJson(),
      'Element_005': instance.element005?.toJson(),
      'Element_006': instance.element006?.toJson(),
      'Element_007': instance.element007?.toJson(),
      'Element_008': instance.element008?.toJson(),
      'Element_009': instance.element009?.toJson(),
      'Element_010': instance.element010?.toJson(),
      'Element_011': instance.element011?.toJson(),
      'Element_012': instance.element012?.toJson(),
      'Element_013': instance.element013?.toJson(),
      'Element_014': instance.element014?.toJson(),
      'Element_015': instance.element015?.toJson(),
      'Element_016': instance.element016?.toJson(),
    };

TooltipElement _$TooltipElementFromJson(Map<String, dynamic> json) =>
    TooltipElement(type: json['type'] as String?, value: json['value']);

Map<String, dynamic> _$TooltipElementToJson(TooltipElement instance) =>
    <String, dynamic>{'type': instance.type, 'value': instance.value};
