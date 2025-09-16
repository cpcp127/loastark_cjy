import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
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
    return Builder(
      builder: (context) {
        if (state.engravings == null ||
            state.engravings!.arkPassiveEffects.isEmpty) {
          return Container();
        } else {
          return Column(
            children: [
              for (
                int i = 0;
                i < state.engravings!.arkPassiveEffects.length;
                i++
              )
                Row(
                  children: [
                    Text(state.engravings!.arkPassiveEffects[i].name),
                    state.engravings!.arkPassiveEffects[i].abilityStoneLevel ==
                            null
                        ? Container()
                        : Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/engrave_stone.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                'LV ${state.engravings!.arkPassiveEffects[i].abilityStoneLevel}',
                              ),
                            ],
                          ),

                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/engrave_level.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          'X ${state.engravings!.arkPassiveEffects[i].level}',
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          );
        }
      },
    );
  }
}
