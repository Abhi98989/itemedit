import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/widget/product_class.dart';

class PaymentBody extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Payment",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Total Payable",
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    Text(
                      "Rs ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Side: Payment Methods & Numpad
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Payment Methods
                      Row(
                        children: [
                          _paymentMethodCard(
                            context,
                            "Cash",
                            Icons.money,
                            selectedPayment == "Cash",
                          ),
                          const SizedBox(width: 16),
                          _paymentMethodCard(
                            context,
                            "Card",
                            Icons.credit_card,
                            selectedPayment == "Card",
                          ),
                          const SizedBox(width: 16),
                          _paymentMethodCard(
                            context,
                            "UPI",
                            Icons.qr_code,
                            selectedPayment == "UPI",
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Amount Input Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Received Amount",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Rs ${enteredAmount.isEmpty ? '0' : enteredAmount}",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Numpad
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _numpadButton("1"),
                                        _numpadButton("2"),
                                        _numpadButton("3"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _numpadButton("4"),
                                        _numpadButton("5"),
                                        _numpadButton("6"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _numpadButton("7"),
                                        _numpadButton("8"),
                                        _numpadButton("9"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _numpadButton("."),
                                        _numpadButton("0"),
                                        _numpadButton(
                                          "⌫",
                                          isIcon: true,
                                          onTap: () {
                                            if (enteredAmount.isNotEmpty) {
                                              onAmountChanged(
                                                enteredAmount.substring(
                                                  0,
                                                  enteredAmount.length - 1,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right Side: Summary & Actions
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bill Summary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _summaryRow(
                        "Subtotal",
                        "Rs ${subtotal.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 12),
                      _summaryRow("Tax (13%)", "Rs ${tax.toStringAsFixed(2)}"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      _summaryRow(
                        "Total Amount",
                        "Rs ${total.toStringAsFixed(2)}",
                        isTotal: true,
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        "Paid Amount",
                        "Rs ${enteredAmount.isEmpty ? '0.00' : double.tryParse(enteredAmount)?.toStringAsFixed(2) ?? enteredAmount}",
                        color: const Color(0xFF10B981),
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        "Change",
                        "Rs ${calculateChange()}",
                        color: Colors.orange,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Confirm Payment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String calculateChange() {
    final paid = double.tryParse(enteredAmount) ?? 0;
    if (paid > total) {
      return (paid - total).toStringAsFixed(2);
    }
    return "0.00";
  }

  Widget _paymentMethodCard(
    BuildContext context,
    String name,
    IconData icon,
    bool isSelected,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => onPaymentModeChanged(name),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade200,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : const Color(0xFF64748B),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numpadButton(
    String text, {
    bool isIcon = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
          onTap:
              onTap ??
              () {
                if (text == "." && enteredAmount.contains(".")) return;
                onAmountChanged(enteredAmount + text);
              },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Center(
              child: isIcon
                  ? const Icon(Icons.backspace_outlined, size: 28)
                  : Text(
                      text,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: color ?? const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
