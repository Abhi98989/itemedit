import 'package:flutter/material.dart';
import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

class Product {
  final String itemId;
  final String itemName;
  final String? itemImage;
  final String artNumber;
  final String categoryId;
  final String categoryName;
  final String unitId;
  final String unitAlias;
  final String costPrice;
  final String salesPrice;
  final String isDiscountable;
  final String itemWiseDiscount;
  final String requiredBatchExpiry;
  final String remainingStock;
  final String taxPer;
  final String barCode;
  final String batch;
  final String expiryDate;
  final String hasAttribute;
  final List<UnitPrice> unitPrice;
  final List<BatchExpiry> batchExpiry;
  final List<Attribute> attribute;
  final bool isWeight;

  Product({
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.artNumber,
    required this.categoryId,
    required this.categoryName,
    required this.unitId,
    required this.unitAlias,
    required this.costPrice,
    required this.salesPrice,
    required this.isDiscountable,
    required this.itemWiseDiscount,
    required this.requiredBatchExpiry,
    required this.remainingStock,
    required this.taxPer,
    required this.barCode,
    required this.batch,
    required this.expiryDate,
    required this.hasAttribute,
    required this.unitPrice,
    required this.batchExpiry,
    required this.attribute,
    this.isWeight = false,
  });

  // Backward compatibility getters
  String get name => itemName;
  double get price => double.tryParse(salesPrice) ?? 0.0;
  String get category => categoryName;
  String? get image => itemImage;
  String get sku => artNumber;
  String get description => "";
  Color get color => Colors.grey;
  bool get isWeightBased =>
      isWeight ||
      (unitAlias.toLowerCase() == 'kg' ||
          unitAlias.toLowerCase() == 'gm' ||
          unitAlias.toLowerCase() == 'gram');

  factory Product.fromJson(Map<String, dynamic> json) {
    dynamic rawAttribute = json["attribute"];
    if (rawAttribute is String) {
      try {
        rawAttribute = jsonDecode(rawAttribute);
      } catch (e) {
        rawAttribute = [];
      }
    }
    if (rawAttribute is! List) {
      rawAttribute = [];
    }
    return Product(
      itemId: json["itemId"] ?? json["Product_ID"]?.toString() ?? "0",
      itemName: json["itemName"] ?? json["Name"] ?? "",
      itemImage: json["itemImage"] ?? "",
      artNumber: json["artNumber"] ?? json["artNo"] ?? "",
      categoryId: json["categoryId"]?.toString() ?? "0",
      categoryName: json["categoryName"] ?? json["GroupName"] ?? "",
      unitId: json["unitId"]?.toString() ?? "0",
      unitAlias: json["unitAlias"] ?? json["UnitName"] ?? "",
      costPrice: json["costPrice"]?.toString() ?? "0",
      salesPrice:
          json["salesPrice"]?.toString() ??
          json["Salesprice_retail"]?.toString() ??
          "0",
      isDiscountable: json["isDiscountable"] ?? "No",
      itemWiseDiscount: json["itemWiseDiscount"]?.toString() ?? "0",
      requiredBatchExpiry: json["requiredBatchExpiry"] ?? "No",
      remainingStock: json["remainingStock"]?.toString() ?? "0",
      taxPer: json["taxPer"]?.toString() ?? "0",
      barCode: json["barCode"] ?? json["Barcode"] ?? "",
      batch: json["batch"] ?? "",
      expiryDate: json["expiryDate"] ?? "",
      unitPrice: json['jsonUnitPrice'] != null
          ? (jsonDecode(json['jsonUnitPrice']) as List)
                .map((e) => UnitPrice.fromJson(e))
                .toList()
          : [],
      hasAttribute: json["hasAttribute"]?.toString() ?? "",
      batchExpiry: json['batchExpiryJson'] != null
          ? (jsonDecode(json['batchExpiryJson']) as List)
                .map((e) => BatchExpiry.fromJson(e))
                .toList()
          : [],
      attribute: List<Attribute>.from(
        rawAttribute.map((x) => Attribute.fromJson(x)),
      ),
      isWeight: json["isWeight"] == true || json["isWeight"] == "Yes",
    );
  }

  // Mock constructor for existing static data
  factory Product.mock({
    required String name,
    required double price,
    required String category,
    String? image,
    Color color = Colors.grey,
    String? sku,
    String? description,
    bool isWeightBased = false,
  }) {
    return Product(
      itemId: "0",
      itemName: name,
      itemImage: image ?? "",
      artNumber: sku ?? "",
      categoryId: "0",
      categoryName: category,
      unitId: "0",
      unitAlias: "",
      costPrice: "0",
      salesPrice: price.toString(),
      isDiscountable: "No",
      itemWiseDiscount: "0",
      requiredBatchExpiry: "No",
      remainingStock: "0",
      taxPer: "0",
      barCode: "",
      batch: "",
      expiryDate: "",
      hasAttribute: "No",
      unitPrice: [],
      batchExpiry: [],
      attribute: [],
      isWeight: isWeightBased,
    );
  }
}

class UnitPrice {
  final String unitId;
  final String unitName;
  String price;
  final String qtyCount;

  UnitPrice({
    required this.unitId,
    required this.unitName,
    required this.price,
    required this.qtyCount,
  });

  factory UnitPrice.fromJson(Map<String, dynamic> json) {
    return UnitPrice(
      unitId: json['UnitId'].toString(),
      unitName: json['UnitName'],
      price: (json['Price'].toString()),
      qtyCount: json['QtyCount'] ?? "1",
    );
  }
}

class BatchExpiry {
  final String batch;
  final String expiry;
  final String stock;
  final String costPrice;
  final String salesPrice;

  BatchExpiry({
    required this.batch,
    required this.expiry,
    required this.stock,
    required this.costPrice,
    required this.salesPrice,
  });

  factory BatchExpiry.fromJson(Map<String, dynamic> json) {
    return BatchExpiry(
      batch: json['Batch'],
      expiry: json['Expiry'],
      stock: json['Stock'].toString(),
      costPrice: json['CostPrice:'].toString(),
      salesPrice: json['SalesPrice'].toString(),
    );
  }
}

class Attribute {
  final String barCode;
  final String remarks;
  final String salesPrice;
  final String remainingStock;

  Attribute({
    required this.barCode,
    required this.remarks,
    required this.salesPrice,
    required this.remainingStock,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    barCode: json["barCode"] ?? "",
    remarks: json["remarks"] ?? "",
    salesPrice: json["salesPrice"]?.toString() ?? "",
    remainingStock: json["remainingStock"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "barCode": barCode,
    "remarks": remarks,
    "salesPrice": salesPrice,
    "remainingStock": remainingStock,
  };
}

final List<Product> products = [
  Product.mock(
    name: "Cappuccino",
    price: 225,
    category: "Beverages",
    sku: '123456',
    description: 'This is a cappuccino',
    color: const Color(0xFFFEF3C7),
  ),
  Product.mock(
    name: "Espresso",
    price: 180,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/espresso",
    sku: '1256',
    description: 'This is a espresso',
    color: const Color(0xFFDDD6FE),
  ),
  Product.mock(
    name: "Caesar Salad",
    price: 650,
    category: "Food",
    image: "https://loremflickr.com/200/200/salad",
    sku: '1256',
    description: 'This is a caesar salad',
    color: const Color(0xFFBBF7D0),
  ),
  Product.mock(
    name: "Margherita Pizza",
    price: 890,
    category: "Food",
    image: "https://loremflickr.com/200/200/pizza",
    sku: '1256',
    description: 'This is a margherita pizza',
    color: const Color(0xFFFECDD3),
  ),
  Product.mock(
    name: "Cheesecake",
    price: 400,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/cheesecake",
    sku: '1256',
    description: 'This is a cheesecake',
    color: const Color(0xFFFED7AA),
  ),
  Product.mock(
    name: "Brownie",
    price: 320,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/brownie",
    sku: '1256',
    description: 'This is a brownie',
    color: const Color(0xFFD1D5DB),
  ),
  Product.mock(
    name: "French Fries",
    price: 280,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/fries",
    color: const Color(0xFFFEF08A),
  ),
  Product.mock(
    name: "Nachos",
    price: 350,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/nachos",
    color: const Color(0xFFFBCAFE),
  ),
  Product.mock(
    name: "Latte",
    price: 210,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/latte",
    color: const Color(0xFFE0F2FE),
  ),
  Product.mock(
    name: "Mocha",
    price: 240,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/mocha",
    color: const Color(0xFFFDE68A),
  ),
  Product.mock(
    name: "Iced Tea",
    price: 160,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/icedtea",
    color: const Color(0xFFCCFBF1),
  ),
  Product.mock(
    name: "Fresh Lime Soda",
    price: 150,
    category: "Beverages",
    image: "https://loremflickr.com/200/200/lime,soda",
    color: const Color(0xFFD9F99D),
  ),
  Product.mock(
    name: "Grilled Chicken Sandwich",
    price: 520,
    category: "Food",
    image: "https://loremflickr.com/200/200/sandwich",
    color: const Color(0xFFBFDBFE),
  ),
  Product.mock(
    name: "Chicken Burger",
    price: 480,
    category: "Food",
    image: "https://loremflickr.com/200/200/burger",
    color: const Color(0xFFFECACA),
  ),
  Product.mock(
    name: "Veg Pasta",
    price: 450,
    category: "Food",
    image: "https://loremflickr.com/200/200/pasta",
    color: const Color(0xFFDCFCE7),
  ),
  Product.mock(
    name: "Chicken Biryani",
    price: 750,
    category: "Food",
    image: "https://loremflickr.com/200/200/biryani",
    color: const Color(0xFFFDE2E2),
  ),
  Product.mock(
    name: "Ice Cream Sundae",
    price: 300,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/icecream",
    color: const Color(0xFFE9D5FF),
  ),
  Product.mock(
    name: "Chocolate Mousse",
    price: 420,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/mousse",
    color: const Color(0xFFFAE8FF),
  ),
  Product.mock(
    name: "Fruit Tart",
    price: 380,
    category: "Dessert",
    image: "https://loremflickr.com/200/200/fruittart",
    color: const Color(0xFFFFEDD5),
  ),
  Product.mock(
    name: "Garlic Bread",
    price: 260,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/garlicbread",
    color: const Color(0xFFFFF7ED),
  ),
  Product.mock(
    name: "Chicken Nuggets",
    price: 340,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/nuggets",
    color: const Color(0xFFFDE68A),
  ),
  Product.mock(
    name: "Spring Rolls",
    price: 300,
    category: "Snacks",
    image: "https://loremflickr.com/200/200/springrolls",
    color: const Color(0xFFECFEFF),
  ),
  Product.mock(
    name: "Banana",
    price: 120,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/banana",
    color: const Color(0xFFFEF08A),
    isWeightBased: true,
  ),
  Product.mock(
    name: "Apple",
    price: 250,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/apple",
    color: const Color(0xFFFECACA),
    isWeightBased: true,
  ),
  Product.mock(
    name: "Grapes",
    price: 180,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/grapes",
    color: const Color(0xFFE9D5FF),
    isWeightBased: true,
  ),
  Product.mock(
    name: "Watermelon",
    price: 60,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/watermelon",
    color: const Color(0xFFBBF7D0),
    isWeightBased: true,
  ),
  Product.mock(
    name: "Orange",
    price: 150,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/orange",
    color: const Color(0xFFFED7AA),
    isWeightBased: true,
  ),
  Product.mock(
    name: "Mango",
    price: 200,
    category: "Fruits",
    image: "https://loremflickr.com/200/200/mango",
    color: const Color(0xFFFDE68A),
    isWeightBased: true,
  ),
];

class OrderItem {
  String name;
  double quantity;
  double price;
  String category;
  String? note;
  double? discount;
  bool isFree;
  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    this.note,
    this.discount = 0.0,
    this.isFree = false,
  });
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    name: json["name"],
    quantity: json["quantity"].toDouble(),
    price: json["price"].toDouble(),
    category: json["category"],
    note: json["note"],
    discount: json["discount"]?.toDouble(),
    isFree: json["isFree"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "price": price,
    "category": category,
    "note": note,
    "discount": discount,
    "isFree": isFree,
  };
}

class DraftOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  final DateTime timestamp;

  DraftOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.timestamp,
  });

  factory DraftOrder.fromJson(Map<String, dynamic> json) => DraftOrder(
    id: json["id"],
    customerName: json["customerName"],
    customerPhone: json["customerPhone"] ?? "",
    customerAddress: json["customerAddress"] ?? "",
    items: List<OrderItem>.from(
      json["items"].map((x) => OrderItem.fromJson(x)),
    ),
    timestamp: DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerName": customerName,
    "customerPhone": customerPhone,
    "customerAddress": customerAddress,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "timestamp": timestamp.toIso8601String(),
  };
}

final List<OrderItem> orderItems = <OrderItem>[
  OrderItem(name: "Burger", quantity: 2, price: 240, category: "Food"),
  OrderItem(name: "Fries", quantity: 1, price: 120, category: "Food"),
  OrderItem(name: "Coke", quantity: 1, price: 80, category: "Beverages"),
  OrderItem(name: "Ice Cream", quantity: 1, price: 150, category: "Dessert"),
  OrderItem(name: "Sandwich", quantity: 1, price: 180, category: "Food"),
  OrderItem(name: "Pizza", quantity: 1, price: 250, category: "Food"),
  OrderItem(name: "Burger", quantity: 2, price: 240, category: "Food"),
  OrderItem(name: "Fries", quantity: 1, price: 120, category: "Food"),
  OrderItem(name: "Coke", quantity: 1, price: 80, category: "Beverages"),
  OrderItem(name: "Ice Cream", quantity: 1, price: 150, category: "Dessert"),
];
