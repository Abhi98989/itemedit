import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onClose;
  final VoidCallback? onDiscount;
  final VoidCallback? onCoupon;
  final VoidCallback? onCharges;
  final VoidCallback? onTips;
  const CustomKeyboard({
    required this.controller,
    required this.onClose,
    this.onDiscount,
    this.onCoupon,
    this.onCharges,
    this.onTips,
    super.key,
  });
  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  bool isNumeric = true;

  void _input(String text) {
    widget.controller.text += text;
  }

  void _backspace() {
    String text = widget.controller.text;
    if (text.isNotEmpty) {
      widget.controller.text = text.substring(0, text.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(8),
      child: isNumeric ? _buildNumericLayout() : _buildAlphaLayout(),
    );
  }

  Widget _buildNumericLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // if (widget.onDiscount != null ||
          //     widget.onCoupon != null ||
          //     widget.onCharges != null ||
          //     widget.onTips != null)
          //   Container(
          //     width: 100,
          //     margin: const EdgeInsets.only(right: 8),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         if (widget.onDiscount != null)
          //           _buildSideNavButton("Discount", widget.onDiscount!),
          //         if (widget.onCoupon != null)
          //           _buildSideNavButton("Coupon", widget.onCoupon!),
          //         if (widget.onCharges != null)
          //           _buildSideNavButton("Charges", widget.onCharges!),
          //         if (widget.onTips != null)
          //           _buildSideNavButton("Tips", widget.onTips!),
          //         const Spacer(),
          //         _buildSideNavButton(
          //           "Alpha",
          //           () => setState(() => isNumeric = false),
          //           isAction: true,
          //         ),
          //       ],
          //     ),
          //   ),
          // Numeric Grid + Actions
          Expanded(
            child: Row(
              children: [
                // Number Grid
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildNumRow(['7', '8', '9']),
                      _buildNumRow(['4', '5', '6']),
                      _buildNumRow(['1', '2', '3']),
                      _buildNumRow(['.', '0', '00']),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Right Actions
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.backspace_outlined,
                          onTap: _backspace,
                          color: Colors.orange[100]!,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _buildActionButton(
                          label: "Clear",
                          onTap: () => widget.controller.clear(),
                          color: Colors.red[100]!,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        flex: 1,
                        child: _buildActionButton(
                          label: "Enter",
                          onTap: widget.onClose,
                          color: const Color(0xff7CD23D),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlphaLayout() {
    List<String> keys = [
      'Q',
      'W',
      'E',
      'R',
      'T',
      'Y',
      'U',
      'I',
      'O',
      'P',
      'A',
      'S',
      'D',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
      'Z',
      'X',
      'C',
      'V',
      'B',
      'N',
      'M',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => isNumeric = true),
              child: const Text(
                "Num",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose,
            ),
          ],
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            ...keys.map(
              (key) => SizedBox(
                width: 45,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => _input(key),
                  child: Text(key, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: () => _input(" "),
                child: const Icon(Icons.space_bar),
              ),
            ),
            SizedBox(
              width: 60,
              height: 45,
              child: ElevatedButton(
                onPressed: _backspace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[200],
                ),
                child: const Icon(Icons.backspace, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumRow(List<String> keys) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: keys.map((key) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 1,
                  ),
                  onPressed: () => _input(key),
                  child: Center(
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    String? label,
    IconData? icon,
    required VoidCallback onTap,
    required Color color,
    Color textColor = Colors.black87,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
          elevation: 1,
        ),
        onPressed: onTap,
        child: icon != null
            ? Icon(icon, color: textColor)
            : Text(
                label!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
      ),
    );
  }

  Widget _buildSideNavButton(
    String label,
    VoidCallback onTap, {
    bool isAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 45,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: isAction ? Colors.grey[300] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: isAction ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
