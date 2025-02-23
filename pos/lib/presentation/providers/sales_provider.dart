import 'package:flutter/material.dart';
import 'package:pos/domain/usecases/add_sale_usecase.dart';
import 'package:pos/domain/usecases/delete_sale_usecase.dart';
import 'package:pos/domain/usecases/fetch_sales_usecase.dart';
import 'package:pos/domain/usecases/generate_csv.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/sale.dart';


class SalesProvider with ChangeNotifier {
  final AddSaleUsecase addSaleUsecase;
  final DeleteSaleUsecase deleteSaleUsecase;
  final FetchSalesUsecase fetchSalesUsecase;
  final GenerateCsv generateCsv;

  SalesProvider(
    this.addSaleUsecase,
    this.deleteSaleUsecase,
    this.fetchSalesUsecase,
    this.generateCsv
  );

  List<Sale> _sales = [];
  List<Sale> get sales => _sales;

  void saveSale(Map<Product, int> info, double totalPrice) async{
    List<SaleItem> list = createSaleItems(info);
    Sale sale = Sale(
    timestamp: DateTime.now(),
    totalPrice: totalPrice,
    items: list
    ); 
    //add here the insert sale.
    await addSaleUsecase.execute(sale);
    notifyListeners();
  }

  List<SaleItem> createSaleItems(Map<Product, int> info){
    List<SaleItem> list = [];
    info.forEach((product, amount) => list.add(
      SaleItem(saleId: 0, productId: product.id, name: product.name, quantity: amount, price: product.price,description: product.description,SKU: product.SKU)
    )
    );

    return list;
  }

  Future<List<Sale>> fetchSales() async {
    _sales = await fetchSalesUsecase.execute(); 
    return _sales;
  }

  Future<void> deleteSale(int? saleId) async {
    await deleteSaleUsecase.execute(saleId!);
    fetchSales();
    notifyListeners();
  }

  Future<String> generateCSV() async {
   return await generateCsv.execute();
  }

}