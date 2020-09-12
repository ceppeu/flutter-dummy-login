import 'dart:convert';
import 'dart:io';

import 'package:form_validation/src/models/product_model.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ProductsProvider {
  final String _url = 'https://flutter-e7485.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/productos.json';
    final res = await http.post(url, body: productModelToJson(product));
    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final url = '$_url/productos/${product.id}.json';
    final res = await http.put(url, body: productModelToJson(product));
    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductModel>> getProducts() async {
    final url = '$_url/productos.json';
    final res = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(res.body);
    final List<ProductModel> products = new List();
    if (decodedData == null) return [];
    decodedData.forEach((key, value) {
      final prodTmp = ProductModel.fromJson(value);
      prodTmp.id = key;
      products.add(prodTmp);
    });
    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_url/productos/$id.json';
    final res = await http.delete(url);
    print(json.decode(res.body));
    return 1;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/ds6bnmwii/image/upload?upload_preset=rvtd2zst');
    final mimeType = mime(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final res = await http.Response.fromStream(streamResponse);
    if (res.statusCode != 200 && res.statusCode != 201) {
      print('Algo salió mal');
      print(res.body);
      return null;
    }
    final responseData = json.decode(res.body);
    print(responseData);
    return responseData['secure_url'];
  }
}
