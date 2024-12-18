import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:alsaif_gallery/services/product_api.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;
  final String categoryName;

  const ProductsScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.categoryName,
  });

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List products = [];
  final ProductApi apiService = ProductApi();
  List<Map<String, dynamic>> favoriteProducts = [];
  String selectedSort = "Newest";
  bool isLoading = true;

  void addToFavorites(Map<String, dynamic> product) {
    setState(() {
      if (!favoriteProducts.contains(product)) {
        favoriteProducts.add(product);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await apiService.get(
      '/api/v1/product/getProductByCategories/${widget.subCategoryId}',
      queryParameters: {'sort': selectedSort},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data['data'];
        isLoading = false; // End loading state after fetching
      });

      // Apply local sorting for additional safety or API fallback
      applyLocalSort();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void applyLocalSort() {
    setState(() {
      if (selectedSort == "priceHighToLow") {
        products.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (selectedSort == "priceLowToHigh") {
        products.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (selectedSort == "popularity") {
        // Assuming 'popularity' is a field in the product data
        products.sort((a, b) => b['popularity'].compareTo(a['popularity']));
      }
    });
  }

  void showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Adjust the curve here
          ),
          title: Center(
            child: Text(
              'Sort By',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Popularity ListTile
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0), // Remove padding
                  title: Row(
                    children: [
                      Radio<String>(
                        value: "popularity",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                          fetchProducts();
                          Navigator.pop(context);
                        },
                        activeColor: const Color.fromARGB(255, 158, 37, 28),
                      ),
                      Text(
                        'Popularity',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 107, 107, 107),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedSort = "popularity";
                    });
                    fetchProducts();
                    Navigator.pop(context);
                  },
                ),
                // Short divider
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: 177,
                        color: const Color.fromARGB(255, 209, 209, 209),
                      ),
                    ],
                  ),
                ),
                // Price: High to Low ListTile
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0), // Remove padding
                  title: Row(
                    children: [
                      Radio<String>(
                        value: "priceHighToLow",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                          fetchProducts();
                          Navigator.pop(context);
                        },
                        activeColor: const Color.fromARGB(255, 160, 39, 30),
                      ),
                      Text(
                        'Price: High to Low',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 107, 107, 107),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedSort = "priceHighToLow";
                    });
                    fetchProducts();
                    Navigator.pop(context);
                  },
                ),
                // Short divider
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: 177,
                        color: const Color.fromARGB(255, 209, 209, 209),
                      ),
                    ],
                  ),
                ),
                // Price: Low to High ListTile
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0), // Remove padding
                  title: Row(
                    children: [
                      Radio<String>(
                        value: "priceLowToHigh",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                          fetchProducts();
                          Navigator.pop(context);
                        },
                        activeColor: const Color.fromARGB(255, 160, 35, 26),
                      ),
                      Text(
                        'Price: Low to High',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 117, 117, 117),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedSort = "priceLowToHigh";
                    });
                    fetchProducts();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/loggo.png', height: 33),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 35.0,
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Find it here...',
                        hintStyle:
                            TextStyle(fontSize: 13.0, color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 14.0),
                        suffixIcon: Icon(Icons.search,
                            color: Colors.grey[600], size: 20.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: Color.fromARGB(255, 204, 204, 204),
            thickness: 1.1,
            height: 1.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  widget.categoryName,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  '${products.length} products',
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Color.fromARGB(255, 109, 109, 109),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: const [
                  Divider(
                    color: Color.fromARGB(255, 219, 219, 219),
                    thickness: 1.0,
                  ),
                  SizedBox(height: 30.0),
                  Divider(
                    color: Color.fromARGB(255, 219, 219, 219),
                    thickness: 1.0,
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                color: Color.fromARGB(255, 248, 248, 248),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: showSortDialog,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Row(
                          children: const [
                            Icon(Icons.sort_sharp,
                                size: 23.0,
                                color: Color.fromARGB(255, 138, 138, 138)),
                            SizedBox(width: 3.0),
                            Text(
                              'Sort',
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Color.fromARGB(255, 80, 80, 80)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 45.0,
                      color: const Color.fromARGB(255, 214, 214, 214),
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Row(
                        children: const [
                          Icon(Icons.filter_alt_outlined,
                              size: 23.0,
                              color: Color.fromARGB(255, 138, 138, 138)),
                          SizedBox(width: 3.0),
                          Text(
                            'Filter',
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(255, 80, 80, 80)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: SizedBox(
                        height: 220,
                        width: 220,
                        child: const Image(
                          image: AssetImage('assets/images/loading-gif.gif'),
                        ),
                      ),
                    ),
                  )
                : products.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: SingleChildScrollView(
                            // Wrap with SingleChildScrollView to prevent overflow
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min, // Keep content centered
                              children: [
                                SizedBox(
                                  height: 240, // Adjust size of the image
                                  width: 240,
                                  child: const Image(
                                    image: AssetImage(
                                        'assets/images/cartman.png!bw700'),
                                    fit: BoxFit.contain,
                                  ),
                                ), // Spacing between image and text
                                const Text(
                                  "Oops! No products found in this category.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 5),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final hasDiscount = product.containsKey('discount') &&
                              product['discount'] != null;
                          final hasDiscountPercentage =
                              product.containsKey('discountPercentage') &&
                                  product['discountPercentage'] != null;

                          final averageRating =
                              product['ratings']?['averageRating'] ?? 0;
                          final numberOfRatings =
                              product['ratings']?['numberOfRatings'] ?? 0;
                          final brand = product['additionalInformation']
                                  ?['brand'] ??
                              'Unknown';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productId: product['_id'],
                                    product: product,
                                    onCompletePurchase: () {},
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 184, 183, 183),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          product['imageIds'][0],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          product['name'],
                                          style: const TextStyle(),
                                        ),
                                      ),
                                      if (hasDiscount)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '${product['price']}',
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'SAR ${product['discount'] ?? product['price']}',
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 194, 6, 6),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Color.fromARGB(
                                                  255, 248, 229, 61),
                                              size: 16.0,
                                            ),
                                            Text(
                                              '$averageRating          ($numberOfRatings ratings)',
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '$brand',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (hasDiscountPercentage)
                                    Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 2.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 194, 6, 6),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Text(
                                          '${product['discountPercentage']}% \nOFF',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    top: 0.0,
                                    right: 0.0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        color: Color.fromARGB(255, 143, 77, 77),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
