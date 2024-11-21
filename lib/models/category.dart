class Category {
  final String id;
  final String categoryName;
  final String categoryLogo;

  Category(
      {required this.id,
      required this.categoryName,
      required this.categoryLogo});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      categoryName: json['name'],
      categoryLogo: json['logo'],
    );
  }
}
