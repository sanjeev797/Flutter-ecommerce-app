import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/product.dart';
import '../screens/edit_product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  Widget _buildProductImage(String imageUrl) {
    try {
      final decodedBytes = base64Decode(imageUrl);
      return Image.memory(
        decodedBytes,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } catch (e) {
      // If decoding fails, show a fallback icon
      return Icon(Icons.broken_image, size: 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 3,
      child: ListTile(
        leading: product.imageUrl != null && product.imageUrl!.isNotEmpty
            ? _buildProductImage(product.imageUrl!)
            : Icon(Icons.image_not_supported, size: 40),
        title: Text(product.name),
        subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProductScreen(product: product),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: onAddToCart,
            ),
          ],
        ),
      ),
    );
  }
}
