import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api/products'; // for emulator

  // GET: Fetch all products
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST: Add a product
  static Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  // PUT: Update a product
  static Future<void> updateProduct(Product product) async {
    final url = '$baseUrl/${product.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  // DELETE: Remove a product
  static Future<void> deleteProduct(String id) async {
    final url = '$baseUrl/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
