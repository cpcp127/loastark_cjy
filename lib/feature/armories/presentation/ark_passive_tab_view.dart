import 'package:cjylostark/constants/app_text_style.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
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
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                state.arkPassive!.points[i].name,
                                style: AppTextStyle.labelMediumStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${state.arkPassive!.points[i].value}P',
                                style: AppTextStyle.labelMediumStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                state.arkPassive!.points[i].description,
                                style: AppTextStyle.labelMediumStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          for (
                            int l = 0;
                            l < state.arkPassive!.effects.length;
                            l++
                          )
                            state.arkPassive!.effects[l].name ==
                                    state.arkPassive!.points[i].name
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundImage: NetworkImage(
                                            state.arkPassive!.effects[l].icon,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        TooltipText(
                                          state
                                              .arkPassive!
                                              .effects[l]
                                              .description,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                        ],
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
