import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/model/product_class.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                    fontFamily: 'SanFrancisco',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  " x ${item.quantity}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'SanFrancisco',
                                  ),
                                ),
                              ],
                            ),
                            if (item.note != null && item.note!.isNotEmpty)
                              Text(
                                item.note!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'SanFrancisco',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (item.discount != null && item.discount! > 0) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.discount, color: Colors.orange[600], size: 16),
                  ],
                  if (item.isFree) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.card_giftcard,
                      color: Colors.blue[600],
                      size: 16,
                    ),
                  ],
                  // if (item.note != null && item.note!.isNotEmpty) ...[
                  //   const SizedBox(width: 4),
                  //   Icon(Icons.note, color: Colors.grey[600], size: 16),
                  // ],
                  const SizedBox(width: 8),
                  Text(
                    item.isFree
                        ? "Free"
                        : "Rs ${(item.price * item.quantity).toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: item.isFree
                          ? Colors.green[600]
                          : const Color(0xFF1E293B),
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
                  // if (item.discount != null && item.discount! > 0) ...[
                  //   const SizedBox(width: 8),
                  //   Text(
                  //     "Rs ${(item.discount! * item.quantity).toStringAsFixed(2)}",
                  //     style: const TextStyle(
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w600,
                  //       color: Color(0xFF1E293B),
                  //       fontFamily: 'SanFrancisco',
                  //     ),
                  //   ),
                  // ],
                ],
              ),
              const Divider(),
            ],
          ),
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
