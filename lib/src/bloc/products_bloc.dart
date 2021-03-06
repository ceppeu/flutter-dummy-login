import 'dart:io';

import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {
  final _productsController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void getProducts() async {
    final products = await _productsProvider.getProducts();
    _productsController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  Future<String> uploadImage(File image) async {
    _loadingController.sink.add(true);
    final imageUrl = await _productsProvider.uploadImage(image);
    _loadingController.sink.add(false);
    return imageUrl;
  }

  void updateProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct(String id) async {
    await _productsProvider.deleteProduct(id);
  }

  dispose() {
    _productsController?.close();
    _loadingController?.close();
  }
}
