class Product {
  final String id;
  final String name;
  final String description;
  final String? imageUrl; // optional
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'], // could be null
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
