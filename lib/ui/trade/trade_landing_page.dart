import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/widget/orderitemtiler.dart';
import 'package:itemedit/ui/trade/model/product_class.dart';
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
                        fontFamily: 'SanFrancisco',
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
                            backgroundColor: const Color(0xff7CD23D),
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
                              Text(
                                "Phone: ${customer.phone}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
                              Text(
                                "Address: ${customer.address}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
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
                                content: Text(
                                  "Selected: ${customer.name}",
                                  style: const TextStyle(
                                    fontFamily: 'SanFrancisco',
                                  ),
                                ),
                                backgroundColor: const Color(0xff7CD23D),
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

  void clearItems() {
    setState(() {
      items.clear();
    });
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
                          title: const Text(
                            "Payment Confirmed",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
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
                    onDeleteClick: clearItems,
                    onPaymentClick: () {
                      setState(() {
                        isPaymentMode = true;
                      });
                    },
                    onSaveDraft: () {
                      if (items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "No items to save as draft",
                              style: TextStyle(fontFamily: 'SanFrancisco'),
                            ),
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
                              Icon(Icons.save, color: Color(0xff7CD23D)),
                              SizedBox(width: 10),
                              Text(
                                "Draft Saved",
                                style: TextStyle(fontFamily: 'SanFrancisco'),
                              ),
                            ],
                          ),
                          content: Text(
                            "Your draft with ${items.length} items has been saved successfully.",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  items.clear();
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
                          content: Text(
                            "Add functionality coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                    onDiscountsClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Discounts functionality coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                    onFavoritesClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Favorites functionality coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                    onScanClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Scan functionality coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                    onMoreClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "More options coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
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

  // Store dynamic charges
  final List<Map<String, dynamic>> _customCharges = [];
  final List<Map<String, dynamic>> _chargeTypes = [
    // {
    //   "name": "Service Charge",
    //   "value": 5.0,
    //   "type": "percentage", // percentage | amount
    //   "active": false,
    // },
    // {
    //   "name": "Handling Charge",
    //   "value": 50.0,
    //   "type": "amount",
    //   "active": false,
    // },
  ];

  void _showEditItemDialog(BuildContext context, int index) {
    final item = widget.items[index];
    int tempQty = item.quantity;
    String tempNote = item.note ?? "";
    double tempDiscount = item.discount ?? 0;
    bool tempIsFree = item.isFree;
    // bool discountTypeA = false;
    // bool discountTypeB = false;
    bool applyBeforeTax = true;
    String? offerType;

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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Rs ${item.price}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 48),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // backgroundColor: Color(0xff7CD23D),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 11,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Color(0xff7CD23D),
                                    ),
                                  ),
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
                                    color: Color(0xff7CD23D),
                                    fontFamily: 'SanFrancisco',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 22),

                        /// QUANTITY
                        const Text(
                          "Quantity",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
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
                                      textAlign: TextAlign.center,
                                      controller: TextEditingController(
                                        text: tempQty.toString(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onChanged: (v) {
                                        final q = int.tryParse(v);
                                        if (q != null && q > 0) {
                                          setDialogState(() => tempQty = q);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rs ${subtotal.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
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

                        /// NOTE
                        TextField(
                          controller: noteController,
                          decoration: const InputDecoration(labelText: "Note"),
                        ),
                        const SizedBox(height: 20),

                        /// APPLY OFFER
                        const Text(
                          "Apply Offer",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _offerTypeButton(
                                context,
                                "Discount",
                                "discount",
                                offerType,
                                (value) => setDialogState(() {
                                  offerType = value;
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
                                "free",
                                offerType,
                                (value) => setDialogState(() {
                                  offerType = value;
                                  tempIsFree = true;
                                  tempDiscount = 0;
                                }),
                              ),
                            ),
                          ],
                        ),

                        /// FREE INFO
                        if (offerType == "free") ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    "This item will be shown as FREE on the receipt.",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        /// DISCOUNT OPTIONS
                        if (offerType == "discount") ...[
                          const SizedBox(height: 16),

                          /// BEFORE / AFTER TAX
                          // const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text(
                                "Discount Apply:",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Expanded(
                                child: ChoiceChip(
                                  label: const Text("Before Tax"),
                                  selected: applyBeforeTax,
                                  onSelected: (_) => setDialogState(() {
                                    applyBeforeTax = true;
                                  }),
                                ),
                              ),
                              Expanded(
                                child: ChoiceChip(
                                  label: const Text("After Tax"),
                                  selected: !applyBeforeTax,
                                  onSelected: (_) => setDialogState(() {
                                    applyBeforeTax = false;
                                  }),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 4),
                          // Text(
                          //   applyBeforeTax
                          //       ? "Discount applied before tax calculation"
                          //       : "Discount applied after tax calculation",
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     color: Colors.grey.shade600,
                          //   ),
                          // ),
                          const SizedBox(height: 9),

                          /// DISCOUNT INPUTS
                          Row(
                            spacing: 3,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _inputField("Percentage", "%", (v) {
                                      final p = double.tryParse(v) ?? 0;
                                      setDialogState(() {
                                        tempDiscount = subtotal * p / 100;
                                      });
                                    }),
                                    const SizedBox(height: 4),
                                    Text(
                                      "By percentage",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("OR"),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _inputField("Amount", "Rs", (v) {
                                      final p = double.tryParse(v) ?? 0;
                                      setDialogState(() {
                                        tempDiscount = p * tempQty;
                                      });
                                    }),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Discount Price (per item)",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),

                        /// SUMMARY
                        if (offerType != null)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  offerType == "free"
                                      ? "FREE"
                                      : "Rs ${total.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: offerType == "free"
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),

                        /// ACTION BUTTONS
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text("Remove from Cart"),
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
  // Store dynamic discounts
  final List<Map<String, dynamic>> _customDiscounts = [];

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
    String value,
    String? groupValue,
    ValueChanged<String?> onChanged,
  ) {
    final bool isSelected = groupValue == value;
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'SanFrancisco')),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _inputField(
    String label,
    String hint,
    ValueChanged<String> onChanged,
  ) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'SanFrancisco'),
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'SanFrancisco', fontSize: 13),

        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        // contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
            fontFamily: 'SanFrancisco',
          ),
        ),
      ],
    );
  }

  void _showDiscountSheet() {
    double tempDiscount = _orderDiscount;
    bool isPercentage = true;

    final controller = TextEditingController(
      text: tempDiscount > 0 ? tempDiscount.toString() : "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// TOP BAR
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "SELECT OR ENTER DISCOUNT VALUE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _orderDiscount = tempDiscount;
                            });
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "SAVE",
                            style: TextStyle(color: Color(0xff7CD23D)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// INPUT LABEL
                        Text(
                          isPercentage
                              ? "Enter Discount in %"
                              : "Enter Discount Amount",
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 6),

                        /// INPUT FIELD
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: UnderlineInputBorder(),
                                ),
                                onChanged: (v) {
                                  tempDiscount = double.tryParse(v) ?? 0;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Checkbox(
                              value: isPercentage,
                              onChanged: (v) {
                                setSheetState(() {
                                  isPercentage = v ?? true;
                                });
                              },
                            ),
                            const Text("%"),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// ADD NEW DISCOUNT
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Show dialog to add new discount type
                              _showAddDiscountDialog(setSheetState);
                            },
                            child: const Text(
                              "ADD NEW DISCOUNT",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// CUSTOM DISCOUNTS
                        if (_customDiscounts.isNotEmpty) ...[
                          Text(
                            "Custom Discounts",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _customDiscounts.map((discount) {
                              return FilterChip(
                                label: Text(
                                  "${discount['name']} (${discount['value']}%)",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                selected: false,
                                onSelected: (bool selected) {
                                  setSheetState(() {
                                    isPercentage =
                                        discount['type'] == 'percentage';
                                    tempDiscount = discount['value'];
                                    controller.text = discount['value']
                                        .toString();
                                  });
                                },
                                backgroundColor: Colors.grey.shade200,
                                selectedColor: const Color(0xff7CD23D),
                                checkmarkColor: Colors.white,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                        ],

                        /// PRESET DISCOUNTS
                        // Text(
                        //   "Preset Discounts",
                        //   style: const TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 14,
                        //   ),
                        // ),

                        // const SizedBox(height: 8),
                        // Wrap(
                        //   spacing: 8,
                        //   runSpacing: 8,
                        //   children: [
                        //     FilterChip(
                        //       label: const Text("ABISEK (10%)"),
                        //       selected: false,
                        //       onSelected: (bool selected) {
                        //         setSheetState(() {
                        //           isPercentage = true;
                        //           tempDiscount = 10;
                        //           controller.text = "10";
                        //         });
                        //       },
                        //       backgroundColor: Colors.grey.shade200,
                        //       selectedColor: const Color(0xff7CD23D),
                        //       checkmarkColor: Colors.white,
                        //     ),
                        //     FilterChip(
                        //       label: const Text("INSOFT (10%)"),
                        //       selected: false,
                        //       onSelected: (bool selected) {
                        //         setSheetState(() {
                        //           isPercentage = true;
                        //           tempDiscount = 10;
                        //           controller.text = "10";
                        //         });
                        //       },
                        //       backgroundColor: Colors.grey.shade200,
                        //       selectedColor: const Color(0xff7CD23D),
                        //       checkmarkColor: Colors.white,
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddDiscountDialog(StateSetter setSheetState) {
    String discountName = "";
    double discountValue = 0;
    bool isPercentage = true; // Default to percentage
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Add New Discount",
            style: TextStyle(fontFamily: 'SanFrancisco'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Discount Name",
                  labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  discountName = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Discount Value",
                  labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  discountValue = double.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Rupees (Rs)",
                      style: TextStyle(fontFamily: 'SanFrancisco'),
                    ),
                  ),
                  Checkbox(
                    value:
                        !isPercentage, // Inverted because checked means rupees, unchecked means percentage
                    onChanged: (value) {
                      setState(() {
                        isPercentage = !(value ?? false);
                      });
                    },
                  ),
                  const Text(
                    "Percentage",
                    style: TextStyle(fontFamily: 'SanFrancisco'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (discountName.trim().isEmpty || discountValue <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter valid discount name and value",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Add the new discount to the list
                _customDiscounts.add({
                  'name': discountName.trim(),
                  'value': discountValue,
                  'type': isPercentage ? 'percentage' : 'amount',
                });

                // Close the dialog
                Navigator.pop(context);

                // Show snackbar to confirm
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added discount: \$discountName"),
                    backgroundColor: const Color(0xff7CD23D),
                  ),
                );
              },
              child: const Text("Add"),
            ),
          ],
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: tempCoupon),
                decoration: const InputDecoration(
                  labelText: "Coupon Code",
                  labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
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
                    backgroundColor: const Color(0xff7CD23D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Apply Coupon",
                    style: TextStyle(fontFamily: 'SanFrancisco'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showChargeAmountSheet(String chargeName) {
    final controller = TextEditingController();
    bool isPercentage = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      chargeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: isPercentage
                                  ? "Percentage (%)"
                                  : "Amount (Rs)",
                              prefixText: isPercentage ? "% " : "Rs ",
                              border: const OutlineInputBorder(),
                              labelStyle: const TextStyle(
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                            style: const TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Container(
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.grey.shade300),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: ChoiceChip(
                        //     label: Text(isPercentage ? "%" : "Rs"),
                        //     selected: isPercentage,
                        //     onSelected: (selected) {
                        //       setSheetState(() {
                        //         isPercentage = selected;
                        //       });
                        //     },
                        //   ),
                        // ),

                        /// TOGGLE % / RS
                        ToggleButtons(
                          isSelected: [isPercentage, !isPercentage],
                          onPressed: (index) {
                            setSheetState(() {
                              isPercentage = index == 0;
                            });
                          },
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text("%"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text("Rs"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// APPLY
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff7CD23D),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          final value = double.tryParse(controller.text) ?? 0;
                          if (value <= 0) return;

                          setState(() {
                            _chargeTypes.add({
                              "name": chargeName,
                              "value": value,
                              "type": isPercentage ? "percentage" : "amount",
                            });
                          });

                          Navigator.pop(context);
                        },
                        child: const Text("APPLY"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSelectChargeSheet() {
    final charges = [
      "Delivery Charge",
      "Packing Charge",
      "Service Charge/Fee",
      "Other Charge",
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    /// HEADER
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "SELECT CHARGE",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),

                    /// ACTIVE CHARGES LIST
                    if (_chargeTypes.any((charge) => charge['active'] == true))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Active Charges:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xff7CD23D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ..._chargeTypes
                                .where((charge) => charge['active'] == true)
                                .map((charge) {
                                  return Card(
                                    color: Colors.grey.shade100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${charge['name']}: ${charge['value']}\${charge['type'] == 'percentage' ? '%' : 'Rs'}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 16,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                charge['active'] = false;
                                                if (charge['type'] ==
                                                    'percentage') {
                                                  // For percentage, we'll recalculate the total
                                                  _packageCharges =
                                                      _packageCharges -
                                                      (widget.items.fold<
                                                            double
                                                          >(
                                                            0,
                                                            (
                                                              double sum,
                                                              OrderItem item,
                                                            ) =>
                                                                sum +
                                                                (item.price *
                                                                    item.quantity),
                                                          ) *
                                                          charge['value'] /
                                                          100);
                                                } else {
                                                  _packageCharges -=
                                                      charge['value'];
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),

                    /// LIST
                    ...charges.map(
                      (charge) => ListTile(
                        title: Text(charge),
                        onTap: () {
                          Navigator.pop(context);
                          _showChargeAmountSheet(charge);
                        },
                      ),
                    ),

                    /// CUSTOM CHARGES FROM THE LIST
                    if (_chargeTypes.any(
                      (charge) => !charges.contains(charge['name']),
                    ))
                      ..._chargeTypes
                          .where((charge) => !charges.contains(charge['name']))
                          .map(
                            (charge) => ListTile(
                              title: Text(charge['name']),
                              subtitle: Text(
                                "${charge['value']}\${charge['type'] == 'percentage' ? '%' : 'Rs'}",
                              ),
                              trailing: Checkbox(
                                value: charge['active'],
                                onChanged: (value) {
                                  setModalState(() {
                                    charge['active'] = value!;
                                  });
                                  setState(() {
                                    if (value!) {
                                      if (charge['type'] == 'percentage') {
                                        _packageCharges +=
                                            (widget.items.fold<double>(
                                              0,
                                              (double sum, OrderItem item) =>
                                                  sum +
                                                  (item.price * item.quantity),
                                            ) *
                                            charge['value'] /
                                            100);
                                      } else {
                                        _packageCharges += charge['value'];
                                      }
                                    } else {
                                      if (charge['type'] == 'percentage') {
                                        // For percentage, we'll recalculate the total
                                        _packageCharges =
                                            _packageCharges -
                                            (widget.items.fold<double>(
                                                  0,
                                                  (
                                                    double sum,
                                                    OrderItem item,
                                                  ) =>
                                                      sum +
                                                      (item.price *
                                                          item.quantity),
                                                ) *
                                                charge['value'] /
                                                100);
                                      } else {
                                        _packageCharges -= charge['value'];
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                          ),

                    /// APPLY BUTTON
                    // Padding(
                    //   padding: const EdgeInsets.all(16),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xff7CD23D),
                    //       foregroundColor: Colors.white,
                    //       padding: const EdgeInsets.symmetric(
                    //         vertical: 12,
                    //         horizontal: 32,
                    //       ),
                    //     ),
                    //     child: const Text("APPLY CHARGES"),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
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
                          ? Color(0xff7CD23D).withAlpha(200)
                          : Colors.grey,
                    ),
                    Text(
                      "Customer",
                      style: TextStyle(
                        fontSize: 10,
                        color: customerSelected
                            ? Color(0xff7CD23D).withAlpha(200)
                            : Colors.grey,
                        fontFamily: 'SanFrancisco',
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
                    Text(
                      "Draft",
                      style: TextStyle(
                        fontFamily: 'SanFrancisco',
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Divider(color: const Color(0xFFE2E8F0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.customerName.isEmpty
                    ? ""
                    : "${widget.customerName} | ${widget.customerPhone}",
                style: TextStyle(
                  fontSize: 13,
                  color: widget.customerName.isEmpty
                      ? Colors.grey
                      : Color(0xFF1E293B),
                  fontFamily: 'SanFrancisco',
                ),
              ),
              if (widget.customerName.isNotEmpty)
                IconButton(
                  onPressed: widget.onCustomerClear,
                  icon: const Icon(Icons.clear),
                  color: Colors.red,
                  iconSize: 20,
                ),
            ],
          ),
          if (widget.customerAddress.isNotEmpty)
            Text(
              "Location: ${widget.customerAddress}",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1E293B),
                fontFamily: 'SanFrancisco',
              ),
            ),
          if (widget.customerBalance.isNotEmpty)
            Text(
              "Outstanding Balance: Rs ${widget.customerBalance}",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1E293B),
                fontFamily: 'SanFrancisco',
              ),
            ),
          if (widget.customerName.isNotEmpty)
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
                            fontFamily: 'SanFrancisco',
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
                  if (_orderDiscount > 0)
                    _summaryRow(
                      "Discount",
                      "- Rs ${_orderDiscount.toStringAsFixed(2)}",
                      true,
                      color: Colors.red,
                    ),
                  _summaryRow(
                    "Tax (13%)",
                    "Rs ${tax.toStringAsFixed(2)}",
                    true,
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
                      color: Color(0xff7CD23D).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apply",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
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
                              fontFamily: 'SanFrancisco',
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
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _showSelectChargeSheet();
                          },
                          child: Text(
                            "Charges",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _showSelectChargeSheet();
                          },
                          child: Text(
                            "Tips",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider(color: Colors.grey[300]),
                  const SizedBox(height: 8),
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
                        fontFamily: 'SanFrancisco',
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
                            fontFamily: 'SanFrancisco',
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
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                    // Show count of items with discount
                    if (widget.items
                        .where((item) => (item.discount ?? 0) > 0)
                        .isNotEmpty)
                      Text(
                        " | ${widget.items.where((item) => (item.discount ?? 0) > 0).length} discount",
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'SanFrancisco',
                        ),
                      ),
                    if (widget.items.where((item) => (item.isFree)).isNotEmpty)
                      Text(
                        " | ${widget.items.where((item) => (item.isFree)).length} Fere",
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'SanFrancisco',
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
