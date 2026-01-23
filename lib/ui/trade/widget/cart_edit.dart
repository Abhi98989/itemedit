import 'package:flutter/material.dart';

class CartEdit extends StatelessWidget {
  const CartEdit({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Quantity',
                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'SanFrancisco',),
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.done), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
