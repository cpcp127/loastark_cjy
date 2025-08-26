import 'dart:convert';

import 'package:cjylostark/feature/armories/domain/tooltip_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character_equipment.g.dart';

@JsonSerializable()
class CharacterEquipment {
  @JsonKey(name: 'Type')
  final String type;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Icon')
  final String icon;

  @JsonKey(name: 'Grade')
  final String grade;

  @JsonKey(name: 'Tooltip', fromJson: _tooltipFromJson, toJson: _tooltipToJson)
  final TooltipModel? tooltip;

  CharacterEquipment({
    required this.type,
    required this.name,
    required this.icon,
    required this.grade,
    required this.tooltip,
  });

  factory CharacterEquipment.fromJson(Map<String, dynamic> json) =>
      _$CharacterEquipmentFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterEquipmentToJson(this);

  /// String 또는 Map 양쪽 다 처리
  static TooltipModel? _tooltipFromJson(dynamic json) {
    if (json == null) return null;

    if (json is String) {
      try {
        final decoded = jsonDecode(json);
        if (decoded is Map<String, dynamic>) {
          return TooltipModel.fromJson(decoded);
        }
      } catch (_) {
        return null; // 문자열인데 JSON 파싱 안되면 null
      }
    }

    if (json is Map<String, dynamic>) {
      return TooltipModel.fromJson(json);
    }

    return null;
  }

  static dynamic _tooltipToJson(TooltipModel? tooltip) =>
      tooltip?.toJson();
}
