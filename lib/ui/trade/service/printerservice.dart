import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:itemedit/ui/trade/model/product_class.dart';

class PrinterService {
  Future<void> printBill({
    required List<OrderItem> items,
    required double subtotal,
    required double tax,
    required double total,
    required String invoiceNumber,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return _buildPdfLayout(
            items,
            subtotal,
            tax,
            total,
            invoiceNumber,
            customerName,
            customerPhone,
            customerAddress,
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Invoice_$invoiceNumber',
    );
  }

  pw.Widget _buildPdfLayout(
    List<OrderItem> items,
    double subtotal,
    double tax,
    double total,
    String invoiceNumber,
    String customerName,
    String customerPhone,
    String customerAddress,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(
          "STORE NAME",
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          "123 Business Street, City, Country",
          textAlign: pw.TextAlign.center,
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Text(
          "Phone: +1 234 567 8900",
          textAlign: pw.TextAlign.center,
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Inv No: $invoiceNumber",
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              "Date: ${DateTime.now().toString().split(' ').first}",
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        if (customerName.isNotEmpty && customerName != "Guest") ...[
          pw.SizedBox(height: 4),
          pw.Text(
            "Customer: $customerName",
            style: const pw.TextStyle(fontSize: 10),
          ),
          if (customerPhone.isNotEmpty)
            pw.Text(
              "Phone: $customerPhone",
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
        pw.Divider(),
        // Items Header
        pw.Row(
          children: [
            pw.Expanded(
              flex: 4,
              child: pw.Text(
                "Item",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                "Qty",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                "Price",
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        // Items List
        ...items.map((item) {
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 4,
                  child: pw.Text(
                    item.name,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    item.quantity.toString().replaceAll('.0', ''),
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    (item.price * item.quantity).toStringAsFixed(2),
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        }),
        pw.Divider(),
        // Totals
        _buildPdfSummaryRow("Subtotal", subtotal),
        _buildPdfSummaryRow("Tax", tax),
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "TOTAL",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
            ),
            pw.Text(
              total.toStringAsFixed(2),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          "Thank you for your visit!",
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10),
        ),
      ],
    );
  }

  pw.Widget _buildPdfSummaryRow(String label, double value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          pw.Text(
            value.toStringAsFixed(2),
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
