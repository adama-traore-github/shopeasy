import 'package:flutter/material.dart';
import 'package:shopease/screens/cart_screen.dart';
import 'package:shopease/screens/main_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String cart = '/cart';
  static const String categoryProducts = '/category-products';
  static const String productDetail = '/product-detail';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const MainScreen(),
    cart: (context) => const CartScreen(),
  };

  // Note: categoryProducts and productDetail might need arguments,
  // so we may use onGenerateRoute if needed, but for simple mock let's stick to this or custom navigation.
}
