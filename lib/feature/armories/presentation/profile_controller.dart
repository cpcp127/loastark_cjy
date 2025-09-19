import 'dart:ui';

import 'package:cjylostark/feature/armories/data/armories_repository.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/domain/gem_model.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:shared_preferences/shared_preferences.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
      return ProfileController(ref);
    });

class ProfileController extends StateNotifier<ProfileState> {
  final Ref ref;

  ProfileController(this.ref) : super(ProfileState());

  Future<void> getRecentSearchNickname() async {
    final pref = await SharedPreferences.getInstance();

    // 저장된 닉네임 리스트 불러오기 (없으면 빈 리스트)
    final recent = pref.getStringList('recent_search') ?? [];

    // state 갱신
    state = state.copyWith(recentSearchNickname: recent);
  }

  Future<void> changeTabBarIndex(int index, String nickname) async {
    state = state.copyWith(tabBarIndex: index);
    if (index == 1) {
      await getGem(nickname);
    } else if (index == 2) {
      await getEngravings(nickname);
    } else if (index == 3) {
      await getArkPassive(nickname);
    } else if (index == 4) {
      await getArkGrid(nickname);
    }
  }

  Future<void> searchProfile(String nickName) async {
    final pref = await SharedPreferences.getInstance();
    state = state.copyWith(profileLoading: true);
    await ref
        .read(armoriesRepositoryProvider)
        .getProfiles(nickName)
        .then((value) async {
          final currentList = pref.getStringList('recent_search') ?? [];

          // 중복 제거 후 맨 앞에 삽입
          currentList.remove(nickName);
          currentList.insert(0, nickName);

          // 최대 5개만 유지
          final updatedList = currentList.take(5).toList();

          await pref.setStringList('recent_search', updatedList);
          await getRecentSearchNickname();
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

  Future<void> getArkGrid(String nickname) async {
    state = state.copyWith(tabViewLoading: true);
    if (state.arkPassive == null) {
      await ref
          .read(armoriesRepositoryProvider)
          .getArkGrid(nickname)
          .then((value) {
            state = state.copyWith(arkGrid: value);
          })
          .whenComplete(() {
            state = state.copyWith(tabViewLoading: false);
          })
          .catchError((e) {
            print('아크그리드 불러오기 에러 : $e');
          });
    }
  }

  Future<void> getArkPassive(String nickname) async {
    state = state.copyWith(tabViewLoading: true);
    if (state.arkPassive == null) {
      await ref
          .read(armoriesRepositoryProvider)
          .getArkPassive(nickname)
          .then((value) {
            state = state.copyWith(arkPassive: value);
          })
          .whenComplete(() {
            state = state.copyWith(tabViewLoading: false);
          })
          .catchError((e) {
            print('앜패 불러오기 에러 : $e');
          });
    }
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

  String getAccessoriesPercent(String itemType, int value) {
    int minValue;
    int maxValue;

    if (itemType == '반지') {
      minValue = 10962;
      maxValue = 12897;
    } else if (itemType == '귀걸이') {
      minValue = 11806;
      maxValue = 13889;
    } else if (itemType == '목걸이') {
      minValue = 15178;
      maxValue = 17857;
    } else {
      return "0%"; // 알 수 없는 타입이면 0%
    }

    // 범위를 벗어난 경우 보정
    if (value < minValue) value = minValue;
    if (value > maxValue) value = maxValue;

    // 퍼센트 계산
    double percent = ((value - minValue) / (maxValue - minValue)) * 100;

    return "${percent.toStringAsFixed(2)}%";
  }

  //악세사리 힘민지 추출
  int extractStrengthValue(String raw) {
    if (raw.contains("힘")) {
      // "힘"으로 split → 두 번째 문자열만 사용
      String part = raw.split("힘")[1].trim();
      // "+" 제거 후 숫자만 추출
      String numberStr = part
          .split(RegExp(r'[^0-9]'))
          .firstWhere((e) => e.isNotEmpty, orElse: () => "");

      return int.tryParse(numberStr) ?? 0;
    }
    return 0;
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
    final pref = await SharedPreferences.getInstance();

    // SharedPreferences 에 저장된 닉네임 리스트 불러오기
    final recent = pref.getStringList('recent_search') ?? [];
    state = ProfileState(recentSearchNickname:  recent);
  }

  String extractText(String rawHtml) {
    final document = html_parser.parse(rawHtml);
    return document.body?.text.trim() ?? '';
  }

  String? getEngravingsIcon(String name) {
    if (name == '슈퍼 차지') {
      return 'assets/images/engravings/super_charge.png';
    } else if (name == '바리케이드') {
      return 'assets/images/engravings/barricade.png';
    } else if (name == '결투의 대가') {
      return 'assets/images/engravings/master_brawler.png';
    } else if (name == '원한') {
      return 'assets/images/engravings/grudge.png';
    } else if (name == '저주받은 인형') {
      return 'assets/images/engravings/cursed_doll.png';
    } else if (name == '정기 흡수') {
      return 'assets/images/engravings/spirit_absorption.png';
    } else if (name == '안정된 상태') {
      return 'assets/images/engravings/stabilized_status.png';
    } else if (name == '예리한 둔기') {
      return 'assets/images/engravings/keen_blunt_weapon.png';
    } else if (name == '마나 효율 증가') {
      return 'assets/images/engravings/mp_efficiency_increase.png';
    } else if (name == '선수필승') {
      return 'assets/images/engravings/preemptive_strike.png';
    } else if (name == '승부사') {
      return 'assets/images/engravings/contender.png';
    } else if (name == '기습의 대가') {
      return 'assets/images/engravings/ambush_master.png';
    } else if (name == '돌격대장') {
      return 'assets/images/engravings/raid_captain.png';
    } else if (name == '질량 증가') {
      return 'assets/images/engravings/mass_increase.png';
    } else if (name == '타격의 대가') {
      return 'assets/images/engravings/hit_master.png';
    } else if (name == '아드레날린') {
      return 'assets/images/engravings/adrenaline.png';
    } else if (name == '정밀 단도') {
      return 'assets/images/engravings/precise_dagger.png';
    } else if (name == '강화 방패') {
      return 'assets/images/engravings/enhanced_shield.png';
    } else if (name == '부러진 뼈') {
      return 'assets/images/engravings/broken_bone.png';
    } else if (name == '에테르 포식자') {
      return 'assets/images/engravings/ether_predator.png';
    } else if (name == '중갑 착용') {
      return 'assets/images/engravings/heavy_armor.png';
    } else if (name == '굳은 의지') {
      return 'assets/images/engravings/strong_will.png';
    } else if (name == '급소 타격') {
      return 'assets/images/engravings/vital_point_hit.png';
    } else if (name == '최대 마나 증가') {
      return 'assets/images/engravings/max_mp_Increase.png';
    } else if (name == '탈출의 명수') {
      return 'assets/images/engravings/master_of_escape.png';
    } else if (name == '실드관통') {
      return 'assets/images/engravings/shield_piercing.png';
    } else if (name == '달인의 저력') {
      return 'assets/images/engravings/master_tenacity.png';
    } else if (name == '여신의 가호') {
      return 'assets/images/engravings/divine_protection.png';
    } else if (name == '번개의 분노') {
      return 'assets/images/engravings/lightning_fury.png';
    } else if (name == '각성') {
      return 'assets/images/engravings/awakening.png';
    } else if (name == '구슬동자') {
      return 'assets/images/engravings/drops_of_ether.png';
    } else if (name == '불굴') {
      return 'assets/images/engravings/fortitude.png';
    } else if (name == '분쇄의 주먹') {
      return 'assets/images/engravings/crushing_fist.png';
    } else if (name == '마나의 흐름') {
      return 'assets/images/engravings/magick_stream.png';
    } else if (name == '위기 모면') {
      return 'assets/images/engravings/crisis_evasion.png';
    } else if (name == '폭발물 전문가') {
      return 'assets/images/engravings/explosive_expert.png';
    } else if (name == '전문의') {
      return 'assets/images/engravings/expert.png';
    } else if (name == '약자 무시') {
      return 'assets/images/engravings/disrespect.png';
    } else if (name == '강령술') {
      return 'assets/images/engravings/necromancy.png';
    } else if (name == '시선 집중') {
      return 'assets/images/engravings/sight_focus.png';
    } else if (name == '추진력') {
      return 'assets/images/engravings/propulsion.png';
    } else if (name == '속전속결') {
      return 'assets/images/engravings/all_out_attack.png';
    } else if (name == '긴급구조') {
      return 'assets/images/engravings/emergency_rescue.png';
    } else {
      return null;
    }
  }
}
