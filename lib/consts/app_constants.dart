import 'package:flutter/material.dart';

class AppConstants {
  static const String imageUrl =
      'http://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';
  static List<String> categoryList = [
    'Phones',
    'Laptops',
    'Electronics',
    'Watches',
    'Clothes',
    'Shoes',
    'Books',
    'Cosmetics',
    "Accessories",
  ];
  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItems =
        List<DropdownMenuItem<String>>.generate(
      categoryList.length,
      (index) => DropdownMenuItem(
        value: categoryList[index],
        child: Text(
          categoryList[index],
        ),
      ),
    );
    return menuItems;
  }
}
