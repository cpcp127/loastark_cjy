import 'package:cjylostark/constants/app_text_style.dart';
import 'package:cjylostark/custom_widget/grade_container.dart';
import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:cjylostark/feature/armories/presentation/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArkGridTabView extends ConsumerStatefulWidget {
  const ArkGridTabView({super.key});

  @override
  ConsumerState createState() => _ArkGridTabViewState();
}

class _ArkGridTabViewState extends ConsumerState<ArkGridTabView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state.arkGrid == null
              ? Container()
              : Column(
                  children: [
                    for (int i = 0; i < state.arkGrid!.effects.length; i++)
                      Row(
                        children: [
                          Text(
                            '${state.arkGrid!.effects[i].name} : LV ${state.arkGrid!.effects[i].level}',
                            style: AppTextStyle.labelMediumStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 14),
                    for (int i = 0; i < state.arkGrid!.slots.length; i++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GradeContainer(
                                grade: state.arkGrid!.slots[i].grade,
                                icon: state.arkGrid!.slots[i].icon,
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.arkGrid!.slots[i].name,
                                    style: AppTextStyle.labelLargeStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    state.arkGrid!.slots[i].grade,
                                    style: AppTextStyle.labelMediumStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    '${state.arkGrid!.slots[i].point}P',
                                    style: AppTextStyle.labelMediumStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //코어 타입
                          buildCoreType(controller, state, i),

                          //코어 옵션
                          buildCoreOption(state, i),

                          SizedBox(height: 10),
                          //코어 장착 쩸
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (
                                  int l = 0;
                                  l < state.arkGrid!.slots[i].gems.length;
                                  l++
                                )
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: buildGem(state, i, l, controller),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14),
                        ],
                      ),

                  ],
                ),
        ],
      ),
    );
  }

  Widget buildGem(
    ProfileState state,
    int i,
    int l,
    ProfileController controller,
  ) {
    return GestureDetector(
      onTap: () {
        print(state.arkGrid!.slots[i].gems[l].tooltip!.element000!);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(state.arkGrid!.slots[i].gems[l].icon),
                  ),
                ),
              ),

              Text(
                controller.extractText(
                  state.arkGrid!.slots[i].gems[l].tooltip!.element000!.value
                      .toString(),
                ),
                style: AppTextStyle.labelSmallStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          TooltipText(
            state
                .arkGrid!
                .slots[i]
                .gems[l]
                .tooltip!
                .element006!
                .value!['Element_001']
                .toString(),
          ),

        ],
      ),
    );
  }

  Widget buildCoreType(
    ProfileController controller,
    ProfileState state,
    int i,
  ) {
    if (state.arkGrid!.slots[i].name.contains('질서')) {
      return Text(
        '${controller.extractText(state.arkGrid!.slots[i].tooltip!.element004!.value['Element_000'].toString())} : ${controller.extractText(state.arkGrid!.slots[i].tooltip!.element004!.value['Element_001'].toString())}',
        style: AppTextStyle.labelMediumStyle.copyWith(color: Colors.white),
      );
    } else {
      return Text(
        '${controller.extractText(state.arkGrid!.slots[i].tooltip!.element003!.value['Element_000'].toString())} : ${controller.extractText(state.arkGrid!.slots[i].tooltip!.element003!.value['Element_001'].toString())}',
        style: AppTextStyle.labelMediumStyle.copyWith(color: Colors.white),
      );
    }
  }

  Widget buildCoreOption(ProfileState state, int i) {
    if (state.arkGrid!.slots[i].name.contains('질서')) {
      return TooltipText(
        state.arkGrid!.slots[i].tooltip!.element006!.value['Element_001']
            .toString(),
      );
    } else {
      return GestureDetector(
        onTap: () {
          print(
            state.arkGrid!.slots[i].tooltip!.element005!.value['Element_001'],
          );
        },
        child: TooltipText(
          state.arkGrid!.slots[i].tooltip!.element005!.value['Element_001']
              .toString(),
        ),
      );
    }
  }
}
