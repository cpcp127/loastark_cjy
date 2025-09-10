import 'package:flutter/material.dart';

class GradeContainer extends StatelessWidget {
  final String? grade;
  final String? icon;

  const GradeContainer({super.key, this.grade, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: grade == '고대'
              ? [
                  const Color(0xFF5C4825), // 좌상단: 짙은 갈색
                  const Color(0xFFE3C78A), // 우하단: 밝은 금색
                ]
              : grade == '유물'
              ? [
                  Color(0xFF371B09), // 상단 짙은 갈색 (예시 색상)
                  Color(0xFFA03F06), // 하단 밝은 갈색 (예시 색상)
                ]
              : grade == '전설'
              ? [
                  Color(0xFF3B2303), // 상단 짙은 갈색 (예시 색상)
                  Color(0xFF9C5E04), // 하단 밝은 갈색 (예시 색상)
                ]
              : grade == '영웅'
              ? [
                  Color(0xFF271332), // 상단 짙은 갈색 (예시 색상)
                  Color(0xFF470D5C), // 하단 밝은 갈색 (예시 색상)
                ]
              : grade == '에스더'
              ? [
                  Color(0xFF0E3432), // 상단 짙은 갈색 (예시 색상)
                  Color(0xFF2B9E9B), // 하단 밝은 갈색 (예시 색상)
                ]
              : [
                  Color(0xFF111F2D), // 상단 짙은 갈색 (예시 색상)
                  Color(0xFF113D5C), // 하단 밝은 갈색 (예시 색상)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(icon!), fit: BoxFit.cover),
      ),
    );
  }
}
