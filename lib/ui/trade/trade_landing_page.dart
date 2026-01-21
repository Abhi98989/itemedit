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

  // Customer Data
  Customer? selectedCustomer;
  bool isCustomerSelected = false;
  String customerName = "";
  String customerPhone = "";
  String customerAddress = "";
  String customerPan = "";
  String invoiceNumber = "";
  String customerBalance = "";

  void _showCustomerSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Customer",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF10B981),
                            child: Text(
                              customer.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            customer.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Phone: ${customer.phone}"),
                              Text("Address: ${customer.address}"),
                              Text(
                                "Outstanding: Rs ${customer.outstandingbalance}",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () {
                            setState(() {
                              selectedCustomer = customer;
                              isCustomerSelected = true;
                              customerName = customer.name;
                              customerPhone = customer.phone;
                              customerAddress = customer.address;
                              customerBalance = customer.outstandingbalance;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Selected: ${customer.name}"),
                                backgroundColor: const Color(0xFF10B981),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          SizedBox(
            width: 380,
            child: Container(
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
                customerName: customerName,
                customerPhone: customerPhone,
                customerAddress: customerAddress,
                customerBalance: customerBalance,
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
                onCustomerSelect: _showCustomerSelectionDialog,
                onCustomerClear: () {
                  setState(() {
                    selectedCustomer = null;
                    isCustomerSelected = false;
                    customerName = "";
                    customerPhone = "";
                    customerAddress = "";
                    customerBalance = "";
                  });
                },
              ),
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
                    invoiceNumber: invoiceNumber,
                    customerName: customerName,
                    customerPhone: customerPhone,
                    customerAddress: customerAddress,
                    customerPan: customerPan,
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
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerBalance;
  final VoidCallback onCustomerSelect;
  final VoidCallback onCustomerClear;

  const OrderSidebar({
    super.key,
    required this.items,
    required this.isPaymentMode,
    required this.onRemove,
    required this.onQuantityChange,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerBalance,
    required this.onCustomerSelect,
    required this.onCustomerClear,
  });

  @override
  State<OrderSidebar> createState() => _OrderSidebarState();
}

class _OrderSidebarState extends State<OrderSidebar> {
  bool showSummary = false;
  double _orderDiscount = 0.0;
  double _deliveryCharges = 0.0;
  double _packageCharges = 0.0;
  String _couponCode = "";

  void _showEditItemDialog(BuildContext context, int index) {
    final item = widget.items[index];
    int tempQty = item.quantity;
    String tempNote = item.note ?? "";
    double tempDiscount = item.discount!;
    bool tempIsFree = item.isFree;
    bool discountTypeA = false;
    bool discountTypeB = false;
    String? offerType; // No default selection
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
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const Divider(),
                        // Quantity
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
                                  SizedBox(
                                    width: 80,
                                    child: TextField(
                                      controller: TextEditingController(
                                        text: tempQty.toString(),
                                      ),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                      onChanged: (val) {
                                        final qty = int.tryParse(val);
                                        if (qty != null && qty > 0) {
                                          setDialogState(() => tempQty = qty);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rs ${subtotal.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
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
                            hintText: "Add a note for the item",
                            prefixIcon: const Icon(Icons.edit_note),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(12),
                            // ),
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
                                  tempDiscount = 0;
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
                                  tempDiscount = 0;
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
                        if (offerType != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                if (offerType == "discount")
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
                                if (offerType == "discount")
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
                                      offerType == "free"
                                          ? "FREE"
                                          : "Rs ${total.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: offerType == "free"
                                            ? Colors.green
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  widget.onRemove(index);
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Remove"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.onQuantityChange(index, tempQty);
                                  setState(() {
                                    item.note = noteController.text;
                                    item.discount = tempDiscount;
                                    item.isFree = tempIsFree;
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
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
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showDiscountSheet() {
    double tempDiscount = _orderDiscount;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Discount",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: tempDiscount > 0 ? tempDiscount.toString() : '',
                ),
                decoration: const InputDecoration(
                  labelText: "Discount Amount (Rs)",
                  border: OutlineInputBorder(),
                  prefixText: "Rs ",
                ),
                onChanged: (val) {
                  tempDiscount = double.tryParse(val) ?? 0.0;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _orderDiscount = tempDiscount;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Apply Discount"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showCouponSheet() {
    String tempCoupon = _couponCode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Apply Coupon",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: tempCoupon),
                decoration: const InputDecoration(
                  labelText: "Coupon Code",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number_outlined),
                ),
                onChanged: (val) {
                  tempCoupon = val;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _couponCode = tempCoupon;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Apply Coupon"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showChargesSheet() {
    double tempDelivery = _deliveryCharges;
    double tempPackage = _packageCharges;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Extra Charges",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: tempDelivery > 0 ? tempDelivery.toString() : '',
                ),
                decoration: const InputDecoration(
                  labelText: "Delivery Charges (Rs)",
                  border: OutlineInputBorder(),
                  prefixText: "Rs ",
                ),
                onChanged: (val) {
                  tempDelivery = double.tryParse(val) ?? 0.0;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: tempPackage > 0 ? tempPackage.toString() : '',
                ),
                decoration: const InputDecoration(
                  labelText: "Package Charges (Rs)",
                  border: OutlineInputBorder(),
                  prefixText: "Rs ",
                ),
                onChanged: (val) {
                  tempPackage = double.tryParse(val) ?? 0.0;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _deliveryCharges = tempDelivery;
                      _packageCharges = tempPackage;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Apply Charges"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.items.fold<double>(
      0,
      (double sum, OrderItem item) => sum + (item.price * item.quantity),
    );
    final tax = subtotal * 0.13;
    final total =
        subtotal + tax - _orderDiscount + _deliveryCharges + _packageCharges;
    bool customerSelected = widget.customerName.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Top Header
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.menu, color: Colors.grey),
              TextButton(
                onPressed: widget.onCustomerSelect,
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: customerSelected
                          ? Color(0xFF10B981).withAlpha(200)
                          : Colors.grey,
                    ),
                    Text(
                      "Customer",
                      style: TextStyle(
                        fontSize: 10,
                        color: customerSelected
                            ? Color(0xFF10B981).withAlpha(200)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.drafts, color: Colors.grey),
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
              Expanded(
                child: Text(
                  widget.customerName.isEmpty
                      ? "No customer selected"
                      : "${widget.customerName} | ${widget.customerPhone}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.customerName.isEmpty
                        ? Colors.grey
                        : Color(0xFF1E293B),
                  ),
                ),
              ),
              if (widget.customerName.isNotEmpty)
                CloseButton(
                  onPressed: widget.onCustomerClear,
                  color: Colors.red,
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(CircleBorder()),
                    iconSize: WidgetStatePropertyAll(17),
                  ),
                ),
            ],
          ),
          if (widget.customerBalance.isNotEmpty)
            Text(
              "Outstanding Balance: Rs ${widget.customerBalance}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
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
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              spacing: 2,
              children: [
                if (showSummary) ...[
                  _summaryRow(
                    "Subtotal",
                    "Rs ${subtotal.toStringAsFixed(2)}",
                    true,
                  ),
                  _summaryRow(
                    "Tax (13%)",
                    "Rs ${tax.toStringAsFixed(2)}",
                    true,
                  ),
                  if (_orderDiscount > 0)
                    _summaryRow(
                      "Discount",
                      "- Rs ${_orderDiscount.toStringAsFixed(2)}",
                      true,
                      color: Colors.red,
                    ),
                  if (_deliveryCharges > 0)
                    _summaryRow(
                      "Delivery Charges",
                      "Rs ${_deliveryCharges.toStringAsFixed(2)}",
                      true,
                    ),
                  if (_packageCharges > 0)
                    _summaryRow(
                      "Package Charges",
                      "Rs ${_packageCharges.toStringAsFixed(2)}",
                      true,
                    ),

                  Container(
                    height: 35,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Apply", style: TextStyle(fontSize: 14)),
                            Icon(
                              Icons.keyboard_double_arrow_right_rounded,
                              size: 20,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _showDiscountSheet,
                          child: Text(
                            "Discount",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _showCouponSheet,
                          child: Text(
                            "Coupon",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Charges",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider(color: Colors.grey[300]),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Text(
                      "${widget.items.length} items | ${widget.items.fold<int>(0, (int sum, OrderItem item) => sum + item.quantity)} units",
                      style: const TextStyle(fontSize: 13),
                    ),
                    // Show count of items with discount
                    if (widget.items
                        .where((item) => (item.discount ?? 0) > 0)
                        .isNotEmpty)
                      Text(
                        " | ${widget.items.where((item) => (item.discount ?? 0) > 0).length} discount",
                        style: const TextStyle(fontSize: 13),
                      ),
                    if (widget.items.where((item) => (item.isFree)).isNotEmpty)
                      Text(
                        " | ${widget.items.where((item) => (item.isFree)).length} Fere",
                        style: const TextStyle(fontSize: 13),
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
