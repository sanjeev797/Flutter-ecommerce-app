import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  String? imageUrl;
  late double price;

  @override
  void initState() {
    super.initState();
    name = widget.product.name;
    description = widget.product.description;
    imageUrl = widget.product.imageUrl;
    price = widget.product.price;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedProduct = Product(
        id: widget.product.id,
        name: name,
        description: description,
        imageUrl: imageUrl,
        price: price,
      );

      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(updatedProduct)
          .then((_) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                initialValue: imageUrl,
                decoration: InputDecoration(labelText: 'Image URL'),
                onSaved: (value) => imageUrl = value!,
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.tryParse(value!) ?? 0.0,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Update Product'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
