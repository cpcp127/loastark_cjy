import 'package:cjylostark/custom_widget/custom_loading_widget.dart';
import 'package:cjylostark/custom_widget/grade_container.dart';
import 'package:cjylostark/custom_widget/quality_progressbar.dart';
import 'package:cjylostark/custom_widget/search_textfield.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:cjylostark/feature/armories/presentation/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser; // html 파서 사용

class EquipmentTabView extends ConsumerStatefulWidget {
  const EquipmentTabView({super.key});

  @override
  ConsumerState createState() => _EquipmentTabViewState();
}

class _EquipmentTabViewState extends ConsumerState<EquipmentTabView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    return Column(
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
                          Text(extractEnhanceLevel(state.weapon!.name)),
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
                          (state
                                          .weapon!
                                          .tooltip!
                                          .element009
                                          ?.value?['Element_000']?['topStr'] !=
                                      null &&
                                  !state
                                      .weapon!
                                      .tooltip!
                                      .element009!
                                      .value['Element_000']['topStr']
                                      .toString()
                                      .contains("에스더"))
                              ? Text(
                                  transcendence(
                                        state
                                            .weapon!
                                            .tooltip!
                                            .element009!
                                            .value['Element_000']['topStr'],
                                      ) ??
                                      "",
                                )
                              : (state
                                        .weapon!
                                        .tooltip!
                                        .element010
                                        ?.value?['Element_000']?['topStr'] !=
                                    null)
                              ? Text(
                                  transcendence(
                                        state
                                            .weapon!
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
        Text('악세'),
        state.necklace == null
            ? buildEmptyEquipment()
            : buildAccessories(state, controller, state.necklace!),
        state.earRings == null
            ? Column(children: [buildEmptyEquipment(), buildEmptyEquipment()])
            : state.earRings!.length == 1
            ? Column(
                children: [
                  buildAccessories(state, controller, state.earRings!.first),
                  buildEmptyEquipment(),
                ],
              )
            : Column(
                children: [
                  for (int i = 0; i < state.earRings!.length; i++)
                    buildAccessories(state, controller, state.earRings![i]),
                ],
              ),
        state.rings == null
            ? Column(children: [buildEmptyEquipment(), buildEmptyEquipment()])
            : state.rings!.length == 1
            ? Column(
                children: [
                  buildAccessories(state, controller, state.rings!.first),
                  buildEmptyEquipment(),
                ],
              )
            : Column(
                children: [
                  for (int i = 0; i < state.rings!.length; i++)
                    buildAccessories(state, controller, state.rings![i]),
                ],
              ),
        //팔찌
        state.bracelet == null ? buildEmptyEquipment() : buildBracelet(state),
        state.stone == null
            ? buildEmptyEquipment()
            : Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print(state.stone!);
                    },
                    child: GradeContainer(
                      icon: state.stone!.icon,
                      grade: state.stone!.grade,
                    ),
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < 3; i++)
                        TooltipText(
                          state
                              .stone!
                              .tooltip!
                              .element007!
                              .value['Element_000']['contentStr']['Element_00$i']['contentStr']
                              .toString()
                              .replaceAll("[", "")
                              .replaceAll("]", "")
                              .replaceAll(RegExp(r"<br>|<BR>"), ""),
                        ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }

  String extractEnhanceLevel(String name) {
    final match = RegExp(r'^\+\d+').firstMatch(name);
    return match != null ? match.group(0)! : '';
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
                print(item.tooltip!.element004!.value);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TooltipText(item.tooltip!.element006!.value['Element_001']),

            ],
          ),
        ),
        Text(
          '힘/민/지 ${controller.getAccessoriesPercent(item.type, controller.extractStrengthValue(item.tooltip!.element004!.value.toString()))} ',
        ),
      ],
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
}
