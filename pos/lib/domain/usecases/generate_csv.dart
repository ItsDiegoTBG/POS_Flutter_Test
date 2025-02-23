
import '../../data/repositories/sale_repository.dart';

class GenerateCsv {
final SaleRepository repository;

  GenerateCsv(this.repository);

  Future<String> execute() async{
    return repository.generateCSV();
  }


}