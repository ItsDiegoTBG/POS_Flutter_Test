import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

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
      'description':item.description,
      'SKU': item.SKU
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
    // THIS LINE
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


Future<String> generateCSV() async {
   final sales = await getAllSales();

  // CSV Header
  List<List<String>> csvData = [
    ['Sale ID', 'Timestamp', 'Products', 'Total Price']
  ];

  for (var sale in sales) {
    int? saleId = sale.id;
    String timestamp = sale.timestamp.toIso8601String();

    //I think We need to fix up Product before We continue on, that or We leave the lines commented.

    // Fetch sale items linked to this sale
    final saleItems = sale.items;

    List<String> productDetails = [];
    double totalPrice = 0;

    for (var item in saleItems) {

      int quantity = item.quantity;
      String productName = item.name;
      double price = item.price;
      double total = price * quantity;
      productDetails.add("$productName x$quantity");
      totalPrice += total;
    }

    // Add row to CSV
    csvData.add([saleId.toString(), timestamp, productDetails.join(', '), totalPrice.toStringAsFixed(2)]);
  }

  // Convert to CSV format
  String csvString = const ListToCsvConverter().convert(csvData);

  // Save file to storage
  final directory = await getExternalStorageDirectory();
  if (directory == null) {
    throw Exception("Failed to get external storage directory.");
  }
  
  final path = '${directory.path}/sales_report.csv';
  final File file = File(path);
  await file.writeAsString(csvString);

  return path; // Return the file path
}

}