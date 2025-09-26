import 'package:cjylostark/constants/app_colors.dart';
import 'package:cjylostark/custom_widget/search_textfield.dart';
import 'package:cjylostark/dio/base_dio_api.dart';
import 'package:cjylostark/feature/armories/data/armories_repository.dart';
import 'package:cjylostark/feature/armories/presentation/profile_view.dart';
import 'package:cjylostark/feature/stone/stone_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  TextEditingController nickController = TextEditingController();
  int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: buildBottomNavigationBar(),
          body: IndexedStack(
            index: bottomIndex,
            children: [ProfileView(), StoneView(), Container()],
          ),
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: bottomIndex,
      elevation: 0,
      enableFeedback: false,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.green400,

      onTap: (index) {
        setState(() {
          bottomIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '프로필'),
        BottomNavigationBarItem(icon: Icon(Icons.hardware), label: '스톤 세공'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: '기타'),
      ],
    );
  }
}
