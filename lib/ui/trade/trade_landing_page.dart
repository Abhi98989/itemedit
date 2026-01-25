import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/widget/orderitemtiler.dart';
import 'package:itemedit/ui/trade/model/product_class.dart';
import 'widget/productarea.dart';
import 'widget/payment_widget.dart';
import 'widget/custom_num.dart';

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
    final TextEditingController searchController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Filter customers based on search query
            List<dynamic> filteredCustomers = customers.where((customer) {
              final searchQuery = searchController.text.toLowerCase();
              final name = customer.name.toLowerCase();
              final phone = customer.phone.toLowerCase();
              return name.contains(searchQuery) || phone.contains(searchQuery);
            }).toList();
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Container(
                  color: Colors.white,
                  width: 700,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
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
                          Row(
                            spacing: 16,
                            children: [
                              TextButton(
                                onPressed: () {
                                  //todo
                                },
                                child: Row(
                                  children: const [
                                    Icon(Icons.add),
                                    Text("Add New Customer"),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  searchController.dispose();
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search Field
                      TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {}); // Rebuild to update filtered list
                        },
                        decoration: InputDecoration(
                          hintText: "Search by name or phone number",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontFamily: 'SanFrancisco',
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey.shade600,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xff7CD23D),
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'SanFrancisco',
                        ),
                      ),
                      // const Divider(height: 1),
                      // Customer List
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: filteredCustomers.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person_off_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        searchController.text.isEmpty
                                            ? "No customers found"
                                            : "No matching customers",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'SanFrancisco',
                                        ),
                                      ),
                                      if (searchController.text.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            "Try different search terms",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade500,
                                              fontFamily: 'SanFrancisco',
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredCustomers.length,
                                itemBuilder: (context, index) {
                                  final customer = filteredCustomers[index];
                                  return Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                      leading: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: const Color(
                                          0xff7CD23D,
                                        ),
                                        child: Text(
                                          customer.name[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            customer.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              fontFamily: 'SanFrancisco',
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              //todo
                                            },
                                            child: Text(
                                              "View",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'SanFrancisco',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                size: 13,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                customer.phone,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade700,
                                                  fontFamily: 'SanFrancisco',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 13,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  customer.address,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade700,
                                                    fontFamily: 'SanFrancisco',
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "Outstanding: Rs ${customer.outstandingbalance}",
                                              style: const TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                fontFamily: 'SanFrancisco',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      isThreeLine: true,
                                      onTap: () {
                                        // Use the outer setState to update the parent widget
                                        this.setState(() {
                                          selectedCustomer = customer;
                                          isCustomerSelected = true;
                                          customerName = customer.name;
                                          customerPhone = customer.phone;
                                          customerAddress = customer.address;
                                          customerBalance =
                                              customer.outstandingbalance;
                                        });
                                        searchController.dispose();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
        // Item exists, update quantity and move to top
        items[index].quantity += quantity;
        final item = items.removeAt(index);
        items.insert(0, item);
      } else {
        // New item, add to top
        items.insert(
          0,
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
      backgroundColor: Colors.white,
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
                    // Move the updated item to the top
                    final item = items.removeAt(index);
                    items.insert(0, item);
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
            child: (isPaymentMode == true)
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
                    onSelectCustomer: _showCustomerSelectionDialog,
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
  final double _deliveryCharges = 0.0;
  double _packageCharges = 0.0;
  String _couponCode = "";

  // Store dynamic charges
  final List<Map<String, dynamic>> _chargeTypes = [];
  final List<Map<String, dynamic>> _customDiscounts = [];
  double _orderTip = 0;
  bool _isDiscountPercentage = false;

  // Track highlighted item for animation
  String? _highlightedItemName;

  @override
  void didUpdateWidget(OrderSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detect if items list changed (new item added or reordered)
    if (widget.items.isNotEmpty &&
        (oldWidget.items.isEmpty ||
            oldWidget.items.first.name != widget.items.first.name ||
            (oldWidget.items.isNotEmpty &&
                oldWidget.items.first.quantity !=
                    widget.items.first.quantity))) {
      // Highlight the first item (most recently updated)
      setState(() {
        _highlightedItemName = widget.items.first.name;
      });

      // Remove highlight after animation
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _highlightedItemName = null;
          });
        }
      });
    }
  }

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
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    " - Rs ${item.price}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 48),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: Color(0xff7CD23D),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.black),
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
                                      fontSize: 16,
                                      fontFamily: 'SanFrancisco',
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
                                    _inputField("Percentage", "% ", (v) {
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
                                    _inputField("Amount", "Rs ", (v) {
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
                          Row(
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
                                child: const Text(
                                  "Remove from Cart",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'sanFrancisco',
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

  Widget _inputField(
    String label,
    // String hint,
    String prefix,
    ValueChanged<String> onChanged,
  ) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        // hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'SanFrancisco'),
        prefix: Text(prefix),
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'SanFrancisco', fontSize: 13),
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
    bool isPercentage = _isDiscountPercentage == true;

    final controller = TextEditingController(
      text: tempDiscount > 0 ? tempDiscount.toString() : "",
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Content
                  Expanded(
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
                            border: Border(
                              bottom: BorderSide(color: Colors.black12),
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Expanded(
                                child: Text(
                                  "ADD DISCOUNT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              // TextButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       _orderDiscount = tempDiscount;
                              //       _isDiscountPercentage = isPercentage;
                              //     });
                              //     Navigator.pop(context);
                              //   },
                              //   style: TextButton.styleFrom(
                              //     backgroundColor: Colors.white,
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 16,
                              //       vertical: 8,
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(6),
                              //     ),
                              //     side: const BorderSide(color: Colors.black),
                              //   ),
                              //   child: const Text(
                              //     "SAVE",
                              //     style: TextStyle(color: Color(0xff7CD23D)),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        label: Text(
                                          isPercentage
                                              ? "Enter in percentage %"
                                              : "Enter in Amount Rs",
                                        ),
                                        prefixText: isPercentage ? "%" : "Rs",
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
                                  Text(isPercentage ? "%" : "Rs"),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _customDiscounts.map((discount) {
                                  return FilterChip(
                                    label: Text(
                                      "${discount['name']} (${discount['value']}${discount['type'] == 'percentage' ? '%' : 'Rs'})",
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right Keyboard
                  Container(
                    width: 380,
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.black12)),
                    ),
                    child: CustomKeyboard(
                      controller: controller,
                      onClose: () {
                        setState(() {
                          _orderDiscount =
                              double.tryParse(controller.text) ?? 0;
                          _isDiscountPercentage = isPercentage;
                        });
                        Navigator.pop(context);
                      },
                      onDiscount: () {},
                      onCoupon: () {
                        Navigator.pop(context);
                        _showCouponSheet();
                      },
                      onCharges: () {
                        Navigator.pop(context);
                        _showSelectChargeSheet();
                      },
                      onTips: () {
                        Navigator.pop(context);
                        _showAddtipedChargeSheet();
                      },
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
    bool isPercentage = true;
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                    ),
                    onChanged: (value) => discountName = value,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Discount Value",
                      labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
                    ),
                    onChanged: (value) =>
                        discountValue = double.tryParse(value) ?? 0,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Type",
                          style: TextStyle(fontFamily: 'SanFrancisco'),
                        ),
                      ),
                      Checkbox(
                        value: isPercentage,
                        onChanged: (v) {
                          setDialogState(() {
                            isPercentage = v ?? true;
                          });
                        },
                      ),
                      Text(isPercentage ? "%" : "Rs"),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
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
                    setState(() {
                      _customDiscounts.add({
                        'name': discountName.trim(),
                        'value': discountValue,
                        'type': isPercentage ? 'percentage' : 'amount',
                      });
                    });
                    setSheetState(() {});
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Added discount: $discountName"),
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
      },
    );
  }

  void _showCouponSheet() {
    String tempCoupon = _couponCode;
    final controller = TextEditingController(text: tempCoupon);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black12),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              "APPLY COUPON",
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
                                _couponCode = controller.text;
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
                              side: const BorderSide(color: Colors.black),
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
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: "Coupon Code",
                          labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
                          prefixIcon: Icon(Icons.confirmation_number_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 450,
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.black12)),
                ),
                child: CustomKeyboard(
                  controller: controller,
                  onClose: () {
                    setState(() {
                      _couponCode = controller.text;
                    });
                    Navigator.pop(context);
                  },
                  onDiscount: () {
                    Navigator.pop(context);
                    _showDiscountSheet();
                  },
                  onCoupon: () {},
                  onCharges: () {
                    Navigator.pop(context);
                    _showSelectChargeSheet();
                  },
                  onTips: () {
                    Navigator.pop(context);
                    _showAddtipedChargeSheet();
                  },
                ),
              ),
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
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
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
                                    labelStyle: const TextStyle(
                                      fontFamily: 'SanFrancisco',
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'SanFrancisco',
                                  ),
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
                              Text(isPercentage ? "%" : "Rs"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff7CD23D),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () {
                                final value =
                                    double.tryParse(controller.text) ?? 0;
                                if (value <= 0) return;
                                setState(() {
                                  _chargeTypes.add({
                                    "name": chargeName,
                                    "value": value,
                                    "type": isPercentage
                                        ? "percentage"
                                        : "amount",
                                    "active": true,
                                  });
                                  if (isPercentage) {
                                    _packageCharges +=
                                        (widget.items.fold<double>(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              (item.price * item.quantity),
                                        ) *
                                        value /
                                        100);
                                  } else {
                                    _packageCharges += value;
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("APPLY"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 450,
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.black12)),
                    ),
                    child: CustomKeyboard(
                      controller: controller,
                      onClose: () {
                        final value = double.tryParse(controller.text) ?? 0;
                        if (value > 0) {
                          setState(() {
                            _chargeTypes.add({
                              "name": chargeName,
                              "value": value,
                              "type": isPercentage ? "percentage" : "amount",
                              "active": true,
                            });
                            if (isPercentage) {
                              _packageCharges +=
                                  (widget.items.fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + (item.price * item.quantity),
                                  ) *
                                  value /
                                  100);
                            } else {
                              _packageCharges += value;
                            }
                          });
                        }
                        Navigator.pop(context);
                      },
                      onDiscount: () {
                        Navigator.pop(context);
                        _showDiscountSheet();
                      },
                      onCoupon: () {
                        Navigator.pop(context);
                        _showCouponSheet();
                      },
                      onCharges: () {},
                      onTips: () {
                        Navigator.pop(context);
                        _showAddtipedChargeSheet();
                      },
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

  void _showAddtipedChargeSheet() {
    double tempTip = _orderTip;
    final controller = TextEditingController(
      text: tempTip > 0 ? tempTip.toString() : "",
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black12),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              "ADD TIP",
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
                                _orderTip =
                                    double.tryParse(controller.text) ?? 0;
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
                              side: const BorderSide(color: Colors.black),
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
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: "Tip Amount",
                          prefixText: "Rs ",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 450,
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.black12)),
                ),
                child: CustomKeyboard(
                  controller: controller,
                  onClose: () {
                    setState(() {
                      _orderTip = double.tryParse(controller.text) ?? 0;
                    });
                    Navigator.pop(context);
                  },
                  onDiscount: () {
                    Navigator.pop(context);
                    _showDiscountSheet();
                  },
                  onCoupon: () {
                    Navigator.pop(context);
                    _showCouponSheet();
                  },
                  onCharges: () {
                    Navigator.pop(context);
                    _showSelectChargeSheet();
                  },
                  onTips: () {},
                ),
              ),
            ],
          ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          "SELECT CHARGE",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  if (_chargeTypes.any((charge) => charge['active'] == true))
                    Padding(
                      padding: const EdgeInsets.all(16),
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
                          ..._chargeTypes
                              .where((charge) => charge['active'] == true)
                              .map((charge) {
                                return ListTile(
                                  title: Text(
                                    "${charge['name']}: ${charge['value']}${charge['type'] == 'percentage' ? '%' : 'Rs'}",
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        charge['active'] = false;
                                        double val = charge['value'];
                                        if (charge['type'] == 'percentage') {
                                          _packageCharges -=
                                              (widget.items.fold<double>(
                                                0,
                                                (sum, item) =>
                                                    sum +
                                                    (item.price *
                                                        item.quantity),
                                              ) *
                                              val /
                                              100);
                                        } else {
                                          _packageCharges -= val;
                                        }
                                      });
                                      setModalState(() {});
                                    },
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ...charges.map(
                    (charge) => ListTile(
                      title: Text(charge),
                      onTap: () {
                        Navigator.pop(context);
                        _showChargeAmountSheet(charge);
                      },
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

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.items.fold<double>(
      0,
      (double sum, OrderItem item) => sum + (item.price * item.quantity),
    );
    final tax = subtotal * 0.13;
    final discountAmount = (_isDiscountPercentage == true)
        ? (subtotal * _orderDiscount / 100)
        : _orderDiscount;
    final total =
        subtotal +
        tax -
        discountAmount +
        _deliveryCharges +
        _packageCharges +
        _orderTip;
    bool customerSelected = widget.customerName.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          IntrinsicHeight(
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.black, size: 26),
                VerticalDivider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
                IconButton(
                  onPressed: widget.onCustomerSelect,
                  icon: Icon(
                    Icons.person_add_alt_1_sharp,
                    color: customerSelected
                        ? const Color(0xff7CD23D)
                        : Colors.black,
                    size: 26,
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.drafts, color: Colors.black, size: 26),
                ),
                VerticalDivider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFE2E8F0)),
          // Customer Info
          if (customerSelected) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.customerName} | ${widget.customerPhone}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onCustomerClear,
                  icon: const Icon(Icons.clear, color: Colors.red, size: 20),
                ),
              ],
            ),
            if (widget.customerAddress.isNotEmpty)
              Text(
                "Location: ${widget.customerAddress}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            if (widget.customerBalance.isNotEmpty)
              Text(
                "Balance: Rs ${widget.customerBalance}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            const Divider(color: Color(0xFFE2E8F0)),
          ],

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
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isHighlighted = _highlightedItemName == item.name;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isHighlighted
                              ? const Color(0xff7CD23D).withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: OrderItemTile(
                          item: item,
                          onRemove: () => widget.onRemove(index),
                          onQuantityChange: (newQty) =>
                              widget.onQuantityChange(index, newQty),
                          onTap: () => _showEditItemDialog(context, index),
                          isdiscount: (item.discount ?? 0) > 0,
                        ),
                      );
                    },
                  ),
          ),

          // Summary Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                if (showSummary == true) ...[
                  _summaryRow(
                    "Subtotal",
                    "Rs ${subtotal.toStringAsFixed(2)}",
                    false,
                  ),
                  if (discountAmount > 0)
                    _summaryRow(
                      "Discount",
                      "- Rs ${discountAmount.toStringAsFixed(2)}",
                      false,
                      color: Colors.red,
                    ),
                  _summaryRow(
                    "Tax (13%)",
                    "Rs ${tax.toStringAsFixed(2)}",
                    false,
                  ),
                  if (_deliveryCharges > 0)
                    _summaryRow(
                      "Delivery",
                      "Rs ${_deliveryCharges.toStringAsFixed(2)}",
                      false,
                    ),
                  if (_packageCharges > 0)
                    _summaryRow(
                      "Charges",
                      "Rs ${_packageCharges.toStringAsFixed(2)}",
                      false,
                    ),
                  if (_orderTip > 0)
                    _summaryRow(
                      "Tip",
                      "Rs ${_orderTip.toStringAsFixed(2)}",
                      false,
                    ),
                  const SizedBox(height: 8),

                  // Quick Actions
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xff7CD23D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Apply",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'sanfrancisco',
                          ),
                        ),
                        Icon(Icons.keyboard_double_arrow_right_outlined),
                        _quickActionButton("Discount", _showDiscountSheet),
                        _quickActionButton("Coupon", _showCouponSheet),
                        _quickActionButton("Charges", _showSelectChargeSheet),
                        _quickActionButton("Tips", _showAddtipedChargeSheet),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Total Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          setState(() => showSummary = !showSummary),
                      icon: Icon(
                        (showSummary == true)
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Text(
                      "Rs ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Footer Info
                Row(
                  children: [
                    Text(
                      "${widget.items.length} items | ${widget.items.fold<int>(0, (sum, item) => sum + item.quantity)} units",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _quickActionButton(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xff7CD23D),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
