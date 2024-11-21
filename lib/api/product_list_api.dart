import 'dart:convert';
import 'package:alsaif_gallery/api/product_service.dart';
import 'package:alsaif_gallery/models/product.dart';

class ProductListApi {
  final ProductService productService;

  ProductListApi({required this.productService});

  Future<List<Product>> fetchProducts(
    int page, {
    int size = 10,
    String? color,
    String? productSize,
    String? brand,
    String? material,
    double? minPrice,
    double? maxPrice,
    String? category,
    bool hasDiscount = true,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
        'color': color ?? '',
        'productSize': productSize ?? '',
        'brand': brand ?? '',
        'material': material ?? '',
        'minPrice': minPrice?.toString() ?? '',
        'maxPrice': maxPrice?.toString() ?? '',
        'category': category ?? '',
        'hasDiscount': hasDiscount.toString(),
      };

      final response = await productService.get(
        '/api/v1/product/getAllProducts',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['products'] != null && data['products'] is List) {
          List<Product> products = (data['products'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
          return products;
        } else {
          throw Exception('"products" is not a list or is null');
        }
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
