import 'package:flutter/material.dart';
import 'auth.dart';
import 'homepage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedPrivacy = false;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? sexValue;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primary1 = const Color(0xFF00BBD3);
    final primary2 = const Color(0xFF33E4DB);
    final fieldFill = const Color(0xFFEFFCFB);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Ensure this is true so the view resizes when keyboard opens
      resizeToAvoidBottomInset: true, 
      // 2. We remove the main Column/Expanded. 
      // Instead, the ENTIRE body is one ScrollView.
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------- HEADER (Now inside the scroll view) ----------------
            Container(
              width: double.infinity,
              // Dynamic padding for Status Bar
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 20,
                left: 10,
                right: 10,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'New Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ---------------- END HEADER ----------------

            // ---------------- FORM BODY ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  const Text('Full name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Alyssa Smith',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text('Date Of Birth', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: dobController,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(1990, 1, 1),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        dobController.text = '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'DD / MM /YYYY',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text('Sex', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: fieldFill,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: sexValue,
                      onChanged: (v) => setState(() => sexValue = v),
                      decoration: const InputDecoration(border: InputBorder.none),
                      items: ['female', 'male', 'other'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'example@gmail.com',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    // 3. Keep scrollPadding just in case
                    scrollPadding: const EdgeInsets.only(bottom: 100),
                    decoration: InputDecoration(
                      hintText: '***************',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      suffixIcon: IconButton(
                        splashRadius: 20,
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.black),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text('Confirm Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    obscureText: _obscureConfirm,
                    scrollPadding: const EdgeInsets.only(bottom: 100),
                    decoration: InputDecoration(
                      hintText: '***************',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      suffixIcon: IconButton(
                        splashRadius: 20,
                        icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: Colors.black),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatefulBuilder(
                        builder: (context, setStateInner) {
                          return Checkbox(
                            value: _acceptedPrivacy,
                            onChanged: (v) => setState(() => _acceptedPrivacy = v ?? false),
                          );
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Privacy Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              content: SingleChildScrollView(
                                child: DefaultTextStyle(
                                  style: const TextStyle(fontSize: 12, height: 1.3, color: Colors.black87),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Effective Date: January 2026\n'),
                                      SizedBox(height: 6),
                                      Text('This Privacy Policy explains how U-COLORPI collects, uses, and protects user information. This application is developed for academic and research purposes only and is not intended to replace professional medical diagnosis or treatment.'),
                                      SizedBox(height: 8),
                                      Text('1. Information We Collect\n\nWhen you create an account, the application may collect the following information:\n\nBasic account information (e.g., name, email address)\n\nUrinalysis scan results generated by the application\n\nApplication usage data for system improvement and academic evaluation'),
                                      SizedBox(height: 8),
                                      Text('2. Purpose of Data Collection\n\nThe collected information is used solely to:\n\n- Store and display urinalysis results based on standard reference values\n- Present scan results and record history for user review\n- Support system testing, evaluation, and documentation for this academic study\n- Improve the functionality, usability, and performance of the application'),
                                      SizedBox(height: 8),
                                      Text('3. Result Interpretation Disclaimer\n\nAll urinalysis results displayed in the application are reference-based and intended for informational and monitoring purposes only. The application does not provide medical diagnoses, treatment recommendations, or clinical decisions.'),
                                      SizedBox(height: 8),
                                      Text('4. Data Protection and Security\n\nReasonable technical and organizational measures are implemented to protect user data against unauthorized access, alteration, or disclosure. Access to stored data is limited to authorized users and researchers involved in this academic project.'),
                                      SizedBox(height: 8),
                                      Text('5. Data Sharing\n\nUser information is not shared with third parties. Data may only be accessed for academic evaluation and research documentation related to this study.'),
                                      SizedBox(height: 8),
                                      Text('6. User Consent\n\nBy creating an account and checking the consent box, you confirm that:\n\n- You have read and understood this Privacy Policy\n- You voluntarily provide your information\n- You consent to the collection and use of your data as described above'),
                                      SizedBox(height: 8),
                                      Text('7. Legal Compliance\n\nThis application follows the principles of the Data Privacy Act of 2012 (Republic Act No. 10173), including transparency, legitimate purpose, and proportionality.'),
                                      SizedBox(height: 8),
                                      Text('8. Contact Information\n\nFor questions or concerns regarding this Privacy Policy, please contact: Developer Contact Information alyssasicatpascual@gmail.com'),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
                              ],
                            ),
                          ),
                          child: const Text('I have read and agree to the Privacy Policy and consent to the collection and use of my data for academic and research purposes.', style: TextStyle(fontSize: 10)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () async {
                      final fullName = fullNameController.text.trim();
                      final dob = dobController.text.trim();
                      final sex = sexValue;
                      final email = emailController.text.trim();
                      final password = passwordController.text;
                      final confirm = confirmController.text;

                      if (fullName.isEmpty || dob.isEmpty || sex == null || email.isEmpty || password.isEmpty || confirm.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
                        return;
                      }

                      if (!_acceptedPrivacy) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the Privacy Policy')));
                        return;
                      }

                      if (password != confirm) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                        return;
                      }

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        final auth = Auth();
                        await auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                          fullName: fullName,
                        );

                        Navigator.of(context).pop(); // dismiss loading
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created.')));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage(isReturningUser: false)));

                      } catch (e) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed: ${e.toString()}')));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [primary2, primary1]),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: primary1.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 6))],
                      ),
                      child: const Center(
                        child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('already have an account? ', style: TextStyle(color: Colors.black54)),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Log in', style: TextStyle(color: Color(0xFF00BBD3))),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dobController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}