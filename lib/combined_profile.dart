import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CombinedProfileApp());
}

class CombinedProfileApp extends StatelessWidget {
  const CombinedProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFEFF6F1),
      ),
      home: const CombinedProfilePage(),
    );
  }
}

class CombinedProfilePage extends StatelessWidget {
  const CombinedProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Account", icon: Icon(Icons.person)),
              Tab(text: "Health", icon: Icon(Icons.health_and_safety)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AccountView(),
            HealthView(),
          ],
        ),
      ),
    );
  }
}

const primaryGreen = Color(0xFF13EC5B);

/// ================= ACCOUNT VIEW =================
class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final picker = ImagePicker();
  File? profileImage;

  final nameCtrl = TextEditingController(text: "Dr. Jonathan Smith");
  final emailCtrl = TextEditingController(text: "j.smith@pathologylab.com");
  final phoneCtrl = TextEditingController(text: "+1 (555) 123-4567");

  Future<void> pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => profileImage = File(img.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _card(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: primaryGreen.withOpacity(.2),
                      backgroundImage:
                      profileImage != null ? FileImage(profileImage!) : null,
                      child: profileImage == null
                          ? const Icon(Icons.person, size: 56)
                          : null,
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: primaryGreen,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18),
                        onPressed: pickImage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                labeledField("Full Name", nameCtrl),
                labeledField("Email", emailCtrl),
                labeledField("Phone", phoneCtrl),

                const SizedBox(height: 12),

                _card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: primaryGreen,
                      child: Icon(Icons.lock_reset,
                          size: 18, color: Colors.black),
                    ),
                    title: const Text(
                      "Change Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                    const Text("Tap to update your account password"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Change password")),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= HEALTH VIEW =================
class HealthView extends StatefulWidget {
  const HealthView({super.key});

  @override
  State<HealthView> createState() => _HealthViewState();
}

class _HealthViewState extends State<HealthView> {
  String? gender;
  bool showAadhar = false;

  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final aadharCtrl = TextEditingController(text: "123456789012");
  final historyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Personal Metrics"),
                genderDropdown(),
                Row(
                  children: [
                    Expanded(
                      child: labeledField(
                        "Height (cm)",
                        heightCtrl,
                        hint: "175",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: labeledField(
                        "Weight (kg)",
                        weightCtrl,
                        hint: "70",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Identity & Privacy"),
                labeledField(
                  "Aadhar Number",
                  aadharCtrl,
                  obscure: !showAadhar,
                  suffix: IconButton(
                    icon: Icon(showAadhar
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => showAadhar = !showAadhar),
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(Icons.lock, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      "Encrypted & Secure",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Medical History"),
                labeledField(
                  "Past Conditions (Optional)",
                  historyCtrl,
                  max: 4,
                  hint: "Chronic asthma, Gluten allergy...",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget genderDropdown() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Gender",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: gender,
        decoration: inputDecoration(hint: "Select Gender"),
        items: const [
          DropdownMenuItem(value: "male", child: Text("Male")),
          DropdownMenuItem(value: "female", child: Text("Female")),
          DropdownMenuItem(value: "other", child: Text("Other")),
          DropdownMenuItem(value: "na", child: Text("Prefer not to say")),
        ],
        onChanged: (v) => setState(() => gender = v),
      ),
      const SizedBox(height: 12),
    ],
  );
}

/// ================= HELPERS =================

Widget sectionTitle(String t) => Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: Text(
    t,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
);

Widget sectionCard({required Widget child}) => Container(
  margin: const EdgeInsets.all(16),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.05),
        blurRadius: 10,
      ),
    ],
  ),
  child: child,
);

Widget _card({required Widget child}) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
    ],
  ),
  child: child,
);

InputDecoration inputDecoration({String? hint, Widget? suffix}) =>
    InputDecoration(
      hintText: hint,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF6F8F6),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );

Widget labeledField(
    String label,
    TextEditingController ctrl, {
      int max = 1,
      String? hint,
      bool obscure = false,
      Widget? suffix,
    }) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: max,
          obscureText: obscure,
          decoration: inputDecoration(hint: hint, suffix: suffix),
        ),
        const SizedBox(height: 12),
      ],
    );
