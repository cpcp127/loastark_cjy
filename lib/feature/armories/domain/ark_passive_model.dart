import 'package:json_annotation/json_annotation.dart';

part 'ark_passive_model.g.dart';

@JsonSerializable()
class ArkPassiveModel {
  @JsonKey(name: "IsArkPassive")
  final bool isArkPassive;

  @JsonKey(name: "Points")
  final List<ArkPoint> points;

  @JsonKey(name: "Effects")
  final List<ArkEffect> effects;

  ArkPassiveModel({
    required this.isArkPassive,
    required this.points,
    required this.effects,
  });

  factory ArkPassiveModel.fromJson(Map<String, dynamic> json) =>
      _$ArkPassiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArkPassiveModelToJson(this);
}

@JsonSerializable()
class ArkPoint {
  @JsonKey(name: "Name")
  final String name;

  @JsonKey(name: "Value")
  final int value;

  @JsonKey(name: "Tooltip")
  final String tooltip;

  @JsonKey(name: "Description")
  final String description;

  ArkPoint({
    required this.name,
    required this.value,
    required this.tooltip,
    required this.description,
  });

  factory ArkPoint.fromJson(Map<String, dynamic> json) =>
      _$ArkPointFromJson(json);

  Map<String, dynamic> toJson() => _$ArkPointToJson(this);
}

@JsonSerializable()
class ArkEffect {
  @JsonKey(name: "Name")
  final String name;

  @JsonKey(name: "Description")
  final String description;

  @JsonKey(name: "Icon")
  final String icon;

  @JsonKey(name: "ToolTip")
  final String tooltip;

  ArkEffect({
    required this.name,
    required this.description,
    required this.icon,
    required this.tooltip,
  });

  factory ArkEffect.fromJson(Map<String, dynamic> json) =>
      _$ArkEffectFromJson(json);

  Map<String, dynamic> toJson() => _$ArkEffectToJson(this);
}
