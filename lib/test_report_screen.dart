import 'package:flutter/material.dart';
import 'pdf_service.dart';

class TestReportScreen extends StatelessWidget {
  const TestReportScreen({super.key});

  static const primaryGreen = Color(0xFF13EC5B);
  static const darkText = Color(0xFF0D1B12);
  static const mutedGreen = Color(0xFF4C9A66);
  static const borderLight = Color(0xFFcfe7d7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),

      /// ---------------- APP BAR ----------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.9),
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Test Report",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.ios_share, color: Colors.black),
          )
        ],

        // 👇 GREEN LINE BELOW APPBAR
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 0.6,
            color: Color(0xFF4C9A66), // primary green
          ),
        ),
      ),


      /// ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// -------- LAB HEADER --------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderLight),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://lh3.googleusercontent.com/aida-public/AB6AXuAYoNytu_hT_pRvulUrwFluvBYfumQePFfN-AQg1EqaBP1G0Il1X_ORMqaMoZJXpC6t6IBMCvdDNgJk7Pshg57juYybS8Mx71tADQqiSkOMt_FtSnnUs1v-eSKt7E_-_N38GNPU8CiDzdwQEPctA2s_MdalhdyaPXPD7oEIoAp_4s90TweMqZuCC9_TK9zWINr5YW8pADEByuzsp0PkxvSV9eJkUw1RiDzBdqao0fObi0hBj0VdekiNAVwuaVFKiAIFJHJPVK1dXmwa",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "City Diagnostic Center",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "123 Medical Drive, Health City",
                        style: TextStyle(
                          fontSize: 12,
                          color: mutedGreen,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "ACCREDITED: NABL / CAP",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: mutedGreen,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            /// -------- PATIENT INFO GRID --------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderLight),
              ),
              child: Column(
                children: [
                  _infoRow(
                    "Patient Name",
                    "Johnathan Doe",
                    "Collection Date",
                    "Oct 24, 2023",
                  ),

                  // 👇 GREEN LINE BETWEEN ROWS
                  const Divider(
                    height: 1,
                    thickness: 0.8,
                    color: Color(0xFF4C9A66),
                    // primary green
                    indent: 12,
                    endIndent: 12,
                  ),

                  _infoRow(
                    "Age / Gender",
                    "32 / Male",
                    "Report ID",
                    "REF-987654321",
                  ),
                ],
              ),
            ),


            /// -------- SECTION HEADER --------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Metabolic Panel",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "VERIFIED",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// -------- RESULTS TABLE --------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderLight),
              ),
              child: Column(
                children: [
                  _tableHeader(),
                  _normalRow(
                    "Hemoglobin",
                    "Method: SLS-Hemoglobin",
                    "14.2 g/dL",
                    "13.5 - 17.5",
                  ),
                  _abnormalRow(
                    "Glucose (Fasting)",
                    "HIGH",
                    Icons.error,
                    "110 mg/dL",
                    "70 - 100",
                  ),
                  _normalRow(
                    "Creatinine",
                    "Serum, Jaffe",
                    "0.9 mg/dL",
                    "0.7 - 1.3",
                  ),
                  _abnormalRow(
                    "Vitamin D",
                    "DEFICIENT",
                    Icons.warning,
                    "18 ng/mL",
                    "30 - 100",
                  ),
                ],
              ),
            ),

            /// -------- DOCTOR NOTE --------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryGreen.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// HEADER
                    const Row(
                      children: [
                        Icon(Icons.medical_services, color: primaryGreen),
                        SizedBox(width: 8),
                        Text(
                          "Pathologist's Impression",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Fasting blood glucose is slightly elevated. Vitamin D deficiency noted. "
                          "Clinical correlation with dietary habits and sun exposure is advised. "
                          "Please consult your physician for further management.",
                      style: TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    /// 👇 NAME + SIGNATURE SAME ROW
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        /// Doctor name + degree (LEFT)
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. Sarah Jenkins",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "MD, Consultant Pathologist",
                              style: TextStyle(fontSize: 11, color: mutedGreen),
                            ),
                          ],
                        ),

                        const Spacer(),

                        /// Signature (RIGHT)
                        Opacity(
                          opacity: 0.7,
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation, // grayscale
                            ),
                            child: Container(
                              width: 64,
                              height: 32,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://lh3.googleusercontent.com/aida-public/AB6AXuAuv65Nhd_gWAKMj-qda3bPc-YIuor2VQJZjLDCFFnJSR0BeZqjFcHXKKRT8QKLryGf7kx2cEhNGYewS9ANB9ZOFqBGLuDVaycRoUX_hEm02lDkoJaxkuW6SxHHkeCPlN3JrpRDnkxA6q-kcZRGIM4azrAF3dauAK1UlesFp2fn-w7pOMPh7QzmsQh2xXFJ7jM9ksGJWyIxN-qkrUSFiFED5VVtAE0oQ_1c89GmIrE8W5Rchbbuok9Ryf6NeuPX5airlfwJTq7mMbWu",
                                  ),
                                  fit: BoxFit.contain,
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// -------- DISCLAIMER --------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "This report is for diagnostic purposes only. All results should be interpreted by a qualified medical professional.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: mutedGreen,
                ),
              ),
            ),
          ],
        ),
      ),

      /// -------- BOTTOM BUTTON --------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(top: BorderSide(color: borderLight)),
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: darkText,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            await PdfService.generateTestReportPdf();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Report downloaded successfully"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.download),
          label: const Text(
            "Download Report (PDF)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// ---------------- HELPERS ----------------

  Widget _infoRow(String l1, String v1, String l2, String v2) {
    return Row(
      children: [
        _infoCell(l1, v1),
        _infoCell(l2, v2),
      ],
    );
  }

  Widget _infoCell(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: mutedGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderLight)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 6,
            child: Text("TEST NAME",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mutedGreen)),
          ),
          Expanded(
            flex: 3,
            child: Text("RESULT",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mutedGreen)),
          ),
          Expanded(
            flex: 3,
            child: Text("REFERENCE",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mutedGreen)),
          ),
        ],
      ),
    );
  }

  Widget _normalRow(
      String name, String method, String result, String ref) {
    return _baseRow(
      name,
      method,
      result,
      ref,
      bgColor: Colors.transparent,
      resultStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _abnormalRow(String name, String status, IconData icon,
      String result, String ref) {
    return _baseRow(
      name,
      status,
      result,
      ref,
      bgColor: Colors.red.withOpacity(0.05),
      resultStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
        fontStyle: FontStyle.italic,
      ),
      icon: icon,
    );
  }

  Widget _baseRow(
      String name,
      String sub,
      String result,
      String ref, {
        Color bgColor = Colors.transparent,
        TextStyle? resultStyle,
        IconData? icon,
      }) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: bgColor,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (icon != null)
                      Icon(icon, size: 14, color: Colors.red),
                    if (icon != null) const SizedBox(width: 4),
                    Text(
                      sub,
                      style: TextStyle(
                        fontSize: 11,
                        color: icon != null ? Colors.red : mutedGreen,
                        fontWeight:
                        icon != null ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(result,
                textAlign: TextAlign.right, style: resultStyle),
          ),
          Expanded(
            flex: 3,
            child: Text(ref,
                textAlign: TextAlign.right,
                style:
                const TextStyle(fontSize: 12, color: mutedGreen)),
          ),
        ],
      ),
    );
  }
}
