class Product {
  final int? id;
  final String name;
  final double price;

  //producto a ingresar (nombre, descripción, precio, SKU). CAMBIAR

  Product({this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }
}
