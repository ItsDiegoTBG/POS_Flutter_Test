class Product {
  final int? id;
  final String name;
  final double price;
  final String description;
  final String SKU; //Special ID.

  //producto a ingresar (nombre, descripción, precio, SKU). CAMBIAR

  Product({this.id, required this.name, required this.price,required this.description, required this.SKU} );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description':description,
      'SKU':SKU
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      description: map['description'],
      SKU: map['SKU']
    );
  }
}
