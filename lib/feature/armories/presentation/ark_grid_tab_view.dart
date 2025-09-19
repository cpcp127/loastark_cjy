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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        state.arkGrid == null
            ? Container()
            : Column(
                children: [
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.arkGrid!.slots[i].name),
                                Text(state.arkGrid!.slots[i].grade),
                                Text('${state.arkGrid!.slots[i].point}P'),
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
                        for (
                          int l = 0;
                          l < state.arkGrid!.slots[i].gems.length;
                          l++
                        )
                          buildGem(state, i, l, controller),
                      ],
                    ),
                ],
              ),
      ],
    );
  }

  Row buildGem(ProfileState state, int i, int l, ProfileController controller) {
    return Row(
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
        ),
      ],
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
      );
    } else {
      return Text(
        '${controller.extractText(state.arkGrid!.slots[i].tooltip!.element003!.value['Element_000'].toString())} : ${controller.extractText(state.arkGrid!.slots[i].tooltip!.element003!.value['Element_001'].toString())}',
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
      return TooltipText(
        state.arkGrid!.slots[i].tooltip!.element005!.value['Element_001']
            .toString(),
      );
    }
  }
}
