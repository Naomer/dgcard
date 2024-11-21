import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteProducts;

  const FavoritesScreen({super.key, required this.favoriteProducts});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> cartItems = [];

  void moveToCart(Map<String, dynamic> product) {
    setState(() {
      widget.favoriteProducts.remove(product);
      cartItems.add(product);
    });
  }

  void removeFromFavorites(Map<String, dynamic> product) {
    setState(() {
      widget.favoriteProducts.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/favlog.png',
          height: 120,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 1.0,
            color: Colors.grey[300],
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: widget.favoriteProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/favo.png',
                          height: 240,
                          width: 800,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Choose your favorite products you like now to buy them later whenever you want',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 167, 15, 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 90, vertical: 13),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'Start Shopping',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.favoriteProducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget.favoriteProducts[index]['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Price: \$${widget.favoriteProducts[index]['price']}'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 163, 22, 12),
                              ),
                              child: const Text(
                                'Move to Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        leading: Image.network(
                          widget.favoriteProducts[index]['imageIds'][0],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 128, 126, 126)),
                          onPressed: () {
                            removeFromFavorites(widget.favoriteProducts[index]);
                          },
                        ),
                      );
                    },
                  ),
          ),
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Products in Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: cartItems.map((cartItem) {
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(cartItem['name']),
                          subtitle: Text('Price: \$${cartItem['price']}'),
                          leading: Image.network(
                            cartItem['imageIds'][0],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
