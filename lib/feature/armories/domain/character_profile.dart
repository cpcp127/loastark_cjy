import 'package:json_annotation/json_annotation.dart';

part 'character_profile.g.dart';

@JsonSerializable()
class CharacterProfile {
  @JsonKey(name: 'CharacterImage')
  final String? characterImage;

  @JsonKey(name: 'ExpeditionLevel')
  final int expeditionLevel;

  @JsonKey(name: 'PvpGradeName')
  final String? pvpGradeName;

  @JsonKey(name: 'TownLevel')
  final int? townLevel;

  @JsonKey(name: 'TownName')
  final String? townName;

  @JsonKey(name: 'Title')
  final String? title;

  @JsonKey(name: 'GuildMemberGrade')
  final String? guildMemberGrade;

  @JsonKey(name: 'GuildName')
  final String? guildName;

  @JsonKey(name: 'UsingSkillPoint')
  final int usingSkillPoint;

  @JsonKey(name: 'TotalSkillPoint')
  final int totalSkillPoint;

  @JsonKey(name: 'Stats')
  final List<LoaStat> stats;

  @JsonKey(name: 'Tendencies')
  final List<LoaTendency> tendencies;

  @JsonKey(name: 'CombatPower')
  final String? combatPower;

  @JsonKey(name: 'Decorations')
  final Decorations decorations;

  @JsonKey(name: 'ServerName')
  final String serverName;

  @JsonKey(name: 'CharacterName')
  final String characterName;

  @JsonKey(name: 'CharacterLevel')
  final int characterLevel;

  @JsonKey(name: 'CharacterClassName')
  final String characterClassName;

  @JsonKey(name: 'ItemAvgLevel')
  final String itemAvgLevel;

  CharacterProfile({
    this.characterImage,
    required this.expeditionLevel,
    this.pvpGradeName,
    this.townLevel,
    this.townName,
    this.title,
    this.guildMemberGrade,
    this.guildName,
    required this.usingSkillPoint,
    required this.totalSkillPoint,
    required this.stats,
    required this.tendencies,
    this.combatPower,
    required this.decorations,
    required this.serverName,
    required this.characterName,
    required this.characterLevel,
    required this.characterClassName,
    required this.itemAvgLevel,
  });

  factory CharacterProfile.fromJson(Map<String, dynamic> json) =>
      _$CharacterProfileFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterProfileToJson(this);
}

@JsonSerializable()
class LoaStat {
  @JsonKey(name: 'Type')
  final String type;

  @JsonKey(name: 'Value')
  final String value;

  @JsonKey(name: 'Tooltip')
  final List<String> tooltip;

  LoaStat({
    required this.type,
    required this.value,
    required this.tooltip,
  });

  factory LoaStat.fromJson(Map<String, dynamic> json) =>
      _$LoaStatFromJson(json);

  Map<String, dynamic> toJson() => _$LoaStatToJson(this);
}

@JsonSerializable()
class LoaTendency {
  @JsonKey(name: 'Type')
  final String type;

  @JsonKey(name: 'Point')
  final int point;

  @JsonKey(name: 'MaxPoint')
  final int maxPoint;

  LoaTendency({
    required this.type,
    required this.point,
    required this.maxPoint,
  });

  factory LoaTendency.fromJson(Map<String, dynamic> json) =>
      _$LoaTendencyFromJson(json);

  Map<String, dynamic> toJson() => _$LoaTendencyToJson(this);
}

@JsonSerializable()
class Decorations {
  @JsonKey(name: 'Symbol')
  final dynamic symbol;

  @JsonKey(name: 'Emblems')
  final dynamic emblems;

  Decorations({this.symbol, this.emblems});

  factory Decorations.fromJson(Map<String, dynamic> json) =>
      _$DecorationsFromJson(json);

  Map<String, dynamic> toJson() => _$DecorationsToJson(this);
}
