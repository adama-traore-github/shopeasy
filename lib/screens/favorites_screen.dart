import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopease/providers/favorites_provider.dart';
import 'package:shopease/providers/product_provider.dart';
import 'package:shopease/screens/home_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: Consumer2<FavoritesProvider, ProductProvider>(
        builder: (context, favoritesProvider, productProvider, child) {
          final favoriteIds = favoritesProvider.favoriteIds;
          final products = productProvider.products
              .where((product) => favoriteIds.contains(product.id))
              .toList();

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'Aucun favori pour le moment',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
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
          );
        },
      ),
    );
  }
}
