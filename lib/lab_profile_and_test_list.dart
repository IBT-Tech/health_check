import 'package:flutter/material.dart';

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

  int selectedIndex = 0; // Selected filter index
  final List<String> filters = [
    "All Tests",
    "Blood Work",
    "Radiology",
    "Health Packages",
  ]; // added extra to show scroll

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
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                _profileHeader(),
                _statsRow(),
                _searchBar(),
                _filtersBar(),
                _testCard(
                  title: "Complete Blood Count (CBC)",
                  desc: "Includes 24 parameters. Recommended for routine checkups.",
                  price: 302,
                  report: "12 hrs",
                  homeVisit: true,
                ),
                _testCardAdded(),
                _lipidProfileCard(),          // Added
                _diabetesScreeningCard(),     // Added

              ],
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  // =================== WIDGETS ===================

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
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuBx6_qp9FxhmXVU-8f6kYXBmqo-0CuYaBocABdZvn6RApoMwXLXMk2kFcFAddL0BPZFh8KnaJPYwFDsWRhH0e0wuKI9M1uA9sxajF6Sj4dGse1nkpmbvzaCq1qPsD72hDKXFNp0zPU_Bi6MPD6aeQom2Tui9JDiaeXzxaYTHWwj8rIBJEJCHHfGtd-57hY4_M-ifclTkWlhg1m7iAzNGQiDYrqyR38xCUO39v0ZP6-SvTKzonlPAkvkOgDf1zyMS6j4IJnqghXel0KS",
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Text(
                          "City Diagnostics Center",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.verified_outlined,
                            color: primary, size: 18),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      "NABL Accredited • Open until 8:00 PM",
                      style: TextStyle(fontSize: 13, color: muted),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 14, color: muted),
                        SizedBox(width: 4),
                        Text(
                          "12, Medical Square, Downtown",
                          style: TextStyle(fontSize: 13, color: muted),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _actionButton(Icons.call, "Call Lab", primary),
              const SizedBox(width: 12),
              _actionButton(Icons.directions_outlined, "Directions", primary,
                  filled: false),
            ],
          )
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String text, Color color,
      {bool filled = true}) {
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
              Icon(icon,
                  size: 18, color: filled ? Colors.white : color),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: filled ? Colors.white : color),
              )
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
            value: "4.8 (1.2k)",
            iconColor: Colors.amber,
            titleColor: Colors.grey,
          ),
          _statCard(
            icon: Icons.biotech,
            title: "TESTS",
            value: "500+",
            iconColor: Colors.grey,
            titleColor: Colors.grey,
          ),
          _statCard(
            icon: Icons.schedule,
            title: "REPORT",
            value: "24h",
            iconColor: Colors.grey,
            titleColor: Colors.grey,
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
    required Color titleColor,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
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

  /// ---------------- SCROLLABLE FILTERS BAR ----------------
  Widget _filtersBar() {
    final ScrollController _scrollController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1️⃣ Horizontal filter buttons
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
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                      right: index == filters.length - 1 ? 16 : 8),
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

        const SizedBox(height: 4),

        // 2️⃣ Scrollbar line below buttons
        SizedBox(
          height: 6, // thickness of the scroll line
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 6,
            radius: const Radius.circular(8),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                // Invisible items to match the width of buttons
                return Container(
                  width: 80, // roughly matches button width
                  margin: const EdgeInsets.only(right: 8),
                  color: Colors.transparent,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _testCard({
    required String title,
    required String desc,
    required int price,
    String? report,
    bool homeVisit = false,
    String? extra,
    int? platformFee = 2, // optional platform fee
  }) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Info Icon
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.info_outline, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 6),

          // Description
          Text(desc, style: const TextStyle(fontSize: 13, color: Colors.grey)),

          const SizedBox(height: 12),

          // Report & Home Visit row
          Row(
            children: [
              if (report != null)
                Row(
                  children: [
                    const Icon(Icons.timer, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("Report in $report", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              if (report != null && homeVisit) const SizedBox(width: 16),
              if (homeVisit)
                Row(
                  children: [
                    const Icon(Icons. home, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    const Text("Home Visit Available", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
            ],
          ),

          if (extra != null) ...[
            const SizedBox(height: 6),
            Text(extra, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],

          const Divider(height: 24),

          // Price + Add to Cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("₹$price", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
                  if (platformFee != null)
                    Text("Incl. ₹$platformFee platform fee",
                        style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  shadowColor: primary.withOpacity(0.2),
                  elevation: 3,
                ),
                onPressed: () {},
                child: const Text("Add to Cart", style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
              )
            ],
          )
        ],
      ),
    );
  }


  Widget _testCardAdded() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and info
          Row(
            children: const [
              Expanded(
                child: Text(
                  "Thyroid Profile (T3, T4, TSH)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.info_outline, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Assessment of thyroid gland function.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          // Report row
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.timer, size: 14, color: Colors.green),
              const SizedBox(width: 4),
              const Text(
                "Report in 8 hrs",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const Divider(height: 24),

          // Price + Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "₹452",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primary),
                  ),
                  Text(
                    "Incl. ₹2 platform fee",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),

              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove, color: primary),
                      splashRadius: 20,
                    ),
                    const Text(
                      "1",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add, color: primary),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _lipidProfileCard() {
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
          Row(
            children: const [
              Expanded(
                child: Text(
                  "Lipid Profile",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.info_outline, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Total cholesterol, HDL, LDL, VLDL and Triglycerides.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.restaurant, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                "12 hrs fasting required",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "₹602",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primary),
                  ),
                  Text(
                    "Incl. ₹2 platform fee",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _diabetesScreeningCard() {
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
          Row(
            children: const [
              Expanded(
                child: Text(
                  "Diabetes Screening",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.info_outline, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "HbA1c and Blood Sugar (Fasting).",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "₹552",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primary),
                  ),
                  Text(
                    "Incl. ₹2 platform fee",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
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
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
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
              /// LEFT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "1 Test Added",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "₹452",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "₹600",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// RIGHT BUTTON
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
}
class _statCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _statCard(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
