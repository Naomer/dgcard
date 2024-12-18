import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  int get cartItemCount => _cartItems.length;

  void addToCart(Map<String, dynamic> product, int quantity) {
    // Check if product already exists in cart
    final existingItemIndex = _cartItems.indexWhere(
        (item) => item['product']['id'] == product['id']);

    if (existingItemIndex != -1) {
      // If product exists, increase quantity
      _cartItems[existingItemIndex]['quantity'] += quantity;
    } else {
      // If product doesn't exist, add new item
      _cartItems.add({
        'product': product,
        'quantity': quantity,
      });
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.removeWhere((item) => item['product']['id'] == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int change) {
    final productIndex =
        _cartItems.indexWhere((item) => item['product']['id'] == productId);

    if (productIndex >= 0) {
      _cartItems[productIndex]['quantity'] += change;

      if (_cartItems[productIndex]['quantity'] <= 0) {
        _cartItems.removeAt(productIndex);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
