import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease/models/category.dart';
import 'package:shopease/providers/product_provider.dart';
import 'package:shopease/screens/home_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final Category category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.getProductsByCategory(category.id);

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: products.isEmpty
          ? const Center(child: Text('No products found in this category'))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
    );
  }
}
