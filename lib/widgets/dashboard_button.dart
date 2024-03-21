import 'package:flutter/material.dart';
import 'package:myshopadminapp/widgets/subtitle.dart';

class DashBoardButtonWidget extends StatelessWidget {
  const DashBoardButtonWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });
  final String text, imagePath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 65,
                height: 65,
              ),
              const SizedBox(height: 10),
              SubTitleTextWidget(label: text)
            ],
          ),
        ),
      ),
    );
  }
}
