import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final Color color;

  Category({required this.id, required this.name, required this.color});
}

final List<Category> staticCategories = [
  Category(id: 1, name: "All", color: const Color(0xFFE0E0E0)),
  Category(id: 2, name: "Beverages", color: const Color(0xFFBBDEFB)),
  Category(id: 3, name: "Hot Beverages", color: const Color(0xFFFFCCBC)),
  Category(id: 4, name: "Cold Beverages", color: const Color(0xFFB2EBF2)),
  Category(id: 5, name: "Food", color: const Color(0xFFC8E6C9)),
  Category(id: 6, name: "Main Course", color: const Color(0xFFF8BBD0)),
  Category(id: 7, name: "Fast Food", color: const Color(0xFFFFF9C4)),
  Category(id: 8, name: "Dessert", color: const Color(0xFFD1C4E9)),
  Category(id: 9, name: "Bakery", color: const Color(0xFFFFE0B2)),
  Category(id: 10, name: "Snacks", color: const Color(0xFFDCEDC8)),
  Category(id: 11, name: "Starters", color: const Color(0xFFF0F4C3)),
  Category(id: 12, name: "Salads", color: const Color(0xFFB2DFDB)),
  Category(id: 13, name: "Combo Meals", color: const Color(0xFFFFCDD2)),
  Category(id: 14, name: "Breakfast", color: const Color(0xFFE1BEE7)),
  Category(id: 15, name: "Lunch", color: const Color(0xFFCFD8DC)),
  Category(id: 16, name: "Dinner", color: const Color(0xFFB3E5FC)),
  Category(id: 17, name: "Healthy", color: const Color(0xFFDCEDC8)),
  Category(id: 18, name: "Vegan", color: const Color(0xFFE8F5E9)),
  Category(id: 19, name: "Kids Menu", color: const Color(0xFFFCE4EC)),
];
