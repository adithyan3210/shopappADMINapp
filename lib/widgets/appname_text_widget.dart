import 'package:flutter/material.dart';
import 'package:myshopadminapp/widgets/title.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({super.key, this.fontSize = 30});
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 5),
        baseColor: Colors.purple,
        highlightColor: Colors.red,
        child: TitleTextWidget(
          label: "Shop Smart",
          fontSize: fontSize,
        ));
  }
}
