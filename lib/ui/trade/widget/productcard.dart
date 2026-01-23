import 'package:flutter/material.dart';
import '../model/product_class.dart';
import 'weight_item_dialog.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(int quantity) onTap;
  final bool isGridView;
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isGridView = true,
  });
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // bool isHovered = false;

  void _handleTap() {
    if (widget.product.isWeightBased == true) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WeightItemDialog(
          product: widget.product,
          onConfirm: (qty) {
            widget.onTap(qty);
          },
        ),
      );
    } else {
      widget.onTap(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // onEnter: (_) => setState(() => isHovered = true),
      // onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // ignore: deprecated_member_use
        // transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
        child: InkWell(
          onTap: _handleTap,
          child: Container(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(2),
            // border: Border.all(
            //   color: isHovered
            //       ? const Color(0xff7CD23D)
            //       : const Color(0xFFE2E8F0),
            //   width: isHovered ? 2 : 1,
            // ),
            // boxShadow: isHovered
            //     ? [
            //         BoxShadow(
            //           color: const Color(0xff7CD23D).withValues(alpha: 0.1),
            //           blurRadius: 12,
            //           offset: const Offset(0, 4),
            //         ),
            //       ]
            //     : [],
            // ),
            child: widget.isGridView
                ? _buildGridContent()
                : _buildListContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildGridContent() {
    if (widget.product.image == null || widget.product.image!.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border(
            bottom: BorderSide(color: const Color(0xff7CD23D), width: 2),
          ),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Color(0xFFE2E8F0),
          //     blurRadius: 12,
          //     offset: Offset(0, 4),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'SanFrancisco',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              "Rs ${widget.product.price}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xff7CD23D),
                fontFamily: 'SanFrancisco',
              ),
            ),
          ],
        ),
      );
    }
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: _buildImage(height: 200, width: double.infinity),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'SanFrancisco',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  "Rs ${widget.product.price}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'SanFrancisco',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListContent() {
    return Row(
      children: [
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(8),
        //   child: _buildImage(height: 60, width: 60),
        // ),
        // const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  fontFamily: 'SanFrancisco',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.product.category,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'SanFrancisco',
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        Text(
          "Rs ${widget.product.price}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff7CD23D),
            fontFamily: 'SanFrancisco',
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildImage({required double height, required double width}) {
    if (widget.product.image != null) {
      if (widget.product.image!.startsWith('http')) {
        return Image.network(
          widget.product.image!,
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildImageError(height, width),
        );
      } else {
        return Image.asset(
          widget.product.image!,
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildImageError(height, width),
        );
      }
    }
    return _buildImagePlaceholder(height, width);
  }

  Widget _buildImageError(double height, double width) {
    return Container(
      height: height,
      width: width,
      color: widget.product.color.withValues(alpha: 0.2),
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  Widget _buildImagePlaceholder(double height, double width) {
    return Container(
      height: height,
      width: width,
      color: widget.product.color.withValues(alpha: 0.2),
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}
