import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myshopadminapp/provider/order_provider.dart';
import 'package:myshopadminapp/provider/products_provider.dart';
import 'package:myshopadminapp/provider/theme_provider.dart';
import 'package:myshopadminapp/screens/edit_upload_product_screen.dart';
import 'package:myshopadminapp/Orders/order_screen.dart';
import 'package:myshopadminapp/screens/edit_screen.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(
                    snapshot.error.toString(),
                  ),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return ThemeProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ProductsProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return OrderProvider();
              }),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'ADMIN APP',
                theme: Styles.themeData(
                    isDarkTheme: themeProvider.getIsDarkTheme,
                    context: context),
                home: const DashboardScreen(),
                routes: {
                  SearchScreen.routeName: (context) => const SearchScreen(),
                  EditOrUploadProductScreen.routeName: (context) =>
                      const EditOrUploadProductScreen(),
                  OrdersScreenFree.routeName: (context) =>
                      const OrdersScreenFree(),
                },
              );
            }),
          );
        });
  }
}
