import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/model/product_class.dart';
import 'dart:async';
import '../trade_landing_page.dart';
import 'custom_num.dart';
import 'billsample.dart';

// ignore: must_be_immutable
class PaymentBody extends StatefulWidget {
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String enteredAmount;
  final String selectedPayment;
  final ValueChanged<String> onPaymentModeChanged;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onBack;
  final VoidCallback onConfirm;
  final VoidCallback onSelectCustomer;
  final String invoiceNumber;
  String customerName;
  String customerPhone;
  String customerAddress;
  final String customerPan;

  PaymentBody({
    super.key,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.enteredAmount,
    required this.selectedPayment,
    required this.onPaymentModeChanged,
    required this.onAmountChanged,
    required this.onBack,
    required this.onConfirm,
    required this.onSelectCustomer,
    this.invoiceNumber = "1500",
    this.customerName = "Guest",
    this.customerPhone = "",
    this.customerAddress = "",
    this.customerPan = "",
    this.onPaymentSuccess,
  });

  final ValueChanged<bool>? onPaymentSuccess;

  @override
  State<PaymentBody> createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<PaymentBody> {
  String _checkoutType = "Serve Now";

  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _refController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _delayTimeController = TextEditingController();
  bool _isPaymentSuccess = false;
  late FocusNode _noteFocusNode;
  late FocusNode _amountFocusNode2;
  late FocusNode _refFocusNode;
  DateTime? _pickupDateTime;
  late TextEditingController _deliveryPhoneController;
  late TextEditingController _deliveryAddressController;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _shouldClearAmountOnInput = false;

  @override
  void initState() {
    super.initState();
    _noteFocusNode = FocusNode();
    _amountFocusNode2 = FocusNode();
    _refFocusNode = FocusNode();
    _deliveryPhoneController = TextEditingController(
      text: widget.customerPhone,
    );
    _deliveryAddressController = TextEditingController(
      text: widget.customerAddress,
    );
    // Initial amount sync
    // Initial amount sync
    if (widget.selectedPayment.isNotEmpty && widget.enteredAmount.isEmpty) {
      _amount.text = widget.total.toStringAsFixed(2);
      _shouldClearAmountOnInput = true;
    } else {
      _amount.text = widget.enteredAmount;
      if (widget.selectedPayment.isNotEmpty) {
        _shouldClearAmountOnInput = true;
      }
    }
    // Sync _amount changes with parent state
    _amount.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onAmountChanged(_amount.text);
        }
      });
    });
  }

  @override
  void didUpdateWidget(PaymentBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customerPhone != oldWidget.customerPhone) {
      _deliveryPhoneController.text = widget.customerPhone;
    }
    if (widget.customerAddress != oldWidget.customerAddress) {
      _deliveryAddressController.text = widget.customerAddress;
    }
    if (widget.enteredAmount != oldWidget.enteredAmount &&
        widget.enteredAmount != _amount.text) {
      _amount.text = widget.enteredAmount;
    }
    if (widget.selectedPayment != oldWidget.selectedPayment &&
        widget.selectedPayment.isNotEmpty) {
      _shouldClearAmountOnInput = true;
    }
  }

  @override
  void dispose() {
    _tipController.dispose();
    _noteController.dispose();
    _emailController.dispose();
    _refFocusNode.dispose();
    _deliveryPhoneController.dispose();
    _deliveryAddressController.dispose();
    _amount.dispose();
    _delayTimeController.dispose();
    _noteFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _clearTextfields() {
    _tipController.clear();
    _noteController.clear();
    _emailController.clear();
    _refController.clear();
    _deliveryPhoneController.clear();
    _deliveryAddressController.clear();
    _amount.clear();

    _delayTimeController.clear();
  }
  //EDIT party details

  void _showEditCustomerDialog() {
    final nameController = TextEditingController(text: widget.customerName);
    final phoneController = TextEditingController(text: widget.customerPhone);
    final addressController = TextEditingController(
      text: widget.customerAddress,
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(3),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Edit Details',
                        style: TextStyle(
                          fontFamily: 'SanFrancisco',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.customerName = nameController.text;
                        widget.customerPhone = phoneController.text;
                        widget.customerAddress = addressController.text;
                        // Update delivery controllers as well
                        _deliveryPhoneController.text = widget.customerPhone;
                        _deliveryAddressController.text =
                            widget.customerAddress;
                      });
                      Navigator.pop(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xff7CD23D)),
                    ),

                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'SanFrancisco',
                        color: Color(0xff7CD23D),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCheckout() {
    setState(() {
      _isPaymentSuccess = true;
    });
    if (widget.onPaymentSuccess != null) {
      widget.onPaymentSuccess!(true);
    }
  }

  // void _handleNewSale() {
  //   widget.onConfirm();
  // }
  void _onBackspace() {
    if (widget.enteredAmount.isNotEmpty) {
      widget.onAmountChanged(
        widget.enteredAmount.substring(0, widget.enteredAmount.length - 1),
      );
    }
  }

  Widget _buildCreditSaleFrame() {
    final bool customerSelected =
        widget.customerName.isNotEmpty && widget.customerPhone.isNotEmpty;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: 620,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Customer Details Section
              GestureDetector(
                onTap: () {
                  if (!customerSelected) {
                    widget.onSelectCustomer();
                  }
                },
                child: Column(
                  spacing: 6,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (customerSelected)
                      Text(
                        "Bill to",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SanFrancisco',
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        color: customerSelected
                            ? const Color(0xFFF8FAFC)
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: customerSelected
                                ? const Color(0xFFF8FAFC)
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!customerSelected)
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1),
                                  child: Icon(
                                    Icons.person,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              const SizedBox(width: 12),

                              /// Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            widget.customerName.isEmpty
                                                ? "Select Customer"
                                                : widget.customerName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              fontFamily: 'SanFrancisco',
                                            ),
                                          ),
                                        ),

                                        if (widget.customerName.isEmpty)
                                          Icon(Icons.arrow_right_sharp),
                                        if (widget.customerName.isNotEmpty)
                                          IconButton(
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () {
                                              _showEditCustomerDialog();
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: Colors.blue,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    if (customerSelected) ...[
                                      Text(
                                        widget.customerPhone,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                          fontFamily: 'SanFrancisco',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.customerAddress,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                          fontFamily: 'SanFrancisco',
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              // Transaction Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildReferenceFieldWithLink(),
                    const SizedBox(height: 12),
                    _buildNoteAndPurchaseType(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoteAndPurchaseType() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isSmallScreen = maxWidth < 620;
        return SizedBox(
          width: 620,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Note Field
              TextField(
                controller: _noteController,
                focusNode: _noteFocusNode,
                decoration: const InputDecoration(labelText: "Note (Optional)"),
              ),
              const SizedBox(height: 10),
              // Purchase Type
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: isSmallScreen
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Purchase Type",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _checkoutType = "Serve Now";
                                  });
                                },
                                child: _checkoutTypeRadio("Serve Now"),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _checkoutType = "Pickup Later";
                                  });
                                },
                                child: _checkoutTypeRadio("Pickup Later"),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _checkoutType = "Delivery";
                                  });
                                },
                                child: _checkoutTypeRadio("Delivery"),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Purchase Type",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _checkoutType = "Serve Now";
                                });
                              },
                              child: _checkoutTypeRadio("Serve Now"),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _checkoutType = "Pickup Later";
                                });
                              },
                              child: _checkoutTypeRadio("Pickup Later"),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _checkoutType = "Delivery";
                                });
                              },
                              child: _checkoutTypeRadio("Delivery"),
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 10),
              // Time Picker for Pickup Later
              if (_checkoutType == "Pickup Later") ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      // ignore: use_build_context_synchronously
                      final time = await showTimePicker(
                        // ignore: use_build_context_synchronously
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        final dateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                        setState(() {
                          _pickupDateTime = dateTime;
                          _delayTimeController.text =
                              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${time.format(context)}";
                        });
                        _startCountdownToTime(dateTime);
                      }
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _delayTimeController,
                      decoration: InputDecoration(
                        labelText: 'Select Pickup Date & Time',
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon:
                            _remainingSeconds > 0 && _pickupDateTime != null
                            ? Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  '${(_remainingSeconds ~/ 3600).toString().padLeft(2, '0')}:${((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      enabled: false,
                    ),
                  ),
                ),
              ],
              // Delivery Address and Phone Fields
              if (_checkoutType == "Delivery") ...[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: TextField(
                    controller: _deliveryPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Phone',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SanFrancisco',
                      ),
                      prefixIcon: Icon(Icons.phone),
                      hintText: '',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: TextField(
                    controller: _deliveryAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Address',
                      prefixIcon: Icon(Icons.location_on),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SanFrancisco',
                      ),
                      hintText: '',
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isPaymentSuccess) {
      return _buildSuccessView();
    }
    return _buildCollectPaymentView();
  }

  Widget _buildCollectPaymentView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 800;

        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: isSmallScreen
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _clearTextfields();
                                widget.onPaymentModeChanged("");
                                widget.onBack();
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Collect Payment",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total amount",
                              style: TextStyle(fontFamily: 'SanFrancisco'),
                            ),
                            Text(
                              "Rs ${widget.total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                _clearTextfields();
                                widget.onPaymentModeChanged("");
                                widget.onBack();
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Collect Payment",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Rs ${widget.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            fontFamily: 'SanFrancisco',
                          ),
                        ),
                        if (!isSmallScreen)
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BillSample(
                                    items: widget.items,
                                    subtotal: widget.subtotal,
                                    tax: widget.tax,
                                    total: widget.total,
                                    invoiceNumber: widget.invoiceNumber,
                                    customerName: widget.customerName,
                                    customerPhone: widget.customerPhone,
                                    customerAddress: widget.customerAddress,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.print, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                const Text(
                                  "Print Guest Check",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                    fontFamily: 'SanFrancisco',
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: isSmallScreen
                              ? Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            _paymentMethodButton("Cash"),
                                            _paymentMethodButton("Credit Sale"),
                                            _paymentMethodButton("Union Pay"),
                                            _paymentMethodButton("Gift Card"),
                                            _paymentMethodButton("Reward"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildCommonAmountHeader(
                                      constraints.maxWidth,
                                    ),
                                    const SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 12.0,
                                          right: 8.0,
                                        ),
                                        child: Divider(),
                                      ),
                                    ),
                                    if (widget.selectedPayment == "Cash")
                                      Expanded(child: _buildCashSection()),
                                    if (widget.selectedPayment ==
                                            "Credit Sale" ||
                                        widget.selectedPayment == "Credit")
                                      Expanded(child: _buildCreditSaleFrame()),
                                    if (widget.selectedPayment.isNotEmpty &&
                                        widget.selectedPayment != "Cash" &&
                                        widget.selectedPayment !=
                                            "Credit Sale" &&
                                        widget.selectedPayment != "Credit")
                                      Expanded(
                                        child: _buildOtherPaymentSection(),
                                      ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 175,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            _paymentMethodButton("Cash"),
                                            _paymentMethodButton("Credit Sale"),
                                            _paymentMethodButton("Union Pay"),
                                            _paymentMethodButton("Gift Card"),
                                            _paymentMethodButton("Reward"),
                                            _paymentMethodButton("Credit"),
                                            _paymentMethodButton("Union "),
                                            _paymentMethodButton("Gift "),
                                            _paymentMethodButton("Reward as"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildCommonAmountHeader(
                                            constraints.maxWidth - 191,
                                          ),
                                          const SizedBox(
                                            width: 620,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 12.0,
                                                right: 8.0,
                                              ),
                                              child: Divider(),
                                            ),
                                          ),
                                          if (widget.selectedPayment == "Cash")
                                            Expanded(
                                              child: _buildCashSection(),
                                            ),
                                          if (widget.selectedPayment ==
                                                  "Credit Sale" ||
                                              widget.selectedPayment ==
                                                  "Credit")
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                child: _buildCreditSaleFrame(),
                                              ),
                                            ),
                                          if (widget
                                                  .selectedPayment
                                                  .isNotEmpty &&
                                              widget.selectedPayment !=
                                                  "Cash" &&
                                              widget.selectedPayment !=
                                                  "Credit Sale" &&
                                              widget.selectedPayment !=
                                                  "Credit")
                                            Expanded(
                                              child:
                                                  _buildOtherPaymentSection(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom Bar
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 830,
                child: Divider(thickness: 1, color: Colors.grey),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 120,
                ), // Adjust this for a custom gap
                child: SizedBox(width: 660, child: _buildBottomBar()),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCashSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified CustomKeyboard
          CustomKeyboard(
            controller: _amount,
            onClose: _handleCheckout,
            onPaymode: () {}, // Ensure Enter button shows
            onValueInput: (val) {
              if (_shouldClearAmountOnInput) {
                _amount.text = val;
                _shouldClearAmountOnInput = false;
              } else {
                _amount.text += val;
              }
            },
          ),
          const SizedBox(height: 16),
          _buildReferenceFieldWithLink(),
          const SizedBox(height: 12),
          _buildNoteAndPurchaseType(),
        ],
      ),
    );
  }

  Widget _buildOtherPaymentSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildReferenceFieldWithLink(),
            const SizedBox(height: 12),
            _buildNoteAndPurchaseType(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                _getPaymentStatusLabel(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              Text(
                _calculateChange(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SanFrancisco',
                  color: (() {
                    final value = double.tryParse(widget.enteredAmount) ?? 0;
                    final change = value - widget.total;
                    return change < 0 ? Colors.red : Colors.black;
                  })(),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _handleCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Checkout",
              style: TextStyle(
                fontFamily: 'SanFrancisco',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final containerWidth = maxWidth < 600 ? maxWidth * 0.9 : 500.0;
        constraints = constraints.copyWith(maxWidth: 0, maxHeight: 0);
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: containerWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Paid Successfully",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Invoice Info
                    _infoRow(
                      "Invoice no: 000000999888999",
                      widget.invoiceNumber,
                    ),
                    if (widget.customerName.isNotEmpty)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Customer info",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'SanFrancisco',
                          ),
                        ),
                      ),
                    if (widget.customerName.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.customerName}, ${widget.customerPhone}\n${widget.customerAddress}${widget.customerPan.isNotEmpty ? ', PAN: ${widget.customerPan}' : ''}",
                          style: const TextStyle(
                            fontFamily: 'SanFrancisco',
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Payment Summary
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Payment summary",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SanFrancisco',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _infoRow("Cash", "Rs ${widget.total.toStringAsFixed(2)}"),
                    const Divider(height: 24),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total paid",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SanFrancisco',
                                  ),
                                ),
                                Text(
                                  "Rs ${widget.total.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SanFrancisco',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Change",
                                  style: TextStyle(
                                    fontFamily: 'SanFrancisco',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _calculateChange(),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SanFrancisco',
                                    color: Colors.black,
                                  ),
                                  maxLines: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Email Input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: "",
                              hintStyle: TextStyle(
                                fontFamily: 'SanFrancisco',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              label: Text(
                                "Enter email",
                                style: TextStyle(
                                  fontFamily: 'SanFrancisco',
                                  color: Colors.black,
                                ),
                              ),
                              prefixIcon: Icon(Icons.email_outlined, size: 18),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.send),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share,
                              size: 16,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Share",
                              style: TextStyle(
                                fontFamily: 'SanFrancisco',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.receipt,
                              size: 16,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Recipt",
                              style: TextStyle(
                                fontFamily: 'SanFrancisco',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.print,
                              size: 16,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Print Bill",
                              style: TextStyle(
                                fontFamily: 'SanFrancisco',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // New Sale Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => POSLandingPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "New Sale",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SanFrancisco',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'SanFrancisco',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SanFrancisco',
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _checkoutTypeRadio(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          groupValue: _checkoutType,
          onChanged: (val) {
            setState(() {
              _checkoutType = val!;
            });
          },
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SanFrancisco',
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _paymentMethodButton(String name) {
    final isSelected = widget.selectedPayment == name;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
      child: InkWell(
        onTap: () => widget.onPaymentModeChanged(name),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xff7CD23D).withValues(alpha: 0.1)
                : Colors.white,
            border: Border(
              left: BorderSide(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : const Color(0xFF64748B),
              fontFamily: 'SanFrancisco',
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommonAmountHeader(double maxWidth) {
    bool hasSelection = widget.selectedPayment.isNotEmpty;
    bool hascashmode = widget.selectedPayment == 'Cash';

    return SizedBox(
      width: 620,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "    Amount Received Rs",
                  style: TextStyle(
                    fontSize: maxWidth < 400 ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SanFrancisco',
                  ),
                ),
              ),
              if (hasSelection)
                Row(
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: maxWidth < 1000 ? 150 : 200,
                      child: TextField(
                        controller: _amount,
                        focusNode: _amountFocusNode2,
                        keyboardType: TextInputType.number,
                        onTap: () {
                          setState(() {
                            _shouldClearAmountOnInput = true;
                          });
                        },
                        onChanged: (value) {
                          if (_shouldClearAmountOnInput) {
                            setState(() {
                              _amount.text = value.isNotEmpty
                                  ? value[value.length - 1]
                                  : '';
                              _amount.selection = TextSelection.collapsed(
                                offset: _amount.text.length,
                              );
                              _shouldClearAmountOnInput = false;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: maxWidth < 400 ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SanFrancisco',
                        ),
                      ),
                    ),
                    if (hascashmode)
                      IconButton(
                        onPressed: () {
                          _onBackspace();
                        },
                        icon: Icon(Icons.backspace_rounded),
                      ),
                  ],
                )
              else
                Text(
                  "Rs 0.00",
                  style: TextStyle(
                    fontSize: maxWidth < 400 ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'SanFrancisco',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateChange() {
    if (widget.selectedPayment.isEmpty) {
      return "Rs 0.00";
    }
    final paid = double.tryParse(widget.enteredAmount) ?? 0;
    final change = paid - widget.total;
    if (change < 0) {
      return "- Rs ${change.abs().toStringAsFixed(2)}";
    }
    return "Rs ${change.abs().toStringAsFixed(2)}";
  }

  String _getPaymentStatusLabel() {
    if (widget.selectedPayment.isEmpty) {
      return "Return Amount ";
    }
    final paid = double.tryParse(widget.enteredAmount) ?? 0;
    final change = paid - widget.total;
    if (change < 0) {
      return "Still Remaining ";
    } else {
      return "Return Amount ";
    }
  }

  void _startCountdownToTime(DateTime selectedDateTime) {
    _timer?.cancel();

    final nowDateTime = DateTime.now();
    int seconds = selectedDateTime.difference(nowDateTime).inSeconds;

    if (seconds < 0) {
      seconds = 0;
    }

    setState(() {
      _remainingSeconds = seconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Widget _buildReferenceFieldWithLink() {
    return SizedBox(
      width: 620,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _refController,
              focusNode: _refFocusNode,
              decoration: const InputDecoration(
                labelText: "Reference no",
                labelStyle: TextStyle(fontFamily: 'SanFrancisco'),
              ),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              foregroundColor: WidgetStateProperty.all(Colors.transparent),
              side: WidgetStateProperty.all(
                const BorderSide(color: Colors.grey, width: 2),
              ),
            ),
            onPressed: () {},
            child: Row(
              spacing: 2,
              children: [
                Icon(Icons.connected_tv, color: Colors.grey.shade600, size: 17),
                const Text(
                  "Connect",
                  style: TextStyle(
                    fontFamily: 'SanFrancisco',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
