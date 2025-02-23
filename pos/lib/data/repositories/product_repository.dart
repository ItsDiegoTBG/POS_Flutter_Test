import '../database_helper.dart';
import '../../domain/entities/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository{
Future<int> insertProduct(Product product) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert('products', product.toMap());
  }

  Future<void> initializeProducts() async {
    List<Product> productToAdd = [
      Product(name: 'Leche', price: 1.0, description: "1 Litro Leche Toni de Carton ",SKU: "LTONI1"),
      Product(name: 'Arroz', price: 11.00, description: "1 Arroba Arroz OSO",SKU: "AROSO1A"),
      Product(name: 'Azucar', price: 1.00, description: "1 KG Azucar San Carlos",SKU: "AZSC1K"),
      Product(name: 'Carne', price: 3.00, description: "1 KG de Carne de Res",SKU: "MOOMOO1KG"),
      Product(name: 'Chorizo', price: 1.50, description: "200 g Chorizo Paiza Juris",SKU: "CHORIZO1"),
    ];

    for (Product product in productToAdd) {
      await insertProduct(product);
    }
  }
  

  Future<Product?> getProduct(String name) async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.query(
      'products',
      where: 'username = ?',
      whereArgs: [name],
    );

    if (result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  Future<List<Product>> getAllProducts() async {
  final db = await DatabaseHelper.instance.db;
  final List<Map<String, dynamic>> maps = await db.query('products');

  return List.generate(maps.length, (i) {
    return Product.fromMap(maps[i]);
  });
}

    Future<int> deleteProduct(int id) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delateProducts(int ammount) async {
    for (int f=0; f<ammount;f++) {
      await deleteProduct(f);
    }
  }

}