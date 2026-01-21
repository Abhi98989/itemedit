import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/widget/orderitemtiler.dart';
import 'package:itemedit/ui/trade/widget/product_class.dart';
import 'widget/productarea.dart';
import 'widget/payment_widget.dart';

class POSLandingPage extends StatefulWidget {
  const POSLandingPage({super.key});
  @override
  State<POSLandingPage> createState() => _POSLandingPageState();
}

class _POSLandingPageState extends State<POSLandingPage> {
  final List<OrderItem> items = [];
  bool isPaymentMode = false;
  String enteredAmount = "";
  String selectedPayment = "Cash";
  void addItem(Product product, {int quantity = 1}) {
    setState(() {
      final index = items.indexWhere((item) => item.name == product.name);
      if (index != -1) {
        items[index].quantity += quantity;
      } else {
        items.add(
          OrderItem(
            name: product.name,
            quantity: quantity,
            price: product.price,
            category: product.category,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<double>(
      0,
      (double sum, OrderItem item) => sum + (item.price * item.quantity),
    );
    final tax = subtotal * 0.13;
    final total = subtotal + tax;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          // Left Sidebar (Order Details) - Always visible
          Container(
            width: 380,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: OrderSidebar(
              items: items,
              isPaymentMode: isPaymentMode,
              onRemove: (index) {
                setState(() {
                  items.removeAt(index);
                });
              },
              onQuantityChange: (index, newQty) {
                setState(() {
                  items[index].quantity = newQty;
                });
              },
            ),
          ),
          // Main Content Area (Product Grid / Payment Content)
          Expanded(
            child: isPaymentMode
                ? PaymentBody(
                    items: items,
                    subtotal: subtotal,
                    tax: tax,
                    total: total,
                    enteredAmount: enteredAmount,
                    selectedPayment: selectedPayment,
                    onPaymentModeChanged: (mode) {
                      setState(() {
                        selectedPayment = mode;
                      });
                    },
                    onAmountChanged: (amount) {
                      setState(() {
                        enteredAmount = amount;
                      });
                    },
                    onBack: () {
                      setState(() {
                        isPaymentMode = false;
                      });
                    },
                    onConfirm: () {
                      // Handle confirmation
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Payment Confirmed"),
                          content: Text(
                            "Mode: $selectedPayment\nPaid: Rs ${enteredAmount.isEmpty ? total.toStringAsFixed(2) : enteredAmount}",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  items.clear();
                                  isPaymentMode = false;
                                  enteredAmount = "";
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : MainProductArea(
                    price: total,
                    onProductTap: addItem,
                    onPaymentClick: () {
                      setState(() {
                        isPaymentMode = true;
                      });
                    },
                    onSaveDraft: () {
                      if (items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No items to save as draft"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      // Logic to save draft
                      // For now, we'll just show a success message
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Row(
                            children: [
                              Icon(Icons.save, color: Color(0xFF10B981)),
                              SizedBox(width: 10),
                              Text("Draft Saved"),
                            ],
                          ),
                          content: Text(
                            "Your draft with ${items.length} items has been saved successfully.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  items
                                      .clear(); // Clear items after saving draft
                                });
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                    onAddClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Add functionality coming soon"),
                        ),
                      );
                    },
                    onDiscountsClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Discounts functionality coming soon"),
                        ),
                      );
                    },
                    onFavoritesClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Favorites functionality coming soon"),
                        ),
                      );
                    },
                    onScanClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Scan functionality coming soon"),
                        ),
                      );
                    },
                    onMoreClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("More options coming soon"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- Left Sidebar Components ---
class OrderSidebar extends StatefulWidget {
  final List<OrderItem> items;
  final bool isPaymentMode;
  final Function(int) onRemove;
  final Function(int, int) onQuantityChange;

  const OrderSidebar({
    super.key,
    required this.items,
    required this.isPaymentMode,
    required this.onRemove,
    required this.onQuantityChange,
  });

  @override
  State<OrderSidebar> createState() => _OrderSidebarState();
}

class _OrderSidebarState extends State<OrderSidebar> {
  bool showSummary = false;
  void _showEditItemDialog(BuildContext context, int index) {
    final item = widget.items[index];
    int tempQty = item.quantity;
    String tempNote = item.note ?? "";
    double tempDiscount = item.discount!;
    bool tempIsFree = item.isFree;
    bool discountTypeA = false;
    bool discountTypeB = false;
    String offerType = tempIsFree ? "free" : "discount";
    final noteController = TextEditingController(text: tempNote);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              final subtotal = item.price * tempQty;
              final total = tempIsFree ? 0.0 : subtotal - tempDiscount;
              return Dialog(
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rs ${item.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // backgroundColor: Theme.of(
                                  //   context,
                                  // ).primaryColor,
                                  // foregroundColor: Colors.white,
                                  // minimumSize: const Size(double.infinity, 40),
                                  // tapTargetSize:
                                  //     MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  widget.onQuantityChange(index, tempQty);
                                  setState(() {
                                    item.note = noteController.text;
                                    item.discount = tempDiscount;
                                    item.isFree = tempIsFree;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 12),
                        // Quantity
                        Center(
                          child: const Text(
                            "Quantity",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _circleButton(Icons.remove, () {
                              if (tempQty > 1) {
                                setDialogState(() => tempQty--);
                              }
                            }),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "$tempQty",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Rs ${subtotal.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _circleButton(Icons.add, () {
                              setDialogState(() => tempQty++);
                            }),
                          ],
                        ),
                        // Note
                        TextField(
                          controller: noteController,
                          decoration: InputDecoration(
                            labelText: "Note",
                            hintText: "Add a note",
                            prefixIcon: const Icon(Icons.edit_note),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        // Apply Offer
                        const Text(
                          "Apply Offer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _offerTypeButton(
                                context,
                                "Discount",
                                Icons.percent,
                                offerType == "discount",
                                () => setDialogState(() {
                                  offerType = "discount";
                                  tempIsFree = false;
                                }),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _offerTypeButton(
                                context,
                                "Free",
                                Icons.card_giftcard,
                                offerType == "free",
                                () => setDialogState(() {
                                  offerType = "free";
                                  tempIsFree = true;
                                }),
                              ),
                            ),
                          ],
                        ),
                        if (offerType == "discount") ...[
                          // Discount Types
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _toggleRow(
                                  "Discount Type A",
                                  discountTypeA,
                                  (val) =>
                                      setDialogState(() => discountTypeA = val),
                                ),
                                const Divider(),
                                _toggleRow(
                                  "Discount Type B",
                                  discountTypeB,
                                  (val) =>
                                      setDialogState(() => discountTypeB = val),
                                ),
                              ],
                            ),
                          ),

                          // Discount Input
                          Row(
                            children: [
                              Expanded(
                                child: _inputField("%", "Percentage", (val) {
                                  final p = double.tryParse(val) ?? 0;
                                  setDialogState(
                                    () => tempDiscount = (subtotal * p / 100),
                                  );
                                }),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("or"),
                              ),
                              Expanded(
                                child: _inputField("Rs", "Amount", (val) {
                                  final p = double.tryParse(val) ?? 0;
                                  setDialogState(
                                    () => tempDiscount = p * tempQty,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                        // Summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Discount:"),
                                  Text(
                                    "Rs ${tempDiscount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Rs ${total.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onRemove(index);
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Remove"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Helper widgets
  Widget _circleButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: IconButton(icon: Icon(icon), onPressed: onPressed, iconSize: 20),
    );
  }

  Widget _offerTypeButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.grey.shade50,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _inputField(
    String prefix,
    String hint,
    ValueChanged<String> onChanged,
  ) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixText: "$prefix ",
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool? isBold, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold! ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 18 : 14,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.items.fold<double>(
      0,
      (double sum, OrderItem item) => sum + (item.price * item.quantity),
    );
    final tax = subtotal * 0.13;
    final total = subtotal + tax;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Header
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.menu),
                    Text("Menu", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.person),
                    Text("Customer", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.card_travel),
                    Text("ClearCart", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.drafts),
                    Text("Draft", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          Divider(thickness: 1, color: const Color(0xFFE2E8F0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ram gopal renu | 98000000000 ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit, size: 17),
                  ),
                  CloseButton(
                    color: Colors.red,
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(CircleBorder()),
                      iconSize: WidgetStatePropertyAll(17),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "Pokhara 7, zero",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          Divider(thickness: 1, color: const Color(0xFFE2E8F0)),
          // Item List
          Expanded(
            child: widget.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No items added yet",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      return OrderItemTile(
                        item: widget.items[index],
                        onRemove: () => widget.onRemove(index),
                        onQuantityChange: (newQty) =>
                            widget.onQuantityChange(index, newQty),
                        onTap: () => _showEditItemDialog(context, index),
                        isdiscount: '${widget.items[index].discount}' != '0',
                      );
                    },
                  ),
          ),
          // Summary Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                if (showSummary) ...[
                  _summaryRow(
                    "Subtotal",
                    "Rs ${subtotal.toStringAsFixed(2)}",
                    true,
                  ),
                  const SizedBox(height: 8),
                  _summaryRow(
                    "Tax (13%)",
                    "Rs ${tax.toStringAsFixed(2)}",
                    true,
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey[300]),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSummary = !showSummary;
                        });
                      },
                      icon: Icon(
                        showSummary
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: const Color(0xFF64748B),
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    Row(
                      children: [
                        Text(
                          "Rs ${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Text(
                      "(${widget.items.length} items ${widget.items.fold<int>(0, (int sum, OrderItem item) => sum + item.quantity)} quantity)",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
