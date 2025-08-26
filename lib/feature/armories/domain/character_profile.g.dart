// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterProfile _$CharacterProfileFromJson(Map<String, dynamic> json) =>
    CharacterProfile(
      characterImage: json['CharacterImage'] as String?,
      expeditionLevel: (json['ExpeditionLevel'] as num).toInt(),
      pvpGradeName: json['PvpGradeName'] as String?,
      townLevel: (json['TownLevel'] as num?)?.toInt(),
      townName: json['TownName'] as String?,
      title: json['Title'] as String?,
      guildMemberGrade: json['GuildMemberGrade'] as String?,
      guildName: json['GuildName'] as String?,
      usingSkillPoint: (json['UsingSkillPoint'] as num).toInt(),
      totalSkillPoint: (json['TotalSkillPoint'] as num).toInt(),
      stats: (json['Stats'] as List<dynamic>)
          .map((e) => LoaStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      tendencies: (json['Tendencies'] as List<dynamic>)
          .map((e) => LoaTendency.fromJson(e as Map<String, dynamic>))
          .toList(),
      combatPower: json['CombatPower'] as String?,
      decorations: Decorations.fromJson(
        json['Decorations'] as Map<String, dynamic>,
      ),
      serverName: json['ServerName'] as String,
      characterName: json['CharacterName'] as String,
      characterLevel: (json['CharacterLevel'] as num).toInt(),
      characterClassName: json['CharacterClassName'] as String,
      itemAvgLevel: json['ItemAvgLevel'] as String,
    );

Map<String, dynamic> _$CharacterProfileToJson(CharacterProfile instance) =>
    <String, dynamic>{
      'CharacterImage': instance.characterImage,
      'ExpeditionLevel': instance.expeditionLevel,
      'PvpGradeName': instance.pvpGradeName,
      'TownLevel': instance.townLevel,
      'TownName': instance.townName,
      'Title': instance.title,
      'GuildMemberGrade': instance.guildMemberGrade,
      'GuildName': instance.guildName,
      'UsingSkillPoint': instance.usingSkillPoint,
      'TotalSkillPoint': instance.totalSkillPoint,
      'Stats': instance.stats,
      'Tendencies': instance.tendencies,
      'CombatPower': instance.combatPower,
      'Decorations': instance.decorations,
      'ServerName': instance.serverName,
      'CharacterName': instance.characterName,
      'CharacterLevel': instance.characterLevel,
      'CharacterClassName': instance.characterClassName,
      'ItemAvgLevel': instance.itemAvgLevel,
    };

LoaStat _$LoaStatFromJson(Map<String, dynamic> json) => LoaStat(
  type: json['Type'] as String,
  value: json['Value'] as String,
  tooltip: (json['Tooltip'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$LoaStatToJson(LoaStat instance) => <String, dynamic>{
  'Type': instance.type,
  'Value': instance.value,
  'Tooltip': instance.tooltip,
};

LoaTendency _$LoaTendencyFromJson(Map<String, dynamic> json) => LoaTendency(
  type: json['Type'] as String,
  point: (json['Point'] as num).toInt(),
  maxPoint: (json['MaxPoint'] as num).toInt(),
);

Map<String, dynamic> _$LoaTendencyToJson(LoaTendency instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Point': instance.point,
      'MaxPoint': instance.maxPoint,
    };

Decorations _$DecorationsFromJson(Map<String, dynamic> json) =>
    Decorations(symbol: json['Symbol'], emblems: json['Emblems']);

Map<String, dynamic> _$DecorationsToJson(Decorations instance) =>
    <String, dynamic>{'Symbol': instance.symbol, 'Emblems': instance.emblems};
