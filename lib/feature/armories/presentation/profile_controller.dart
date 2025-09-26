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
          await getArkPassive(nickName);
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
    if (state.arkGrid == null) {
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

  String? extractTier4NodeName() {
    String? nodeName;
    for (int i = 0; i < state.arkPassive!.effects.length; i++) {
      if (state.arkPassive!.effects[i].description.contains('중력 수련')) {
        nodeName = '중력 수련';
      } else if (state.arkPassive!.effects[i].description.contains('분노의 망치')) {
        nodeName = '분노의 망치';
      } else if (state.arkPassive!.effects[i].description.contains('빛의 기사')) {
        nodeName = '빛의 기사';
      } else if (state.arkPassive!.effects[i].description.contains('해방자')) {
        nodeName = '해방자';
      } else if (state.arkPassive!.effects[i].description.contains('광전사의 비기')) {
        nodeName = '광전사의 비기';
      } else if (state.arkPassive!.effects[i].description.contains('광기')) {
        nodeName = '광기';
      } else if (state.arkPassive!.effects[i].description.contains('처단자')) {
        nodeName = '처단자';
      } else if (state.arkPassive!.effects[i].description.contains('포식자')) {
        nodeName = '포식자';
      } else if (state.arkPassive!.effects[i].description.contains('고독한 기사')) {
        nodeName = '고독한 기사';
      } else if (state.arkPassive!.effects[i].description.contains('전투 태세')) {
        nodeName = '전투 태세';
      } else if (state.arkPassive!.effects[i].description.contains('축복의 오라')) {
        nodeName = '축복의 오라';
      } else if (state.arkPassive!.effects[i].description.contains('심판자')) {
        nodeName = '심판자';
      } else if (state.arkPassive!.effects[i].description.contains('세맥타통')) {
        nodeName = '세맥타통';
      } else if (state.arkPassive!.effects[i].description.contains('역천지체')) {
        nodeName = '역천지체';
      } else if (state.arkPassive!.effects[i].description.contains('초심')) {
        nodeName = '초심';
      } else if (state.arkPassive!.effects[i].description.contains('오의 강화')) {
        nodeName = '오의 강화';
      } else if (state.arkPassive!.effects[i].description.contains('수라의 길')) {
        nodeName = '수라의 길';
      } else if (state.arkPassive!.effects[i].description.contains('권왕파천무')) {
        nodeName = '권왕파천무';
      } else if (state.arkPassive!.effects[i].description.contains('오의난무')) {
        nodeName = '오의난무';
      } else if (state.arkPassive!.effects[i].description.contains('일격필살')) {
        nodeName = '일격필살';
      } else if (state.arkPassive!.effects[i].description.contains('충격 단련')) {
        nodeName = '충격 단련';
      } else if (state.arkPassive!.effects[i].description.contains('극의: 체술')) {
        nodeName = '극의: 체술';
      } else if (state.arkPassive!.effects[i].description.contains('절제')) {
        nodeName = '절제';
      } else if (state.arkPassive!.effects[i].description.contains('절정')) {
        nodeName = '절정';
      } else if (state.arkPassive!.effects[i].description.contains('사냥의 시간')) {
        nodeName = '사냥의 시간';
      } else if (state.arkPassive!.effects[i].description.contains('피스메이커')) {
        nodeName = '피스메이커';
      } else if (state.arkPassive!.effects[i].description.contains('핸드거너')) {
        nodeName = '핸드거너';
      } else if (state.arkPassive!.effects[i].description.contains('전술 탄환')) {
        nodeName = '전술 탄환';
      } else if (state.arkPassive!.effects[i].description.contains('화력 강화')) {
        nodeName = '화력 강화';
      } else if (state.arkPassive!.effects[i].description.contains('포격 강화')) {
        nodeName = '포격 강화';
      } else if (state.arkPassive!.effects[i].description.contains(
        '아르데타인의 기술',
      )) {
        nodeName = '아르데타인의 기술';
      } else if (state.arkPassive!.effects[i].description.contains('진화의 유산')) {
        nodeName = '진화의 유산';
      } else if (state.arkPassive!.effects[i].description.contains('죽음의 습격')) {
        nodeName = '죽음의 습격';
      } else if (state.arkPassive!.effects[i].description.contains('두 번째 동료')) {
        nodeName = '두 번째 동료';
      } else if (state.arkPassive!.effects[i].description.contains('절실한 구원')) {
        nodeName = '절실한 구원';
      } else if (state.arkPassive!.effects[i].description.contains('진실된 용맹')) {
        nodeName = '진실된 용맹';
      } else if (state.arkPassive!.effects[i].description.contains('넘치는 교감')) {
        nodeName = '넘치는 교감';
      } else if (state.arkPassive!.effects[i].description.contains('상급 소환사')) {
        nodeName = '상급 소환사';
      } else if (state.arkPassive!.effects[i].description.contains('점화')) {
        nodeName = '점화';
      } else if (state.arkPassive!.effects[i].description.contains('환류')) {
        nodeName = '환류';
      } else if (state.arkPassive!.effects[i].description.contains('황후의 은총')) {
        nodeName = '황후의 은총';
      } else if (state.arkPassive!.effects[i].description.contains('황제의 칙령')) {
        nodeName = '황제의 칙령';
      } else if (state.arkPassive!.effects[i].description.contains(
        '멈출 수 없는 충동',
      )) {
        nodeName = '멈출 수 없는 충동';
      } else if (state.arkPassive!.effects[i].description.contains('완벽한 억제')) {
        nodeName = '완벽한 억제';
      } else if (state.arkPassive!.effects[i].description.contains('갈증')) {
        nodeName = '갈증';
      } else if (state.arkPassive!.effects[i].description.contains('달의 소리')) {
        nodeName = '달의 소리';
      } else if (state.arkPassive!.effects[i].description.contains('잔재된 기운')) {
        nodeName = '잔재된 기운';
      } else if (state.arkPassive!.effects[i].description.contains('버스트')) {
        nodeName = '버스트';
      } else if (state.arkPassive!.effects[i].description.contains('만월의 집행자')) {
        nodeName = '만월의 집행자';
      } else if (state.arkPassive!.effects[i].description.contains('그믐의 경계')) {
        nodeName = '그믐의 경계';
      } else if (state.arkPassive!.effects[i].description.contains('질풍노도')) {
        nodeName = '질풍노도';
      } else if (state.arkPassive!.effects[i].description.contains('이슬비')) {
        nodeName = '이슬비';
      } else if (state.arkPassive!.effects[i].description.contains('만개')) {
        nodeName = '만개';
      } else if (state.arkPassive!.effects[i].description.contains('회귀')) {
        nodeName = '회귀';
      } else if (state.arkPassive!.effects[i].description.contains('야성')) {
        nodeName = '야성';
      } else if (state.arkPassive!.effects[i].description.contains('환수 각성')) {
        nodeName = '환수 각성';
      }
    }
    return nodeName;
  }

  Color getQualityColor(int quality) {
    if (quality < 9) {
      return Colors.grey;
    } else if (quality < 29) {
      return Colors.green;
    } else if (quality < 69) {
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
    state = ProfileState(recentSearchNickname: recent);
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
