import 'package:cjylostark/constants/app_text_style.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '장비',
              style: AppTextStyle.headlineMediumBoldStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),

          //무기
          state.weapon == null
              ? buildEmptyEquipment()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Stack(
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
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    state.weapon!.grade,
                                    style: AppTextStyle.labelMediumStyle
                                        .copyWith(
                                          color: controller.getGradeColor(
                                            state.weapon!.grade,
                                          ),
                                        ),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    extractEnhanceLevel(state.weapon!.name),
                                    style: AppTextStyle.labelMediumStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              //상급재련
                              state.weapon!.tooltip!.element005!.value
                                      .toString()
                                      .contains('상급 재련')
                                  ? Text(
                                      '상급 재련 ${controller.getAdvancedRefiningLevel(state.weapon!.tooltip!.element005!.value as String).toString()}단계',
                                      style: AppTextStyle.labelMediumStyle
                                          .copyWith(color: Colors.white),
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
                                          controller.transcendence(
                                                state
                                                    .weapon!
                                                    .tooltip!
                                                    .element009!
                                                    .value['Element_000']['topStr'],
                                              ) ??
                                              "",
                                          style: AppTextStyle.labelMediumStyle
                                              .copyWith(color: Colors.white),
                                        )
                                      : (state
                                                .weapon!
                                                .tooltip!
                                                .element010
                                                ?.value?['Element_000']?['topStr'] !=
                                            null)
                                      ? Text(
                                          controller.transcendence(
                                                state
                                                    .weapon!
                                                    .tooltip!
                                                    .element010!
                                                    .value['Element_000']['topStr'],
                                              ) ??
                                              "",
                                          style: AppTextStyle.labelMediumStyle
                                              .copyWith(color: Colors.white),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '액세서리',
              style: AppTextStyle.headlineMediumBoldStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '어빌리티 스톤',
              style: AppTextStyle.headlineMediumBoldStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          state.stone == null ? buildEmptyEquipment() : buildStone(state),
        ],
      ),
    );
  }

  Padding buildStone(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              GradeContainer(
                icon: state.stone!.icon,
                grade: state.stone!.grade,
              ),
              SizedBox(width: 8),
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
        ),
      ),
    );
  }

  String extractEnhanceLevel(String name) {
    final match = RegExp(r'^\+\d+').firstMatch(name);
    return match != null ? match.group(0)! : '';
  }

  Widget buildEquipmentItem(
    ProfileState state,
    ProfileController controller,
    CharacterEquipment item,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GradeContainer(icon: item.icon, grade: item.grade),
                  //품질 프로그레스바
                  QualityProgressbar(
                    qualityValue:
                        item.tooltip!.element001!.value['qualityValue'],
                    progressColor: controller.getQualityColor(
                      item.tooltip!.element001!.value['qualityValue'],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.grade,
                        style: AppTextStyle.labelMediumStyle.copyWith(
                          color: controller.getGradeColor(item.grade),
                        ),
                      ),
                      SizedBox(width: 3),
                      Text(
                        extractEnhanceLevel(item.name),
                        style: AppTextStyle.labelMediumStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  //상급재련
                  item.tooltip!.element005!.value.toString().contains('상급 재련')
                      ? Text(
                          '상급 재련 ${controller.getAdvancedRefiningLevel(item.tooltip!.element005!.value as String).toString()}단계',
                          style: AppTextStyle.labelMediumStyle.copyWith(
                            color: Colors.white,
                          ),
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
                              controller.transcendence(
                                    item
                                        .tooltip!
                                        .element009!
                                        .value['Element_000']['topStr'],
                                  ) ??
                                  "",
                              style: AppTextStyle.labelMediumStyle.copyWith(
                                color: Colors.white,
                              ),
                            )
                          // 없으면 element010 확인
                          : item
                                    .tooltip
                                    ?.element010
                                    ?.value?['Element_000']?['topStr']
                                    ?.toString()
                                    .contains('초월') ==
                                true
                          ? Text(
                              controller.transcendence(
                                    item
                                        .tooltip!
                                        .element010!
                                        .value['Element_000']['topStr'],
                                  ) ??
                                  "",
                              style: AppTextStyle.labelMediumStyle.copyWith(
                                color: Colors.white,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 10),
              //엘릭서
              buildElixir(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildElixir(CharacterEquipment item) {
    final controller = ref.read(profileControllerProvider.notifier);
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
                controller.elixir(
                  elixirItemElements['Element_000']['contentStr'],
                ),
              )
            : Container(),
        elixirItemElements.length >= 2
            ? TooltipText(
                controller.elixir(
                  elixirItemElements['Element_001']['contentStr'],
                ),
              )
            : Container(),
      ],
    );
  }

  Widget buildAccessories(
    ProfileState state,
    ProfileController controller,
    CharacterEquipment item,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GradeContainer(icon: item.icon, grade: item.grade),
                  //품질 프로그레스바
                  QualityProgressbar(
                    qualityValue:
                        item.tooltip!.element001!.value['qualityValue'],
                    progressColor: controller.getQualityColor(
                      item.tooltip!.element001!.value['qualityValue'],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Text(
                item.grade,
                style: AppTextStyle.labelMediumStyle.copyWith(
                  color: controller.getGradeColor(item.grade),
                ),
              ),
              SizedBox(width: 8),
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
                style: AppTextStyle.labelMediumStyle.copyWith(
                  color: Colors.white,
                ),
              ),
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
        color: Colors.grey.withOpacity(0.8),
      ),
    );
  }

  Widget buildBracelet(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
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
          ),
        ),
      ),
    );
  }
}
