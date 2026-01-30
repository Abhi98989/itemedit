class CustomDiscount {
  final String name;
  final double value;
  final String type;

  CustomDiscount({required this.name, required this.value, required this.type});

  factory CustomDiscount.fromMap(Map<String, dynamic> map) {
    return CustomDiscount(
      name: map['name'] ?? '',
      value: (map['value'] as num).toDouble(),
      type: map['type'] ?? 'percentage',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'value': value, 'type': type};
  }

  ///  discount list
  static final List<CustomDiscount> discountList = [
    CustomDiscount(name: 'Christmas Offer', value: 50, type: 'amount'),
    CustomDiscount(name: 'Weekend Offer', value: 10, type: 'percentage'),
    CustomDiscount(name: 'New Year Offer', value: 30, type: 'amount'),
  ];
}
