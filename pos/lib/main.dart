import 'package:flutter/material.dart';
import 'package:pos/data/repositories/user_repository.dart';
import 'package:pos/domain/usecases/add_product_usecase.dart';
import 'package:pos/domain/usecases/delete_product_usecase.dart';
import 'package:pos/domain/usecases/fetch_products_usecase.dart';
import 'package:pos/domain/usecases/generate_csv.dart';
import 'package:pos/presentation/providers/sales_provider.dart';
import 'package:provider/provider.dart';
import 'data/database_helper.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/sale_repository.dart';
import 'domain/usecases/add_sale_usecase.dart';
import 'domain/usecases/delete_sale_usecase.dart';
import 'domain/usecases/fetch_sales_usecase.dart';
import 'domain/usecases/login_user_usecase.dart';
import 'domain/usecases/register_user_usecase.dart';
import 'presentation/pages/inicial_page.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/prod_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.init();
  //commands to set up database Please dont uncomment unless new test setup
  //await UserRepository().delateUsers(100);
  //await UserRepository().initializeUsers();
  //await ProductRepository().initializeProducts();
  final authRepository = UserRepository();
  final loginUsecase = LoginUserUsecase(authRepository);
  final registerUsecase = RegisterUserUsecase(authRepository);
  final productRepository = ProductRepository();
  final addProductUsecase = AddProductUsecase(productRepository);
  final deleteProductUsecase = DeleteProductUsecase(productRepository);
  final fetchProductsUsecase = FetchProductsUsecase(productRepository);
  final saleRepository = SaleRepository();
  final addSaleUsecase = AddSaleUsecase(saleRepository);
  final deleteSaleUsecase = DeleteSaleUsecase(saleRepository);
  final fetchSalesUsecase = FetchSalesUsecase(saleRepository);
  final generateCsv = GenerateCsv(saleRepository);
   
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(loginUsecase,registerUsecase)),
        ChangeNotifierProvider(create: (context) => ProductProvider(addProductUsecase,deleteProductUsecase,fetchProductsUsecase)),
        ChangeNotifierProvider(create: (context) => SalesProvider(addSaleUsecase,deleteSaleUsecase,fetchSalesUsecase,generateCsv))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 241, 240, 244)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: InitialPage(),
    );
  }
}


