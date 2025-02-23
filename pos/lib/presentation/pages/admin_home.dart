import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/sale.dart';
import '../providers/prod_provider.dart';
import '../../domain/entities/product.dart';
import 'previous_sale_page.dart';

class AdminHome extends StatefulWidget {
  @override
  AdminHomeState createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _SKUController = TextEditingController();
  List<Product> products = [];


  @override
  void initState() {
    super.initState();
  _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    var productsObtained = await productProvider.fetchProducts(); 
    setState(() {
      products =  productsObtained ;
    });
  }


  void _addProduct() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final description = _descriptionController.text;
    final SKU = _SKUController.text;

    if (name.isNotEmpty && price > 0) {
      final product = Product(name: name, price: price, description: description, SKU: SKU);
      if(!checkDuplicateProducts(product)){
        Provider.of<ProductProvider>(context, listen: false).addProduct(product);
      }
      else{
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
          content: Text("Ya existe un Producto con ese SKU"),
      ),
    );
      }
      _nameController.clear();
      _priceController.clear();
      _SKUController.clear();
      _descriptionController.clear();
    }
    _loadProducts();
  }

  bool checkDuplicateProducts(Product product){
    for (Product proList in products){
      if (proList.SKU == product.SKU){
        return true;
      }
    }
    return false;
  }



  void _deleteProduct(int id) {
    Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(title: Text('Admin Home')),
      body: Column(
        children: [ElevatedButton(
      onPressed: () async {
          Navigator.push<Sale?>(
          context,
          MaterialPageRoute(builder: (context) => PreviousSalePage()),
        );
      },
      child: Text("Ver ventas pasadas"),
        ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre del Producto'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripcion'),
                ),
                TextField(
                  controller: _SKUController,
                  decoration: InputDecoration(labelText: 'SKU'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: Text('Añadir Producto'),
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(child: Text('No hay productos disponibles'))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text( '\$${product.price.toStringAsFixed(2)}\n${product.description}\nSKU: ${product.SKU}',
                        style: TextStyle(color: Colors.grey[700])), // Optional styling
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
