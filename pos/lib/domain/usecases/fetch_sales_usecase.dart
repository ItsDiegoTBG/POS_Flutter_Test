import '../../data/repositories/sale_repository.dart';
import '../entities/sale.dart';

class FetchSalesUsecase {
  final SaleRepository repository;

  FetchSalesUsecase(this.repository);

  Future<List<Sale>> execute() async{
    return repository.getAllSales();
  }


}