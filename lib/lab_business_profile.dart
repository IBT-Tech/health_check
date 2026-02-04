import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

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

  Map<String, dynamic>? data;
  Map<String, dynamic>? profile;
  Map<String, dynamic>? verification;
  Map<String, dynamic>? location;

  late TextEditingController labName;
  late TextEditingController license;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;

  List uploadedFiles = [];
  List<PlatformFile> newFiles = [];

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final jsonStr = await rootBundle.loadString("assets/all.json");
    final jsonData = json.decode(jsonStr);

    setState(() {
      profile = jsonData['lab_business_profile'] ?? {};

      data = profile;

      labName = TextEditingController(
          text: profile?['basicInfo']?['labName'] ?? '');
      license = TextEditingController(
          text: profile?['basicInfo']?['license'] ?? '');
      email = TextEditingController(
          text: profile?['contactDetails']?['email'] ?? '');
      phone = TextEditingController(
          text: profile?['contactDetails']?['phone'] ?? '');
      address = TextEditingController(
          text: profile?['location']?['address'] ?? '');

      verification = profile?['verification'] ?? {};
      uploadedFiles = verification?['files'] ?? [];
      location = profile?['location'] ?? {};
    });
  }

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
        newFiles.add(file);
      });
    }
  }

  void saveProfile() {
    if (labName.text.isEmpty || license.text.isEmpty || email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Business Profile Saved Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
              input("Business Email", email),
              input("Phone Number", phone),

              section("Location"),
              textarea("Full Address", address),

              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      /// Map Image
                      Image.network(
                        location?['mapImage'] ?? '',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      /// Black overlay (bg-black/10)
                      Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.1),
                      ),

                      /// Adjust Pin Button
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Open map / adjust pin logic
                          },
                          icon: const Icon(
                            Icons.location_on,
                            size: 18,
                            color: primary,
                          ),
                          label: const Text(
                            "Adjust Pin",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 6,
                            padding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // section on left, count on right
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Section Title
                    Text(
                      "Verification & Licenses",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Uploaded Count Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13EC5B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${uploadedFiles.length}/${verification?['total'] ?? 0} Uploaded",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🟢 ADD THIS BLOCK HERE 👇 (IMPORTANT)
              if (uploadedFiles.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center( // optional: center the wider box
                    child: SizedBox(
                      width: 800, // <-- increase width as needed
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: primary.withOpacity(0.4),
                            width: 2,
                          ),
                          color: primary.withOpacity(0.05),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.upload_file,
                                size: 32,
                                color: primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Upload New Certification",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "PDF, JPG or PNG (Max 10MB)",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: pickFile, // 🔥 connects file picker
                              child: const Text(
                                "Browse Files",
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ...uploadedFiles.map<Widget>((file) {
                final isPdf = file['type'] == 'pdf';
                return Container(
                  width: double.infinity, // card will take full available width
                  margin: const EdgeInsets.symmetric(vertical: 4), // optional spacing
                  child: uploadedFileCard(
                    fileIcon: isPdf ? Icons.picture_as_pdf : Icons.image_outlined,
                    fileIconColor: isPdf ? Colors.red : Colors.blue,
                    fileName: file['name'] ?? '',
                    statusText: "${file['status']} • ${file['sizeMB']} MB",
                    statusIcon: file['status'] == 'Verified'
                        ? Icons.check_circle_outline
                        : Icons.schedule,
                    statusColor: file['status'] == 'Verified'
                        ? Colors.green
                        : Colors.orange,
                  ),
                );
              }).toList(),


              verificationInfoBox(),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.black, // <-- makes text white
            minimumSize: const Size.fromHeight(56),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    child: Text(title,
        style:
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget input(String label, TextEditingController c) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300, // normal state
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: primary, // 👈 GREEN border on tap
                width: 2,
              ),
            ),
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
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300, // normal
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _LabBusinessProfileState.primary, // 🟢 green on tap
                width: 2,
              ),
            ),
          ),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                  Text(fileName,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(statusText,
                      style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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

Widget verificationInfoBox() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.verified_user_outlined, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Verification increases your lab's visibility and builds trust.",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
}
