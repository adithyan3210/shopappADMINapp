import 'package:flutter/material.dart';
import 'package:myshopadminapp/screens/edit_screen.dart';
import 'package:myshopadminapp/screens/edit_upload_product_screen.dart';
import 'package:myshopadminapp/Orders/order_screen.dart';
import 'package:myshopadminapp/services/asset_manager.dart';

class DashboardButtonsModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });
  static List<DashboardButtonsModel> dashboardBtnList(context) => [
        DashboardButtonsModel(
          text: "Add New Product",
          imagePath: AssetsManager.add,
          onPressed: () {
            Navigator.pushNamed(context, EditOrUploadProductScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "Inspect products",
          imagePath: AssetsManager.editProduct,
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "View orders",
          imagePath: AssetsManager.order,
          onPressed: () {
            Navigator.pushNamed(context, OrdersScreenFree.routeName);
          },
        ),
      ];
}
