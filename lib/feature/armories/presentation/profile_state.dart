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

  ProfileState({
    this.profile,
    this.equipment,
    this.profileLoading = false,
    this.tabViewLoading = false,
    this.tabBarIndex = 0,
  });

  ProfileState copyWith({
    CharacterProfile? profile,
    List<CharacterEquipment>? equipment,
    bool? profileLoading,
    bool? tabViewLoading,
    int? tabBarIndex,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      equipment: equipment ?? this.equipment,
      profileLoading: profileLoading ?? this.profileLoading,
      tabViewLoading: tabViewLoading ?? this.tabViewLoading,
      tabBarIndex: tabBarIndex ?? this.tabBarIndex,
    );
  }
}

class ProfileParms {
  final BuildContext context;
  final WidgetRef ref;

  ProfileParms({required this.context, required this.ref});
}
