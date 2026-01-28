import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/widget/productcard.dart' show ProductCard;
import '../model/category_model.dart';
import '../model/product_class.dart';

class MainProductArea extends StatefulWidget {
  final Function(Product, {double quantity}) onProductTap;
  final VoidCallback onPaymentClick;
  final VoidCallback onSaveDraft;
  final VoidCallback onAddClick;
  final VoidCallback onDiscountsClick;
  final VoidCallback onFavoritesClick;
  final VoidCallback onScanClick;
  final VoidCallback onMoreClick;
  final VoidCallback onDeleteClick;
  final double price;

  const MainProductArea({
    super.key,
    required this.onProductTap,
    required this.onPaymentClick,
    required this.onSaveDraft,
    required this.onAddClick,
    required this.onDiscountsClick,
    required this.onFavoritesClick,
    required this.onScanClick,
    required this.onMoreClick,
    required this.onDeleteClick,
    required this.price,
  });

  @override
  State<MainProductArea> createState() => _MainProductAreaState();
}

class _MainProductAreaState extends State<MainProductArea> {
  late Category selectedCategory;
  bool isGridView = true;
  bool isKeyboardBlocked = false;
  final List<Category> categories = staticCategories;
  List<Category> filteredCategories = [];
  TextEditingController categorySearchController = TextEditingController();
  TextEditingController productSearchController = TextEditingController();
  String productSearchQuery = "";
  bool showCategory = false;

  List<Product> get filteredProducts {
    List<Product> filtered = products;
    if (selectedCategory.categoryName != "All") {
      filtered = filtered
          .where((p) => p.category == selectedCategory.categoryName)
          .toList();
    }
    if (productSearchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) =>
                p.name.toLowerCase().contains(productSearchQuery.toLowerCase()),
          )
          .toList();
    }
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.first;
    filteredCategories = List.from(categories);
  }

  @override
  void dispose() {
    categorySearchController.dispose();
    productSearchController.dispose();
    super.dispose();
  }

  void searchCategory(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCategories = List.from(categories);
      });
    } else {
      setState(() {
        filteredCategories = categories
            .where(
              (category) => category.categoryName.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      });
    }
  }

  void showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                titlePadding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

                /// Title
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.red,
                      splashRadius: 20,
                      onPressed: () {
                        categorySearchController.clear();
                        searchCategory('');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                /// Content
                content: SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      /// Search Field
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: categorySearchController,
                          autofocus: true,
                          onChanged: (value) {
                            setDialogState(() {
                              searchCategory(value);
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Search category...",
                            hintStyle: TextStyle(fontFamily: 'SanFrancisco'),
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Category List
                      Expanded(
                        child: filteredCategories.isEmpty
                            ? const Center(
                                child: Text(
                                  "No categories found",
                                  style: TextStyle(
                                    fontFamily: 'SanFrancisco',
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredCategories.length,
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final category = filteredCategories[index];
                                  return ListTile(
                                    title: Text(
                                      category.categoryName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'SanFrancisco',
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = category;
                                      });
                                      Navigator.pop(context);
                                      categorySearchController.clear();
                                      searchCategory('');
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 32,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// TITLE
                  const Text(
                    "Clear All Items?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This will remove all items from the cart. "
                    "This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 24),

                  /// ACTION BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onDeleteClick();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Clear All",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(0),
            color: Colors.white,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: showCategory ? 180 : 52,
                    curve: Curves.easeInOut,
                    child: _actionIconButton(
                      showCategory ? Icons.chevron_left : Icons.chevron_right,
                      showCategory ? 'Category' : '',
                      () {
                        setState(() {
                          showCategory = !showCategory;
                        });
                      },
                      30,
                      Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: TextField(
                        controller: productSearchController,
                        readOnly: isKeyboardBlocked,
                        showCursor: true,
                        onChanged: (value) {
                          setState(() {
                            productSearchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: isKeyboardBlocked
                              ? "Keyboard Blocked..."
                              : "Search products...",
                          hintStyle: const TextStyle(
                            fontFamily: 'SanFrancisco',
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF64748B),
                          ),
                          suffixIcon: productSearchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      productSearchController.clear();
                                      productSearchQuery = "";
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _iconButton(Icons.qr_code, widget.onScanClick),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  _iconButton(
                    isKeyboardBlocked ? Icons.keyboard_hide : Icons.keyboard,
                    () {
                      setState(() {
                        isKeyboardBlocked = !isKeyboardBlocked;
                        productSearchController.clear();
                        productSearchQuery = "";
                      });
                    },
                    color: isKeyboardBlocked ? Colors.grey : null,
                  ),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Sync':
                          // Handle Sync
                          break;
                        case 'Cash in/out':
                          // Handle Cash in/out
                          break;
                        case 'Open cash drawer':
                          // Handle Open cash drawer
                          break;
                        case 'Change Outlet':
                          // Handle Change Outlet
                          break;
                      }
                      widget.onMoreClick();
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      size: 30,
                      color: Color(0xFF64748B),
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Sync',
                            child: Row(
                              children: [
                                Icon(Icons.sync, size: 20),
                                Text(
                                  'Sync',
                                  style: TextStyle(fontFamily: 'SanFrancisco'),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Cash in/out',
                            child: Row(
                              children: [
                                Icon(Icons.attach_money, size: 20),
                                Text(
                                  'Cash in/out',
                                  style: TextStyle(fontFamily: 'SanFrancisco'),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Open cash drawer',
                            child: Row(
                              children: [
                                Icon(Icons.menu, size: 20),
                                Text(
                                  'Open cash drawer',
                                  style: TextStyle(fontFamily: 'SanFrancisco'),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Change Outlet',
                            child: Row(
                              children: [
                                Icon(Icons.store, size: 20),
                                Text(
                                  'Change Outlet',
                                  style: TextStyle(fontFamily: 'SanFrancisco'),
                                ),
                              ],
                            ),
                          ),
                        ],
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Middle Area (Sidebar + Grid)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: showCategory ? 180 : 0,
                curve: Curves.easeInOut,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 180,
                    color: Colors.white,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected =
                            selectedCategory.categoryId == category.categoryId;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(3),
                              border: Border(
                                left: BorderSide(
                                  color: isSelected
                                      ? selectedCategory.color
                                      : Colors.white,
                                  width: 3,
                                ),
                                bottom: BorderSide(
                                  color: isSelected
                                      ? selectedCategory.color
                                      : Colors.white,
                                  width: 0.6,
                                ),
                              ),
                            ),
                            child: Text(
                              category.categoryName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected ? Colors.black : Colors.black,
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Right side (Products)
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No products found",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(5),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isGridView ? 6 : 1,
                          childAspectRatio: isGridView ? 1.1 : 13,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final category = categories.firstWhere(
                            (c) => c.categoryName == product.category,
                            orElse: () => categories.first,
                          );
                          return ProductCard(
                            product: product,
                            category: category,
                            isGridView: isGridView,
                            onTap: (qty) =>
                                widget.onProductTap(product, quantity: qty),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),

        // Bottom Action Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              _actionIconButton(Icons.menu, "", () {}, 25, Colors.grey),
              _actionIconButton(
                Icons.local_offer_outlined,
                "",
                widget.onDiscountsClick,
                25,
                Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _viewToggle(Icons.grid_view, isGridView, () {
                      setState(() {
                        isGridView = true;
                      });
                    }),
                    _viewToggle(Icons.list, !isGridView, () {
                      setState(() {
                        isGridView = false;
                      });
                    }),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7CD23D).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xff7CD23D).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    _showClearAllDialog(context);
                  },
                  icon: Icon(Icons.delete, size: 25, color: Colors.red),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7CD23D).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xff7CD23D).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: widget.onSaveDraft,
                  icon: Icon(
                    Icons.back_hand_outlined,
                    size: 25,
                    // color: Colors.yellow,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 200,
                child: Center(
                  child: _actionButton(
                    "Rs ${widget.price}",
                    const Color(0xff7CD23D),
                    Colors.white,
                    widget.onPaymentClick,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed, {Color? color}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color ?? const Color(0xFF64748B)),
    );
  }

  Widget _actionIconButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
    double size,
    Color? color,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: size, color: color ?? const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'SanFrancisco',
                fontSize: 14,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewToggle(IconData icon, bool isActive, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 25,
          color: isActive ? const Color(0xff7CD23D) : const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  Widget _actionButton(
    String text,
    Color bg,
    Color textCol,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: textCol,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 4,
        children: [
          Text(
            "Pay",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFamily: 'SanFrancisco',
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'SanFrancisco',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
