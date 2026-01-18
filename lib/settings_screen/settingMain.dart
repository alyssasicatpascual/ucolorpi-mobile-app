import 'package:flutter/material.dart';
import '../signin_screen.dart';
import 'profile.dart';
import 'privacyPolicy.dart';
import 'help.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({Key? key}) : super(key: key);

  Widget _item(BuildContext context, IconData icon, String title, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(color: Color(0xFF33E4DB), shape: BoxShape.circle),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, color: Color(0xFF33E4DB)),
          ],
        ),
      ),
    );
  }

  void _showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                const Text('Are you sure you want to log out?', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00BBD3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF00BBD3), fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(ctx).pop(); // Close the modal first
                          
                          await FirebaseAuth.instance.signOut();
                          
                          // FIX: Check if the parent context is still valid
                          if (!context.mounted) return; 

                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignInScreen()));
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(child: Text('Yes, Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)]),
            ),
            child: const SafeArea(
              child: Center(
                child: Text('SETTINGS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _item(context, Icons.person_outline, 'Profile', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  }),

                  const Divider(),

                  _item(context, Icons.lock_outline, 'Privacy Policy', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
                  }),

                  const Divider(),

                  _item(context, Icons.help_outline, 'Help', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpScreen()));
                  }),

                  const Divider(),

                  _item(context, Icons.logout, 'Logout', () {
                    _showLogoutSheet(context);
                  }),

                  const Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}