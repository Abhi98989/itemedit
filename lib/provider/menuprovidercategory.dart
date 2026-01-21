import 'dart:developer';
import 'package:flutter/material.dart';
import '../model/statcic_menucategory.dart';
import '../repo/menuservice.dart';

class MenuCategoryProvider with ChangeNotifier {
  final MenuCategoryService _service = MenuCategoryService();

  List<MenuCategory> _categories = [];
  bool _isLoading = false;

  List<MenuCategory> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _service.fetchCategories();
    } catch (e) {
      log('Error loading menu categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
