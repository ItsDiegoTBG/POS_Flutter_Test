class Sale {
  final int? id;
  final DateTime timestamp;
  final double totalPrice;
  final List<SaleItem> items;

  Sale({
    this.id,
    required this.timestamp,
    required this.totalPrice,
    required this.items,
  });

  Map<String, dynamic> toMap() {
 return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'totalPrice': totalPrice,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map, List<SaleItem> items) {
    return Sale(
      id: map['id'],
      timestamp: DateTime.parse(map['timestamp']),
      totalPrice: map['totalPrice'],
      items: items,
    );
  }
}

class SaleItem{
  final int? id;
  final int saleId;
  final int? productId;
  final String name;
  final int quantity;
  final double price;
  final String description;
  final String SKU;

   SaleItem({
    this.id,
    required this.saleId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.description, 
    required this.SKU
  });

  Map<String, dynamic> toMap(int saleId) {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'description':description,
      'SKU':SKU
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'],
      saleId: map['sale_id'],
      productId: map['product_id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      description: map['description'], //this line
      SKU: map['SKU']
    );
  }
}