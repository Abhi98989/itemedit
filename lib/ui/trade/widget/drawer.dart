import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 380,
      backgroundColor: const Color(0xFFF1F5F9),
      child: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // decoration: BoxDecoration(color: Color(0xFF81D43A)),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.language_sharp,
                      color: Color(0xFF81D43A),
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Customer Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SanFrancisco',
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "Customer Address",
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                    Text(
                      "WHOISHI",
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                    Text(
                      "+91 1234567890",
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontFamily: 'SanFrancisco',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Drawer Items
          Divider(height: 1, color: Colors.black.withValues(alpha: 0.2)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  icon: Icons.home_outlined,
                  label: "Home",
                  onTap: () {},
                ),
                _expansionDrawerItem(
                  icon: Icons.shopping_cart_outlined,
                  label: "Sales",
                  children: [
                    _drawerSubItem("Sales Entry", () {}),
                    _drawerSubItem("Sales Invoice", () {}),
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
                _drawerItem(
                  icon: Icons.groups_outlined,
                  label: "Party",
                  onTap: () {},
                ),
                _drawerItem(
                  icon: Icons.shopping_bag_outlined,
                  label: "Product",
                  onTap: () {},
                ),
                _drawerItem(
                  icon: Icons.inventory_2_outlined,
                  label: "Inventory",
                  onTap: () {},
                ),
                _drawerItem(
                  icon: Icons.bar_chart_outlined,
                  label: "Report",
                  onTap: () {},
                ),
                _drawerItem(
                  icon: Icons.receipt_long_outlined,
                  label: "Payment/Receipt",
                  onTap: () {},
                ),
                _drawerItem(
                  icon: Icons.settings_outlined,
                  label: "Setting",
                  onTap: () {},
                ),
                _drawerItem(
                  icon: Icons.qr_code_scanner_outlined,
                  label: "Update BarCode",
                  onTap: () {},
                ),
                _drawerItem(
                  icon: Icons.shield_outlined,
                  label: "Subscription Plan",
                  onTap: () {},
                ),

                _drawerItem(
                  icon: Icons.logout_outlined,
                  label: "Log Out",
                  onTap: () {},
                ),
                const Divider(
                  height: 30,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                _drawerItem(
                  icon: Icons.info_outlined,
                  label: "Version 1.0.0",
                  onTap: () {},
                ),
              ],
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
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black, size: 24),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'SanFrancisco',
        ),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
    );
  }

  Widget _expansionDrawerItem({
    required IconData icon,
    required String label,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.black, size: 24),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'SanFrancisco',
        ),
      ),
      tilePadding: const EdgeInsets.only(left: 16, right: 16),
      childrenPadding: const EdgeInsets.only(left: 20),
      collapsedIconColor: Colors.black,
      iconColor: const Color(0xFF7CD23D),
      expandedAlignment: Alignment.centerLeft,
      children: children,
    );
  }

  Widget _drawerSubItem(String label, VoidCallback onTap) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'SanFrancisco',
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}
