import 'package:cjylostark/custom_widget/search_textfield.dart';
import 'package:cjylostark/dio/base_dio_api.dart';
import 'package:cjylostark/feature/armories/data/armories_repository.dart';
import 'package:cjylostark/feature/armories/presentation/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  TextEditingController nickController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ProfileView();
  }
}
