import 'package:cjylostark/feature/armories/domain/ark_passive_model.dart';
import 'package:cjylostark/feature/armories/domain/engravings_model.dart';
import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:cjylostark/feature/armories/presentation/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArkPassiveTabView extends ConsumerStatefulWidget {
  const ArkPassiveTabView({super.key});

  @override
  ConsumerState createState() => _ArkPassiveTabViewState();
}

class _ArkPassiveTabViewState extends ConsumerState<ArkPassiveTabView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    return Column(
      children: [
        state.arkPassive == null
            ? Column()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < state.arkPassive!.points.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(state.arkPassive!.points[i].name),
                            SizedBox(width: 10),
                            Text('${state.arkPassive!.points[i].value}P'),
                            SizedBox(width: 10),
                            Text(state.arkPassive!.points[i].description),
                          ],
                        ),
                        for (
                          int l = 0;
                          l < state.arkPassive!.effects.length;
                          l++
                        )
                          state.arkPassive!.effects[l].name ==
                                  state.arkPassive!.points[i].name
                              ? Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(
                                        state.arkPassive!.effects[l].icon,
                                      ),
                                    ),
                                    TooltipText(
                                      state.arkPassive!.effects[l].description,
                                    ),
                                  ],
                                )
                              : Container(),
                      ],
                    ),
                ],
              ),
      ],
    );
  }
}
