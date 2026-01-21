class MenuItem {
  final String token;
  final String itemId;
  final String itemName;
  final String itemDescription;
  final bool isFavoriteItem;
  final bool isMaStringainStock;
  final int categoryId;
  final int baseUnit;
  final bool taxable;
  final double costPrice;
  final double salesPrice;
  final String imageUrl;
  final String itemImage;
  final double minQty;
  final bool rawMaterial;
  final double taxType;
  final double taxAmount;
  final double taxableAmount;
  final List<int> itemstyle;
  final List<int> addOns;
  final List<MenuItemListPrice> unitpricing;
  final Set<String> prStringLocation;
  final String displayOrder;

  MenuItem({
    required this.token,
    required this.itemId,
    required this.itemName,
    required this.itemDescription,
    required this.isFavoriteItem,
    required this.isMaStringainStock,
    required this.categoryId,
    required this.baseUnit,
    required this.costPrice,
    required this.salesPrice,
    required this.imageUrl,
    required this.itemImage,
    required this.taxable,
    required this.minQty,
    required this.rawMaterial,
    required this.taxType,
    required this.taxAmount,
    required this.taxableAmount,
    required this.itemstyle,
    required this.unitpricing,
    required this.addOns,
    required this.prStringLocation,
    required this.displayOrder,
  });

  factory MenuItem.empty() {
    return MenuItem(
      token: '',
      itemId: "0",
      itemName: '',
      itemDescription: '',
      isFavoriteItem: false,
      isMaStringainStock: false,
      categoryId: 0,
      baseUnit: 0,
      costPrice: 0.0,
      salesPrice: 0.0,
      imageUrl: '',
      itemImage: '',
      taxable: false,
      minQty: 0.0,
      rawMaterial: false,
      taxType: 0.0,
      taxAmount: 0.0,
      taxableAmount: 0.0,
      itemstyle: [],
      unitpricing: [],
      addOns: [],
      prStringLocation: {},
      displayOrder: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TokenNo': token,
      'ItemId': itemId,
      'ItemName': itemName,
      'ItemDescription': itemDescription,
      'IsFavoriteItem': isFavoriteItem,
      'IsMaStringainStock': isMaStringainStock,
      'CategoryId': categoryId,
      'BaseUnit': baseUnit,
      'CostPrice': costPrice,
      'SalesPrice': salesPrice,
      'ItemImage': itemImage,
      'MinQty': minQty,
      'RawMaterial': rawMaterial,
      'TaxType': taxType,
      'TaxAmount': taxAmount,
      'TaxableAmount': taxableAmount,
      'FoodOption': itemstyle,
      'AddOnsList': addOns,
      'ItemUnitPriceSetting': unitpricing.map((unit) => unit.toJson()).toList(),
      'PrStringLocation': prStringLocation.isEmpty
          ? "-1"
          : prStringLocation.join(', '),
      'DisplayOrder': displayOrder.isEmpty ? "0" : displayOrder,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      token: json['token'] ?? "",
      itemId: json['ItemId']?.toString() ?? "0",
      itemName: json['ItemName'] ?? "",
      itemDescription: json['ItemDesc'] ?? "",
      isFavoriteItem: json['IsFavoriteItem'] ?? false,
      isMaStringainStock: json['MaStringainStock'] ?? false,
      categoryId: int.tryParse(json['CatID']?.toString() ?? "0") ?? 0,
      baseUnit: int.tryParse(json['Baseunit']?.toString() ?? "0") ?? 0,
      costPrice: double.tryParse(json['CostPrice']?.toString() ?? "0.0") ?? 0.0,
      salesPrice:
          double.tryParse(json['SalesPrice']?.toString() ?? "0.0") ?? 0.0,
      itemImage: json['image'] ?? "",
      imageUrl: json['ImagUrl'] ?? "",
      minQty: double.tryParse(json['MinQty']?.toString() ?? "0.0") ?? 0.0,
      taxable: json['Taxable'] ?? false,
      rawMaterial: json['RawMaterial'] ?? false,
      taxType: double.tryParse(json['TaxType']?.toString() ?? "0.0") ?? 0.0,
      taxAmount: double.tryParse(json['TaxValue']?.toString() ?? "0.0") ?? 0.0,
      taxableAmount:
          double.tryParse(json['TaxableAmount']?.toString() ?? "0.0") ?? 0.0,
      itemstyle: (json['ItemStyle'] as String? ?? "")
          .split(',')
          .where((s) => s.isNotEmpty)
          .map((s) => int.tryParse(s.trim()) ?? 0)
          .toList(),
      addOns: (json['AddOnsList'] as String? ?? "")
          .split(',')
          .where((s) => s.isNotEmpty)
          .map((s) => int.tryParse(s.trim()) ?? 0)
          .toList(),
      unitpricing: [],
      prStringLocation: Set<String>.from(
        json['PrStringLocation'] == "-1"
            ? []
            : json['PrStringLocation']?.split(",").map((s) => s.trim()) ?? [],
      ),
      displayOrder: (json['DisplayOrder'] ?? 0).toString(),
    );
  }
}

class MenuItemListPrice {
  String ukId;
  String itemId;
  String unitId;
  double costPrice;
  double salesPrice;
  double taxAmount;
  double taxableAmount;

  MenuItemListPrice({
    required this.ukId,
    required this.itemId,
    required this.unitId,
    required this.costPrice,
    required this.salesPrice,
    required this.taxAmount,
    required this.taxableAmount,
  });

  factory MenuItemListPrice.fromJson(Map<String, dynamic> json) {
    return MenuItemListPrice(
      ukId: "0",
      itemId: json['ItemId']?.toString() ?? "0",
      unitId: json['Baseunit']?.toString() ?? "0",
      salesPrice:
          double.tryParse(json['SalesPrice']?.toString() ?? "0.0") ?? 0.0,
      taxAmount: double.tryParse(json['TaxValue']?.toString() ?? "0.0") ?? 0.0,
      taxableAmount:
          double.tryParse(json['TaxableAmount']?.toString() ?? "0.0") ?? 0.0,
      costPrice: 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UkId': ukId,
      '_ITEMID': itemId,
      'UnitId': unitId,
      'CostPrice': costPrice,
      'SalesPrice': salesPrice,
      'TaxAmt': taxAmount,
      'TaxableAmount': taxableAmount,
    };
  }
}
