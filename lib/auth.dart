import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // ===================== LOGIN =====================
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ===================== SIGN UP =====================
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    // FIX: Added parameters for Sex and DOB
    required String? sex,
    required String dateOfBirth,
  }) async {
    // 1. Create the user in Firebase Authentication
    final UserCredential credential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Save extended user info in Firestore using the new UID
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'fullName': fullName,
      'email': email,
      // Save the new fields (with a default fallback just in case)
      'sex': sex ?? 'Not Specified',
      'dateOfBirth': dateOfBirth,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 3. Optional: Update the basic display name on the Auth object immediately
    await credential.user?.updateDisplayName(fullName);

    return credential;
  }

  // ===================== LOGOUT =====================
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}