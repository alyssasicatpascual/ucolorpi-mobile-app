import 'package:flutter/material.dart';
import 'mockData.dart'; // Ensure this file exists
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Using the printing package

class FullReportPage extends StatelessWidget {
  final UrinalysisRecord record;
  const FullReportPage({Key? key, required this.record}) : super(key: key);

  String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    String status() {
      int outOfRange = 0;
      final ph = double.tryParse(record.ph) ?? 0.0;
      if (ph != 7.0) outOfRange++;
      final sg = double.tryParse(record.specificGravity) ?? 0.0;
      if (!(sg >= 1.005 && sg <= 1.030)) outOfRange++;
      final chemicals = [record.glucose, record.blood, record.ketone, record.protein, record.urobilinogen, record.bilirubin, record.leukocyte, record.nitrite];
      for (var v in chemicals) if (v.toLowerCase() != 'negative') outOfRange++;
      if (outOfRange == 0) return 'Normal';
      if (outOfRange <= 2) return 'Attention';
      return 'Abnormal';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: Column(
        children: [
          // 1. MERGED HEADER (Back button is now inside the gradient)
          Container(
            width: double.infinity,
            // Add padding for the status bar
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10, 
              bottom: 20,
              left: 10,
              right: 10
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter, 
                colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)]
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Back Button (Aligned Left)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                // Title Info (Centered)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('FULL REPORT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('DATE: ${_formatDate(record.date)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(generateRecordId(record, mockUrinalysisRecords), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                // Ensure bottom padding for Navigation Bar
                padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  children: [
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: const [
                                Expanded(child: Text('Component', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))),
                                Expanded(child: Text('Result', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))),
                                Expanded(child: Text('Reference', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(height: 6),
                            _row('Ph', record.ph, '5.0-8.0'),
                            const SizedBox(height: 8),
                            _row('Specific Gravity', record.specificGravity, '1.005-1.030'),
                            const SizedBox(height: 8),
                            _row('Glucose', record.glucose, 'Negative'),
                            const SizedBox(height: 8),
                            _row('Blood', record.blood, 'Negative'),
                            const SizedBox(height: 8),
                            _row('Ketone', record.ketone, 'Negative'),
                            const SizedBox(height: 8),
                            _row('Protein', record.protein, 'Negative'),
                            const SizedBox(height: 8),
                            _row('Urobilinogen', record.urobilinogen, 'Negative'),
                            const SizedBox(height: 8),
                            _row('Bilirubin', record.bilirubin, 'Negative'),
                            const SizedBox(height: 8),
                            _row('Leukocyte', record.leukocyte, 'Negative'),
                            const SizedBox(height: 8),
                            _row('Nitrite', record.nitrite, 'Negative'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Remarks:', style: TextStyle(color: Colors.black54)),
                          const SizedBox(height: 6),
                          Text(status() == 'Normal' ? 'Overall Result Is Within Normal Range.' : 'Please consult a healthcare professional for abnormal results.'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          Container(width: 6, height: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(text: 'NOTE: ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                                  TextSpan(text: 'The Reference Column Indicates The Normal Or Expected Range For Each Urine Test Parameter.', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          await _downloadPDF(context);
                        },
                        child: Container(
                          height: 44,
                          width: 220,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)]),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [BoxShadow(color: const Color(0xFF00BBD3).withOpacity(0.18), blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: const Center(child: Text('Download PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],      
        ),
    );
  }

  Widget _row(String label, String value, String reference) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: Colors.black54))),
        Expanded(child: Text(value, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(reference, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)))
      ],
    );
  }

  // UPDATED: Now uses Printing package to save to public Downloads/Files
  Future<void> _downloadPDF(BuildContext context) async {
    try {
      final pdf = pw.Document();
      final recordId = generateRecordId(record, mockUrinalysisRecords);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(child: pw.Text('U-COLORPI URINALYSIS REPORT', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 10),
                pw.Center(child: pw.Text('Date: ${_formatDate(record.date)}', style: const pw.TextStyle(fontSize: 12))),
                pw.Center(child: pw.Text('Report ID: $recordId', style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(height: 20),
                pw.Text('TEST RESULTS', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  headers: ['Component', 'Result', 'Reference Range'],
                  data: [
                    ['pH', record.ph, '5.0-8.0'],
                    ['Specific Gravity', record.specificGravity, '1.005-1.030'],
                    ['Glucose', record.glucose, 'Negative'],
                    ['Blood', record.blood, 'Negative'],
                    ['Ketone', record.ketone, 'Negative'],
                    ['Protein', record.protein, 'Negative'],
                    ['Urobilinogen', record.urobilinogen, 'Negative'],
                    ['Bilirubin', record.bilirubin, 'Negative'],
                    ['Leukocyte', record.leukocyte, 'Negative'],
                    ['Nitrite', record.nitrite, 'Negative'],
                  ],
                  border: pw.TableBorder.all(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 15),
                pw.Text('REMARKS', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text(_getStatus() == 'Normal' ? 'Overall Result Is Within Normal Range.' : 'Please consult a healthcare professional for abnormal results.', style: const pw.TextStyle(fontSize: 11)),
                pw.SizedBox(height: 15),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('IMPORTANT NOTE:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.red)),
                      pw.Text('This report is for informational purposes only. Results are reference-based and do not constitute medical diagnosis or treatment. Please consult a healthcare provider for medical concerns.', style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Generated by U-COLORPI • For Academic Research Only', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
              ],
            );
          },
        ),
      );

      // This prompts the user to save the file
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'U-COLORPI-Report-$recordId.pdf');

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
      }
    }
  }

  String _getStatus() {
    int outOfRange = 0;
    final ph = double.tryParse(record.ph) ?? 0.0;
    if (ph != 7.0) outOfRange++;
    final sg = double.tryParse(record.specificGravity) ?? 0.0;
    if (!(sg >= 1.005 && sg <= 1.030)) outOfRange++;
    final chemicals = [record.glucose, record.blood, record.ketone, record.protein, record.urobilinogen, record.bilirubin, record.leukocyte, record.nitrite];
    for (var v in chemicals) if (v.toLowerCase() != 'negative') outOfRange++;
    if (outOfRange == 0) return 'Normal';
    if (outOfRange <= 2) return 'Attention';
    return 'Abnormal';
  }
}