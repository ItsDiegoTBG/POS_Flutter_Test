import 'package:flutter/material.dart';
import 'package:pos/domain/usecases/fetch_products_usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';

class ProductProvider extends ChangeNotifier{
  final AddProductUsecase addProductUseCase;
  final DeleteProductUsecase deleteProductUseCase;
  final FetchProductsUsecase fetchProductsUsecase;

  List<Product> _products = [];
  List<Product> get products => _products;


  Future<List<Product>> fetchProducts() async {
    _products = await fetchProductsUsecase.execute(); 
    return _products;
  }

  ProductProvider(
   this.addProductUseCase,
   this.deleteProductUseCase,
   this.fetchProductsUsecase
  );
    Future<void> addProduct(Product product) async {
    await addProductUseCase.execute(product);
    fetchProducts();
        notifyListeners();
  }

  Future<void> deleteProduct(int productId) async {
    await deleteProductUseCase.execute(productId);
    fetchProducts();
    notifyListeners();
  }

}