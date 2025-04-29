import 'package:flutter/material.dart';
import 'package:flutter_application/services/api_service.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  // Getter to fetch the products list
  List<Product> get products => _products;

  // Getter to check the loading state
  bool get isLoading => _isLoading;

  // Fetch the products from the API
  Future<void> fetchProducts() async {
    _isLoading = true;  // Set loading state
    notifyListeners();  // Notify UI that loading has started

    try {
      _products = await ApiService.getProducts(); // Fetch products
    } catch (e) {
      print('Fetch error: $e');
    }

    _isLoading = false;  // Set loading state to false
    notifyListeners();  // Notify UI that loading has finished and products are fetched
  }

  // Add a new product
  Future<void> addProduct(Product product) async {
    try {
      final newProduct = await ApiService.addProduct(product); // Call API to add product
      _products.add(newProduct); // Add new product to the list
      notifyListeners();  // Notify UI to rebuild
    } catch (e) {
      print('Add error: $e');
    }
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    try {
      await ApiService.updateProduct(product); // Call API to update product
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product; // Update product in the list
        notifyListeners(); // Notify UI to rebuild
      }
    } catch (e) {
      print('Update error: $e');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      await ApiService.deleteProduct(id); // Call API to delete product
      _products.removeWhere((p) => p.id == id); // Remove product from the list
      notifyListeners(); // Notify UI to rebuild
    } catch (e) {
      print('Delete error: $e');
    }
  }

  // Find a product by ID
  Product findById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }
}
