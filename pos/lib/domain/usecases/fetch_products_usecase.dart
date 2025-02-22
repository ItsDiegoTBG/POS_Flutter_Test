

import '../../data/repositories/product_repository.dart';
import '../entities/product.dart';

class FetchProductsUsecase {
  final ProductRepository repository;

  FetchProductsUsecase(this.repository);

  Future<List<Product>> execute() async{
    return repository.getAllProducts();
  }


}