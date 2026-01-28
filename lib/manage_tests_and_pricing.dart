import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

void main() {
  runApp(const MyApp());
}

/* ---------------- APP ROOT ---------------- */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManageTestsScreen(),
    );
  }
}

/* ---------------- MODEL ---------------- */

class LabTest {
  String name;
  String labId;
  int yourPrice;
  bool isActive;
  IconData icon;

  LabTest({
    required this.name,
    required this.labId,
    required this.yourPrice,
    required this.isActive,
    required this.icon,
  });

  int get customerPrice => yourPrice + 2;
}

/* ---------------- SCREEN ---------------- */

class ManageTestsScreen extends StatefulWidget {
  const ManageTestsScreen({super.key});

  @override
  State<ManageTestsScreen> createState() => _ManageTestsScreenState();
}

class _ManageTestsScreenState extends State<ManageTestsScreen> {
  final TextEditingController searchCtrl = TextEditingController();

  int selectedTab = 0; // 0=All,1=Active,2=Inactive

  List<LabTest> tests = [
    LabTest(
        name: "Complete Blood Count (CBC)",
        labId: "20491",
        yourPrice: 498,
        isActive: true,
        icon: Symbols.science),
    LabTest(
        name: "Lipid Profile",
        labId: "20498",
        yourPrice: 748,
        isActive: true,
        icon: Symbols.monitor_heart),
    LabTest(
        name: "HbA1c (Glycated Hb)",
        labId: "31052",
        yourPrice: 598,
        isActive: false,
        icon: Symbols.bloodtype),
    LabTest(
        name: "Liver Function Test (LFT)",
        labId: "20492",
        yourPrice: 848,
        isActive: true,
        icon: Symbols.health_and_safety),
  ];

  List<LabTest> get filteredTests {
    return tests.where((t) {
      final matchSearch =
      t.name.toLowerCase().contains(searchCtrl.text.toLowerCase());

      final matchTab = selectedTab == 0 ||
          (selectedTab == 1 && t.isActive) ||
          (selectedTab == 2 && !t.isActive);

      return matchSearch && matchTab;
    }).toList();
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _topBar(),
      floatingActionButton: _fab(),
      bottomNavigationBar: _bottomNav(),
      body: Column(
        children: [
          _searchBar(),
          _tabs(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: filteredTests.length,
              itemBuilder: (_, i) => _testCard(filteredTests[i]),
            ),
          )
        ],
      ),
    );
  }

  /* ---------------- TOP BAR ---------------- */

  AppBar _topBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      centerTitle: true,

      // 👇 BACK ARROW
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF0D1B12),
          size: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: const Text(
        "Manage Tests & Pricing",
        style: TextStyle(
          color: Color(0xFF0D1B12),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),

      // 👇 BULK BUTTON
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              // TODO: Bulk action
            },
            child: const Text(
              "Bulk",
              style: TextStyle(
                color: Color(0xFF13EC5B),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    );
  }


  /* ---------------- SEARCH ---------------- */

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchCtrl,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          prefixIcon:
          const Icon(Icons.search, color: Color(0xFF13EC5B)),
          hintText: "Search tests by name...",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /* ---------------- TABS ---------------- */

  Widget _tabs() {
    return Row(
      children: [
        _tab("All Tests", 0),
        _tab("Active", 1),
        _tab("Inactive", 2),
      ],
    );
  }

  Widget _tab(String title, int index) {
    final active = selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedTab = index),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 3,
              color: active
                  ? const Color(0xFF13EC5B)
                  : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  /* ---------------- CARD ---------------- */

  Widget _testCard(LabTest t) {
    return Opacity(
      opacity: t.isActive ? 1 : 0.6,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                  const Color(0xFF13EC5B).withOpacity(0.2),
                  child: Icon(
                    t.icon,
                    color: const Color(0xFF13EC5B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Lab ID: ${t.labId}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                Switch(
                  value: t.isActive,
                  activeColor: const Color(0xFF13EC5B),
                  onChanged: (v) =>
                      setState(() => t.isActive = v),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _priceBox(
                  "Your Price",
                  "₹${t.yourPrice}",
                  editable: true,
                  onEdit: () => _editPrice(t),
                ),
                const SizedBox(width: 12),
                _priceBox(
                  "Customer Price",
                  "₹${t.customerPrice}",
                  subtitle: "Incl. ₹2 platform fee",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _priceBox(String title,
      String price, {
        bool editable = false,
        String? subtitle,
        VoidCallback? onEdit,
      }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (editable)
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Color(0xFF13EC5B),
                    ),
                    onPressed: onEdit,
                  )
              ],
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF13EC5B),
                ),
              )
          ],
        ),
      ),
    );
  }

  /* ---------------- EDIT PRICE ---------------- */

  void _editPrice(LabTest t) {
    final ctrl =
    TextEditingController(text: t.yourPrice.toString());

    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text("Edit Price"),
            content: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    t.yourPrice = int.tryParse(ctrl.text) ?? t.yourPrice;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  /* ---------------- ADD NEW TEST ---------------- */

  Widget _fab() {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF13EC5B),
      onPressed: _addTest,
      icon: const Icon(Icons.add, color: Colors.black),
      label: const Text(
        "ADD NEW TEST",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  void _addTest() {
    setState(() {
      tests.add(
        LabTest(
          name: "New Test",
          labId: DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          yourPrice: 500,
          isActive: true,
          icon: Symbols.science,
        ),
      );
    });
  }

  /* ---------------- BOTTOM NAV ---------------- */

  Widget _bottomNav() {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 1,
          selectedItemColor: const Color(0xFF13EC5B),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined), label: "Dashboard"),
            BottomNavigationBarItem(
                icon: Icon(Icons.medical_services_outlined), label: "Tests"),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: "Orders"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: "Settings"),
          ],
        ),
      ),
    );
  }
}