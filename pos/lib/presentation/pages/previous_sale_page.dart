import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/sale.dart';
import '../providers/sales_provider.dart';

class PreviousSalePage extends StatefulWidget{
  @override
  PreviousSalePageState createState() => PreviousSalePageState();
}

class PreviousSalePageState extends State<PreviousSalePage>{
  List<Sale> previousSales = []; 

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    final saleProvider = Provider.of<SalesProvider>(context, listen: false);
    var salesObtained = await saleProvider.fetchSales(); 
    setState(() {
      previousSales =  salesObtained;
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
    
        },
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {
  final salesProvider = Provider.of<SalesProvider>(context, listen: false);

  return Scaffold(
    appBar: AppBar(title: Text("Previous Sales")),
    body: Column(
      children: [
        Expanded(
          child: previousSales.isEmpty
              ? Center(child: Text("No previous sales found"))
              : ListView.builder(
                  itemCount: previousSales.length,
                  itemBuilder: (context, index) {
                    final sale = previousSales[index];

                    return ListTile(
                      title: Text("Sale #${sale.id} - \$${sale.totalPrice.toStringAsFixed(2)}"),
                      subtitle: Text("Date: ${sale.timestamp}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Delete Sale"),
                                  content: Text("Are you sure you want to delete this sale?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text("Delete"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmDelete) {
                                await salesProvider.deleteSale(sale.id);
                                setState(() {
                                  previousSales.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Sale deleted successfully")),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context, sale);
                      },
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _exportCSV,
            child: Text("Exportar ventas a CSV"),
          ),
        ),
      ],
    ),
  );
}


  }