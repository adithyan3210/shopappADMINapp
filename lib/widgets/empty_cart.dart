import 'package:flutter/material.dart';
import 'package:myshopadminapp/main.dart';
import 'package:myshopadminapp/widgets/subtitle.dart';
import 'package:myshopadminapp/widgets/title.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.buttonText,
  });

  final String imagePath, title, subTitle, buttonText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: size.height * 0.35,
            ),
          ),
          const TitleTextWidget(
            label: "Whoops",
            color: Colors.red,
            fontSize: 40,
          ),
          const SizedBox(height: 20),
          const SubTitleTextWidget(
            label: "Your Cart Is Empty",
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SubTitleTextWidget(
              label:
                  "look Like Your Cart Is Empty Add Something And Make me Happy",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                )),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return const MyApp();
                },
              ));
            },
            child: const Text("Shop Now"),
          )
        ],
      ),
    );
  }
}
