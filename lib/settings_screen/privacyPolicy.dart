import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BBD3),
        elevation: 0,
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            const Text('Effective Date: January 2026', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text('This Privacy Policy explains how U-COLORPI collects, uses, and protects user information. This application is developed for academic and research purposes only and is not intended to replace professional medical diagnosis or treatment.', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 14),
            
            const Text('1. Information We Collect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
            const SizedBox(height: 6),
            const Text('When you create an account, the application may collect:\n- Basic account information (name, email)\n- Urinalysis scan results\n- Application usage data', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 12),
            
            const Text('2. Purpose of Data Collection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            const Text('Data is used to:\n- Store and display results\n- Support academic research\n- Improve app functionality', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 12),
            
            const Text('3. Result Interpretation Disclaimer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            const Text('Results are reference-based for informational purposes only. The app does not provide medical diagnoses or treatment recommendations.', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 12),
            
            const Text('4. Data Protection and Security', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            const Text('Data is protected against unauthorized access. Access is limited to authorized researchers.', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 12),
            
            const Text('5. Data Sharing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            const Text('User information is not shared with third parties. Data is accessed only for academic evaluation.', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 12),
            
            const Text('6. User Consent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            const Text('By creating an account, you confirm you have read this policy and consent to data collection.', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 12),
            
            const Text('7. Legal Compliance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            const Text('This app follows the Data Privacy Act of 2012 (Republic Act No. 10173).', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 12),
            
            const Text('8. Contact Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            const Text('For questions: alyssasicatpascual@gmail.com', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

