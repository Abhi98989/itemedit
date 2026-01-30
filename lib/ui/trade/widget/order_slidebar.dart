import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/widget/custom_num.dart';
import '../model/product_class.dart';
import '../store/local_store.dart';
import '../model/discount_list.dart';
import 'orderitemtiler.dart';

class OrderSidebar extends StatefulWidget {
  final List<OrderItem> items;
  final bool isPaymentMode;
  final Function(int) onRemove;
  final Function(int, double) onQuantityChange;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerBalance;
  final String tipn;
  final VoidCallback onCustomerSelect;
  final VoidCallback onCustomerClear;
  final List<DraftOrder> draftOrders;
  final Function(DraftOrder) onRestoreDraft;

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
    required this.tipn,
    required this.onCustomerSelect,
    required this.onCustomerClear,
    required this.draftOrders,
    required this.onRestoreDraft,
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
  double _orderTip = 0;
  bool _isDiscountPercentage = false;
  bool _isTipPercentage = false;
  List<DraftOrder> draftOrders = [];
  final LocalStore _localStore = LocalStore();
  String? _highlightedItemName;
  final discounts = CustomDiscount.discountList;
  String selectedDiscountlist = "";

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  @override
  void didUpdateWidget(OrderSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync draft orders if they changed in the parent
    final bool draftsChanged =
        oldWidget.draftOrders.length != widget.draftOrders.length ||
        (widget.draftOrders.isNotEmpty &&
            oldWidget.draftOrders.isNotEmpty &&
            (oldWidget.draftOrders.first.id != widget.draftOrders.first.id ||
                oldWidget.draftOrders.last.id != widget.draftOrders.last.id));

    if (draftsChanged) {
      setState(() {
        draftOrders = widget.draftOrders;
      });
    }
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
    double tempQty = item.quantity;
    String tempNote = item.note ?? "";
    double tempDiscount = item.discount ?? 0;
    bool tempIsFree = item.isFree;
    bool applyBeforeTax = true;
    String? offerType;
    final noteController = TextEditingController(text: tempNote);
    final percentageController = TextEditingController();
    final amountrsController = TextEditingController();
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
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Container(
                  width: 500,
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
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 8,
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              onPressed: () {
                                widget.onQuantityChange(
                                  index,
                                  tempQty.toDouble(),
                                );
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
                        Center(
                          child: const Text(
                            "Quantity",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
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
                                        final q = double.tryParse(v);
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
                          decoration: const InputDecoration(
                            labelText: "Note",
                            labelStyle: TextStyle(
                              fontFamily: 'SanFrancisco',
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              "Apply Offer",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Wrap(
                              spacing: 8,
                              children: [
                                ChoiceChip(
                                  label: const Text("Discount"),
                                  selected: offerType == "discount",
                                  backgroundColor: Colors.white,
                                  selectedColor: Colors.grey.shade300,
                                  onSelected: (_) => setDialogState(() {
                                    offerType = "discount";
                                    tempIsFree = false;
                                    tempDiscount = 0;
                                  }),
                                ),
                                ChoiceChip(
                                  label: const Text("Free"),
                                  selected: offerType == "free",
                                  backgroundColor: Colors.white,
                                  selectedColor: Colors.grey.shade300,
                                  onSelected: (_) => setDialogState(() {
                                    offerType = "free";
                                    tempIsFree = true;
                                    tempDiscount = 0;
                                  }),
                                ),
                              ],
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
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'SanFrancisco',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        /// DISCOUNT OPTIONS
                        if (offerType == "discount") ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              const Text(
                                "Discount Apply",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text(
                                  "Before Tax",
                                  style: TextStyle(fontFamily: 'SanFrancisco'),
                                ),
                                backgroundColor: Colors.white,
                                selectedColor: Colors.grey.shade300,
                                selected: applyBeforeTax,
                                onSelected: (_) => setDialogState(() {
                                  applyBeforeTax = true;
                                }),
                              ),
                              ChoiceChip(
                                label: const Text(
                                  "After Tax",
                                  style: TextStyle(fontFamily: 'SanFrancisco'),
                                ),
                                backgroundColor: Colors.white,
                                selectedColor: Colors.grey.shade300,
                                selected: !applyBeforeTax,
                                onSelected: (_) => setDialogState(() {
                                  applyBeforeTax = false;
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Text(
                            "Discount list",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'SanFrancisco',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: discounts.map((discount) {
                              final bool isPercentage =
                                  discount.type == 'percentage';
                              final bool isSelected =
                                  selectedDiscountlist == discount.name;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: FilterChip(
                                  label: SizedBox(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.discount, size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${discount.name} (${discount.value} ${isPercentage ? '%' : 'Rs'})',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  selected: isSelected,
                                  backgroundColor: Colors.white,
                                  selectedColor: Colors.grey.shade300,
                                  checkmarkColor: Colors.black,
                                  side: const BorderSide(color: Colors.black12),
                                  onSelected: (bool selected) {
                                    setDialogState(() {
                                      if (selected) {
                                        selectedDiscountlist = discount.name;
                                        offerType = "discount";
                                        tempIsFree = false;
                                        if (isPercentage) {
                                          double factor = discount.value;
                                          if (factor >= 1.0) factor /= 100;
                                          tempDiscount = subtotal * factor;
                                          item.discountType = "percentage";
                                        } else {
                                          tempDiscount =
                                              discount.value * tempQty;
                                          item.discountType = "amount";
                                        }
                                        if (isPercentage == true) {
                                          percentageController.text = discount
                                              .value
                                              .toString();
                                          amountrsController.clear();
                                        } else {
                                          amountrsController.text = discount
                                              .value
                                              .toString();
                                          percentageController.clear();
                                        }
                                      } else {
                                        selectedDiscountlist = "";
                                        tempDiscount = 0;
                                        item.discountType = null;
                                        percentageController.clear();
                                        amountrsController.clear();
                                      }
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),

                          /// DISCOUNT INPUTS
                          Row(
                            spacing: 3,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _inputField("Percentage(%)", "% ", (v) {
                                      final p = double.tryParse(v) ?? 0;
                                      setDialogState(() {
                                        tempDiscount = subtotal * p / 100;
                                        item.discountType = "percentage";
                                      });
                                    }, percentageController),
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
                                    _inputField("Amount(Rs)", "Rs ", (v) {
                                      final p = double.tryParse(v) ?? 0;
                                      setDialogState(() {
                                        tempDiscount = p * tempQty;
                                        item.discountType = "amount";
                                      });
                                    }, amountrsController),
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

  Widget _inputField(
    String label,
    // String hint,
    String prefix,
    ValueChanged<String> onChanged,
    TextEditingController controller,
  ) {
    return TextField(
      keyboardType: TextInputType.number,
      style: const TextStyle(fontFamily: 'SanFrancisco'),
      controller: controller,
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

  void showDiscountSheet() {
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
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.5,
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
                            vertical: 4,
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
                                onPressed: () {
                                  controller.clear();
                                  Navigator.pop(context);
                                },
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
                                              ? "Percentage(%)"
                                              : "Amount(Rs)",
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
                                  Text(isPercentage ? "Rs" : "%"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: discounts.map((discount) {
                                  final bool isPercentage =
                                      discount.type == 'percentage';
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: FilterChip(
                                      label: SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.discount,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  '${discount.name} (${discount.value} ${isPercentage ? '%' : 'Rs'})',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _orderDiscount =
                                                      double.tryParse(
                                                        controller.text,
                                                      ) ??
                                                      0;
                                                  _isDiscountPercentage =
                                                      isPercentage;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Apply",
                                                style: TextStyle(
                                                  color: Color(0xff7CD23D),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      selected: false,
                                      onSelected: (bool selected) {
                                        setSheetState(() {
                                          var isPercentage =
                                              discount.type == 'percentage';
                                          tempDiscount = discount.value;
                                          controller.text = discount.value
                                              .toString();
                                        });
                                      },
                                      backgroundColor: Colors.grey.shade200,
                                      selectedColor: const Color(0xff7CD23D),
                                      checkmarkColor: Colors.white,
                                    ),
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
                    width: 350,
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
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.4,
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
                          // TextButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       _couponCode = controller.text;
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
                width: 350,
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
                    showDiscountSheet();
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
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.4,
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
                          child: Row(
                            spacing: 16,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                chargeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                                        ? "Percentage(%)"
                                        : "Amount(Rs)",
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
                              Text(isPercentage ? "Rs" : "%"),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 16),
                        // Padding(
                        //   padding: const EdgeInsets.all(16),
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: const Color(0xff7CD23D),
                        //         padding: const EdgeInsets.symmetric(
                        //           vertical: 14,
                        //         ),
                        //       ),
                        //       onPressed: () {
                        //         final value =
                        //             double.tryParse(controller.text) ?? 0;
                        //         if (value <= 0) return;
                        //         setState(() {
                        //           _chargeTypes.add({
                        //             "name": chargeName,
                        //             "value": value,
                        //             "type": isPercentage
                        //                 ? "percentage"
                        //                 : "amount",
                        //             "active": true,
                        //           });
                        //           if (isPercentage) {
                        //             _packageCharges +=
                        //                 (widget.items.fold<double>(
                        //                   0,
                        //                   (sum, item) =>
                        //                       sum +
                        //                       (item.price * item.quantity),
                        //                 ) *
                        //                 value /
                        //                 100);
                        //           } else {
                        //             _packageCharges += value;
                        //           }
                        //         });
                        //         Navigator.pop(context);
                        //       },
                        //       child: const Text("APPLY"),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
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
                        showDiscountSheet();
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
    bool isPercentage = _isTipPercentage == true;
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
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.4,
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
                              // TextButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       _orderTip =
                              //           double.tryParse(controller.text) ?? 0;
                              //       _isTipPercentage = isPercentage;
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: isPercentage
                                        ? "Percentage(%)"
                                        : "Amount(Rs)",
                                    prefixText: isPercentage ? "% " : "Rs ",
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: isPercentage,
                                onChanged: (v) {
                                  setSheetState(() {
                                    isPercentage = v ?? true;
                                  });
                                },
                              ),
                              Text(isPercentage ? "Rs" : "%"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.black12)),
                    ),
                    child: CustomKeyboard(
                      controller: controller,
                      onClose: () {
                        setState(() {
                          _orderTip = double.tryParse(controller.text) ?? 0;
                          _isTipPercentage = isPercentage;
                        });
                        Navigator.pop(context);
                      },
                      onDiscount: () {
                        Navigator.pop(context);
                        showDiscountSheet();
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
      backgroundColor: Colors.white,
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
    final tipAmount = (_isTipPercentage == true)
        ? (subtotal * _orderTip / 100)
        : _orderTip;
    final total =
        subtotal +
        tax -
        discountAmount +
        _deliveryCharges +
        _packageCharges +
        tipAmount;
    bool customerSelected = widget.customerName.isNotEmpty;
    final discountCount = widget.items
        .where((i) => (i.discount ?? 0) > 0)
        .length;
    final freecount = widget.items.where((f) => f.isFree == true).length;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          IntrinsicHeight(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.grey, size: 26),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
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
                        : Colors.grey,
                    size: 26,
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await _loadDrafts();
                        // ignore: use_build_context_synchronously
                        _showDraftsDialog(context);
                      },
                      icon: Icon(
                        Icons.drafts,
                        color: draftOrders.isNotEmpty
                            ? const Color(0xff7CD23D)
                            : Colors.grey,
                        size: 26,
                      ),
                    ),
                    if (draftOrders.isNotEmpty)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${draftOrders.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
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
          SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          // Customer Info
          if (customerSelected) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.customerName} | ${widget.customerPhone}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
                ),
                IconButton(
                  constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: widget.onCustomerClear,
                  icon: const Icon(Icons.clear, color: Colors.red, size: 26),
                ),
              ],
            ),
            if (widget.customerAddress.isNotEmpty)
              if (widget.customerAddress.isNotEmpty)
                Text(
                  "Location: ${widget.customerAddress}",
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
            if (widget.tipn.isNotEmpty)
              Text(
                "Tipn: ${widget.tipn}",
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
            if (widget.customerBalance.isNotEmpty)
              Text(
                "Balance: Rs ${widget.customerBalance}",
                style: const TextStyle(fontSize: 13, color: Colors.black),
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
                              ? const Color(0xff7CD23D).withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: OrderItemTile(
                          item: item,
                          onRemove: () => widget.onRemove(index),
                          onQuantityChange: (double newQty) =>
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
                  if (tipAmount > 0)
                    _summaryRow(
                      "Tip",
                      "Rs ${tipAmount.toStringAsFixed(2)}",
                      false,
                    ),
                  const SizedBox(height: 8),
                  // Quick Actions
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xff7CD23D).withValues(alpha: 0.1),
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
                        _quickActionButton("Discount", showDiscountSheet),
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
                      "${widget.items.length} items | ${widget.items.fold<double>(0.0, (double sum, OrderItem item) => sum + item.quantity).toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')} units",
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    if (discountCount > 0)
                      Text(
                        " | $discountCount discount",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    if (freecount > 0)
                      Text(
                        " | $freecount free",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
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

  //load draft
  Future<void> _loadDrafts() async {
    final drafts = await _localStore.loadDrafts();
    setState(() {
      draftOrders = drafts;
    });
  }

  // delete draft
  Future<void> _removeDraft(String draftId) async {
    await _localStore.removeDraft(draftId);
    await _loadDrafts();
  }

  void _showDraftsDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    DraftOrder? selectedDraft;
    String searchQuery = "";
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredDrafts = draftOrders.where((draft) {
              final query = searchQuery.toLowerCase();
              return draft.customerName.toLowerCase().contains(query) ||
                  draft.id.contains(query) ||
                  draft.customerPhone.contains(query) ||
                  draft.items.any(
                    (item) => item.name.toLowerCase().contains(query),
                  );
            }).toList();
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.white,
                      child: Row(
                        children: [
                          // Search Box
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TextField(
                                controller: searchController,
                                onChanged: (val) =>
                                    setDialogState(() => searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: "Search Orders...",
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontFamily: 'SanFrancisco',
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 18,
                                    color: Colors.grey,
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
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${filteredDrafts.length} / ${draftOrders.length}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              size: 28,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Body Content
                    Expanded(
                      child: Row(
                        children: [
                          // Left Panel: Order List
                          Expanded(
                            flex: 2,
                            child: draftOrders.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No saved drafts found",
                                      style: TextStyle(
                                        fontFamily: 'SanFrancisco',
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: filteredDrafts.length,
                                    separatorBuilder: (_, _) => const Divider(
                                      height: 1,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                    itemBuilder: (context, index) {
                                      final draft = filteredDrafts[index];
                                      final isSelected =
                                          selectedDraft?.id == draft.id;
                                      final total = draft.items.fold(
                                        0.0,
                                        (sum, item) =>
                                            sum + (item.price * item.quantity),
                                      );
                                      return InkWell(
                                        onTap: () => setDialogState(
                                          () => selectedDraft = draft,
                                        ),
                                        child: Container(
                                          color: isSelected
                                              ? const Color(
                                                  0xffD1F1F1,
                                                ).withValues(alpha: 0.3)
                                              : Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Date & Time
                                              SizedBox(
                                                width: 120,
                                                child: Row(
                                                  spacing: 10,
                                                  children: [
                                                    Text(
                                                      "${draft.timestamp.month}/${draft.timestamp.day}/${draft.timestamp.year}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'SanFrancisco',
                                                      ),
                                                    ),
                                                    Text(
                                                      "${draft.timestamp.hour.toString().padLeft(2, '0')}:${draft.timestamp.minute.toString().padLeft(2, '0')}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'SanFrancisco',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Reference / Table
                                              SizedBox(
                                                width: 140,
                                                child: Row(
                                                  spacing: 10,
                                                  children: [
                                                    Text(
                                                      "Order ID",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'SanFrancisco',
                                                      ),
                                                    ),
                                                    Text(
                                                      "#${draft.id.substring(draft.id.length - 6)}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'SanFrancisco',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Customer
                                              SizedBox(
                                                width: 220,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      draft.customerName.isEmpty
                                                          ? "Party not selected"
                                                          : draft.customerName
                                                                .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'SanFrancisco',
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      draft.items.length == 1
                                                          ? "${draft.items.length} Item"
                                                          : "${draft.items.length} Items",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'SanFrancisco',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Amount
                                              Text(
                                                "Rs ${total.toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontFamily: 'SanFrancisco',
                                                ),
                                              ),
                                              SizedBox(
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    await _removeDraft(
                                                      draft.id,
                                                    );
                                                    setDialogState(() {
                                                      // If the deleted draft was selected, clear selection
                                                      if (selectedDraft?.id ==
                                                          draft.id) {
                                                        selectedDraft = null;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          // Right Panel: Order Summary
                          Container(
                            width: 370,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: selectedDraft == null
                                ? const Center(
                                    child: Text(
                                      "Select an order to view details",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'SanFrancisco',
                                      ),
                                    ),
                                  )
                                : _buildDraftSummaryPanel(
                                    selectedDraft!,
                                    context,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDraftSummaryPanel(DraftOrder draft, BuildContext context) {
    final subtotal = draft.items.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final tax = subtotal * 0.13;
    final total = subtotal + tax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: draft.items.length,
            itemBuilder: (context, index) {
              final item = draft.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 16,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
                              Text(
                                "X ${item.quantity.toInt()} ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
                            ],
                          ),
                          if (item.note != null && item.note!.isNotEmpty)
                            Text(
                              "- ${item.note}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                          if (item.isFree == true)
                            Text(
                              "- Free",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                          if (item.isDiscountable == true)
                            Icon(
                              Icons.discount,
                              size: 18,
                              color: Colors.orange,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Rs ${(item.price * item.quantity).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SanFrancisco',
                          ),
                        ),
                        if (item.tax != null)
                          Text(
                            "Rs ${(item.tax)}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Totals
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Taxes",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
                  Text(
                    "Rs ${tax.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
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
              const SizedBox(height: 20),
              // Load Order Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onRestoreDraft(draft);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xff7CD23D,
                  ), // Dark maroon/purple
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Create Invoice",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SanFrancisco',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
