import 'package:alsaif_gallery/provider/CartProvider.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:alsaif_gallery/screens/checkout_screen.dart';
import 'package:alsaif_gallery/widgets/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
    required Null Function() onStartShoppingPressed,
    required List cart,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  String selectedCity = 'Riyadh';
  bool isExpanded = false;
  final List<String> cities = [
    'Riyadh',
    'Dammam',
    'Jeddah',
    'Madinah',
    'Tabuk',
    'Taif'
  ];
  final TextEditingController couponController = TextEditingController();
  final TextEditingController giftCardController = TextEditingController();

  String getDeliveryDate() {
    final now = DateTime.now();
    final deliveryDate = now.add(Duration(hours: 48));

    final List<String> weekdays = [
      'Mon',
      'Tues',
      'Wed',
      'Thur',
      'Fri',
      'Sat',
      'Sun'
    ];
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final weekday = weekdays[deliveryDate.weekday - 1];
    final day = deliveryDate.day;
    final month = months[deliveryDate.month - 1];
    final year = deliveryDate.year;

    return '$weekday $day $month $year';
  }

  String _getDayName(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    couponController.dispose();
    giftCardController.dispose();
    super.dispose();
  }

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
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(),
                        ),
                      );
                    },
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
        final double price = (product['price'] is num)
            ? product['price'].toDouble()
            : double.tryParse(product['price'].toString()) ?? 0.0;
        final int qty = item['quantity'] ?? 1;
        totalPrice += price * qty;
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
              height: 33,
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (cart.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  if (totalWithVAT < 1000)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Want ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FadeTransition(
                          opacity: _blinkController,
                          child: Text(
                            'Free Shipping? ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Text(
                          'Add ',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${(1000 - totalWithVAT).toStringAsFixed(2)} SAR',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' more to your cart',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Congrats! You\'ve got Free Shipping!',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                      ),
                    ),
                  SizedBox(height: 12),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (totalWithVAT / 1000).clamp(0.0, 1.0),
                          backgroundColor: Color.fromARGB(255, 243, 243, 243),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            totalWithVAT >= 1000 ? Colors.green : Colors.red,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        left: (MediaQuery.of(context).size.width - 56) *
                            (totalWithVAT / 1000).clamp(0.0, 1.0),
                        top: -8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.local_shipping,
                            size: 16,
                            color: totalWithVAT >= 1000
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: cart.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/cartno.png',
                        height: 240,
                        width: 800,
                      ),
                      Text(
                        'Your cart is empty! Add products you want to your cart.',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Find the MainScreen and set its index to home (0)
                          final mainScreenState = context
                              .findAncestorStateOfType<MainScreenState>();
                          if (mainScreenState != null) {
                            mainScreenState
                                .onTabSelected(0); // 0 is the index for home
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 185, 41, 30),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 90, vertical: 13),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          'Continue Shopping',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      ...cart.map((item) {
                        final product = item['product'];
                        print(
                            'Cart Item Product: $product'); // Debug print for entire product
                        final imageUrl = product['image'];
                        print(
                            'Cart Item Image URL: $imageUrl'); // Debug print for image URL

                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          color: Colors.white,
                          child: Stack(
                            children: [
                              ListTile(
                                leading: Container(
                                  width: 75,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: imageUrl != null && imageUrl.isNotEmpty
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print(
                                                'Error loading image: $error');
                                            return Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey[400],
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey[400],
                                        ),
                                ),
                                title: Text(
                                  product['name'] ?? 'Unknown Product',
                                  style: TextStyle(fontSize: 12),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Color : ${product['color']}'),
                                    SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 243, 243, 243),
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      left: Radius.circular(4)),
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(
                                                minWidth: 25,
                                                minHeight: 25,
                                              ),
                                              icon: const Icon(Icons.remove,
                                                  size: 15,
                                                  color: Colors.black),
                                              onPressed: () {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .updateQuantity(
                                                        product['id'], -1);
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Center(
                                              child: Text(
                                                '${item['quantity']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 243, 243, 243),
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(4)),
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(
                                                minWidth: 25,
                                                minHeight: 25,
                                              ),
                                              icon: const Icon(Icons.add,
                                                  size: 15,
                                                  color: Colors.black),
                                              onPressed: () {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .updateQuantity(
                                                        product['id'], 1);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -4,
                                right: -4,
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.grey),
                                  onPressed: () {
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .removeItem(product['id']);
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Text(
                                  '${product['price']} SAR',
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      if (cart.isNotEmpty) SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 9),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 250, 225),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Deliver to: ',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 10,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: selectedCity,
                                  icon: Icon(Icons.arrow_drop_down, size: 22),
                                  iconSize: 16,
                                  underline: SizedBox(),
                                  isDense: true,
                                  items: cities.map((String city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(
                                        city,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedCity = newValue;
                                      });
                                    }
                                  },
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'to be delivered by ',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  '${getDeliveryDate()} ',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  'order in ',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '48 Hour',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 9),
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 16),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 247, 247, 247),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3),
                                    topRight: Radius.circular(3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Do you have a coupon or a Gift card?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 20,
                                      color: Colors.grey[700],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  if (isExpanded) ...[
                                    SizedBox(height: 16),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: couponController,
                                              decoration: InputDecoration(
                                                hintText: 'Enter coupon code',
                                                hintStyle:
                                                    TextStyle(fontSize: 12),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: Colors.grey[300]!,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Handle coupon application
                                              },
                                              child: Text(
                                                'Apply',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: giftCardController,
                                              decoration: InputDecoration(
                                                hintText: 'Enter gift card',
                                                hintStyle:
                                                    TextStyle(fontSize: 12),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: Colors.grey[300]!,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Handle gift card application
                                              },
                                              child: Text(
                                                'Apply',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        '${totalWithVAT.toStringAsFixed(2)} SAR',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Discount',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        '-0.00 SAR',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${totalWithVAT.toStringAsFixed(2)} SAR',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 9),
                        child: const Image(
                          image: AssetImage('assets/images/paymeth.PNG'),
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: cart.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showBottomSheet(context, totalWithVAT),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              backgroundColor: const Color.fromARGB(255, 185, 29, 18),
            )
          : null,
    );
  }
}
