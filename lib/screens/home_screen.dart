import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shopease/constants/colors.dart';
import 'package:shopease/providers/favorites_provider.dart';
import 'package:shopease/models/product.dart';
import 'package:shopease/providers/cart_provider.dart';
import 'package:shopease/providers/product_provider.dart';
import 'package:shopease/providers/theme_provider.dart';
import 'package:shopease/screens/category_products_screen.dart';
import 'package:shopease/screens/product_detail_screen.dart';
import 'package:shopease/routes.dart';
import 'package:shopease/utils/currency_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopEase'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.wb_sunny
                      : Icons.nightlight_round,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(LucideIcons.shoppingCart),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    if (cart.itemCount == 0) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final featuredProducts = productProvider.featuredProducts;
          final categories = productProvider.categories;

          // Determine content based on search query
          List<Product> searchResults = [];
          if (_searchQuery.isNotEmpty) {
            searchResults = productProvider.searchProducts(_searchQuery);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Rechercher un produit...',
                      prefixIcon: const Icon(LucideIcons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Theme.of(context).cardTheme.color,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // CONTENT: Either Search Results OR Default Home
                if (_searchQuery.isNotEmpty) ...[
                  // SEARCH RESULTS VIEW
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Résultats pour "$_searchQuery"',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (searchResults.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.searchX,
                              size: 60,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucun produit trouvé',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: searchResults[index]);
                      },
                    ),
                ] else ...[
                  // DEFAULT HOME VIEW

                  // Hero/Banner section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Nouvelle Collection',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Jusqu\'à -50% sur tout',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Acheter'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Categories section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Catégories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryProductsScreen(category: category),
                              ),
                            );
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage(category.imageUrl),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(16),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      category.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Featured Products section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Produits Vedettes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: featuredProducts.length,
                    itemBuilder: (context, index) {
                      final product = featuredProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
                  const SizedBox(height: 32),
                  // All Products section (excluding featured)
                  if (productProvider.nonFeaturedProducts.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Tous les produits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: productProvider.nonFeaturedProducts.length,
                      itemBuilder: (context, index) {
                        final product =
                            productProvider.nonFeaturedProducts[index];
                        return ProductCard(product: product);
                      },
                    ),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).cardTheme.shadowColor ??
                  Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-${product.id}',
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: AssetImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Consumer<FavoritesProvider>(
                        builder: (context, favorites, child) {
                          final isFavorite = favorites.isFavorite(product.id);
                          return GestureDetector(
                            onTap: () => favorites.toggleFavorite(product.id),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyHelper.format(product.price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
