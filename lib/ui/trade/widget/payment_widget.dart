import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/model/product_class.dart';
import 'dart:async';

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
    this.invoiceNumber = "1500",
    this.customerName = "Guest",
    this.customerPhone = "",
    this.customerAddress = "",
    this.customerPan = "",
  });

  @override
  State<PaymentBody> createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<PaymentBody> {
  String _checkoutType = "Serve Now";
  bool _isDeliveryMode = false;
  bool _showTips = false;
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final TextEditingController _delayTimeController = TextEditingController();
  bool _isPaymentSuccess = false;
  bool _isNoteActive = false;
  late FocusNode _noteFocusNode;
  late FocusNode _amountFocusNode2;
  TimeOfDay? _selectedTime;
  int _remainingSeconds = 0;
  Timer? _timer;

  bool _isEditingCustomer = false;
  @override
  void initState() {
    super.initState();
    _noteFocusNode = FocusNode();
    _noteFocusNode.requestFocus();
    _amountFocusNode2 = FocusNode();
    _noteFocusNode.addListener(() {
      setState(() {
        _isNoteActive = _noteFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _tipController.dispose();
    _noteController.dispose();
    _emailController.dispose();
    _amount.dispose();
    _delayTimeController.dispose();
    _noteFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _handleCheckout() {
    setState(() {
      _isPaymentSuccess = true;
    });
  }

  void _handleNewSale() {
    widget.onConfirm();
  }

  void _onBackspace() {
    if (widget.enteredAmount.isNotEmpty) {
      widget.onAmountChanged(
        widget.enteredAmount.substring(0, widget.enteredAmount.length - 1),
      );
    }
  }

  Widget _buildCreditSaleFrame() {
    bool showAddress = false;

    final bool customerSelected =
        widget.customerName.isNotEmpty && widget.customerPhone.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Amount Received Rs",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SanFrancisco',
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      widget.total.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SanFrancisco',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Flexible(
                    //   child: IntrinsicWidth(
                    //     child: Container(
                    //       constraints:
                    //           const BoxConstraints(
                    //             minWidth: 100,
                    //             maxWidth: 200,
                    //           ),
                    //       child: TextField(
                    //         controller:
                    //             _amountController,
                    //         focusNode:
                    //             _amountFocusNode,
                    //         keyboardType:
                    //             const TextInputType.numberWithOptions(
                    //               decimal: true,
                    //             ),
                    //         textAlign:
                    //             TextAlign.right,
                    //         style: const TextStyle(
                    //           fontSize: 24,
                    //           fontWeight:
                    //               FontWeight.bold,
                    //           fontFamily:
                    //               'SanFrancisco',
                    //         ),
                    //         decoration: InputDecoration(
                    //           hintText: "0",
                    //           hintStyle: TextStyle(
                    //             color: Colors
                    //                 .grey
                    //                 .shade400,
                    //             fontSize: 24,
                    //             fontWeight:
                    //                 FontWeight.bold,
                    //             fontFamily:
                    //                 'SanFrancisco',
                    //           ),
                    //           prefix: const Padding(
                    //             padding:
                    //                 EdgeInsets.only(
                    //                   right: 4,
                    //                 ),
                    //             child: Text(
                    //               "Rs ",
                    //               style: TextStyle(
                    //                 fontSize: 24,
                    //                 fontWeight:
                    //                     FontWeight
                    //                         .bold,
                    //                 fontFamily:
                    //                     'SanFrancisco',
                    //               ),
                    //             ),
                    //           ),

                    //           contentPadding:
                    //               const EdgeInsets.symmetric(
                    //                 horizontal: 12,
                    //                 vertical: 8,
                    //               ),
                    //           isDense: true,
                    //         ),
                    //         onChanged: (value) {
                    //           // Validate input - only allow numbers and one decimal point
                    //           if (value
                    //               .isNotEmpty) {
                    //             final isValid =
                    //                 RegExp(
                    //                   r'^\d*\.?\d*$',
                    //                 ).hasMatch(
                    //                   value,
                    //                 );
                    //             if (!isValid) {
                    //               _amountController
                    //                   .text = value
                    //                   .substring(
                    //                     0,
                    //                     value.length -
                    //                         1,
                    //                   );
                    //               _amountController
                    //                       .selection =
                    //                   TextSelection.fromPosition(
                    //                     TextPosition(
                    //                       offset: _amountController
                    //                           .text
                    //                           .length,
                    //                     ),
                    //                   );
                    //             }
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          // Customer Details Section
          Container(
            decoration: BoxDecoration(
              color: customerSelected ? const Color(0xFFF8FAFC) : Colors.white,
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
                padding: const EdgeInsets.all(16),
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
                          Text(
                            widget.customerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.customerPhone,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),

                          /// Address (toggle)
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.customerAddress,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontFamily: 'SanFrancisco',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState: CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    ),

                    /// Toggle icon
                    InkWell(
                      onTap: () {
                        setState(() {
                          showAddress = !showAddress;
                        });
                      },
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          // Transaction Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildCompactFormField(
                    label: "Reference #",
                    hint: "Add reference number",
                  ),
                ),
                const SizedBox(height: 12),
                _buildNoteAndPurchaseType(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactFormField({
    required String label,
    required String hint,
    String? value,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontFamily: 'SanFrancisco',
          ),
        ),
        TextField(
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          controller: value != null ? TextEditingController(text: value) : null,
          decoration: InputDecoration(
            // hintText: hint,
            isDense: true,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontFamily: 'SanFrancisco',
            ),
            filled: true,
            fillColor: isReadOnly ? Colors.grey.shade50 : Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 2),
          ),
          style: const TextStyle(fontSize: 14, fontFamily: 'SanFrancisco'),
        ),
      ],
    );
  }

  Widget _buildNoteAndPurchaseType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Note Field
        SizedBox(
          width: 500,
          child: TextField(
            controller: _noteController,
            focusNode: _noteFocusNode,
            decoration: const InputDecoration(
              labelText: "Note (Optional)",
              // border: UnderlineInputBorder(),
            ),
          ),
        ),

        const SizedBox(height: 10),
        // Purchase Type
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Row(
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
                      _isDeliveryMode = false;
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
                      _isDeliveryMode = false;
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
                      _isDeliveryMode = true;
                    });
                  },
                  child: _checkoutTypeRadio("Delivery"),
                ),
              ),
            ],
          ),
        ),
        // Time Picker for Pickup Later
        if (_checkoutType == "Pickup Later") ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime ?? TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedTime = picked;
                  _delayTimeController.text = picked.format(context);
                });
                _startCountdownToTime(picked);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: _delayTimeController,
                decoration: InputDecoration(
                  labelText: 'Select Pickup Time',
                  prefixIcon: const Icon(Icons.schedule),
                  suffixIcon: _remainingSeconds > 0 && _selectedTime != null
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
                  border: const OutlineInputBorder(),
                ),
                enabled: false,
              ),
            ),
          ),
        ],
        // Delivery Address and Phone Fields
        if (_isDeliveryMode) ...[
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController(
              text: widget.customerPhone.isNotEmpty ? widget.customerPhone : '',
            ),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Delivery Phone',
              hintText: 'Enter phone number',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Handle phone number change
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController(
              text: widget.customerAddress.isNotEmpty
                  ? widget.customerAddress
                  : '',
            ),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Delivery Address',
              hintText: 'Enter delivery address',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Handle address change
            },
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Update amount controller text when enteredAmount changes
    if (_amount.text != widget.enteredAmount) {
      _amount.text = widget.enteredAmount;
    }

    if (_isPaymentSuccess) {
      return _buildSuccessView();
    }
    return _buildCollectPaymentView();
  }

  Widget _buildCollectPaymentView() {
    bool isCashSelected = widget.selectedPayment == "Cash";
    bool isCardSelected = widget.selectedPayment == "Credit Sale";

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
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
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print, size: 18),
                label: const Text("Print Guest Check"),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Amount Display
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Total amount",
                            style: TextStyle(
                              fontFamily: 'SanFrancisco',
                              fontSize: 20,
                            ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 175,
                          child: Container(
                            height: 340,
                            decoration: BoxDecoration(),
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
                        ),
                        const SizedBox(width: 16),
                        if (isCashSelected)
                          Expanded(
                            child: SizedBox(
                              width: 500,
                              child: Container(
                                height: 440,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 500,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Amount Received Rs",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'SanFrancisco',
                                              ),
                                            ),
                                            Row(
                                              spacing: 8,
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    controller: _amount,
                                                    focusNode:
                                                        _amountFocusNode2,
                                                    decoration:
                                                        const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                        ),
                                                  ),
                                                ),

                                                // Text(
                                                //   widget.enteredAmount.isEmpty
                                                //       ? '0'
                                                //       : widget.enteredAmount,
                                                //   style: const TextStyle(
                                                //     fontSize: 24,
                                                //     fontWeight: FontWeight.bold,
                                                //     fontFamily: 'SanFrancisco',
                                                //   ),
                                                //   textAlign: TextAlign.center,
                                                // ),
                                                // Flexible(
                                                //   child: IntrinsicWidth(
                                                //     child: Container(
                                                //       constraints:
                                                //           const BoxConstraints(
                                                //             minWidth: 100,
                                                //             maxWidth: 200,
                                                //           ),
                                                //       child: TextField(
                                                //         controller:
                                                //             _amountController,
                                                //         focusNode:
                                                //             _amountFocusNode,
                                                //         keyboardType:
                                                //             const TextInputType.numberWithOptions(
                                                //               decimal: true,
                                                //             ),
                                                //         textAlign:
                                                //             TextAlign.right,
                                                //         style: const TextStyle(
                                                //           fontSize: 24,
                                                //           fontWeight:
                                                //               FontWeight.bold,
                                                //           fontFamily:
                                                //               'SanFrancisco',
                                                //         ),
                                                //         decoration: InputDecoration(
                                                //           hintText: "0",
                                                //           hintStyle: TextStyle(
                                                //             color: Colors
                                                //                 .grey
                                                //                 .shade400,
                                                //             fontSize: 24,
                                                //             fontWeight:
                                                //                 FontWeight.bold,
                                                //             fontFamily:
                                                //                 'SanFrancisco',
                                                //           ),
                                                //           prefix: const Padding(
                                                //             padding:
                                                //                 EdgeInsets.only(
                                                //                   right: 4,
                                                //                 ),
                                                //             child: Text(
                                                //               "Rs ",
                                                //               style: TextStyle(
                                                //                 fontSize: 24,
                                                //                 fontWeight:
                                                //                     FontWeight
                                                //                         .bold,
                                                //                 fontFamily:
                                                //                     'SanFrancisco',
                                                //               ),
                                                //             ),
                                                //           ),

                                                //           contentPadding:
                                                //               const EdgeInsets.symmetric(
                                                //                 horizontal: 12,
                                                //                 vertical: 8,
                                                //               ),
                                                //           isDense: true,
                                                //         ),
                                                //         onChanged: (value) {
                                                //           // Validate input - only allow numbers and one decimal point
                                                //           if (value
                                                //               .isNotEmpty) {
                                                //             final isValid =
                                                //                 RegExp(
                                                //                   r'^\d*\.?\d*$',
                                                //                 ).hasMatch(
                                                //                   value,
                                                //                 );
                                                //             if (!isValid) {
                                                //               _amountController
                                                //                   .text = value
                                                //                   .substring(
                                                //                     0,
                                                //                     value.length -
                                                //                         1,
                                                //                   );
                                                //               _amountController
                                                //                       .selection =
                                                //                   TextSelection.fromPosition(
                                                //                     TextPosition(
                                                //                       offset: _amountController
                                                //                           .text
                                                //                           .length,
                                                //                     ),
                                                //                   );
                                                //             }
                                                //           }
                                                //         },
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                InkWell(
                                                  onTap: _onBackspace,
                                                  child: const Icon(
                                                    Icons.backspace,
                                                    size: 21,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Numpad
                                      Container(
                                        width: 500,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            _numpadRow(["7", "8", "9"]),
                                            _numpadRow(["4", "5", "6"]),
                                            _numpadRow(["1", "2", "3"]),
                                            _numpadRow([".", "0", "00"]),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildNoteAndPurchaseType(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        if (isCardSelected)
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: _buildCreditSaleFrame(),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Bottom Bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Center(
            child: SizedBox(
              width: 700,
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "Still Remaining ",
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
                            final value =
                                double.tryParse(widget.enteredAmount) ?? 0;
                            final change = value - widget.total;
                            return change < 0 ? Colors.red : Colors.black;
                          })(),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _handleCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
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
                  color: Color(0xFF1E293B),
                  fontFamily: 'SanFrancisco',
                ),
              ),
              const SizedBox(height: 24),

              // Invoice Info
              _infoRow("Invoice no: 000000999888999", widget.invoiceNumber),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Customer info",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
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
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Payment Summary
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Payment summary",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total paid",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontFamily: 'SanFrancisco',
                          ),
                        ),
                        Text(
                          "Rs ${widget.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SanFrancisco',
                          ),
                        ),
                      ],
                    ),
                    VerticalDivider(
                      color: Colors.grey,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Change",
                          style: TextStyle(
                            fontFamily: 'SanFrancisco',
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          _calculateChange(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SanFrancisco',
                          ),
                        ),
                      ],
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
                        hintStyle: TextStyle(fontFamily: 'SanFrancisco'),
                        label: Text(
                          "Enter email",
                          style: TextStyle(fontFamily: 'SanFrancisco'),
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
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text(
                        "Share",
                        style: TextStyle(fontFamily: 'SanFrancisco'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text(
                        "Download",
                        style: TextStyle(fontFamily: 'SanFrancisco'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.print, size: 16),
                      label: const Text(
                        "Print Bill",
                        style: TextStyle(fontFamily: 'SanFrancisco'),
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
                  onPressed: _handleNewSale,
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B))),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontFamily: 'SanFrancisco',
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _checkoutTypeRadio(String label) {
    return Row(
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
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _paymentMethodButton(String name) {
    final isSelected = widget.selectedPayment == name;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => widget.onPaymentModeChanged(name),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xff7CD23D).withValues(alpha: 0.1)
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
            // textAlign: TextAlign.center,
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

  Widget _numpadRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: InkWell(
            onTap: () {
              if (key == "00") {
                widget.onAmountChanged("${widget.enteredAmount}00");
              } else {
                if (key == "." && widget.enteredAmount.contains(".")) {
                  return;
                }
                widget.onAmountChanged(widget.enteredAmount + key);
              }
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Center(
                child: Text(
                  key,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SanFrancisco',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _calculateChange() {
    final paid = double.tryParse(widget.enteredAmount) ?? 0;
    final change = paid - widget.total;
    if (change < 0) {
      return "-Rs ${(-change).toStringAsFixed(2)}";
    } else if (change > 0) {
      return "Rs ${change.toStringAsFixed(2)}";
    } else {
      return "Rs ${change.toStringAsFixed(2)}";
    }
  }

  void _showEditCustomerDialog() {
    // Show a dialog to edit customer details
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final nameController = TextEditingController(text: widget.customerName);
        final phoneController = TextEditingController(
          text: widget.customerPhone,
        );
        final addressController = TextEditingController(
          text: widget.customerAddress,
        );

        return AlertDialog(
          title: const Text('Edit Customer Details'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update customer details in the parent widget
                // Since we can't directly modify widget properties,
                // we'd need to call a callback function
                // For now, just close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _startCountdownToTime(TimeOfDay selectedTime) {
    _timer?.cancel();

    final nowDateTime = DateTime.now();
    final selectedDateTime = DateTime(
      nowDateTime.year,
      nowDateTime.month,
      nowDateTime.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    int seconds = selectedDateTime.difference(nowDateTime).inSeconds;
    if (seconds < 0) {
      seconds += 24 * 60 * 60; // wrap around to next day
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
}
