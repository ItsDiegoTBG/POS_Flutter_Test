import '../../data/repositories/product_repository.dart';
import '../entities/product.dart';

class AddProductUsecase{
  final ProductRepository repository;

  AddProductUsecase(this.repository);

  Future<void> execute(Product product) async{
    await repository.insertProduct(product);
  }
}