import 'package:flutter/material.dart';
import 'product_class.dart';

class WeightItemDialog extends StatefulWidget {
  final Product product;
  final Function(int quantity) onConfirm;
  const WeightItemDialog({
    super.key,
    required this.product,
    required this.onConfirm,
  });
  @override
  State<WeightItemDialog> createState() => _WeightItemDialogState();
}

class _WeightItemDialogState extends State<WeightItemDialog> {
  String _quantity = "1";

  void _onKeyTap(String value) {
    setState(() {
      if (_quantity == "0") {
        _quantity = value;
      } else {
        _quantity += value;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_quantity.isNotEmpty) {
        _quantity = _quantity.substring(0, _quantity.length - 1);
        if (_quantity.isEmpty) {
          _quantity = "0";
        }
      }
    });
  }

  void _onConfirm() {
    final qty = int.tryParse(_quantity) ?? 0;
    if (qty > 0) {
      widget.onConfirm(qty);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qty = double.tryParse(_quantity) ?? 0;
    final amount = widget.product.price * qty;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 6,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CloseButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(iconSize: WidgetStatePropertyAll(20)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs ${widget.product.price} / kg",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text("Quantity", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _quantity,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: _onBackspace,
                    child: const Icon(Icons.backspace_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Amount: ${amount.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          children: [
            _keypadButton("1"),
            _keypadButton("2"),
            _keypadButton("3"),
          ],
        ),
        Row(
          children: [
            _keypadButton("4"),
            _keypadButton("5"),
            _keypadButton("6"),
          ],
        ),
        Row(
          children: [
            _keypadButton("7"),
            _keypadButton("8"),
            _keypadButton("9"),
          ],
        ),
        Row(
          children: [
            _keypadButton("."),
            _keypadButton("0"),
            Expanded(
              child: InkWell(
                onTap: _onConfirm,
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green, // OK button color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _keypadButton(String label) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyTap(label),
        child: Container(
          height: 60,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
