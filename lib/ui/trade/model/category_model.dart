import 'dart:convert';
import 'package:flutter/material.dart';

List<Category> categoryFromJson(List str) =>
    List<Category>.from(str.map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  final String categoryId;
  final String categoryName;
  final Color color;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["categoryId"] ?? "",
    categoryName: json["categoryName"] ?? "",
    color: Colors.grey,
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryName": categoryName,
  };
}

final List<Category> staticCategories = [
  Category(
    categoryId: "1",
    categoryName: "All",
    color: const Color(0xFFE0E0E0),
  ),
  Category(
    categoryId: "2",
    categoryName: "Beverages",
    color: const Color(0xFFBBDEFB),
  ),
  Category(
    categoryId: "3",
    categoryName: "Hot Beverages",
    color: const Color(0xFFFFCCBC),
  ),
  Category(
    categoryId: "4",
    categoryName: "Cold Beverages",
    color: const Color(0xFFB2EBF2),
  ),
  Category(
    categoryId: "5",
    categoryName: "Food",
    color: const Color(0xFFC8E6C9),
  ),
  Category(
    categoryId: "6",
    categoryName: "Main Course",
    color: const Color(0xFFF8BBD0),
  ),
  Category(
    categoryId: "7",
    categoryName: "Fast Food",
    color: const Color(0xFFFFF9C4),
  ),
  Category(
    categoryId: "8",
    categoryName: "Dessert",
    color: const Color(0xFFD1C4E9),
  ),
  Category(
    categoryId: "9",
    categoryName: "Bakery",
    color: const Color(0xFFFFE0B2),
  ),
  Category(
    categoryId: "10",
    categoryName: "Snacks",
    color: const Color(0xFFDCEDC8),
  ),
  Category(
    categoryId: "11",
    categoryName: "Starters",
    color: const Color(0xFFF0F4C3),
  ),
  Category(
    categoryId: "12",
    categoryName: "Salads",
    color: const Color(0xFFB2DFDB),
  ),
  Category(
    categoryId: "13",
    categoryName: "Combo Meals",
    color: const Color(0xFFFFCDD2),
  ),
  Category(
    categoryId: "14",
    categoryName: "Breakfast",
    color: const Color(0xFFE1BEE7),
  ),
  Category(
    categoryId: "15",
    categoryName: "Lunch",
    color: const Color(0xFFCFD8DC),
  ),
  Category(
    categoryId: "16",
    categoryName: "Dinner",
    color: const Color(0xFFB3E5FC),
  ),
  Category(
    categoryId: "17",
    categoryName: "Healthy",
    color: const Color(0xFFDCEDC8),
  ),
  Category(
    categoryId: "18",
    categoryName: "Vegan",
    color: const Color(0xFFE8F5E9),
  ),
  Category(
    categoryId: "19",
    categoryName: "Kids Menu",
    color: const Color(0xFFFCE4EC),
  ),
];
