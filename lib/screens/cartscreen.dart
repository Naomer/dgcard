import 'package:alsaif_gallery/provider/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
    required Null Function() onStartShoppingPressed,
    required List cart,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _showBottomSheet(BuildContext context, double totalWithVAT) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('(Includes VAT)', style: TextStyle(fontSize: 12)),
                  Text(
                    '${totalWithVAT.toStringAsFixed(2)} SAR',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.apple, color: Colors.white, size: 20),
                    label: Text(
                      'Pay   ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(140, 50),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Complete Order',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 182, 43, 33),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(140, 50),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cartItems;
    double totalPrice = 0;

    for (var item in cart) {
      final product = item['product'];
      if (product != null && product['price'] != null) {
        totalPrice += product['price'] * item['quantity'];
      }
    }

    final double totalWithVAT = totalPrice * 1.15;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/loggo.png',
              height: 45,
            ),
            const SizedBox(width: 12),
            Text(
              'Cart ${cart.isEmpty ? 0 : cart.length} product(s)',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty!'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                final product = item['product'];
                final imageUrl = product != null &&
                        product['imageIds'] != null &&
                        product['imageIds'] is List &&
                        product['imageIds'].isNotEmpty
                    ? product['imageIds'][0]
                    : null;

                return ListTile(
                  leading: imageUrl != null
                      ? Image.network(imageUrl)
                      : const Icon(Icons.image_not_supported),
                  title: Text(product?['name'] ?? 'Unknown Product'),
                  subtitle: Text('Quantity: ${item['quantity'] ?? 0}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .removeItem(product?['id']);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.black),
                        onPressed: () {
                          if (item['quantity'] != null &&
                              item['quantity'] > 1) {
                            Provider.of<CartProvider>(context, listen: false)
                                .updateQuantity(product?['id'], -1);
                          }
                        },
                      ),
                      Text(
                        '${item['quantity'] ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .updateQuantity(product?['id'], 1);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: cart.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showBottomSheet(context, totalWithVAT),
              child: const Icon(Icons.shopping_cart),
              backgroundColor: const Color.fromARGB(255, 218, 71, 60),
            )
          : null,
    );
  }
}
