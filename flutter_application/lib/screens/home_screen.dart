import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../screens/edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  String sortOption = 'None';

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    List filteredProducts = productProvider.products.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (sortOption == 'Price: Low to High') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == 'Price: High to Low') {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.redAccent.withOpacity(0.3),
        title: Text(
          'GadgetHub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.redAccent,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.redAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  );
                },
              ),
              if (cartProvider.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      cartProvider.items.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange.shade100, Colors.orange.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: productProvider.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 3,
                ),
              )
            : productProvider.products.isEmpty
                ? Center(
                    child: Text(
                      'No products found!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        // 🔍 Search bar and Sort Dropdown
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search products...',
                                  prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.redAccent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.redAccent),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            DropdownButton<String>(
                              value: sortOption,
                              borderRadius: BorderRadius.circular(12),
                              items: [
                                'None',
                                'Price: Low to High',
                                'Price: High to Low'
                              ].map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value, style: TextStyle(fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  sortOption = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        // 🛍 Products Grid
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (ctx, i) {
                              final product = filteredProducts[i];
                              return Card(
                                elevation: 8,
                                shadowColor: Colors.redAccent.withOpacity(0.25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    gradient: LinearGradient(
                                      colors: [Colors.white, Colors.orange.shade50],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: product.imageUrl != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.network(
                                                    product.imageUrl!,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                                                ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.grey[800],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          '₹${product.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit, color: Colors.orange[700]),
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
                                              icon: Icon(Icons.delete, color: Colors.redAccent),
                                              onPressed: () async {
                                                await Provider.of<ProductProvider>(context, listen: false)
                                                    .deleteProduct(product.id);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add_shopping_cart, color: Colors.red),
                                              onPressed: () {
                                                cartProvider.addToCart(product);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Added to cart'),
                                                    backgroundColor: Colors.redAccent,
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        elevation: 5,
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
