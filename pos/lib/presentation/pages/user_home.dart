import 'package:flutter/material.dart';
import 'package:pos/domain/entities/sale.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/prod_provider.dart';
import '../providers/sales_provider.dart';
import 'previous_sale_user_page.dart';

class UserHome extends StatefulWidget {

  @override
  UserHomeState createState() => UserHomeState();
}

class UserHomeState extends State<UserHome> {
  Map<Product, int> selectedProducts = {}; 
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



  @override
  Widget build(BuildContext context) {
  double totalPrice = selectedProducts.entries.fold(
      0, 
      (sum, entry) => sum + (entry.key.price * entry.value),
    );

  void addSale()async{
  final saleProvider = Provider.of<SalesProvider>(context, listen: false);
  saleProvider.saveSale(selectedProducts,totalPrice);

  }

    //First We get the Items from the sale, then turn does into products, and add them to the list with thier quantity.
void repeatSale(Sale sale) {
    setState(() {
    selectedProducts.clear(); 
    for (SaleItem si in sale.items) {
      Product? matchingProduct = products.firstWhere(
        (p) => p.name == si.name && p.price == si.price,
      );
      
      if (matchingProduct.id != -1) {
        selectedProducts[matchingProduct] = si.quantity;
      }
    }
  });
}

int _selectedIndex = 0;

Future<void> _onItemTapped(int index) async {
  setState(() {
    _selectedIndex = index;
  });

  if (index == 1) {
    final Sale? selectedSale = await Navigator.push<Sale?>(
      context,
      MaterialPageRoute(builder: (context) => PreviousSaleUserPage()),
    );
    if (selectedSale != null) {
      repeatSale(selectedSale);
    }
  }
}

return Scaffold(
    appBar: AppBar(title: Text("Ventas"),backgroundColor: Colors.blue,foregroundColor: Colors.white,),
    body: Column(
      children: [
        ElevatedButton(
  onPressed: () async {
    final Sale? selectedSale = await Navigator.push<Sale?>(
      context,
      MaterialPageRoute(builder: (context) => PreviousSaleUserPage()),
    );
    if (selectedSale != null) {
      repeatSale(selectedSale);
    }
  },
  child: Text("Cargar una Venta Pasada"),
),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];

              return ListTile(
                title: Text(product.name),
                subtitle: Text(
                  '\$${product.price.toStringAsFixed(2)}\n${product.description}\nSKU: ${product.SKU}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (selectedProducts.containsKey(product) && selectedProducts[product]! > 0) {
                            selectedProducts[product] = selectedProducts[product]! - 1;
                            if (selectedProducts[product] == 0) {
                              selectedProducts.remove(product);
                            }
                          }
                        });
                      },
                    ),
                    Text(selectedProducts[product]?.toString() ?? "0"),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          selectedProducts[product] = (selectedProducts[product] ?? 0) + 1;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Total: \$${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: selectedProducts.isNotEmpty
                    ? () {
                        addSale();
                        setState(() {
                          selectedProducts.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Venta confirmada")),
                        );
                      }
                    : null,
                child: Text("Confirmar Venta"),
              ),
            ],
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Ventas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historial de ventas',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    ),
  );
  }
}
