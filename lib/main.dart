import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease/providers/cart_provider.dart';
import 'package:shopease/providers/favorites_provider.dart';
import 'package:shopease/providers/orders_provider.dart';
import 'package:shopease/providers/product_provider.dart';
import 'package:shopease/routes.dart';
import 'package:shopease/constants/app_theme.dart';
import 'package:shopease/providers/theme_provider.dart';

void main() {
  runApp(const ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ShopEase',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.home,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
