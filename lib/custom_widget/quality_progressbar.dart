import 'package:flutter/material.dart';

class QualityProgressbar extends StatelessWidget {
  final int qualityValue;
  final Color progressColor;

  const QualityProgressbar({
    super.key,
    required this.qualityValue,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 54,
          height: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: qualityValue / 100,
              minHeight: 10,
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ),
        Text(
          '$qualityValue',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
