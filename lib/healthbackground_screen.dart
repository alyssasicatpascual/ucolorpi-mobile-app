import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import 'homepage.dart';
import 'auth.dart';

class HealthBackgroundScreen extends StatefulWidget {
  final Map<String, dynamic> profile;
  const HealthBackgroundScreen({super.key, required this.profile});

  @override
  State<HealthBackgroundScreen> createState() => _HealthBackgroundScreenState();
}

class _HealthBackgroundScreenState extends State<HealthBackgroundScreen> {
  final fieldFill = const Color(0xFFEFFCFB);
  final primary1 = const Color(0xFF00BBD3);

  final TextEditingController prevDiagController = TextEditingController();
  final TextEditingController lastDiagController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();

  final Map<String, bool> conditions = {
    'diabetes': false,
    'hypertension': false,
    'kidney stone': false,
    'uti': false,
    'others': false,
  };
  final TextEditingController otherController = TextEditingController();

  @override
  void dispose() {
    prevDiagController.dispose();
    lastDiagController.dispose();
    medicationController.dispose();
    doctorController.dispose();
    otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)],
              ),
            ),
            child: SafeArea(
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
                      'Health Background',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  const Text('Previous Diagnosis', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: prevDiagController,
                    decoration: InputDecoration(
                      hintText: 'e.g. kidney stone, uti, hypertension',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text('Date Of Last Diagnosis', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: lastDiagController,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        lastDiagController.text = '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'DD / MM /YYYY',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text('Current medication', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: medicationController,
                    decoration: InputDecoration(
                      hintText: 'e.g. uricare',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text('Existing Condition', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: fieldFill, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: conditions.keys.map((k) {
                        if (k == 'others') {
                          return Row(
                            children: [
                              Checkbox(value: conditions[k], onChanged: (v) => setState(() => conditions[k] = v ?? false)),
                              const SizedBox(width: 6),
                              const Text('others:', style: TextStyle(color: Color(0xFF00BBD3))),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: otherController,
                                  decoration: InputDecoration(
                                    hintText: 'specify',
                                    hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                                    filled: true,
                                    fillColor: fieldFill,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Checkbox(value: conditions[k], onChanged: (v) => setState(() => conditions[k] = v ?? false)),
                            const SizedBox(width: 6),
                            Expanded(child: Text(k, style: const TextStyle(color: Color(0xFF00BBD3)))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text('Doctor/Clinic Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: doctorController,
                    decoration: InputDecoration(
                      hintText: 'Dr. Em',
                      hintStyle: const TextStyle(color: Color(0xFF88D6D9)),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Center(
                    child: Text('By continuing, you agree to\nTerms of Use and Privacy Policy.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),

                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () async {
                      // Create Firebase user and save profile + health data to Firestore
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        final auth = Auth();
                        final credential = await auth.createUserWithEmailAndPassword(
                          email: widget.profile['email'],
                          password: widget.profile['password'],
                          fullName: widget.profile['fullName'],
                        );

                        final uid = credential.user?.uid;
                        if (uid == null) throw Exception('Failed to obtain uid');

                        final Map<String, bool> cond = Map.from(conditions);
                        final Map<String, dynamic> existingMap = {};
                        cond.forEach((k, v) {
                          if (k == 'others') {
                            existingMap[k] = v ? otherController.text.trim() : '';
                          } else {
                            existingMap[k] = v;
                          }
                        });

                        final data = {
                          'fullName': widget.profile['fullName'],
                          'dateOfBirth': widget.profile['dateOfBirth'],
                          'sex': widget.profile['sex'],
                          'email': widget.profile['email'],
                          'previousDiagnosis': prevDiagController.text.trim(),
                          'lastDiagnosisDate': lastDiagController.text.trim(),
                          'currentMedication': medicationController.text.trim(),
                          'existingConditions': existingMap,
                          'doctorName': doctorController.text.trim(),
                          'createdAt': FieldValue.serverTimestamp(),
                        };

                        await FirebaseFirestore.instance.collection('users').doc(uid).set(data);

                        Navigator.of(context).pop(); // dismiss loading
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage(isReturningUser: false)));
                      } on FirebaseAuthException catch (e) {
                        Navigator.of(context).pop();
                        if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email already in use. Please log in or use another email.')));
                        } else if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password is too weak.')));
                        } else if (e.code == 'invalid-email') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email address.')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed: ${e.message ?? e.toString()}')));
                        }
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
                        gradient: const LinearGradient(colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)]),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: primary1.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 6))],
                      ),
                      child: const Center(child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('already have an account? ', style: TextStyle(color: Colors.black54)),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInScreen())),
                          child: const Text('Log in', style: TextStyle(color: Color(0xFF00BBD3))),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
