import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shopease/models/category.dart';
import 'package:shopease/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  ProductProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load products
      final String productsString = await rootBundle.loadString(
        'assets/data/products.json',
      );
      final List<dynamic> productsJson = json.decode(productsString);
      _products = productsJson
          .map(
            (json) => Product(
              id: json['id'],
              name: json['name'],
              description: json['description'],
              price: (json['price'] as num).toDouble(),
              imageUrl: json['imageUrl'],
              categoryId: json['categoryId'],
              isFeatured: json['isFeatured'] ?? false,
            ),
          )
          .toList();

      // Load categories
      final String categoriesString = await rootBundle.loadString(
        'assets/data/categories.json',
      );
      final List<dynamic> categoriesJson = json.decode(categoriesString);
      _categories = categoriesJson
          .map(
            (json) => Category(
              id: json['id'],
              name: json['name'],
              imageUrl: json['imageUrl'],
            ),
          )
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Product> get featuredProducts {
    return _products.where((p) => p.isFeatured).toList();
  }

  List<Product> get nonFeaturedProducts {
    return _products.where((p) => !p.isFeatured).toList();
  }

  List<Product> getProductsByCategory(String categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];
    return _products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
