import 'package:flutter/material.dart';
import 'services/data_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF6F7F8),
      ),
      home: const LabProfileScreen(),
    );
  }
}

class LabProfileScreen extends StatefulWidget {
  const LabProfileScreen({super.key});

  @override
  State<LabProfileScreen> createState() => _LabProfileScreenState();
}

class _LabProfileScreenState extends State<LabProfileScreen> {
  static const primary = Color(0xFF137FEC);
  static const muted = Color(0xFF4C739A);

  int selectedIndex = 0;
  final List<String> filters = [
    "All Tests",
    "Blood Work",
    "Radiology",
    "Health Packages",
  ];

  Map<String, int> cart = {};
  Map<String, int> prices = {};
  List<Map<String, dynamic>> tests = [];
  Map<String, dynamic> labProfile = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final testsList = await DataService.getTests();
      final lab = await DataService.getLabProfile();

      setState(() {
        tests = testsList;
        labProfile = lab;
        prices = DataService.buildPricesMap(testsList);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  int get totalItems => cart.values.fold(0, (a, b) => a + b);
  int get totalPrice =>
      cart.entries.fold(0, (sum, e) => sum + (prices[e.key]! * e.value));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Lab Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade300),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    children: [
                      _profileHeader(),
                      _statsRow(),
                      _searchBar(),
                      _filtersBar(),
                      ...tests.map((test) => _buildTestCard(test)).toList(),
                    ],
                  ),
                ),
                _bottomBar(),
              ],
            ),
    );
  }

  Widget _buildTestCard(Map<String, dynamic> test) {
    final title = test['title'];
    final quantity = cart[title] ?? 0;
    final price = prices[title] ?? 0;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Info
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.info_outline, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            test['description'],
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          if (test['reportTime'] != null || test['homeVisit'])
            Row(
              children: [
                if (test['reportTime'] != null)
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "Report in ${test['reportTime']}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                if (test['reportTime'] != null && test['homeVisit'])
                  const SizedBox(width: 16),
                if (test['homeVisit'])
                  Row(
                    children: [
                      const Icon(Icons.home, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text(
                        "Home Visit Available",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
              ],
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹$price",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const Text(
                    "Incl. ₹2 platform fee",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              quantity == 0
                  ? ElevatedButton(
                      onPressed: () => setState(() => cart[title] = 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : _quantityCounter(title, quantity),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityCounter(String title, int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 40,
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() {
              if (cart[title]! > 1)
                cart[title] = cart[title]! - 1;
              else
                cart.remove(title);
            }),
            icon: const Icon(Icons.remove, color: primary),
            splashRadius: 20,
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, color: primary),
          ),
          IconButton(
            onPressed: () => setState(() => cart[title] = cart[title]! + 1),
            icon: const Icon(Icons.add, color: primary),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$totalItems Test${totalItems > 1 ? 's' : ''} Added",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹$totalPrice",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
                child: Row(
                  children: const [
                    Text(
                      "Proceed to Pay",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- OTHER EXISTING WIDGETS ----------
  Widget _profileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  labProfile['image'] ?? "",
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 90,
                    width: 90,
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          labProfile['name'] ?? "Lab Name",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_outlined,
                          color: primary,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${labProfile['accreditation'] ?? ''} • ${labProfile['status'] ?? ''}",
                      style: const TextStyle(fontSize: 13, color: muted),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: muted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          labProfile['address'] ?? "",
                          style: const TextStyle(fontSize: 13, color: muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _actionButton(Icons.call, "Call Lab", primary),
              const SizedBox(width: 12),
              _actionButton(
                Icons.directions_outlined,
                "Directions",
                primary,
                filled: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String text,
    Color color, {
    bool filled = true,
  }) {
    return Expanded(
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: filled ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: filled ? Colors.white : color),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: filled ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statsRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _statCard(
            icon: Icons.star_border,
            title: "RATING",
            value: "${labProfile['rating'] ?? 0}",
            iconColor: Colors.amber,
          ),
          _statCard(
            icon: Icons.biotech,
            title: "TESTS",
            value: "${labProfile['testsCount'] ?? 0}+",
            iconColor: Colors.grey,
          ),
          _statCard(
            icon: Icons.schedule,
            title: "REPORT",
            value: labProfile['reportTime'] ?? "",
            iconColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Search blood tests, health packages...",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _filtersBar() {
    final ScrollController _scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final selected = index == selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: Container(
                  margin: EdgeInsets.only(
                    right: index == filters.length - 1 ? 16 : 8,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? primary : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
