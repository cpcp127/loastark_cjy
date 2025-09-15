import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GemTabView extends ConsumerStatefulWidget {
  const GemTabView({super.key});

  @override
  ConsumerState createState() => _GemTabViewState();
}

class _GemTabViewState extends ConsumerState<GemTabView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print(state.gem);
          },
          child: Container(width: 100, height: 100, color: Colors.red),
        ),
        Text('피해 증가 보석 : ${state.damageGemMap==null?0:state.damageGemMap!.length}개'),

        Text('재사용 대기시간 감소 보석 : ${state.cooldownGemMap==null?0:state.cooldownGemMap!.length}개'),
      ],
    );
  }
}
