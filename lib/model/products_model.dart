class Product {
  Product({
    required this.id,
    required this.productName,
    required this.modelNumber,
    required this.price,
    required this.description,
    required this.manufactureDate,
    required this.manufactureAddress,
  });
  late final int id;
  late final String productName;
  late final String modelNumber;
  late final String price;
  late final String description;
  late final String manufactureDate;
  late final String manufactureAddress;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    modelNumber = json['model_number'];
    price = json['price'];
    description = json['description'];
    manufactureDate = json['manufacture_date'];
    manufactureAddress = json['manufactureAddress'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['product_name'] = productName;
    _data['model_number'] = modelNumber;
    _data['price'] = price;
    _data['description'] = description;
    _data['manufacture_date'] = manufactureDate;
    _data['manufactureAddress'] = manufactureAddress;
    return _data;
  }
}
