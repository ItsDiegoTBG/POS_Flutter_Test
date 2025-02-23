import 'package:flutter/material.dart';
import 'package:pos/presentation/pages/user_home.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/sale.dart';
import '../providers/sales_provider.dart';

class PreviousSaleUserPage extends StatefulWidget{
  @override
  PreviousSalePageState createState() => PreviousSalePageState();
}

class PreviousSalePageState extends State<PreviousSaleUserPage>{
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
      content: Text("Archivo CSV guardado en: $filePath"),
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
    appBar: AppBar(title: Text("Historial de Ventas"),backgroundColor: Colors.blue,foregroundColor: Colors.white,),
    body: Column(
      children: [
        Expanded(
          child: previousSales.isEmpty
              ? Center(child: Text("Ninguna venta encontrada"))
              : ListView.builder(
                  itemCount: previousSales.length,
                  itemBuilder: (context, index) {
                    final sale = previousSales[index];

                    return ListTile(
                      title: Text("Venta #${sale.id} - \$${sale.totalPrice.toStringAsFixed(2)}"),
                      subtitle: Text("Dia: ${sale.timestamp}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Borrar Venta"),
                                  content: Text("Vas a borrar esta venta, estas seguro?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text("Borrar"),
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
                                  SnackBar(content: Text("Venta borrada exitosamente")),
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
bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, 
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserHome()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Productos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historial de ventas",
          ),
        ],
      ),
  );
}


  }