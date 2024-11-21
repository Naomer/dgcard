class Product {
  final String name;
  final String adjective;
  final double price;
  final int stockQuantity;
  final double averageRating;
  final List<String> imageUrls;

  Product({
    required this.name,
    required this.adjective,
    required this.price,
    required this.stockQuantity,
    required this.averageRating,
    required this.imageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      adjective: json['adjective'] ?? '',
      price: json['price'].toDouble(),
      stockQuantity: json['stockQuantity'],
      averageRating: json['averageRating']?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
    );
  }
}
