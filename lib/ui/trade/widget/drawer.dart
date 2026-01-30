import 'package:flutter/material.dart';

import '../drawer/home_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 375,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header Section with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF81D43A), const Color(0xFF6BC22F)],
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Profile Icon
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.language_sharp,
                          color: Color(0xFF81D43A),
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SanFrancisco',
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Customer Address",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "WHOISHI",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "+91 1234567890",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                              fontFamily: 'SanFrancisco',
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Close Button
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFB),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                physics: const BouncingScrollPhysics(),
                children: [
                  _drawerItem(
                    icon: Icons.home_outlined,
                    label: "Home",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),

                  _drawerItem(
                    icon: Icons.post_add_outlined,
                    label: "Quick POS",
                    onTap: () {},
                  ),
                  _expansionDrawerItem(
                    icon: Icons.receipt_long_outlined,
                    label: "Receipts",
                    children: [
                      _drawerSubItem("All Order", () {}),
                      _drawerSubItem("InStore", () {}),
                      _drawerSubItem("Pickup", () {}),
                      _drawerSubItem("Delivery", () {}),
                    ],
                  ),
                  _drawerItem(
                    icon: Icons.person_outlined,
                    label: "Customers",
                    onTap: () {},
                  ),
                  _expansionDrawerItem(
                    icon: Icons.shopping_bag_outlined,
                    label: "Product Catalog",
                    children: [
                      _drawerSubItem("Add Product", () {}),
                      _drawerSubItem("Product List", () {}),
                      // _drawerSubItem("Product Category", () {}),
                    ],
                  ),
                  _expansionDrawerItem(
                    icon: Icons.shopping_cart_outlined,
                    label: "Sales",
                    children: [
                      _drawerSubItem("Add Sales", () {}),
                      _drawerSubItem("Return", () {}),
                      _drawerSubItem("Void Sales", () {}),
                    ],
                  ),

                  _expansionDrawerItem(
                    icon: Icons.grid_view_outlined,
                    label: "Order",
                    children: [
                      _drawerSubItem("New Order", () {}),
                      _drawerSubItem("Order History", () {}),
                    ],
                  ),
                  _expansionDrawerItem(
                    icon: Icons.assignment_outlined,
                    label: "Purchase",
                    children: [
                      _drawerSubItem("Purchase Entry", () {}),
                      _drawerSubItem("Vendor List", () {}),
                    ],
                  ),

                  // const SizedBox(height: 4),
                  _drawerItem(
                    icon: Icons.groups_outlined,
                    label: "Party",
                    onTap: () {},
                  ),
                  _drawerItem(
                    icon: Icons.inventory_2_outlined,
                    label: "Inventory Management",
                    onTap: () {},
                  ),
                  _drawerItem(
                    icon: Icons.payment_outlined,
                    label: "Payment",
                    onTap: () {},
                  ),

                  // const SizedBox(height: 4),
                  _drawerItem(
                    icon: Icons.bar_chart_outlined,
                    label: "Reports",
                    onTap: () {},
                  ),
                  _drawerItem(
                    icon: Icons.attach_money_outlined,
                    label: "Expenses",
                    onTap: () {},
                  ),
                  _drawerItem(
                    icon: Icons.settings_overscan_outlined,
                    label: "Setup",
                    onTap: () {},
                  ),
                  _drawerItem(
                    icon: Icons.settings_outlined,
                    label: "Setting",
                    onTap: () {},
                  ),

                  // _drawerItem(
                  //   icon: Icons.qr_code_scanner_outlined,
                  //   label: "Update BarCode",
                  //   onTap: () {},
                  // ),

                  // _drawerItem(
                  //   icon: Icons.shield_outlined,
                  //   label: "Subscription Plan",
                  //   onTap: () {},
                  // ),
                  _drawerItem(
                    icon: Icons.logout_outlined,
                    label: "Log Out",
                    onTap: () {},
                    iconColor: Colors.red.shade400,
                  ),
                  // Version Info at bottom
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ezregi",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: 'SanFrancisco',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outlined,
                              size: 16,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Version 1.0.0",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'SanFrancisco',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // color: Colors.transparent,
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.black, size: 22),
            ),
            title: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'SanFrancisco',
                letterSpacing: 0.2,
              ),
            ),
            onTap: onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hoverColor: const Color(0xFF81D43A).withValues(alpha: 0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }

  Widget _expansionDrawerItem({
    required IconData icon,
    required String label,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // color: Colors.transparent,
      ),
      child: Column(
        children: [
          Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              visualDensity: const VisualDensity(vertical: -4),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.black, size: 22),
              ),
              title: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SanFrancisco',
                  letterSpacing: 0.2,
                ),
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              childrenPadding: const EdgeInsets.only(
                left: 24,
                right: 12,
                bottom: 8,
              ),
              collapsedIconColor: const Color(0xFF81D43A),
              iconColor: const Color(0xFF81D43A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              children: children,
            ),
          ),
          Padding(padding: const EdgeInsets.all(0), child: Divider(height: 1)),
        ],
      ),
    );
  }

  Widget _drawerSubItem(String label, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: ListTile(
        leading: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            // color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'SanFrancisco',
          ),
        ),
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        hoverColor: const Color(0xFF81D43A).withValues(alpha: 0.05),
      ),
    );
  }
}
