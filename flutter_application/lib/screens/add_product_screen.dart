import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String? imageUrl = '';
  double price = 0.0;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newProduct = Product(
        id: '',
        name: name,
        description: description,
        imageUrl: imageUrl == '' ? null : imageUrl,
        price: price,
      );

      Provider.of<ProductProvider>(context, listen: false)
          .addProduct(newProduct)
          .then((_) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.redAccent.withOpacity(0.3),
        title: Text(
          'Add Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.redAccent,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange.shade100, Colors.orange.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  label: 'Name',
                  onSaved: (value) => name = value!,
                  validator: (value) => value!.isEmpty ? 'Enter product name' : null,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  label: 'Description',
                  onSaved: (value) => description = value!,
                  maxLines: 3,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  label: 'Image URL (optional)',
                  onSaved: (value) => imageUrl = value!,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  label: 'Price',
                  onSaved: (value) => price = double.tryParse(value!) ?? 0.0,
                  validator: (value) => value!.isEmpty ? 'Enter price' : null,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: _submit,
                  child: Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.redAccent),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
