import 'dart:ui';
import 'package:flutter/material.dart';
import '../model/product_class.dart';
import 'custom_num.dart';

class WeightItemDialog extends StatefulWidget {
  final Product product;
  final Function(double quantity) onConfirm;
  const WeightItemDialog({
    super.key,
    required this.product,
    required this.onConfirm,
  });
  @override
  State<WeightItemDialog> createState() => _WeightItemDialogState();
}

class _WeightItemDialogState extends State<WeightItemDialog> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    // Rebuild to update amount preview when text changes
    textEditingController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final qtyText = textEditingController.text;
    final qty = double.tryParse(qtyText) ?? 0;

    if (qty > 0) {
      widget.onConfirm(qty);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qty = double.tryParse(textEditingController.text) ?? 0;
    final amount = widget.product.price * qty;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: Container(
          width: 390,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white),
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
                    style: const ButtonStyle(
                      iconSize: WidgetStatePropertyAll(20),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.product.name} - Rs ${widget.product.price}/kg",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SanFrancisco',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                "Quantity",
                style: TextStyle(fontSize: 16, fontFamily: 'SanFrancisco'),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      textEditingController.text.isEmpty
                          ? "0"
                          : textEditingController.text,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     if (textEditingController.text.isNotEmpty) {
                    //       textEditingController.text = textEditingController
                    //           .text
                    //           .substring(
                    //             0,
                    //             textEditingController.text.length - 1,
                    //           );
                    //     }
                    //   },
                    //   child: const Icon(Icons.backspace_outlined),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Amount Rs ${amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              const SizedBox(height: 20),
              // Use the shared CustomKeyboard
              CustomKeyboard(
                controller: textEditingController,
                onClose: _onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
