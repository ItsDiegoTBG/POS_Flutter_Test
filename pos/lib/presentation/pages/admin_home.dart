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

  // TODO Puede ver un listado de las ventas pasadas. Entonces copia y pega el codigo de userhome. Listo
  // TODO En caso de que se intente registrar un SKU ya existente, se deberá mostrar un mensaje de error. 

  void _addProduct() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final description = _descriptionController.text;
    final SKU = _SKUController.text;

    if (name.isNotEmpty && price > 0) {
      final product = Product(name: name, price: price, description: description, SKU: SKU);
      Provider.of<ProductProvider>(context, listen: false).addProduct(product);
      _nameController.clear();
      _priceController.clear();
      _SKUController.clear();
      _descriptionController.clear();
    }
    _loadProducts();
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
