import 'package:cjylostark/feature/armories/domain/gem_model.dart';
import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser;

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
        Text(
          '피해 증가 보석 : ${state.damageGemMap == null ? 0 : state.damageGemMap!.length}개',
        ),
        buildGemColumn(state, controller, state.damageGemMap),

        Text(
          '재사용 대기시간 감소 보석 : ${state.cooldownGemMap == null ? 0 : state.cooldownGemMap!.length}개',
        ),
        buildGemColumn(state, controller, state.cooldownGemMap),
      ],
    );
  }

  Column buildGemColumn(
    ProfileState state,
    ProfileController controller,
    Map<Gem, GemSkill>? gemMap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          gemMap?.entries.map((entry) {
            final gem = entry.key; // Gem 객체
            final skill = entry.value; // GemSkill 객체

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // Gem 아이콘
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: NetworkImage(gem.icon), // 보석 아이콘
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Gem 정보 (이름 + 스킬 옵션 등)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.extractText(gem.name),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(skill.icon),
                            ),
                            SizedBox(width: 4),
                            Text(skill.name),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList() ??
          [], // damageGemMap이 null이면 빈 리스트
    );
  }
}
