import 'package:cjylostark/feature/armories/domain/ark_grid_model.dart';
import 'package:cjylostark/feature/armories/domain/ark_passive_model.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/domain/character_profile.dart';
import 'package:cjylostark/feature/armories/domain/engravings_model.dart';
import 'package:cjylostark/feature/armories/domain/gem_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {

  final List<String>? recentSearchNickname;
  final CharacterProfile? profile;
  final List<CharacterEquipment>? equipment;
  final bool profileLoading;
  final bool tabViewLoading;
  final int tabBarIndex;
  final CharacterEquipment? weapon;
  final CharacterEquipment? helmet;
  final CharacterEquipment? shoulder;
  final CharacterEquipment? armor;
  final CharacterEquipment? pants;
  final CharacterEquipment? glove;
  final CharacterEquipment? necklace;
  final List<CharacterEquipment>? rings;
  final List<CharacterEquipment>? earRings;
  final CharacterEquipment? bracelet;
  final CharacterEquipment? stone;
  final GemResponse? gem;
  final Map<Gem, GemSkill>? damageGemMap;
  final Map<Gem, GemSkill>? cooldownGemMap;
  final EngravingsModel? engravings;
  final ArkPassiveModel? arkPassive;
  final ArkGrid? arkGrid;

  ProfileState({

    this.recentSearchNickname,
    this.profile,
    this.equipment,
    this.profileLoading = false,
    this.tabViewLoading = false,
    this.tabBarIndex = 0,
    this.weapon,
    this.helmet,
    this.shoulder,
    this.armor,
    this.pants,
    this.glove,
    this.necklace,
    this.rings,
    this.earRings,
    this.bracelet,
    this.stone,
    this.gem,
    this.damageGemMap,
    this.cooldownGemMap,
    this.engravings,
    this.arkPassive,
    this.arkGrid,
  });

  ProfileState copyWith({

    List<String>? recentSearchNickname,
    CharacterProfile? profile,
    List<CharacterEquipment>? equipment,
    bool? profileLoading,
    bool? tabViewLoading,
    int? tabBarIndex,
    CharacterEquipment? weapon,
    CharacterEquipment? helmet,
    CharacterEquipment? shoulder,
    CharacterEquipment? armor,
    CharacterEquipment? pants,
    CharacterEquipment? glove,
    CharacterEquipment? necklace,
    List<CharacterEquipment>? rings,
    List<CharacterEquipment>? earRings,
    CharacterEquipment? bracelet,
    CharacterEquipment? stone,
    GemResponse? gem,
    Map<Gem, GemSkill>? damageGemMap,
    Map<Gem, GemSkill>? cooldownGemMap,
    EngravingsModel? engravings,
    ArkPassiveModel? arkPassive,
    ArkGrid? arkGrid,
  }) {
    return ProfileState(

      recentSearchNickname: recentSearchNickname ?? this.recentSearchNickname,
      profile: profile ?? this.profile,
      equipment: equipment ?? this.equipment,
      profileLoading: profileLoading ?? this.profileLoading,
      tabViewLoading: tabViewLoading ?? this.tabViewLoading,
      tabBarIndex: tabBarIndex ?? this.tabBarIndex,
      weapon: weapon ?? this.weapon,
      helmet: helmet ?? this.helmet,
      shoulder: shoulder ?? this.shoulder,
      armor: armor ?? this.armor,
      pants: pants ?? this.pants,
      glove: glove ?? this.glove,
      necklace: necklace ?? this.necklace,
      earRings: earRings ?? this.earRings,
      rings: rings ?? this.rings,
      bracelet: bracelet ?? this.bracelet,
      stone: stone ?? this.stone,
      gem: gem ?? this.gem,
      damageGemMap: damageGemMap ?? this.damageGemMap,
      cooldownGemMap: cooldownGemMap ?? this.cooldownGemMap,
      engravings: engravings ?? this.engravings,
      arkPassive: arkPassive ?? this.arkPassive,
      arkGrid: arkGrid ?? this.arkGrid,
    );
  }
}

class ProfileParms {
  final BuildContext context;
  final WidgetRef ref;

  ProfileParms({required this.context, required this.ref});
}
