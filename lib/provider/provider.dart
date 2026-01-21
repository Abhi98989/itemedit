import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/meniitem.dart';
import '../model/statcic_menucategory.dart';
import '../repo/service.dart';

class MenuItemProvider extends ChangeNotifier {
  final MenuItems _menuService = MenuItems();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Menu categories
  List<MenuCategory> get menuCategory => MenuCategory.itemCategoryList;

  // Unit names - you can customize this list as needed
  List<Map<String, dynamic>> get unitName => [
    {'id': '1', 'name': 'Pieces'},
    {'id': '2', 'name': 'Kilogram'},
    {'id': '3', 'name': 'Glass'},
    {'id': '4', 'name': 'Liter'},
    {'id': '5', 'name': 'Plate'},
  ];

  // Method to update sale price
  void updateSalePrice(String value) {
    // You can add logic here to handle price updates
    notifyListeners();
  }

  /// Function to save a new menu item
  Future<bool> saveNewItem({
    required String token,
    required String itemName,
    required String itemDescription,
    required int categoryId,
    required int baseUnit,
    required double salesPrice,
    required double costPrice,
    required double taxType,
    required double taxAmount,
    required double taxableAmount,
    required List<int> foodTags,
    required List<int> addOns,
    required bool isFavorite,
    required bool isConsumable,
    required bool maintainStock,
    required String displayOrder,
    required double minQty,
    required Set<String> prStringLocation,
    required List<MenuItemListPrice> unitpricing,
    required String itemImage,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newItem = MenuItem(
        token: token,
        itemId: "0",
        itemName: itemName,
        itemDescription: itemDescription,
        isFavoriteItem: isFavorite,
        isMaStringainStock: maintainStock,
        categoryId: categoryId,
        baseUnit: baseUnit,
        costPrice: costPrice,
        salesPrice: salesPrice,
        imageUrl: '',
        itemImage: itemImage,
        taxable: taxType != 0.0,
        minQty: minQty,
        rawMaterial: !isConsumable,
        taxType: taxType,
        taxAmount: taxAmount,
        taxableAmount: taxableAmount,
        itemstyle: foodTags,
        unitpricing: unitpricing,
        addOns: addOns,
        prStringLocation: prStringLocation,
        displayOrder: displayOrder,
      );
      http.Response response = await _menuService.addItem(newItem, token);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        if (body['dataCode'] == 416) {
          _errorMessage = "Error 416: ${body['message'] ?? 'Unknown error'}";
          _isLoading = false;
          notifyListeners();
          return false;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage =
            "Failed to add item: ${response.statusCode}\n${response.body}";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
