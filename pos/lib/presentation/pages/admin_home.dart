import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prod_provider.dart';
import '../../domain/entities/product.dart';

class AdminHome extends StatefulWidget {
  @override
  AdminHomeState createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProductsUsecase;
  }

  void _addProduct() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (name.isNotEmpty && price > 0) {
      final product = Product(name: name, price: price);
      Provider.of<ProductProvider>(context, listen: false).addProduct(product);
      _nameController.clear();
      _priceController.clear();
    }
  }

  void _deleteProduct(int id) {
    Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Admin Home')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
          Expanded(
            child: productProvider.products.isEmpty
                ? Center(child: Text('No products available'))
                : ListView.builder(
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(product.id!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
