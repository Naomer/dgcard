class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String? description; // Made description optional

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.description, // Added optional parameter for description
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String, // Ensure correct type
      name: json['name'] as String,
      imageUrl: json['image'] as String,
      price: (json['price'] as num).toDouble(), // Cast to num for safety
      description: json['description'] as String?, // Optional description
    );
  }
}
