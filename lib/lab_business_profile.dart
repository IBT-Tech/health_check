import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const LabProfileApp());
}

class LabProfileApp extends StatelessWidget {
  const LabProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LabBusinessProfile(),
    );
  }
}

class LabBusinessProfile extends StatefulWidget {
  const LabBusinessProfile({super.key});

  @override
  State<LabBusinessProfile> createState() => _LabBusinessProfileState();
}

class _LabBusinessProfileState extends State<LabBusinessProfile> {
  static const Color primary = Color(0xFF13EC5B);

  // Controllers
  final labName = TextEditingController();
  final license = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  List<Map<String, dynamic>> uploadedFiles = [];
  String pinImageUrl = "";
  String verificationInfo = "";
  int uploadedCount = 0;
  int totalCount = 0;

  // Load JSON from assets
  Future<void> loadJson() async {
    final jsonString = await rootBundle.loadString('assets/lab_profile.json');
    final data = json.decode(jsonString);

    setState(() {
      labName.text = data['labProfile']['basicInformation']['labName'];
      license.text = data['labProfile']['basicInformation']['licenseNumber'];
      email.text = data['labProfile']['contactDetails']['email'];
      phone.text = data['labProfile']['contactDetails']['phone'];
      address.text = data['labProfile']['location']['address'];
      pinImageUrl = data['labProfile']['location']['pinImageUrl'];
      verificationInfo = data['labProfile']['verificationInfo'];
      uploadedCount = data['labProfile']['verificationAndLicenses']['uploadedCount'];
      totalCount = data['labProfile']['verificationAndLicenses']['totalCount'];
      uploadedFiles = List<Map<String, dynamic>>.from(
          data['labProfile']['verificationAndLicenses']['uploadedFiles']);
    });
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  // FILE PICKER (WEB + MOBILE)
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      withData: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (file.size > 10 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${file.name} exceeds 10MB limit")),
        );
        continue;
      }

      setState(() {
        uploadedFiles.add({
          "fileName": file.name,
          "fileType": file.extension,
          "fileSizeMB": (file.size / 1024 / 1024).toStringAsFixed(2),
          "status": "Pending",
          "statusColor": "blue"
        });
      });
    }
  }

  // SAVE PROFILE
  void saveProfile() {
    if (labName.text.isEmpty || license.text.isEmpty || email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields")),
      );
      return;
    }

    debugPrint("===== LAB PROFILE DATA =====");
    debugPrint("Lab Name: ${labName.text}");
    debugPrint("License: ${license.text}");
    debugPrint("Email: ${email.text}");
    debugPrint("Phone: ${phone.text}");
    debugPrint("Address: ${address.text}");
    debugPrint("Files: ${uploadedFiles.map((e) => e['fileName']).toList()}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Business Profile Saved Successfully")),
    );
  }

  @override
  void dispose() {
    labName.dispose();
    license.dispose();
    email.dispose();
    phone.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Business Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.info_outline, color: primary),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              section("Basic Information"),
              input("Lab Name", labName),
              input("License Number", license),

              section("Contact Details"),
              input("Business Email", email, suffix: Icons.check_circle_outline),
              input("Phone Number", phone),

              section("Location"),
              textarea("Full Address", address),

              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.network(
                        pinImageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                          ),
                          onPressed: () => debugPrint("Adjust Pin clicked"),
                          icon: const Icon(Icons.location_on_outlined, color: primary, size: 20),
                          label: const Text(
                            "Adjust Pin",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Verification & Licenses
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Verification & Licenses",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$uploadedCount/$totalCount Uploaded",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Upload Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GestureDetector(
                  onTap: pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primary, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: primary.withOpacity(0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.upload_file, color: Colors.green, size: 36),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Upload New Certification",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "PDF, JPG or PNG (Max 10MB)",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Browse Files",
                          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Existing files
              ...uploadedFiles.map((file) => uploadedFileCard(
                fileIcon: file['fileType'] == 'pdf' ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
                fileIconColor: file['fileType'] == 'pdf' ? Colors.red : Colors.blue,
                fileName: file['fileName'],
                statusText: "${file['status']} • ${file['fileSizeMB']} MB",
                statusIcon: file['status'] == 'Verified'
                    ? Icons.check_circle_outline
                    : Icons.schedule,
                statusColor: file['status'] == 'Verified' ? Colors.green : Colors.orange,
              )),

              verificationInfoBox(verificationInfo),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: saveProfile,
          child: const Text(
            "Save Business Profile",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget section(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget input(String label, TextEditingController c, {IconData? suffix}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          decoration: InputDecoration(
            suffixIcon: suffix != null ? Icon(suffix, color: primary) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    ),
  );

  Widget textarea(String label, TextEditingController c) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          maxLines: 4,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ],
    ),
  );
}

Widget uploadedFileCard({
  required IconData fileIcon,
  required Color fileIconColor,
  required String fileName,
  required String statusText,
  required IconData statusIcon,
  required Color statusColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(fileIcon, color: fileIconColor),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fileName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(statusText, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
          Icon(statusIcon, color: statusColor),
        ],
      ),
    ),
  );
}

Widget verificationInfoBox(String info) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_outlined, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(child: Text(info, style: TextStyle(fontSize: 12, color: Colors.blue.shade800))),
        ],
      ),
    ),
  );
}
