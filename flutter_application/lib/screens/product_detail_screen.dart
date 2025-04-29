import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 3,
      child: ListTile(
        leading: product.imageUrl != null
            ? Image.network(product.imageUrl!, width: 50, fit: BoxFit.cover)
            : Icon(Icons.image_not_supported, size: 40),
        title: Text(product.name),
        subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: onAddToCart,
        ),
      ),
    );
  }
}
