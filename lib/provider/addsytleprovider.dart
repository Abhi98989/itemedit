import 'dart:developer';

import 'package:flutter/material.dart';
import '../model/addstyle.dart';
import '../repo/addservcie.dart';
class ItemStyleProvider with ChangeNotifier {
  final AddedStyleService _service = AddedStyleService();

  List<AddedStyle> _allStyles = [];
  bool _isLoading = false;

  List<AddedStyle> get allStyles => _allStyles;
  bool get isLoading => _isLoading;

  // Initialize and load data
  Future<void> loadStyles() async {
    _isLoading = true;
    try {
      _allStyles = await _service.fetchStyles();
    } catch (e) {
      log("Error loading styles: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}