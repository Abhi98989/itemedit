import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itemedit/ui/trade/model/product_class.dart';
import 'package:itemedit/ui/trade/model/party.dart';
import 'widget/order_slidebar.dart';
import 'widget/productarea.dart';
import 'widget/payment_widget.dart';
import 'store/local_store.dart';
import 'widget/drawer.dart';

class POSLandingPage extends StatefulWidget {
  const POSLandingPage({super.key});
  @override
  State<POSLandingPage> createState() => _POSLandingPageState();
}

class _POSLandingPageState extends State<POSLandingPage> {
  final List<OrderItem> items = [];
  bool isPaymentMode = false;
  String enteredAmount = "";
  String selectedPayment = "";
  // Customer Data
  Customer? selectedCustomer;
  bool isCustomerSelected = false;
  String customerName = "";
  String customerPhone = "";
  String customerAddress = "";
  String customerPan = "";
  String invoiceNumber = "";
  String customerBalance = "";
  String tipn = "";
  List<DraftOrder> draftOrders = [];
  final LocalStore _localStore = LocalStore();

  void _showAddCustomerDialog(
    BuildContext context,
    StateSetter setSelectionState,
  ) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressLine1Controller = TextEditingController();
    final addressLine2Controller = TextEditingController();
    final cityController = TextEditingController();
    final zipController = TextEditingController();
    final regionController = TextEditingController();
    final birthdayController = TextEditingController();
    final tipnController = TextEditingController();
    final customerCodeController = TextEditingController();
    final nirController = TextEditingController();
    final balanceController = TextEditingController();
    final companyController = TextEditingController();
    final jobPositionController = TextEditingController();
    final websiteController = TextEditingController();
    final tagsController = TextEditingController();

    String selectedCustomerType = "Individual";
    String selectedBalanceType = "To receive";

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                width: 1000,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 16,
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                                const Text(
                                  "Create Customer",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (nameController.text.isEmpty ||
                                        phoneController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Name and Phone are required",
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    final newCustomer = Customer(
                                      partyId: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      address:
                                          "${addressLine1Controller.text} ${addressLine2Controller.text} ${cityController.text}"
                                              .trim(),
                                      tipn: tipnController.text,
                                      outstandingbalance:
                                          balanceController.text.isEmpty
                                          ? "0.00"
                                          : balanceController.text,
                                      balanceType:
                                          selectedBalanceType == "To receive"
                                          ? "DR"
                                          : "CR",
                                      email: emailController.text,
                                      city: cityController.text,
                                      zip: zipController.text,
                                      region: regionController.text,
                                      birthday: birthdayController.text,
                                      customerCode: customerCodeController.text,
                                      nir: nirController.text,
                                      type: selectedCustomerType,
                                    );
                                    customers.add(newCustomer);
                                    setSelectionState(() {});
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Customer saved successfully",
                                        ),
                                        backgroundColor: Color(0xff7CD23D),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white, // Odoo purple
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'SanFrancisco',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Identity Section
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar Placeholder
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Name and Quick Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildIconField(
                                    Icons.person_outlined,
                                    "Name",
                                    companyController,
                                  ),
                                  _buildIconField(
                                    Icons.email_outlined,
                                    "Email",
                                    emailController,
                                  ),
                                  _buildIconField(
                                    Icons.phone_outlined,
                                    "Phone",
                                    phoneController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dual Column Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column: Address
                            Expanded(
                              child: Column(
                                spacing: 4,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRowField(
                                    "Address",
                                    "Street...",
                                    addressLine1Controller,
                                  ),
                                  _buildRowField(
                                    "",
                                    "Street 2...",
                                    addressLine2Controller,
                                    hideLabel: true,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 100),
                                      Expanded(
                                        child: _buildMinimalField(
                                          "City",
                                          cityController,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildMinimalField(
                                          "State",
                                          regionController,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildMinimalField(
                                          "ZIP",
                                          zipController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  _buildRowField(
                                    "",
                                    "Country",
                                    TextEditingController(text: "Nepal"),
                                    hideLabel: true,
                                  ),
                                  _buildRowField(
                                    "Tax ID",
                                    "e.g. BE0477472701",
                                    tipnController,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 48),
                            // Right Column: Professional fields
                            Expanded(
                              child: Column(
                                spacing: 4,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRowField(
                                    "Job Position",
                                    "e.g. Sales Director",
                                    jobPositionController,
                                  ),
                                  _buildRowField(
                                    "Website",
                                    "e.g. https://www.odoo.com",
                                    websiteController,
                                  ),
                                  _buildRowField(
                                    "Tags",
                                    "e.g. \"B2B\", \"VIP\"",
                                    tagsController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Tabs Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          labelColor: Color(0xff7CD23D),
                          unselectedLabelColor: Colors.black54,
                          indicatorColor: Color(0xff7CD23D),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          tabs: [
                            Tab(text: "Contacts"),
                            Tab(text: "Sales & Purchase"),
                            Tab(text: "Invoicing"),
                            Tab(text: "Notes"),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      // Tab Content (Flexible)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: TabBarView(
                            children: [
                              _buildInvoicingTab(
                                balanceController,
                                selectedBalanceType,
                                (val) => setDialogState(
                                  () => selectedBalanceType = val,
                                ),
                              ),
                              const Center(child: Text("Sales details here")),
                              _buildExtraInfoTab(
                                customerCodeController,
                                nirController,
                                birthdayController,
                                context,
                                setDialogState,
                              ),
                              const Center(child: Text("Notes area")),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIconField(
    IconData icon,
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'SanFrancisco',
                ),
                isDense: true,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
              style: const TextStyle(fontSize: 13, fontFamily: 'SanFrancisco'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowField(
    String label,
    String hint,
    TextEditingController controller, {
    bool hideLabel = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              hideLabel ? "" : label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
                fontFamily: 'SanFrancisco',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.black, fontSize: 13),
                isDense: true,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontFamily: 'SanFrancisco',
        ),
        isDense: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),

        contentPadding: const EdgeInsets.symmetric(vertical: 6),
      ),
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _buildInvoicingTab(
    TextEditingController balanceController,
    String selectedType,
    Function(String) onTypeChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Accounts info",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'SanFrancisco',
          ),
        ),
        const SizedBox(height: 16),
        _buildRowField("Balance", "0.00", balanceController),
        const SizedBox(height: 16),
        Row(
          children: [
            const SizedBox(width: 100),
            ChoiceChip(
              label: const Text(
                "To receive",
                style: TextStyle(fontFamily: 'SanFrancisco'),
              ),
              selected: selectedType == "To receive",
              selectedColor: const Color(0xff008784).withValues(alpha: 0.1),
              onSelected: (s) => onTypeChanged("To receive"),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text(
                "To give",
                style: TextStyle(fontFamily: 'SanFrancisco'),
              ),
              selected: selectedType == "To give",
              selectedColor: const Color(0xff714B67).withValues(alpha: 0.1),
              onSelected: (s) => onTypeChanged("To give"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExtraInfoTab(
    TextEditingController code,
    TextEditingController nir,
    TextEditingController birthday,
    BuildContext context,
    StateSetter setDialogState,
  ) {
    return Column(
      children: [
        _buildRowField("Customer Code", "Ext-ID...", code),
        _buildRowField("NIR", "National ID...", nir),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              const SizedBox(width: 100),
              const Text(
                "Birthday",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setDialogState(
                        () => birthday.text =
                            "${picked.month}/${picked.day}/${picked.year}",
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Text(
                      birthday.text.isEmpty ? "Select date..." : birthday.text,
                      style: TextStyle(
                        color: birthday.text.isEmpty
                            ? Colors.grey.shade400
                            : Colors.black87,
                        fontSize: 13,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCustomerSelectionDialog() {
    final TextEditingController searchController = TextEditingController();
    String sortOption = 'default';
    String filterDiscount = 'All';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Filter customers based on search query
            List<Customer> filteredCustomers = customers.where((customer) {
              final searchQuery = searchController.text.toLowerCase();
              final name = customer.name.toLowerCase();
              final phone = customer.phone.toLowerCase();
              // return name.contains(searchQuery) || phone.contains(searchQuery);
              final matchesSearch =
                  name.contains(searchQuery) || phone.contains(searchQuery);
              if (!matchesSearch) return false;
              if (filterDiscount != 'All') {
                return customer.discountPer == filterDiscount;
              }
              return true;
            }).toList();
            if (sortOption == 'az') {
              filteredCustomers.sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
              );
            } else if (sortOption == 'za') {
              filteredCustomers.sort(
                (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
              );
            } else if (sortOption == 'newest') {
              filteredCustomers.sort((a, b) {
                int idA = int.tryParse(a.partyId) ?? 0;
                int idB = int.tryParse(b.partyId) ?? 0;
                return idB.compareTo(idA);
              });
            }
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Container(
                  color: Colors.white,
                  width: 700,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 16,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  searchController.dispose();
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const Text(
                                "Select Customer",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              _showAddCustomerDialog(context, setState);
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.add),
                                Text(
                                  "Add Customer",
                                  style: TextStyle(fontFamily: 'SanFrancisco'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search Field
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Search by name or phone number",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontFamily: 'SanFrancisco',
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey.shade600,
                                    size: 20,
                                  ),
                                  suffixIconColor: Colors.grey.shade600,
                                  suffixIcon: searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.grey.shade600,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            searchController.clear();
                                            setState(() {});
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'SanFrancisco',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.05,
                              child: IconButton(
                                onPressed: () {},
                                icon: Center(
                                  child: const Icon(
                                    Icons.qr_code_2_outlined,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey[300],
                              thickness: 1,
                              indent: 5,
                              endIndent: 5,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.05,
                              child: PopupMenuButton<String>(
                                tooltip: "Filter by Discount",
                                icon: Center(
                                  child: Icon(
                                    Icons.discount_sharp,
                                    size: 20,
                                    color: filterDiscount != 'All'
                                        ? Colors.blue
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                onSelected: (val) {
                                  setState(() {
                                    filterDiscount = val;
                                  });
                                },
                                itemBuilder: (context) {
                                  final discounts =
                                      customers
                                          .map((e) => e.discountPer)
                                          .toSet()
                                          .toList()
                                        ..sort(
                                          (a, b) => (double.tryParse(a) ?? 0)
                                              .compareTo(
                                                double.tryParse(b) ?? 0,
                                              ),
                                        );
                                  return [
                                    const PopupMenuItem(
                                      value: 'All',
                                      child: Text('All Discounts'),
                                    ),
                                    ...discounts.map(
                                      (d) => PopupMenuItem(
                                        value: d,
                                        child: Text('$d%'),
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey[300],
                              thickness: 1,
                              indent: 5,
                              endIndent: 5,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.05,
                              child: PopupMenuButton<String>(
                                tooltip: "Sort Customers",
                                icon: Center(
                                  child: Icon(
                                    Icons.filter_list,
                                    size: 26,
                                    color: sortOption != 'default'
                                        ? Colors.blue
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                onSelected: (val) {
                                  setState(() {
                                    sortOption = val;
                                  });
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'az',
                                    child: Text('Name (A-Z)'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'za',
                                    child: Text('Name (Z-A)'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'newest',
                                    child: Text('New Created'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Customer List
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: filteredCustomers.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person_off_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        searchController.text.isEmpty
                                            ? "No customers found"
                                            : "No matching customers",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'SanFrancisco',
                                        ),
                                      ),
                                      if (searchController.text.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            "Try different search terms",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade500,
                                              fontFamily: 'SanFrancisco',
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredCustomers.length,
                                itemBuilder: (context, index) {
                                  final customer = filteredCustomers[index];
                                  return Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 0,
                                          ),
                                      leading: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: const Color(
                                          0xff7CD23D,
                                        ),
                                        child: Text(
                                          customer.name[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            customer.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              fontFamily: 'SanFrancisco',
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_vert_outlined,
                                              size: 20,
                                            ),
                                            padding: EdgeInsets.zero,
                                            itemBuilder:
                                                (BuildContext context) => [
                                                  const PopupMenuItem<String>(
                                                    value: 'edit',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit_outlined,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'SanFrancisco',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const PopupMenuItem<String>(
                                                    value: 'view_details',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .visibility_outlined,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'View Details',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'SanFrancisco',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const PopupMenuItem<String>(
                                                    value: 'receive_payment',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .payment_outlined,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Receive Payment',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'SanFrancisco',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                            onSelected: (String value) {
                                              switch (value) {
                                                case 'edit':
                                                  // TODO: Implement edit functionality
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Edit ${customer.name}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'SanFrancisco',
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  break;
                                                case 'view_details':
                                                  // TODO: Implement view details functionality
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'View details for ${customer.name}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'SanFrancisco',
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  break;
                                                case 'receive_payment':
                                                  // TODO: Implement receive payment functionality
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Receive payment from ${customer.name}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'SanFrancisco',
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  break;
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 2),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  size: 13,
                                                  color: Colors.grey.shade600,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  customer.phone,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade700,
                                                    fontFamily: 'SanFrancisco',
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                VerticalDivider(
                                                  width: 1,
                                                  thickness: 1,
                                                  color: Colors.grey.shade600,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  customer.tipn,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade700,
                                                    fontFamily: 'SanFrancisco',
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 13,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  customer.address,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade700,
                                                    fontFamily: 'SanFrancisco',
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "Outstanding: Rs ${customer.outstandingbalance}",
                                              style: const TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                fontFamily: 'SanFrancisco',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      dense: true,
                                      onTap: () {
                                        this.setState(() {
                                          selectedCustomer = customer;
                                          isCustomerSelected = true;
                                          customerName = customer.name;
                                          customerPhone = customer.phone;
                                          customerAddress = customer.address;
                                          customerBalance =
                                              customer.outstandingbalance;
                                        });
                                        searchController.dispose();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void clearItems() {
    setState(() {
      items.clear();
      selectedCustomer = null;
      isCustomerSelected = false;
      customerName = "";
      customerPhone = "";
      customerAddress = "";
      customerBalance = "";
    });
  }

  void addItem(Product product, {double quantity = 1}) {
    setState(() {
      final existingIndex = items.indexWhere(
        (item) => item.name == product.name,
      );
      if (existingIndex != -1) {
        items[existingIndex].quantity += quantity;
        // The original logic to move to top was removed in the provided diff,
        // so I'm keeping the new simplified logic.
      } else {
        items.insert(
          0,
          OrderItem(
            name: product.name,
            quantity: quantity,
            price: product.price,
            category: product.category,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    final drafts = await _localStore.loadDrafts();
    setState(() {
      draftOrders = drafts;
    });
  }

  Future<void> _saveDrafts() async {
    await _localStore.saveDrafts(draftOrders);
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<double>(
      0.0,
      (double sum, OrderItem item) => sum + (item.price * item.quantity),
    );
    final tax = subtotal * 0.13;
    final total = subtotal + tax;
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left Sidebar (Order Details) - Always visible
          SizedBox(
            width: 380,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: OrderSidebar(
                items: items,
                isPaymentMode: isPaymentMode,
                customerName: customerName,
                customerPhone: customerPhone,
                customerAddress: customerAddress,
                customerBalance: customerBalance,
                tipn: tipn,
                onRemove: (index) {
                  setState(() {
                    items.removeAt(index);
                  });
                },
                onQuantityChange: (int index, double newQty) {
                  setState(() {
                    if (newQty <= 0) {
                      items.removeAt(index);
                    } else {
                      items[index].quantity = newQty;
                      // Move the updated item to the top
                      final item = items.removeAt(index);
                      items.insert(0, item);
                    }
                  });
                },
                onCustomerSelect: _showCustomerSelectionDialog,
                onCustomerClear: () {
                  setState(() {
                    selectedCustomer = null;
                    isCustomerSelected = false;
                    customerName = "";
                    customerPhone = "";
                    customerAddress = "";
                    customerBalance = "";
                  });
                },
                draftOrders: draftOrders,
                onRestoreDraft: (DraftOrder draft) {
                  setState(() {
                    items.clear();
                    items.addAll(draft.items);
                    customerName = draft.customerName;
                    customerPhone = draft.customerPhone;
                    customerAddress = draft.customerAddress;
                    isCustomerSelected = customerName.isNotEmpty;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Draft restored successfully"),
                      backgroundColor: Color(0xff7CD23D),
                    ),
                  );
                },
              ),
            ),
          ),
          // Main Content Area (Product Grid / Payment Content)
          Expanded(
            child: (isPaymentMode == true)
                ? PaymentBody(
                    items: items,
                    subtotal: subtotal,
                    tax: tax,
                    total: total,
                    enteredAmount: enteredAmount,
                    selectedPayment: selectedPayment,
                    invoiceNumber: invoiceNumber,
                    customerName: customerName,
                    customerPhone: customerPhone,
                    customerAddress: customerAddress,
                    customerPan: customerPan,
                    onSelectCustomer: _showCustomerSelectionDialog,
                    onPaymentModeChanged: (mode) {
                      setState(() {
                        selectedPayment = mode;
                        if (mode == "Cash") {
                          enteredAmount = total.toStringAsFixed(2);
                        }
                      });
                    },
                    onAmountChanged: (amount) {
                      setState(() {
                        enteredAmount = amount;
                      });
                    },
                    onBack: () {
                      setState(() {
                        isPaymentMode = false;
                      });
                    },
                    onConfirm: () {
                      // Handle confirmation
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                            "Payment Confirmed",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                          content: Text(
                            "Mode: $selectedPayment\nPaid: Rs ${enteredAmount.isEmpty ? total.toStringAsFixed(2) : enteredAmount}",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  items.clear();
                                  isPaymentMode = false;
                                  enteredAmount = "";
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : MainProductArea(
                    price: total,
                    onProductTap: addItem,
                    onDeleteClick: clearItems,
                    onPaymentClick: () {
                      setState(() {
                        isPaymentMode = true;
                      });
                    },
                    onSaveDraft: () {
                      if (items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "No items to save as draft",
                              style: TextStyle(fontFamily: 'SanFrancisco'),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      // Show Confirmation Dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Container(
                                width: 360,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// ICON
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xff7CD23D,
                                        ).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.save_outlined,
                                        size: 32,
                                        color: Color(0xff7CD23D),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    /// TITLE
                                    const Text(
                                      "Save as Draft?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SanFrancisco',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Are you sure you want to save this draft with ${items.length} items? This will clear your current cart.",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF64748B),
                                        fontFamily: 'SanFrancisco',
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    /// ACTION BUTTONS
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontFamily: 'SanFrancisco',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                              ); // Close confirmation

                                              // Save to drafts and clear cart
                                              setState(() {
                                                final newDraft = DraftOrder(
                                                  id: DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString(),
                                                  customerName: customerName,
                                                  customerPhone: customerPhone,
                                                  customerAddress:
                                                      customerAddress,
                                                  items: List.from(items),
                                                  timestamp: DateTime.now(),
                                                );
                                                draftOrders = [
                                                  ...draftOrders,
                                                  newDraft,
                                                ];
                                                _saveDrafts();
                                                items.clear();
                                                customerName = "";
                                                customerPhone = "";
                                                customerAddress = "";
                                                customerBalance = "";
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xff7CD23D,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              "Save Draft",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: 'SanFrancisco',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    onAddClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Add functionality coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                    onDiscountsClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Discounts functionality coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                    onFavoritesClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Favorites functionality coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                    onScanClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Scan functionality coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                    onMoreClick: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "More options coming soon",
                            style: TextStyle(fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
