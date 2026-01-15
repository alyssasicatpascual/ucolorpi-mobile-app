import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BBD3),
        elevation: 0,
        title: const Text('Help & FAQ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Preparation Before Scanning', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF00BBD3))),
            const SizedBox(height: 10),
            const Text('- Wash and dry your hands properly\n- Collect fresh urine in clean container\n- Dip reagent strip for 1-2 seconds\n- Remove and tap gently\n- Place strip flat on U-COLORPI tray', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 18),

            const Text('Scanning Guidelines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF00BBD3))),
            const SizedBox(height: 10),
            const Text('- Place device on stable surface\n- Keep dipstick centered on tray\n- Avoid direct sunlight\n- Wait for green indicator light\n- Scan time: 10-15 seconds', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 18),

            const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF00BBD3))),
            const SizedBox(height: 12),

            _buildFAQItem(
              'Q: What is U-COLORPI?',
              'A: An academic research app for monitoring urinalysis results. For informational and educational purposes only.',
            ),

            _buildFAQItem(
              'Q: Can U-COLORPI diagnose medical conditions?',
              'A: No. It provides reference-based interpretation only. Always consult healthcare providers.',
            ),

            _buildFAQItem(
              'Q: How accurate is scanning?',
              'A: Accuracy depends on proper preparation, fresh samples, and correct device placement.',
            ),

            _buildFAQItem(
              'Q: Can I use expired reagent strips?',
              'A: No. Always use fresh, unexpired strips for accurate results.',
            ),

            _buildFAQItem(
              'Q: What if scan fails or shows error?',
              'A: Ensure dipstick placement, stable surface, and good lighting. Retry after proper preparation.',
            ),

            _buildFAQItem(
              'Q: How is my data protected?',
              'A: Data is securely stored and accessible only to authorized researchers per the Privacy Policy.',
            ),

            _buildFAQItem(
              'Q: Can I export or share results?',
              'A: Results are stored in your account. View them in Record History section.',
            ),

            _buildFAQItem(
              'Q: What do status indicators mean?',
              'A: Normal (all in range) | Attention (slightly outside) | Abnormal (significantly outside)',
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF00BBD3))),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
