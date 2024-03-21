import 'package:flutter/material.dart';
import 'package:myshopadminapp/models/dashboard_bttn_model.dart';
import 'package:myshopadminapp/provider/theme_provider.dart';
import 'package:myshopadminapp/services/asset_manager.dart';
import 'package:myshopadminapp/widgets/dashboard_button.dart';
import 'package:myshopadminapp/widgets/title.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({Key? key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitleTextWidget(label: "Dashboard Screen"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.logoImage),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(
                  themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(themeProvider.getIsDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 100 / 55,
        ),
        itemCount: DashboardButtonsModel.dashboardBtnList(context).length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 100, right: 100),
            child: DashBoardButtonWidget(
              imagePath: DashboardButtonsModel.dashboardBtnList(context)[index]
                  .imagePath,
              text: DashboardButtonsModel.dashboardBtnList(context)[index].text,
              onPressed: DashboardButtonsModel.dashboardBtnList(context)[index]
                  .onPressed,
            ),
          );
        },
      ),
    );
  }
}
