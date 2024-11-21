import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  int get cartItemCount => _cartItems.length;

  void addToCart(Map<String, dynamic> product, int quantity) {
    _cartItems.add({...product, 'quantity': quantity});
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int change) {
    final productIndex =
        _cartItems.indexWhere((item) => item['id'] == productId);

    if (productIndex >= 0) {
      _cartItems[productIndex]['quantity'] += change;

      if (_cartItems[productIndex]['quantity'] <= 0) {
        _cartItems.removeAt(productIndex);
      }
      notifyListeners();
    } else {
      print("Product not found in cart.");
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
