import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/domain/character_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
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

  ProfileState({
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
  });

  ProfileState copyWith({
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
  }) {
    return ProfileState(
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
    );
  }
}

class ProfileParms {
  final BuildContext context;
  final WidgetRef ref;

  ProfileParms({required this.context, required this.ref});
}
