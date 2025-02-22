import 'package:pos/domain/entities/sale.dart';
import '../../data/repositories/sale_repository.dart';

class AddSaleUsecase {
  final SaleRepository repository;
  AddSaleUsecase(this.repository);
  Future<void> execute(Sale sale) async{
    await repository.insertSale(sale);
  }
}