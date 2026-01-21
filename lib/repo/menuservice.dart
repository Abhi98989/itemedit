import '../model/statcic_menucategory.dart';

class MenuCategoryService {
  // Simulate API call or return static data
  Future<List<MenuCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MenuCategory.itemCategoryList;
  }
}
