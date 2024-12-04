import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool get isLoggedIn => _token != null;
  String? get token => _token;

  void login(String token) {
    _token = token;
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}

class FavoriteProvider with ChangeNotifier {
  List<int> _favoriteProducts = [];

  List<int> get favoriteProducts => _favoriteProducts;

  void addToFavorites(int productId) {
    _favoriteProducts.add(productId);
    notifyListeners();
  }

  void removeFromFavorites(int productId) {
    _favoriteProducts.remove(productId);
    notifyListeners();
  }
}
