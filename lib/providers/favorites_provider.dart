import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];

  List<String> get favoriteIds => _favoriteIds;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList('favoriteIds') ?? [];
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    // Optimistic update
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();

    // Persist in background
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteIds', _favoriteIds);
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }
}
