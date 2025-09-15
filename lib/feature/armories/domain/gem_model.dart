import 'package:json_annotation/json_annotation.dart';

part 'gem_model.g.dart';

@JsonSerializable()
class GemResponse {
  @JsonKey(name: 'Gems')
  final List<Gem> gems;

  @JsonKey(name: 'Effects')
  final GemEffects effects;

  GemResponse({
    required this.gems,
    required this.effects,
  });

  factory GemResponse.fromJson(Map<String, dynamic> json) =>
      _$GemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GemResponseToJson(this);
}

@JsonSerializable()
class Gem {
  @JsonKey(name: 'Slot')
  final int slot;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Icon')
  final String icon;

  @JsonKey(name: 'Level')
  final int level;

  @JsonKey(name: 'Grade')
  final String grade;



  Gem({
    required this.slot,
    required this.name,
    required this.icon,
    required this.level,
    required this.grade,

  });

  factory Gem.fromJson(Map<String, dynamic> json) => _$GemFromJson(json);

  Map<String, dynamic> toJson() => _$GemToJson(this);
}

@JsonSerializable()
class GemEffects {
  @JsonKey(name: 'Description')
  final String description;

  @JsonKey(name: 'Skills')
  final List<GemSkill> skills;

  GemEffects({
    required this.description,
    required this.skills,
  });

  factory GemEffects.fromJson(Map<String, dynamic> json) =>
      _$GemEffectsFromJson(json);

  Map<String, dynamic> toJson() => _$GemEffectsToJson(this);
}

@JsonSerializable()
class GemSkill {
  @JsonKey(name: 'GemSlot')
  final int gemSlot;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Description')
  final List<String> description;

  @JsonKey(name: 'Option')
  final String option;

  @JsonKey(name: 'Icon')
  final String icon;

  @JsonKey(name: 'Tooltip')
  final String tooltip;

  GemSkill({
    required this.gemSlot,
    required this.name,
    required this.description,
    required this.option,
    required this.icon,
    required this.tooltip,
  });

  factory GemSkill.fromJson(Map<String, dynamic> json) =>
      _$GemSkillFromJson(json);

  Map<String, dynamic> toJson() => _$GemSkillToJson(this);
}
