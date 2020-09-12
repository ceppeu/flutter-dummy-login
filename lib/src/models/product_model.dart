import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String title;
  double value;
  bool available;
  String imageUrl;

  ProductModel({
    this.id,
    this.title = '',
    this.value = 0.0,
    this.available = true,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        value: json["value"],
        available: json["available"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "available": available,
        "imageUrl": imageUrl,
      };
}
