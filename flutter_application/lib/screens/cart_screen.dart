import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) {
                      final item = cartItems[i];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: item.product.imageUrl != null
                              ? Image.network(item.product.imageUrl!, width: 50, fit: BoxFit.cover)
                              : Icon(Icons.image_not_supported),
                          title: Text(item.product.name),
                          subtitle: Text(
                            '₹${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => cartProvider.decreaseQuantity(item.product.id),
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => cartProvider.increaseQuantity(item.product.id),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => cartProvider.removeFromCart(item.product.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('₹${cartProvider.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 18, color: Colors.green)),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Checkout not implemented yet')),
                            );
                          },
                          child: Text('Checkout'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
