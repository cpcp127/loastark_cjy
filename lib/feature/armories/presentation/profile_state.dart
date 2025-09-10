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
  }) {
    return ProfileState(
      profile: profile ??this.profile,
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
    );
  }
}

class ProfileParms {
  final BuildContext context;
  final WidgetRef ref;

  ProfileParms({required this.context, required this.ref});
}
