import '../../domain/entities/sale.dart';
import '../database_helper.dart';

class SaleRepository {

  Future<void> insertSale(Sale sale) async {
    final db = await DatabaseHelper.instance.db;
    
    int saleId = await db.insert('sales', {
    'timestamp': sale.timestamp.toIso8601String(),
    'totalPrice': sale.totalPrice,
    });

    for (SaleItem item in sale.items) {
    await db.insert('sale_items', {
      'sale_id': saleId,
      'product_id': item.productId,
      'name': item.name,
      'quantity': item.quantity,
      'price': item.price,
    });
  }}

  Future<List<Sale>> getAllSales() async {
  final db = await DatabaseHelper.instance.db;
  List<Map<String, dynamic>> salesData = await db.query('sales');

  List<Sale> salesList = [];

  for (var saleMap in salesData) {
    int saleId = saleMap['id'];
    List<Map<String, dynamic>> itemsData = await db.query(
      'sale_items',
      where: 'sale_id = ?',
      whereArgs: [saleId],
    );

    List<SaleItem> saleItems = itemsData.map((item) => SaleItem.fromMap(item)).toList();
    salesList.add(Sale.fromMap(saleMap, saleItems));
  }

  return salesList;
}

//This Should Work because of the ON DELETE CASCADE thing that was 
// declared previously

Future<void> deleteSale(int saleId) async {
  final db = await DatabaseHelper.instance.db;
  await db.delete('sales', where: 'id = ?', whereArgs: [saleId]);
}

}