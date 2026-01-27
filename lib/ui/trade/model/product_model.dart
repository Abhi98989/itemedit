// import 'dart:convert';
// List<Product> productFromJson(String str) =>
//     List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));
// class Product {
//   final String itemId;
//   final String itemName;
//   final String? itemImage;
//   final String artNumber;
//   final String categoryId;
//   final String categoryName;
//   final String unitId;
//   final String unitAlias;
//   final String costPrice;
//   final String salesPrice;
//   final String isDiscountable;
//   final String itemWiseDiscount;
//   final String requiredBatchExpiry;
//   final String remainingStock;
//   final String taxPer;
//   final String barCode;
//   final String batch;
//   final String expiryDate;
//   final String hasAttribute;
//   final List<UnitPrice> unitPrice;
//   final List<BatchExpiry> batchExpiry;
//   final List<Attribute> attribute;

//   Product({
//     required this.itemId,
//     required this.itemName,
//     required this.itemImage,
//     required this.artNumber,
//     required this.categoryId,
//     required this.categoryName,
//     required this.unitId,
//     required this.unitAlias,
//     required this.costPrice,
//     required this.salesPrice,
//     required this.isDiscountable,
//     required this.itemWiseDiscount,
//     required this.requiredBatchExpiry,
//     required this.remainingStock,
//     required this.taxPer,
//     required this.barCode,
//     required this.batch,
//     required this.expiryDate,
//     required this.hasAttribute,
//     required this.unitPrice,
//     required this.batchExpiry,
//     required this.attribute,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     // --- Safely decode attribute ---
//     dynamic rawAttribute = json["attribute"];
//     if (rawAttribute is String) {
//       try {
//         rawAttribute = jsonDecode(rawAttribute);
//       } catch (e) {
//         rawAttribute = [];
//       }
//     }
//     if (rawAttribute is! List) {
//       rawAttribute = [];
//     }
//     return Product(
//       itemId: json["itemId"],
//       itemName: json["itemName"],
//       itemImage: json["itemImage"] ?? "",
//       artNumber: json["artNumber"],
//       categoryId: json["categoryId"] ?? "",
//       categoryName: json["categoryName"] ?? "",
//       unitId: json["unitId"],
//       unitAlias: json["unitAlias"],
//       costPrice: json["costPrice"],
//       salesPrice: json["salesPrice"],
//       isDiscountable: json["isDiscountable"],
//       itemWiseDiscount: json["itemWiseDiscount"],
//       requiredBatchExpiry: json["requiredBatchExpiry"],
//       remainingStock: json["remainingStock"],
//       taxPer: json["taxPer"],
//       barCode: json["barCode"],
//       batch: json["batch"] ?? "",
//       expiryDate: json["expiryDate"] ?? "",
//       // unitPrice: jsonDecode(json["jsonUnitPrice"]),
//       unitPrice: (jsonDecode(json['jsonUnitPrice']) as List)
//           .map((e) => UnitPrice.fromJson(e))
//           .toList(),
//       hasAttribute: json["hasAttribute"] == null
//           ? ""
//           : json["hasAttribute"].toString(),
//       // backExpiry: jsonDecode(json["batchExpiryJson"]),
//       batchExpiry: (jsonDecode(json['batchExpiryJson']) as List)
//           .map((e) => BatchExpiry.fromJson(e))
//           .toList(),
//       attribute: List<Attribute>.from(
//         rawAttribute.map((x) => Attribute.fromJson(x)),
//       ),
//     );
//   }
// }

// /*
// "AttributeCount" -> 1
// "discountPer" -> 0.0
// "Barcode" -> "1.2"
// "Product_ID" -> 1
// "itemid" -> 2
// "GroupName" -> "CASES AND WALLET"
// "Name" -> "L WASH BAG"
// "Salesprice_retail" -> 1800.0
// "CostPrice" -> 640.0
// "TaxInc" -> 0
// "TaxName" -> "0% TAX"
// "TaxPer" -> 0.0
// "BrandCompany" -> "GEN"
// "UnitName" -> "PCS"
// "UnitID" -> 3
// "canCalculateQtyByRate" -> false
// "HSCode" -> ""
// "Published" -> true
// "Mrp" -> 0.0
// */

// class UnitPrice {
//   final String unitId;
//   final String unitName;
//    String price;
//   final String qtyCount;

//   UnitPrice({
//     required this.unitId,
//     required this.unitName,
//     required this.price,
//     required this.qtyCount,
//   });

//   factory UnitPrice.fromJson(Map<String, dynamic> json) {
//     return UnitPrice(
//       unitId: json['UnitId'].toString(),
//       unitName: json['UnitName'],
//       price: (json['Price'].toString()),
//       qtyCount: json['QtyCount'] ?? "1",
//     );
//   }
// }

// class BatchExpiry {
//   final String batch;
//   final String expiry;
//   final String stock;
//   final String costPrice;
//   final String salesPrice;

//   BatchExpiry({
//     required this.batch,
//     required this.expiry,
//     required this.stock,
//     required this.costPrice,
//     required this.salesPrice,
//   });

//   factory BatchExpiry.fromJson(Map<String, dynamic> json) {
//     return BatchExpiry(
//       batch: json['Batch'],
//       expiry: json['Expiry'],
//       stock: json['Stock'].toString(),
//       costPrice: json['CostPrice:'].toString(),
//       salesPrice: json['SalesPrice'].toString(),
//     );
//   }
// }

// class Attribute {
//   final String barCode;
//   final String remarks;
//   final String salesPrice;
//   final String remainingStock;

//   Attribute({
//     required this.barCode,
//     required this.remarks,
//     required this.salesPrice,
//     required this.remainingStock,
//   });

//   factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
//     barCode: json["barCode"] ?? "",
//     remarks: json["remarks"] ?? "",
//     salesPrice: json["salesPrice"]?.toString() ?? "",
//     remainingStock: json["remainingStock"]?.toString() ?? "",
//   );

//   Map<String, dynamic> toJson() => {
//     "barCode": barCode,
//     "remarks": remarks,
//     "salesPrice": salesPrice,
//     "remainingStock": remainingStock,
//   };
// }
