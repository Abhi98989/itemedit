import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/widget/product_class.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItem item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChange;
  final VoidCallback? onTap;
  final bool isdiscount;
  const OrderItemTile({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChange,
    this.onTap,
    this.isdiscount = false,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(" x ${item.quantity}"),
                    ],
                  ),
                ),
                if (isdiscount) ...[
                  Icon(Icons.discount, color: Colors.green[600], size: 18),
                ],
                Text(
                  "Rs ${(item.price * item.quantity).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //   Widget _quantityButton(IconData icon, VoidCallback onPressed) {
  //     return InkWell(
  //       onTap: onPressed,
  //       borderRadius: BorderRadius.circular(4),
  //       child: Container(
  //         padding: const EdgeInsets.all(4),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFF1F5F9),
  //           borderRadius: BorderRadius.circular(4),
  //         ),
  //         child: Icon(icon, size: 14, color: const Color(0xFF475569)),
  //       ),
  //     );
  //   }
  // }
}
