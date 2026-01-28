import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

void main() {
  runApp(const LabReportApp());
}

class LabReportApp extends StatelessWidget {
  const LabReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        brightness: Brightness.light,
        primaryColor: const Color(0xFF13EC5B),
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF13EC5B),
        scaffoldBackgroundColor: const Color(0xFF102216),
      ),
      home: const LabReportPage(),
    );
  }
}

class LabReportPage extends StatefulWidget {
  const LabReportPage({super.key});

  @override
  State<LabReportPage> createState() => _LabReportPageState();
}

class _LabReportPageState extends State<LabReportPage> {
  String selectedStatus = 'Draft'; // default selected status

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable content
            ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                // Top App Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withAlpha(230),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.arrow_back_ios,
                            color: isDark ? Colors.white : Colors.black),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Report #LAB-8829',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.red, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(
                                color: Color(0xFF13EC5B),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // Status Selector
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              _buildStatusButton('Draft', isDark),
                              _buildStatusButton('Submitted', isDark),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Patient Card
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PATIENT INFORMATION',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF13EC5B),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Ronald Richards',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Male, 42 years • ID: P-9921',
                                style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      size: 14,
                                      color: isDark ? Colors.grey[400] : Colors.grey),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Collected: Oct 24, 2023',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAQJIqkFidE0R6lXzBBDOms5DJ6QkFqjKj_NoN6ivZ2_ccTKLWiUDccxLXWffyL-ZxgHb4Yrlr7iNxyRI22FNOjN0vlDpR3YHwuC6Y6v2jBB1PYNrIWjLm6tocXu5RWPkGywtLAaY0WVlrrzH7l5rEVhUUpbqfO5BosbY2pxDgzXGqndhNmdjy9A7XWWWqwYaYOZmtjPZYh1sAmyxS9otq71c5Byp7suiLKMA6v_rPpa9AA0Eb5hFqQh9jQlA5OxpZqPpUrTu--hW9B'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: const Color(0xFF13EC5B).withAlpha(51),
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Test Parameters Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Test Parameters',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF13EC5B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '3 Tests',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF13EC5B),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Test Results with divider
                Column(
                  children: [
                    _TestResultItem(
                      name: 'Hemoglobin (Hb)',
                      reference: 'Ref: 13.5 - 17.5 g/dL',
                      value: '14.2 g/dL',
                      status: 'Normal',
                      icon: Icons.biotech,
                      color: const Color(0xFF13EC5B),
                      valueColor: Colors.black,
                    ),
                    Divider(color: Colors.grey.shade300, height: 1),
                    _TestResultItem(
                      name: 'Glucose (Fasting)',
                      reference: 'Ref: 70 - 99 mg/dL',
                      value: '126 mg/dL',
                      status: 'High',
                      icon: Icons.warning_amber,
                      color: Colors.red,
                      valueColor: Colors.red,
                    ),
                    Divider(color: Colors.grey.shade300, height: 1),
                    _TestResultItem(
                      name: 'Platelet Count',
                      reference: 'Ref: 150 - 450 x10³/µL',
                      value: '210 x10³/µL',
                      status: 'Normal',
                      icon: Icons.opacity,
                      color: const Color(0xFF13EC5B),
                      valueColor: Colors.black,
                    ),
                  ],
                ),

                // Technician Notes
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Technician Remarks',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? Colors.grey[900] : Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                              )),
                          hintText:
                          'Enter additional clinical observations or notes here...',
                        ),
                        controller: TextEditingController(
                            text:
                            'Patient shows slightly elevated fasting glucose. Recommended follow-up HbA1c test for confirmation. Other blood parameters are within healthy range.'),
                      )
                    ],
                  ),
                ),


                // Digital Signature
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      padding: EdgeInsets.zero,
                      dashPattern: const [6, 4],
                      strokeWidth: 1.5,
                      color: isDark ? Colors.grey.shade900 : Colors.grey.shade500,
                      radius: const Radius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[900]!.withAlpha(128)
                            : Colors.white.withAlpha(128),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center, // <-- vertically center content
                        children: [
                          const Text(
                            'DIGITAL SIGNATURE VERIFIED',
                            style: TextStyle(
                                fontSize: 10, letterSpacing: 2, color: Colors.grey),
                            textAlign: TextAlign.center, // <-- horizontally center text
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              width: 192,
                              height: 64,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCfgno67jtP8fTn76Qq_OYwW1x5MkUC19Sd2Vh7LlohxsAU2whQVJSqa-4xE7oA7S665YMBOzi5HIA0lkUfhVoAPXVIo4j7ZpP2-HAH_a1hJDbTtTZS07GduGOSiM1iAbqwTkkWtCvvWdCkHiOwd99_G8TecwZ8lAhXNWxOQddfa_pLuTwWG-L4JWoe86KNKr5ifJg7_kWPP8MTwBA6NztBQivgn-IAEsdvPJyfhc4yJFotUdtpHppFgIpNHcay7LSFl2XlLkl7cId2'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Dr. Sarah Jenkins, MD',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'Chief Pathologist • Reg #882910',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),

      // Bottom Submit Button (outside ListView)
            // Bottom Submit Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withAlpha(245),
                child: ElevatedButton.icon(
                  onPressed: selectedStatus == 'Submitted'
                      ? null
                      : () {
                    setState(() {
                      selectedStatus = 'Submitted';
                    });
                  },
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'Submit Report to Patient',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13EC5B),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Status Button
  Widget _buildStatusButton(String label, bool isDark) {
    bool isSelected = selectedStatus == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedStatus = label;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.grey[700] : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Test Result Item Widget
class _TestResultItem extends StatelessWidget {
  final String name, reference, value, status;
  final IconData icon;
  final Color color;
  final Color valueColor;

  const _TestResultItem({
    super.key,
    required this.name,
    required this.reference,
    required this.value,
    required this.status,
    required this.icon,
    required this.color,
    this.valueColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? Colors.grey[900] : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    reference,
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: valueColor, fontSize: 16),
              ),
              Text(
                status,
                style: TextStyle(fontSize: 12, color: color),
              ),
            ],
          )
        ],
      ),
    );
  }
}
