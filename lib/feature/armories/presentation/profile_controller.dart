import 'dart:ui';

import 'package:cjylostark/feature/armories/data/armories_repository.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/domain/gem_model.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser;

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
      return ProfileController(ref);
    });

class ProfileController extends StateNotifier<ProfileState> {
  final Ref ref;

  ProfileController(this.ref) : super(ProfileState());

  Future<void> changeTabBarIndex(int index, String nickname) async {
    state = state.copyWith(tabBarIndex: index);
    if (index == 1) {
      await getGem(nickname);
    } else if (index == 2) {
      await getEngravings(nickname);
    }
  }

  Future<void> searchProfile(String nickName) async {
    state = state.copyWith(profileLoading: true);
    await ref
        .read(armoriesRepositoryProvider)
        .getProfiles(nickName)
        .then((value) async {
          await getEquipment(nickName);
          state = state.copyWith(profile: value);
        })
        .whenComplete(() {
          state = state.copyWith(profileLoading: false);
        })
        .catchError((e) {
          print('프로필 불러오기 에러 : $e');
        });
  }

  Future<void> getEngravings(String nickname) async {
    state = state.copyWith(tabViewLoading: true);
    if (state.engravings == null) {
      await ref
          .read(armoriesRepositoryProvider)
          .getEngravings(nickname)
          .then((value) {
            state = state.copyWith(engravings: value);
          })
          .whenComplete(() {
            state = state.copyWith(tabViewLoading: false);
          })
          .catchError((e) {
            print('각인 불러오기 에러 : $e');
          });
    }
  }

  Future<void> getGem(String nickname) async {
    state = state.copyWith(tabViewLoading: true);
    if (state.gem == null) {
      await ref
          .read(armoriesRepositoryProvider)
          .getGem(nickname)
          .then((value) {
            state = state.copyWith(gem: value);
            final Map<Gem, GemSkill> damageGemMap = {};
            final Map<Gem, GemSkill> cooldownGemMap = {};

            for (final gem in value.gems) {
              final skill = value.effects.skills.firstWhere(
                (s) => s.gemSlot == gem.slot,
                orElse: () => null as GemSkill,
              );

              if (skill != null) {
                final joinedDesc = skill.description.join(" ");
                if (joinedDesc.contains("피해")) {
                  damageGemMap[gem] = skill;
                } else if (joinedDesc.contains("재사용")) {
                  cooldownGemMap[gem] = skill;
                }
              }
            }

            // state 갱신
            state = state.copyWith(
              damageGemMap: damageGemMap,
              cooldownGemMap: cooldownGemMap,
            );
          })
          .whenComplete(() {
            state = state.copyWith(tabViewLoading: false);
          })
          .catchError((e) {
            print('보석 불러오기 에러 : $e');
          });
    } else {
      state = state.copyWith(tabViewLoading: false);
    }
  }

  Future<void> getEquipment(String nickName) async {
    state = state.copyWith(tabViewLoading: true);
    await ref
        .read(armoriesRepositoryProvider)
        .getEquipment(nickName)
        .then((value) {
          state = state.copyWith(equipment: value);
          for (int i = 0; i < value.length; i++) {
            if (value[i].type == '무기') {
              state = state.copyWith(weapon: value[i]);
            } else if (value[i].type == '투구') {
              state = state.copyWith(helmet: value[i]);
            } else if (value[i].type == '상의') {
              state = state.copyWith(armor: value[i]);
            } else if (value[i].type == '하의') {
              state = state.copyWith(pants: value[i]);
            } else if (value[i].type == '장갑') {
              state = state.copyWith(glove: value[i]);
            } else if (value[i].type == '어깨') {
              state = state.copyWith(shoulder: value[i]);
            } else if (value[i].type == '목걸이') {
              state = state.copyWith(necklace: value[i]);
            } else if (value[i].type == '귀걸이') {
              List<CharacterEquipment>? updatedEarrings = [
                ...state.earRings ?? [],
                value[i],
              ];
              state = state.copyWith(earRings: updatedEarrings);
            } else if (value[i].type == '반지') {
              List<CharacterEquipment>? updatedRings = [
                ...state.rings ?? [],
                value[i],
              ];
              state = state.copyWith(rings: updatedRings);
            } else if (value[i].type == '팔찌') {
              state = state.copyWith(bracelet: value[i]);
            } else if (value[i].type == '어빌리티 스톤') {
              state = state.copyWith(stone: value[i]);
            }
          }
        })
        .whenComplete(() {
          state = state.copyWith(tabViewLoading: false);
        })
        .catchError((e) {
          print('장비 불러오기 에러 : $e');
        });
  }

  Color getQualityColor(int quality) {
    if (quality <= 9) {
      return Colors.grey;
    } else if (quality <= 29) {
      return Colors.green;
    } else if (quality <= 69) {
      return Colors.blue;
    } else if (quality <= 99) {
      return Colors.purple;
    } else {
      return const Color(0xFFFFA500); // 주황/금색
    }
  }

  int getAdvancedRefiningLevel(String toolTip) {
    // 1) HTML 태그 모두 제거
    String plainText = toolTip.replaceAll(RegExp(r'<[^>]*>'), '');

    // 2) 숫자만 추출 (첫번째 등장하는 숫자)
    final regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(plainText);

    int level = 0;
    if (match != null) {
      level = int.parse(match.group(0)!);
    }
    return level;
  }

  Future<void> tabBackButton() async {
    state = ProfileState();
  }

  String extractText(String rawHtml) {
    final document = html_parser.parse(rawHtml);
    return document.body?.text.trim() ?? '';
  }
}
