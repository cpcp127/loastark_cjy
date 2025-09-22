import 'package:cjylostark/custom_widget/custom_loading_widget.dart';
import 'package:cjylostark/custom_widget/grade_container.dart';
import 'package:cjylostark/custom_widget/quality_progressbar.dart';
import 'package:cjylostark/custom_widget/search_textfield.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/presentation/ark_grid_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/ark_passive_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/engravings_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/equipment_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/gem_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser; // html 파서 사용

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState createState() => _ProfileView();
}

class _ProfileView extends ConsumerState<ProfileView> {
  TextEditingController nickController = TextEditingController();
  ProfileParms? parms;

  @override
  Widget build(BuildContext context) {
    return buildProfileBody();
  }

  Widget buildProfileBody() {
    final state = ref.watch(profileControllerProvider);
    if (state.profileLoading) {
      return buildProfileLoadingView();
    } else if (state.profile == null) {
      return buildSearchProfileView();
    } else {
      return buildProfile();
    }
  }

  Widget buildProfileLoadingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Row(), CustomLoadingWidget()],
    );
  }

  Column buildSearchProfileView() {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomSearchTextField(
            controller: nickController,
            onSearch: () async {
              await controller.searchProfile(nickController.text.trim());
            },
          ),
        ),
        SizedBox(height: 20),
        Text('최근 검색 닉네임'),
        Builder(
          builder: (context) {
            if (state.recentSearchNickname == null ||
                state.recentSearchNickname!.isEmpty) {
              return Container();
            } else {
              return Column(
                children: [
                  for (int i = 0; i < state.recentSearchNickname!.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          controller.searchProfile(
                            state.recentSearchNickname![i],
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Text(state.recentSearchNickname![i]),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildProfile() {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    final profile = ref.watch(profileControllerProvider).profile;
    final equipment = ref.watch(profileControllerProvider).equipment;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.tabBackButton();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: profile!.title == null ? 0 : 20,
                    ),
                    child: Text(profile.title ?? ''),
                  ),

                  Text(profile.characterName),
                ],
              ),

              Row(
                children: [
                  Container(
                    width: 100,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(profile.characterImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.serverName),
                      Text(profile.characterClassName),
                      Text(profile.itemAvgLevel),
                      profile.combatPower == null
                          ? Container()
                          : Text(profile.combatPower!),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              TabBar(
                padding: EdgeInsets.zero,
                // 👈 전체 좌우 여백 제거
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicatorPadding: EdgeInsets.zero,
                // 👈 인디케이터 여백 제거
                labelPadding: EdgeInsets.symmetric(horizontal: 16),
                // 👈 탭 간 간격만 주기
                onTap: (index) {
                  controller.changeTabBarIndex(index, profile.characterName);
                },
                tabs: [
                  Tab(text: '장비'),
                  Tab(text: '보석'),
                  Tab(text: '각인'),
                  Tab(text: '아크패시브'),
                  Tab(text: '아크그리드'),
                ],
              ),
              state.tabBarIndex == 0
                  ? EquipmentTabView()
                  : state.tabBarIndex == 1
                  ? GemTabView()
                  : state.tabBarIndex == 2
                  ? EngravingsTabView()
                  : state.tabBarIndex == 3
                  ? ArkPassiveTabView()
                  : ArkGridTabView(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildEmptyEquipment() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
    );
  }

  Row buildBracelet(ProfileState state) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                print(state.bracelet);
              },
              child: GradeContainer(
                icon: state.bracelet!.icon,
                grade: state.bracelet!.grade,
              ),
            ),
          ],
        ),
        Text(state.bracelet!.grade),
        Expanded(
          child: TooltipText(
            state.bracelet!.tooltip!.element005!.value['Element_001'],
          ),
        ),
      ],
    );
  }

  Row buildAccessories(
    ProfileState state,
    ProfileController controller,
    CharacterEquipment item,
  ) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                print(item);
              },
              child: GradeContainer(icon: item.icon, grade: item.grade),
            ),
            //품질 프로그레스바
            QualityProgressbar(
              qualityValue: item.tooltip!.element001!.value['qualityValue'],
              progressColor: controller.getQualityColor(
                item.tooltip!.element001!.value['qualityValue'],
              ),
            ),
          ],
        ),
        Text(item.grade),
        Expanded(
          child: TooltipText(item.tooltip!.element006!.value['Element_001']),
        ),
      ],
    );
  }

  Row buildEquipmentItem(
    ProfileState state,
    ProfileController controller,
    CharacterEquipment item,
  ) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                print(item);
              },
              child: GradeContainer(icon: item.icon, grade: item.grade),
            ),
            //품질 프로그레스바
            QualityProgressbar(
              qualityValue: item.tooltip!.element001!.value['qualityValue'],
              progressColor: controller.getQualityColor(
                item.tooltip!.element001!.value['qualityValue'],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(item.grade),
                Text(extractEnhanceLevel(item.name)),
              ],
            ),
            //상급재련
            item.tooltip!.element005!.value.toString().contains('상급 재련')
                ? Text(
                    '상급 재련 ${controller.getAdvancedRefiningLevel(item.tooltip!.element005!.value as String).toString()}단계',
                  )
                : Container(),
            //초월
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/ico_tooltip_transcendence.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // element009 먼저 확인
                item.tooltip?.element009?.value?['Element_000']?['topStr']
                            ?.toString()
                            .contains('초월') ==
                        true
                    ? Text(
                        transcendence(
                              item
                                  .tooltip!
                                  .element009!
                                  .value['Element_000']['topStr'],
                            ) ??
                            "",
                      )
                    // 없으면 element010 확인
                    : item.tooltip?.element010?.value?['Element_000']?['topStr']
                              ?.toString()
                              .contains('초월') ==
                          true
                    ? Text(
                        transcendence(
                              item
                                  .tooltip!
                                  .element010!
                                  .value['Element_000']['topStr'],
                            ) ??
                            "",
                      )
                    : Container(),
              ],
            ),
          ],
        ),
        //엘릭서
        buildElixir(item),
      ],
    );
  }

  Widget buildElixir(CharacterEquipment item) {
    final element010Value = item.tooltip?.element010?.value;
    final element011Value = item.tooltip?.element011?.value;

    dynamic elixirSource;

    if (element010Value != null && element010Value.toString().contains('엘릭서')) {
      elixirSource = element010Value;
    } else if (element011Value != null &&
        element011Value.toString().contains('엘릭서')) {
      elixirSource = element011Value;
    }

    if (elixirSource == null) {
      return Container(); // 둘 다 없으면 빈 위젯
    }

    final elixirElements = elixirSource as Map<String, dynamic>;
    final elixirItemElements =
        elixirSource['Element_000']['contentStr'] as Map<String, dynamic>?;

    if (elixirElements.isEmpty || elixirItemElements == null) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        elixirItemElements.isNotEmpty
            ? TooltipText(
                elixir(elixirItemElements['Element_000']['contentStr']),
              )
            : Container(),
        elixirItemElements.length >= 2
            ? TooltipText(
                elixir(elixirItemElements['Element_001']['contentStr']),
              )
            : Container(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    parms = ProfileParms(context: context, ref: ref);
    ref.read(profileControllerProvider.notifier).getRecentSearchNickname();
  }
}

String extractEnhanceLevel(String name) {
  final match = RegExp(r'^\+\d+').firstMatch(name);
  return match != null ? match.group(0)! : '';
}

//엘릭서
String elixir(String rawHtml) {
  // 1. HTML 태그 제거
  String text = rawHtml.replaceAll(RegExp(r"<[^>]*>"), "");

  // 2. [공용], [투구] 같은 괄호 제거
  text = text.replaceAll(RegExp(r"\[.*?\]"), "").trim();

  // 3. 줄바꿈, 공백 정리
  text = text.replaceAll("\n", " ").replaceAll("\r", " ").trim();

  // 4. 정규식으로 "이름 + Lv.x" 부분만 추출
  final match = RegExp(r"([가-힣A-Za-z ()]+)\s*Lv\.\d+").firstMatch(text);

  if (match != null) {
    return match.group(0) ?? ""; // "민첩 Lv.5"
  }

  return "";
}

//초월 추출
String? transcendence(String html) {
  final regex = RegExp(r'(\d+)$'); // 문자열 끝에 있는 숫자
  final match = regex.firstMatch(html);

  String? result = match?.group(1); // "21"

  return result;
}

class TooltipText extends StatelessWidget {
  final String rawHtml;

  const TooltipText(this.rawHtml, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: _parseHtmlToSpans(rawHtml)),
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }

  List<InlineSpan> _parseHtmlToSpans(String htmlString) {
    final document = html_parser.parse(htmlString);
    final spans = <InlineSpan>[];

    for (var node in document.body!.nodes) {
      if (node.nodeType == 3) {
        spans.add(
          TextSpan(
            text: node.text,
            style: const TextStyle(color: Colors.black),
          ),
        );
      } else if (node.nodeType == 1) {
        final element = node as dynamic;
        switch (element.localName) {
          case "br":
            spans.add(const TextSpan(text: "\n"));
            break;

          case "font":
            final colorAttr = element.attributes['color'];
            Color textColor = Colors.black;

            if (colorAttr != null) {
              try {
                final hex = colorAttr.replaceAll('#', '').toUpperCase();
                if (hex == 'FFFFFF') {
                  textColor = Colors.black;
                } else {
                  textColor = Color(int.parse("0xFF$hex"));
                }
              } catch (_) {}
            }

            spans.addAll([
              TextSpan(
                text: element.text,
                style: TextStyle(color: textColor),
              ),
            ]);
            break;

          default:
            spans.add(
              TextSpan(
                text: element.text,
                style: const TextStyle(color: Colors.black),
              ),
            );
        }
      }
    }

    return spans;
  }
}
