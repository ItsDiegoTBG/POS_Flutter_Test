import 'package:flutter/material.dart';
import 'package:pos/domain/entities/sale.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/prod_provider.dart';
import '../providers/sales_provider.dart';
import 'previous_sale_page.dart';

class UserHome extends StatefulWidget {

  @override
  UserHomeState createState() => UserHomeState();
}

class UserHomeState extends State<UserHome> {
  Map<Product, int> selectedProducts = {}; // Stores products & their quantitiess
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

void _exportCSV() async {
  final saleProvider = Provider.of<SalesProvider>(context, listen: false); 
  String filePath = await saleProvider.generateCSV();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("CSV file saved at: $filePath"),
      action: SnackBarAction(
        label: "Open",
        onPressed: () {
          // Optionally, open the file using a file manager
        },
      ),
    ),
  );
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
    selectedProducts.clear(); // Clear the selection before repeating
    for (SaleItem si in sale.items) {
      Product? matchingProduct = products.firstWhere(
        (p) => p.name == si.name && p.price == si.price,
        orElse: () => Product(id: -1, name: si.name, price: si.price),
      );
      
      if (matchingProduct.id != -1) {
        selectedProducts[matchingProduct] = si.quantity;
      }
    }
  });
}

    return Scaffold(
      appBar: AppBar(title: Text("Sales")),
      body: Column(
        children: [
         ElevatedButton(
      onPressed: () async {
        final Sale? selectedSale = await Navigator.push<Sale?>(
          context,
          MaterialPageRoute(builder: (context) => PreviousSalePage()),
        );

        if (selectedSale != null) {
         repeatSale(selectedSale);
        }
      },
      child: Text("View Previous Sales"),
        ) ,
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];

                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
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
                            SnackBar(content: Text("Sale Confirmed!")),
                          );
                        }
                      : null,
                  child: Text("Confirm Sale"),
                ),
        ElevatedButton(
          onPressed: _exportCSV,
          child: Text("Export Sales to CSV"),
        ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
