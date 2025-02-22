import '../../data/repositories/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  Future<int> execute(int productId) async {
    return repository.deleteProduct(productId);
  }
}