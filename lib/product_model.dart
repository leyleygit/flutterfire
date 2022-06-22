class ProductModel {
  final String name;
  final num cost, price, qty;

  ProductModel(
      {required this.name,
      required this.cost,
      required this.price,
      required this.qty});

  factory ProductModel.fromJson(json) {
    return ProductModel(
        name: json['name'],
        cost: json['cost'],
        price: json['price'],
        qty: json['qty']);
  }
}
