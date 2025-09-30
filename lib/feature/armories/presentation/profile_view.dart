import 'package:cjylostark/constants/app_colors.dart';
import 'package:cjylostark/constants/app_text_style.dart';
import 'package:cjylostark/custom_widget/custom_loading_widget.dart';
import 'package:cjylostark/custom_widget/grade_container.dart';
import 'package:cjylostark/custom_widget/quality_progressbar.dart';
import 'package:cjylostark/custom_widget/search_textfield.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/domain/character_profile.dart';
import 'package:cjylostark/feature/armories/presentation/ark_grid_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/ark_passive_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/engravings_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/equipment_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/gem_tab_view.dart';
import 'package:cjylostark/feature/armories/presentation/profile_controller.dart';
import 'package:cjylostark/feature/armories/presentation/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:html/parser.dart' as html_parser; // html 파서 사용

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState createState() => _ProfileView();
}

class _ProfileView extends ConsumerState<ProfileView> {
  TextEditingController nickController = TextEditingController();
  ProfileParms? parms;

  @override
  Widget build(BuildContext context) {
    return buildProfileBody();
  }

  Widget buildProfileBody() {
    final state = ref.watch(profileControllerProvider);
    if (state.profileLoading) {
      return buildProfileLoadingView();
    } else if (state.profile == null) {
      return buildSearchProfileView();
    } else {
      return buildProfile();
    }
  }

  Widget buildProfileLoadingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Row(), CustomLoadingWidget()],
    );
  }

  Widget buildSearchProfileView() {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/thank_kong.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomSearchTextField(
              controller: nickController,
              onSearch: () async {
                await controller.searchProfile(nickController.text.trim());
              },
            ),
          ),

          SizedBox(height: 24),
          Text(
            "최근 검색 닉네임",
            style: AppTextStyle.titleSmallBoldStyle.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              if (state.recentSearchNickname == null ||
                  state.recentSearchNickname!.isEmpty) {
                return Container();
              } else {
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    for (int i = 0; i < state.recentSearchNickname!.length; i++)
                      buildRecentContainer(i),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Padding buildRecentContainer(int i) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          controller.searchProfile(state.recentSearchNickname![i]);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.green10,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              state.recentSearchNickname![i],
              style: AppTextStyle.bodyMediumStyle.copyWith(
                color: AppColors.green400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfile() {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    final profile = ref.watch(profileControllerProvider).profile;
    final equipment = ref.watch(profileControllerProvider).equipment;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.backGround,
        appBar: AppBar(
          backgroundColor: AppColors.backGround,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),

            onPressed: () {
              controller.tabBackButton();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: AppColors.backGround,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      buildCharacterNameRow(profile),

                      buildProfileRow(profile, controller),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              buildTabBar(controller, profile),
              state.tabBarIndex == 0
                  ? EquipmentTabView()
                  : state.tabBarIndex == 1
                  ? GemTabView()
                  : state.tabBarIndex == 2
                  ? EngravingsTabView()
                  : state.tabBarIndex == 3
                  ? ArkPassiveTabView()
                  : ArkGridTabView(),
            ],
          ),
        ),
      ),
    );
  }

  TabBar buildTabBar(ProfileController controller, CharacterProfile? profile) {
    return TabBar(
      labelColor: AppColors.green400,
      unselectedLabelColor: AppColors.gray500,
      indicatorColor: AppColors.green400,
      dividerColor: AppColors.backGround,
      padding: EdgeInsets.zero,
      // 👈 전체 좌우 여백 제거
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      indicatorPadding: EdgeInsets.zero,
      // 👈 인디케이터 여백 제거
      labelPadding: EdgeInsets.symmetric(horizontal: 16),
      // 👈 탭 간 간격만 주기
      onTap: (index) {
        controller.changeTabBarIndex(index, profile!.characterName);
      },
      tabs: [
        Tab(text: '장비'),
        Tab(text: '보석'),
        Tab(text: '각인'),
        Tab(text: '아크패시브'),
        Tab(text: '아크그리드'),
      ],
    );
  }

  Row buildProfileRow(CharacterProfile? profile, ProfileController controller) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(profile!.characterImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 21,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '서버',
                      style: AppTextStyle.bodyMediumStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  profile.serverName,
                  style: AppTextStyle.bodyMediumStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Container(
                  height: 21,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '클래스',
                      style: AppTextStyle.bodyMediumStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      profile.characterClassName,
                      style: AppTextStyle.bodyMediumStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    controller.extractTier4NodeName() == null
                        ? Container()
                        : Text(
                            ' - ',
                            style: AppTextStyle.bodyMediumStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                    controller.extractTier4NodeName() == null
                        ? Container()
                        : Text(
                            controller.extractTier4NodeName()!,
                            style: AppTextStyle.bodyMediumStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Container(
                  height: 21,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '원대랩',
                      style: AppTextStyle.bodyMediumStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  profile.expeditionLevel.toString(),
                  style: AppTextStyle.bodyMediumStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Container(
                  height: 21,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '아이템',
                      style: AppTextStyle.bodyMediumStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  profile.itemAvgLevel,
                  style: AppTextStyle.bodyMediumStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            profile.combatPower == null
                ? Container()
                : Row(
                    children: [
                      Container(
                        height: 21,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '전투력',
                            style: AppTextStyle.bodyMediumStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        profile.combatPower.toString(),
                        style: AppTextStyle.bodyMediumStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 6),
            profile.guildName == null
                ? Container()
                : Row(
                    children: [
                      Container(
                        height: 21,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '길드',
                            style: AppTextStyle.bodyMediumStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        profile.guildName.toString(),
                        style: AppTextStyle.bodyMediumStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 6),
            Row(
              children: [
                Container(
                  height: 21,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '영지',
                      style: AppTextStyle.bodyMediumStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${profile.townName} - LV ${profile.townLevel.toString()}',
                  style: AppTextStyle.bodyMediumStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Row buildCharacterNameRow(CharacterProfile? profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: profile!.title == null ? 0 : 20),
          child: Text(
            profile.title ?? '',
            style: AppTextStyle.headlineSmallBoldStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),

        Text(
          profile.characterName,
          style: AppTextStyle.headlineSmallBoldStyle.copyWith(
            color: Colors.white,
          ),
        ),
      ],
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

  @override
  void initState() {
    super.initState();
    parms = ProfileParms(context: context, ref: ref);
    ref.read(profileControllerProvider.notifier).getRecentSearchNickname();
  }
}

class TooltipText extends StatelessWidget {
  final String rawHtml;

  const TooltipText(this.rawHtml, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: _parseHtmlToSpans(rawHtml)),
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }

  List<InlineSpan> _parseHtmlToSpans(String htmlString) {
    final document = html_parser.parse(htmlString);
    final spans = <InlineSpan>[];

    for (var node in document.body!.nodes) {
      if (node.nodeType == 3) {
        spans.add(
          TextSpan(
            text: node.text,
            style: AppTextStyle.labelMediumStyle.copyWith(color: Colors.white),
          ),
        );
      } else if (node.nodeType == 1) {
        final element = node as dynamic;
        switch (element.localName) {
          case "br":
            spans.add(const TextSpan(text: "\n"));
            break;

          case "font":
            final colorAttr = element.attributes['color'];
            Color textColor = Colors.white;

            if (colorAttr != null) {
              try {
                final hex = colorAttr.replaceAll('#', '').toUpperCase();
                textColor = Color(int.parse("0xFF$hex"));
              } catch (_) {}
            }

            spans.addAll([
              TextSpan(
                text: element.text,
                style: AppTextStyle.labelMediumStyle.copyWith(color: textColor),
              ),
            ]);
            break;

          default:
            spans.add(
              TextSpan(
                text: element.text,
                style: AppTextStyle.labelMediumStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            );
        }
      }
    }

    return spans;
  }
}
