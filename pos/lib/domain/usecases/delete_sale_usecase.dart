import '../../data/repositories/sale_repository.dart';

class DeleteSaleUsecase {
  final SaleRepository repository;

  DeleteSaleUsecase(this.repository);

  Future<void> execute(int saleId) async {
    return repository.deleteSale(saleId);
  }
}