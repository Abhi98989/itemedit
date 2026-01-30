import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/model/product_class.dart';
import 'package:itemedit/ui/trade/service/printerservice.dart';

class BillSample extends StatelessWidget {
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String invoiceNumber;
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  const BillSample({
    super.key,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.invoiceNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Invoice',
              style: TextStyle(
                fontFamily: 'SanFrancisco',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'Print',
              onPressed: () {
                PrinterService().printBill(
                  items: items,
                  subtotal: subtotal,
                  tax: tax,
                  total: total,
                  invoiceNumber: invoiceNumber,
                  customerName: customerName,
                  customerPhone: customerPhone,
                  customerAddress: customerAddress,
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Container(
          width: 400,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "STORE NAME",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "123 Business Street, City, Country",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              const Text(
                "Phone: +1 234 567 8900",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Inv No: $invoiceNumber",
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
                  Text(
                    "Date: ${DateTime.now().toString().split(' ').first}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
                ],
              ),
              if (customerName.isNotEmpty && customerName != "Guest") ...[
                const SizedBox(height: 8),
                Text(
                  "Customer: $customerName",
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'SanFrancisco',
                  ),
                ),
                if (customerPhone.isNotEmpty)
                  Text(
                    "Phone: $customerPhone",
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
              ],
              const Divider(height: 24),
              // Items Header
              const Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Item",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Qty",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Price",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Items List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            item.quantity.toString().replaceAll('.0', ''),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            (item.price * item.quantity).toStringAsFixed(2),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(height: 24),
              // Totals
              _buildSummaryRow("Subtotal", subtotal),
              _buildSummaryRow("Tax", tax),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TOTAL",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    total.toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'SanFrancisco',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "Thank you for your visit!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              const SizedBox(height: 16),
              // Barcode placeholder
              Container(
                height: 40,
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Text(
                  "|||| ||| ||||| || ||||",
                  style: TextStyle(
                    fontFamily: 'Courier',
                    letterSpacing: 4,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(fontSize: 14, fontFamily: 'SanFrancisco'),
          ),
        ],
      ),
    );
  }
}
