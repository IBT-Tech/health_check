import 'package:flutter/material.dart';

void main() {
  runApp(const UserHealthApp());
}

class UserHealthApp extends StatelessWidget {
  const UserHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCFE7D7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCFE7D7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: Color(0xFF13EC5B), width: 2),
          ),
        ),
      ),
      home: const UserHealthProfile(),
    );
  }
}

class UserHealthProfile extends StatefulWidget {
  const UserHealthProfile({super.key});

  @override
  State<UserHealthProfile> createState() => _UserHealthProfileState();
}

class _UserHealthProfileState extends State<UserHealthProfile> {
  String? gender;
  bool showAadhar = false;

  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final aadharCtrl =
  TextEditingController(text: "123456789012");
  final historyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                /// APP BAR
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back_ios_new),
                      Expanded(
                        child: Text(
                          "User Health Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 24),
                    ],
                  ),
                ),

                /// BODY
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// PRIVACY CARD
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF13EC5B)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFF13EC5B)
                                    .withOpacity(0.2)),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.verified_user,
                                  color: Colors.green),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Data Privacy Guaranteed",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Your medical data is encrypted using AES-256 standards and shared only with certified pathologists.",
                                      style:
                                      TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        _title("Personal Metrics"),

                        _dropdown(
                          label: "Gender",
                          value: gender,
                          items: const [
                            DropdownMenuItem(
                                value: "male",
                                child: Text("Male")),
                            DropdownMenuItem(
                                value: "female",
                                child: Text("Female")),
                            DropdownMenuItem(
                                value: "other",
                                child: Text("Other")),
                            DropdownMenuItem(
                                value: "na",
                                child: Text("Prefer not to say")),
                          ],
                          onChanged: (v) =>
                              setState(() => gender = v),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _field(
                                  label: "Height (cm)",
                                  ctrl: heightCtrl,
                                  hint: "175",
                                  type: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _field(
                                  label: "Weight (kg)",
                                  ctrl: weightCtrl,
                                  hint: "70",
                                  type: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _title("Identity & Privacy"),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text("Aadhar Card Number"),
                              const SizedBox(height: 8),
                              TextField(
                                controller: aadharCtrl,
                                keyboardType:
                                TextInputType.number,
                                obscureText: !showAadhar,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(showAadhar
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () => setState(
                                            () => showAadhar =
                                        !showAadhar),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Icon(Icons.lock, size: 12),
                                  SizedBox(width: 4),
                                  Text("Securely Encrypted",
                                      style:
                                      TextStyle(fontSize: 10))
                                ],
                              )
                            ],
                          ),
                        ),

                        _title("Medical History"),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: _field(
                            label:
                            "Past Conditions (Optional)",
                            ctrl: historyCtrl,
                            max: 4,
                            hint:
                            "Chronic asthma, Gluten allergy...",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// BOTTOM BUTTON
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF13EC5B),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        // API / Save logic
                      },
                      child: const Text(
                        "Update Health Info",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(t,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _field({
    required String label,
    required TextEditingController ctrl,
    String? hint,
    int max = 1,
    TextInputType? type,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            keyboardType: type,
            maxLines: max,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      );

  Widget _dropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: value,
              items: items,
              onChanged: onChanged,
              decoration:
              const InputDecoration(hintText: "Select"),
            ),
          ],
        ),
      );
}
