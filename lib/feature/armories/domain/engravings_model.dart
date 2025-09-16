import 'package:json_annotation/json_annotation.dart';

part 'engravings_model.g.dart';

@JsonSerializable()
class EngravingsModel {
  @JsonKey(name: "Engravings")
  final List<dynamic>? engravings;

  @JsonKey(name: "Effects")
  final List<dynamic>? effects;

  @JsonKey(name: "ArkPassiveEffects")
  final List<ArkPassiveEffect> arkPassiveEffects;

  EngravingsModel({
    this.engravings,
    this.effects,
    required this.arkPassiveEffects,
  });

  factory EngravingsModel.fromJson(Map<String, dynamic> json) =>
      _$EngravingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EngravingsModelToJson(this);
}

@JsonSerializable()
class ArkPassiveEffect {
  @JsonKey(name: "AbilityStoneLevel")
  final int? abilityStoneLevel;

  @JsonKey(name: "Grade")
  final String grade;

  @JsonKey(name: "Level")
  final int level;

  @JsonKey(name: "Name")
  final String name;

  @JsonKey(name: "Description")
  final String description;

  ArkPassiveEffect({
    this.abilityStoneLevel,
    required this.grade,
    required this.level,
    required this.name,
    required this.description,
  });

  factory ArkPassiveEffect.fromJson(Map<String, dynamic> json) =>
      _$ArkPassiveEffectFromJson(json);

  Map<String, dynamic> toJson() => _$ArkPassiveEffectToJson(this);
}
