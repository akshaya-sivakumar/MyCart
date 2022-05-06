class Product {
  Product({
    this.productId,
    this.orderId,
    required this.productName,
    required this.modelNumber,
    required this.price,
    required this.category,
    required this.description,
    required this.manufactureDate,
    required this.manufactureAddress,
    this.userId,
  });
  int? productId;
  String? orderId;
  late final String productName;
  late final String modelNumber;
  late final String price;
  late final String category;
  late final String description;
  late final String manufactureDate;
  late final String manufactureAddress;
  String? userId;
  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    orderId = json['orderId'];
    productName = json['productName'];
    modelNumber = json['modelNumber'];
    price = json['price'];
    category = json['categoryName'];
    description = json['description'];
    manufactureDate = json['manufactureDate'];
    manufactureAddress = json['manufactureAddress'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (productId != null) _data['productId'] = productId;
    if (orderId != null) _data['orderId'] = orderId;
    _data['productName'] = productName;
    _data['modelNumber'] = modelNumber;
    _data['price'] = price;
    _data['categoryName'] = category;
    _data['description'] = description;
    _data['manufactureDate'] = manufactureDate;
    _data['manufactureAddress'] = manufactureAddress;
    if (userId != null) _data['userId'] = userId;
    return _data;
  }
}
