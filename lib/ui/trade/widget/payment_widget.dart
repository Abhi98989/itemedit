import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/widget/product_class.dart';

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
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerPan;

  const PaymentBody({
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
  bool _showTips = false;
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isPaymentSuccess = false;

  @override
  void dispose() {
    _tipController.dispose();
    _noteController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleCheckout() {
    // Validate if needed
    setState(() {
      _isPaymentSuccess = true;
    });
    // widget.onConfirm(); // Call parent confirm if needed, but we are handling success view here
  }

  void _handleNewSale() {
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPaymentSuccess) {
      return _buildSuccessView();
    }
    return _buildCollectPaymentView();
  }

  Widget _buildCollectPaymentView() {
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
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print, size: 18),
                label: const Text("Print Guest Check"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
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
                          Text(
                            "Rs ${widget.total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const Text(
                            "Total amount",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Cash Received Input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Cash Received",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Rs ${widget.enteredAmount.isEmpty ? '0' : widget.enteredAmount}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _showTips = !_showTips;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "ADD TIPS?",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    Icon(
                                      _showTips
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                              if (_showTips)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextField(
                                    controller: _tipController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "Tip Amount",
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),
                    const Text(
                      "Checkout Type:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    // Checkout Type
                    Row(
                      children: [
                        _checkoutTypeRadio("Serve Now"),
                        _checkoutTypeRadio("Pickup Later"),
                        _checkoutTypeRadio("Delivery"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Main Content: Methods & Numpad
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Payment Methods (Left Column)
                          SizedBox(
                            width: 140,
                            child: Column(
                              children: [
                                _paymentMethodButton("Cash"),
                                _paymentMethodButton("Credit Sale"),
                                _paymentMethodButton("Union Pay"),
                                _paymentMethodButton("Gift Card"),
                                _paymentMethodButton("Reward"),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Numpad (Right Column)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tips & Notes
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _noteController,
                            decoration: InputDecoration(
                              hintText: "NOTES",
                              suffixIcon: const Icon(Icons.check),
                              border: const UnderlineInputBorder(),
                            ),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Change Rs ${_calculateChange()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.1),
          //     blurRadius: 20,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
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
              ),
            ),
            const SizedBox(height: 24),

            // Invoice Info
            _infoRow("Invoice no:", widget.invoiceNumber),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Customer info",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.customerName}, ${widget.customerPhone}\n${widget.customerAddress}${widget.customerPan.isNotEmpty ? ', PAN: ${widget.customerPan}' : ''}",
                style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
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
                ),
              ),
            ),
            const SizedBox(height: 8),
            _infoRow("Cash", "Rs ${widget.total.toStringAsFixed(2)}"),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total paid",
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                    Text(
                      "Rs ${widget.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Change",
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                    Text(
                      "Rs ${_calculateChange()}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Email Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "enter email",
                      prefixIcon: Icon(Icons.email_outlined, size: 18),
                      isDense: true,
                      border: OutlineInputBorder(),
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
                    label: const Text("Share"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text("Download"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print, size: 16),
                    label: const Text("Print Bill"),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
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
        Text(label),
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
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _numpadRow(List<String> keys) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  // borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    key,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _calculateChange() {
    final paid = double.tryParse(widget.enteredAmount) ?? 0;
    if (paid > widget.total) {
      return (paid - widget.total).toStringAsFixed(2);
    }
    return "0.00";
  }
}
