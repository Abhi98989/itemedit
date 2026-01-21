// ignore: file_names
class MenuCategory {
  final String id;
  final String title;
  final String iconPath;
  final bool isAddons;
  MenuCategory({
    required this.id,
    required this.title,
    required this.iconPath,
    this.isAddons = false,
  });
  // This is your static list of categories
  static List<MenuCategory> get itemCategoryList => [
    MenuCategory(id: '1', title: 'Bakery', iconPath: ''),
    MenuCategory(id: '2', title: 'Drink', iconPath: ''),
    MenuCategory(id: '3', title: 'Food', iconPath: ''),
    MenuCategory(id: '4', title: 'Other', iconPath: ''),
  ];
}
