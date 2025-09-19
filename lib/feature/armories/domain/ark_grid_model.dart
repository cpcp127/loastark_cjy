import 'dart:convert';

import 'package:cjylostark/feature/armories/domain/tooltip_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ark_grid_model.g.dart';

@JsonSerializable()
class ArkGrid {
  @JsonKey(name: 'Slots')
  final List<ArkSlot> slots;

  @JsonKey(name: 'Effects')
  final List<ArkEffect> effects;

  ArkGrid({
    required this.slots,
    required this.effects,
  });

  factory ArkGrid.fromJson(Map<String, dynamic> json) => _$ArkGridFromJson(json);
  Map<String, dynamic> toJson() => _$ArkGridToJson(this);
}

@JsonSerializable()
class ArkSlot {
  @JsonKey(name: 'Index')
  final int index;

  @JsonKey(name: 'Icon')
  final String icon;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Point')
  final int point;

  @JsonKey(name: 'Grade')
  final String grade;

  @JsonKey(name: 'Tooltip', fromJson: _tooltipFromJson, toJson: _tooltipToJson)
  final TooltipModel? tooltip;

  @JsonKey(name: 'Gems')
  final List<ArkGem> gems;

  ArkSlot({
    required this.index,
    required this.icon,
    required this.name,
    required this.point,
    required this.grade,
    required this.tooltip,
    required this.gems,
  });

  factory ArkSlot.fromJson(Map<String, dynamic> json) => _$ArkSlotFromJson(json);
  Map<String, dynamic> toJson() => _$ArkSlotToJson(this);

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

@JsonSerializable()
class ArkGem {
  @JsonKey(name: 'Index')
  final int index;

  @JsonKey(name: 'Icon')
  final String icon;

  @JsonKey(name: 'IsActive')
  final bool isActive;

  @JsonKey(name: 'Grade')
  final String grade;

  @JsonKey(name: 'Tooltip', fromJson: _tooltipFromJson, toJson: _tooltipToJson)
  final TooltipModel? tooltip;

  ArkGem({
    required this.index,
    required this.icon,
    required this.isActive,
    required this.grade,
    required this.tooltip,
  });

  factory ArkGem.fromJson(Map<String, dynamic> json) => _$ArkGemFromJson(json);
  Map<String, dynamic> toJson() => _$ArkGemToJson(this);

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

@JsonSerializable()
class ArkEffect {
  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Level')
  final int level;

  @JsonKey(name: 'Tooltip', fromJson: _tooltipFromJson, toJson: _tooltipToJson)
  final TooltipModel? tooltip;

  ArkEffect({
    required this.name,
    required this.level,
    required this.tooltip,
  });

  factory ArkEffect.fromJson(Map<String, dynamic> json) => _$ArkEffectFromJson(json);
  Map<String, dynamic> toJson() => _$ArkEffectToJson(this);

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
