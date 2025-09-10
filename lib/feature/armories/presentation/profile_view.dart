import 'package:cjylostark/custom_widget/custom_loading_widget.dart';
import 'package:cjylostark/custom_widget/grade_container.dart';
import 'package:cjylostark/custom_widget/quality_progressbar.dart';
import 'package:cjylostark/custom_widget/search_textfield.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/domain/character_profile.dart';
import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser; // html 파서 사용

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<ProfileView> {
  TextEditingController nickController = TextEditingController();
  ProfileParms? parms;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    final profile = ref.watch(profileControllerProvider).profile;
    final equipment = ref.watch(profileControllerProvider).equipment;
    return state.profileLoading == true
        ? Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Row(), CustomLoadingWidget()],
            ),
          )
        : profile == null
        ? Container(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomSearchTextField(
                        controller: nickController,
                        onSearch: () async {
                          await controller.searchProfile(
                            nickController.text.trim(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : buildProfile();
  }

  Widget buildProfile() {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    final profile = ref.watch(profileControllerProvider).profile;
    final equipment = ref.watch(profileControllerProvider).equipment;
    return DefaultTabController(
      length: 4,
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
                onTap: (index) {
                  controller.changeTabBarIndex(index);
                },
                tabs: [
                  Tab(text: '장비'),
                  Tab(text: '전투 특성'),
                  Tab(text: '각인'),
                  Tab(text: '각인'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('장비'),
                  //무기
                  state.weapon == null
                      ? Container()
                      : Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print(state.weapon);
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  GradeContainer(
                                    icon: state.weapon!.icon,
                                    grade: state.weapon!.grade,
                                  ),
                                  //품질 프로그레스바
                                  QualityProgressbar(
                                    qualityValue: state
                                        .weapon!
                                        .tooltip!
                                        .element001!
                                        .value['qualityValue'],
                                    progressColor: controller.getQualityColor(
                                      state
                                          .weapon!
                                          .tooltip!
                                          .element001!
                                          .value['qualityValue'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(state.weapon!.grade),
                                    Text(
                                      extractEnhanceLevel(state.weapon!.name),
                                    ),
                                  ],
                                ),
                                //상급재련
                                state.weapon!.tooltip!.element005!.value
                                        .toString()
                                        .contains('상급 재련')
                                    ? Text(
                                        '상급 재련 ${controller.getAdvancedRefiningLevel(state.weapon!.tooltip!.element005!.value as String).toString()}단계',
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
                                    state.weapon!.tooltip!.element009!.value ==
                                            null
                                        ? Container()
                                        : Text(
                                            transcendence(
                                                  state
                                                      .weapon!
                                                      .tooltip!
                                                      .element009!
                                                      .value['Element_000']['topStr'],
                                                ) ??
                                                "",
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                  state.helmet == null
                      ? Container()
                      : buildEquipmentItem(state, controller, state.helmet!),
                  state.shoulder == null
                      ? Container()
                      : buildEquipmentItem(state, controller, state.shoulder!),
                  state.armor == null
                      ? Container()
                      : buildEquipmentItem(state, controller, state.armor!),
                  state.pants == null
                      ? Container()
                      : buildEquipmentItem(state, controller, state.pants!),
                  state.glove == null
                      ? Container()
                      : buildEquipmentItem(state, controller, state.glove!),

                ],
              ),
              // state.tabViewLoading
              //     ? CustomLoadingWidget()
              //     : state.tabBarIndex == 0
              //     ? Column(
              //         children: [
              //           //장비
              //           Text('장비'),
              //           for (int i = 0; i < 6; i++)
              //             buildEquipment(equipment, i, controller),
              //           //악세사리
              //           Text('악세사리'),
              //           for (int i = 6; i < 11; i++)
              //             buildAccessories(equipment, i, controller),
              //           //팔찌
              //           Row(
              //             children: [
              //               Container(
              //                 width: 60,
              //                 height: 60,
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(8),
              //                   border: Border.all(color: Colors.black),
              //                   image: DecorationImage(
              //                     image: NetworkImage(equipment![12].icon),
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               ),
              //               Text(extractEnhanceLevel(equipment[12].name)),
              //               SizedBox(width: 4),
              //               Text(equipment[12].grade),
              //               SizedBox(width: 4),
              //               equipment[12].tooltip == null
              //                   ? Container()
              //                   : Expanded(
              //                       child: TooltipText(
              //                         equipment[12]
              //                             .tooltip!
              //                             .element005!
              //                             .value['Element_001'],
              //                       ),
              //                     ),
              //             ],
              //           ),
              //           //어빌리티 스톤
              //           Container(
              //             width: double.infinity,
              //             child: Row(
              //               children: [
              //                 Stack(
              //                   alignment: Alignment.center,
              //                   children: [
              //                     Container(
              //                       width: 60,
              //                       height: 60,
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(8),
              //                         border: Border.all(color: Colors.black),
              //                         image: DecorationImage(
              //                           image: NetworkImage(
              //                             equipment![11].icon,
              //                           ),
              //                           fit: BoxFit.cover,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: [
              //                     Text(extractEnhanceLevel(equipment[11].name)),
              //                     SizedBox(width: 4),
              //                     Text(equipment[11].grade),
              //                     SizedBox(width: 4),
              //                     equipment[11].tooltip == null
              //                         ? Container()
              //                         : Column(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               for (int i = 0; i < 3; i++)
              //                                 TooltipText(
              //                                   equipment[11]
              //                                       .tooltip!
              //                                       .element007!
              //                                       .value['Element_000']['contentStr']['Element_00$i']['contentStr']
              //                                       .toString()
              //                                       .replaceAll("[", "")
              //                                       .replaceAll("]", "")
              //                                       .replaceAll(
              //                                         RegExp(r"<br>|<BR>"),
              //                                         "",
              //                                       ),
              //                                 ),
              //                             ],
              //                           ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       )
              //     : Container(),
            ],
          ),
        ),
      ),
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
            GradeContainer(icon: item.icon, grade: item.grade),
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
                item.tooltip!.element010!.value == null ||
                        item.tooltip!.element005!.value.toString().contains(
                              '초월',
                            ) ==
                            false
                    ? Container()
                    : Text(
                        transcendence(
                              item
                                  .tooltip!
                                  .element010!
                                  .value['Element_000']['topStr'],
                            ) ??
                            "",
                      ),
              ],
            ),
          ],
        ),
        //엘릭서
        item.tooltip!.element011!.value.isEmpty ||
                item.tooltip!.element011!.value.toString().contains('엘릭서') ==
                    false
            ? Container()
            : Column(
                children: [
                  Builder(
                    builder: (context) {
                      final elixirElements =
                          item.tooltip!.element011!.value
                              as Map<String, dynamic>;
                      final elixirItemElements =
                          item
                                  .tooltip!
                                  .element011!
                                  .value['Element_000']['contentStr']
                              as Map<String, dynamic>;
                      if (elixirElements.isEmpty) {
                        return Container();
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            elixirItemElements.isNotEmpty
                                ? TooltipText(
                                    elixir(
                                      item
                                          .tooltip!
                                          .element011!
                                          .value['Element_000']['contentStr']['Element_000']['contentStr'],
                                    ),
                                  )
                                : Container(),
                            elixirItemElements.length >= 2
                                ? TooltipText(
                                    elixir(
                                      item
                                          .tooltip!
                                          .element011!
                                          .value['Element_000']['contentStr']['Element_001']['contentStr'],
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
      ],
    );
  }

  Padding buildAccessories(
    List<CharacterEquipment>? equipment,
    int i,
    ProfileController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                      image: DecorationImage(
                        image: NetworkImage(equipment![i].icon),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 55,
                          height: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value:
                                  equipment[i]
                                      .tooltip!
                                      .element001!
                                      .value['qualityValue'] /
                                  100,
                              minHeight: 10,
                              backgroundColor: Colors.black26,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                controller.getQualityColor(
                                  equipment[i]
                                      .tooltip!
                                      .element001!
                                      .value['qualityValue'],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${equipment[i].tooltip!.element001!.value['qualityValue']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(extractEnhanceLevel(equipment[i].name)),
                  SizedBox(width: 4),
                  Text(equipment[i].grade),
                  SizedBox(width: 4),
                  equipment[i].tooltip == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print(equipment[i].tooltip!.element006!.value);
                              },
                              child: TooltipText(
                                equipment[i]
                                    .tooltip!
                                    .element006!
                                    .value['Element_001'],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildEquipment(
    List<CharacterEquipment>? equipment,
    int i,
    ProfileController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black),
                    image: DecorationImage(
                      image: NetworkImage(equipment![i].icon),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      //초월
                      Container(
                        color: Colors.black,
                        child: Row(
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
                            i == 0
                                ? Text(
                                    transcendence(
                                          equipment[i]
                                              .tooltip!
                                              .element009!
                                              .value['Element_000']['topStr'],
                                        ) ??
                                        "",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    transcendence(
                                          equipment[i]
                                              .tooltip!
                                              .element010!
                                              .value['Element_000']['topStr'],
                                        ) ??
                                        "",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 55,
                            height: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value:
                                    equipment[i]
                                        .tooltip!
                                        .element001!
                                        .value['qualityValue'] /
                                    100,
                                minHeight: 10,
                                backgroundColor: Colors.black26,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  controller.getQualityColor(
                                    equipment[i]
                                        .tooltip!
                                        .element001!
                                        .value['qualityValue'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '${equipment[i].tooltip!.element001!.value['qualityValue']}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(extractEnhanceLevel(equipment[i].name)),
                SizedBox(width: 4),
                Text(equipment[i].grade),
                Text(
                  ' 상급 재련 ${controller.getAdvancedRefiningLevel(equipment[i].tooltip!.element005!.value as String).toString()}단계',
                ),
              ],
            ),
            //엘릭서
            equipment[i].tooltip!.element011!.value.isEmpty
                ? Container()
                : Column(
                    children: [
                      i == 0
                          ? Container()
                          : Builder(
                              builder: (context) {
                                final elixirElements =
                                    equipment[i].tooltip!.element011!.value
                                        as Map<String, dynamic>;
                                final elixirItemElements =
                                    equipment[i]
                                            .tooltip!
                                            .element011!
                                            .value['Element_000']['contentStr']
                                        as Map<String, dynamic>;
                                if (elixirElements.isEmpty) {
                                  return Container();
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      elixirItemElements.isNotEmpty
                                          ? TooltipText(
                                              elixir(
                                                equipment[i]
                                                    .tooltip!
                                                    .element011!
                                                    .value['Element_000']['contentStr']['Element_000']['contentStr'],
                                              ),
                                            )
                                          : Container(),
                                      elixirItemElements.length >= 2
                                          ? TooltipText(
                                              elixir(
                                                equipment[i]
                                                    .tooltip!
                                                    .element011!
                                                    .value['Element_000']['contentStr']['Element_001']['contentStr'],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  );
                                }
                              },
                            ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    parms = ProfileParms(context: context, ref: ref);
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
