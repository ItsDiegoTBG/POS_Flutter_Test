class Sale {
  final int? id;
  final int productId;
  final int quantity;
  final double totalPrice;
  final String date;

  Sale({
    this.id,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'date': date,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      productId: map['productId'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      date: map['date'],
    );
  }
}
