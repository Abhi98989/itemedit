import 'package:flutter/material.dart';
import '../model/category_model.dart';
import '../model/product_class.dart';
import 'weight_item_dialog.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(double quantity) onTap;
  final Category? category;
  final bool isGridView;
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isGridView = true,
    this.category,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: InkWell(
          onTap: _handleTap,
          child: widget.isGridView ? _buildGridContent() : _buildListContent(),
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
                color: Colors.black,
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
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.grey, width: 0.1),
              boxShadow: [
                BoxShadow(
                  color: widget.category?.color ?? Colors.transparent,
                  offset: const Offset(-3.0, 1.0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      if (widget.product.sku.isNotEmpty)
                        Text(
                          "SKU: ${widget.product.sku} ",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'SanFrancisco',
                            color: Colors.grey[500],
                          ),
                        ),
                      if (widget.product.description.isNotEmpty)
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'SanFrancisco',
                            color: Colors.grey[500],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  Text(
                    "Rs ${widget.product.price}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'SanFrancisco',
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
