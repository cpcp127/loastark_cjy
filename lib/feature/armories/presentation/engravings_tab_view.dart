import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EngravingsTabView extends ConsumerStatefulWidget {
  const EngravingsTabView({super.key});

  @override
  ConsumerState createState() => _EngravingsTabViewState();
}

class _EngravingsTabViewState extends ConsumerState<EngravingsTabView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    return Column(
      children: [
        Text('각인'),
        state.engravings == null || state.engravings!.arkPassiveEffects.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    buildEngravingWidget(state, controller, 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildEngravingWidget(state, controller, 3),
                        buildEngravingWidget(state, controller, 1),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildEngravingWidget(state, controller, 4),
                        SizedBox(width: 60),
                        buildEngravingWidget(state, controller, 2),
                      ],
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget buildEngravingWidget(
    ProfileState state,
    ProfileController controller,
    int effectsIndex,
  ) {
    return Builder(
      builder: (context) {
        if(state.engravings!.arkPassiveEffects.length == effectsIndex){
          return Column(
            children: [
              Text('장착 X'),
              CircleAvatar(radius: 40),
              Container(height: 20),
              SizedBox(width: 16, height: 16)
            ],
          );
        }
        return Column(
          children: [
            Text(state.engravings!.arkPassiveEffects[effectsIndex].name),
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                controller.getEngravingsIcon(
                  state.engravings!.arkPassiveEffects[effectsIndex].name,
                )!,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 4; i++)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            i <
                                state
                                    .engravings!
                                    .arkPassiveEffects[effectsIndex]
                                    .level
                            ? state.engravings!.arkPassiveEffects[i].grade == '유물'
                                  ? AssetImage(
                                      'assets/images/engraving_grade_3.png',
                                    )
                                  : state.engravings!.arkPassiveEffects[i].grade ==
                                        '전설'
                                  ? AssetImage(
                                      'assets/images/engraving_grade_2.png',
                                    )
                                  : AssetImage(
                                      'assets/images/engraving_grade_1.png',
                                    )
                            : AssetImage('assets/images/engraving_level_off.png'),
                      ),
                    ),
                  ),
              ],
            ),
            state.engravings!.arkPassiveEffects[effectsIndex].abilityStoneLevel ==
                    null
                ? SizedBox(width: 16, height: 16)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/engrave_stone.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        'LV ${state.engravings!.arkPassiveEffects[effectsIndex].abilityStoneLevel}',
                      ),
                    ],
                  ),
          ],
        );
      }
    );
  }
}
