import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateTestReportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// ---------- TITLE ----------
              pw.Center(
                child: pw.Text(
                  "Test Report",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
              pw.SizedBox(height: 16), // spacing after title

              /// ---------- HEADER ----------
              pw.Text(
                "City Diagnostic Center",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text("123 Medical Drive, Health City"),
              pw.Text("ACCREDITED: NABL / CAP"),
              pw.SizedBox(height: 16),

              /// ---------- PATIENT INFO ----------
              _infoRow("Patient Name", "Johnathan Doe"),
              _infoRow("Age / Gender", "32 / Male"),
              _infoRow("Collection Date", "Oct 24, 2023"),
              _infoRow("Report ID", "REF-987654321"),

              pw.Divider(height: 24),

              /// ---------- TABLE HEADER ----------
              pw.Text(
                "Metabolic Panel",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              _tableHeader(),
              _tableRow("Hemoglobin", "14.2 g/dL", "13.5 - 17.5"),
              _tableRow("Glucose (Fasting)", "110 mg/dL", "70 - 100", status: "HIGH"),
              _tableRow("Creatinine", "0.9 mg/dL", "0.7 - 1.3"),
              _tableRow("Vitamin D", "18 ng/mL", "30 - 100", status: "DEFICIENT"),

              pw.SizedBox(height: 20),

              /// ---------- IMPRESSION ----------
              pw.Text(
                "Pathologist's Impression",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                "Fasting blood glucose is slightly elevated. "
                    "Vitamin D deficiency noted. Please consult your physician.",
              ),

              pw.SizedBox(height: 16),
              pw.Text("Dr. Sarah Jenkins"),
              pw.Text("MD, Consultant Pathologist"),
            ],
          );
        },
      ),
    );

    /// ---------- SAVE + OPEN ----------
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/test_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

  }

  /// ---------- HELPERS ----------

  static pw.Widget _infoRow(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }

  static pw.Widget _tableHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text("TEST NAME", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Expanded(child: pw.Text("RESULT", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Expanded(child: pw.Text("REFERENCE", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        ],
      ),
    );
  }

  static pw.Widget _tableRow(
      String name,
      String result,
      String reference, {
        String? status,
      }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(name),
                if (status != null)
                  pw.Text(
                    status,
                    style: pw.TextStyle(
                      color: PdfColors.red,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Text(result, textAlign: pw.TextAlign.right),
          ),
          pw.Expanded(
            child: pw.Text(reference, textAlign: pw.TextAlign.right),
          ),
        ],
      ),
    );
  }
}
