import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mockData.dart';
import 'fullReport.dart';
import 'A_NewScan.dart';
import 'recordHistory.dart';
import 'settings_screen/settingMain.dart';

class HomePage extends StatefulWidget {
  final bool isReturningUser;
  const HomePage({super.key, this.isReturningUser = true});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum HealthStatus { normal, attention, abnormal }

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  int navIndex = 0;
  String? _fullName;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSubscription;

  @override
  void initState() {
    super.initState();
    // initial load and keep in sync when auth state changes
    _loadFullName();
    // Attach real-time listener to the user's document so UI updates when profile changes
    _attachUserDocListener(FirebaseAuth.instance.currentUser);
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _loadFullName(user);
      _attachUserDocListener(user);
    });
  }

  Future<void> _loadFullName([User? user]) async {
    try {
      final u = user ?? FirebaseAuth.instance.currentUser;
      if (u == null) {
        if (mounted) setState(() => _fullName = null);
        return;
      }
      final doc = await FirebaseFirestore.instance.collection('users').doc(u.uid).get();
      final name = doc.data()?['fullName'] as String?;
      if (mounted) setState(() => _fullName = name ?? u.email);
    } catch (_) {
      // ignore errors and keep default
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _userDocSubscription?.cancel();
    super.dispose();
  }

  void _attachUserDocListener(User? user) {
    _userDocSubscription?.cancel();
    if (user == null) return;
    _userDocSubscription = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots().listen((doc) {
      final name = doc.data()?['fullName'] as String?;
      if (mounted) setState(() => _fullName = name ?? 'User');
    }, onError: (_) {
      // ignore
    });
  }

  // Device connection state: false by default. When true, UI shows Connected and button becomes 'Start a New Scan'.
  bool deviceConnected = false;
  bool isConnecting = false;

  // Hover/tap status info overlay
  OverlayEntry? _statusInfoOverlay;
  final GlobalKey _infoKey = GlobalKey();

  static const bgColor = Color(0xFFF2F2F7);
  static const gradientStart = Color(0xFF33E4DB);
  static const gradientEnd = Color(0xFF00BBD3);

  HealthStatus evaluate(UrinalysisRecord r) {
    int outOfRange = 0;

    // ph healthy when exactly 7.0
    final ph = double.tryParse(r.ph) ?? 0.0;
    if (ph != 7.0) outOfRange++;

    // specific gravity healthy between 1.005 and 1.030 inclusive
    final sg = double.tryParse(r.specificGravity) ?? 0.0;
    if (!(sg >= 1.005 && sg <= 1.030)) outOfRange++;

    // other chemical parameters should be "Negative"
    final chemicals = [
      r.glucose,
      r.blood,
      r.ketone,
      r.protein,
      r.urobilinogen,
      r.bilirubin,
      r.leukocyte,
      r.nitrite,
    ];

    for (var v in chemicals) {
      if (v.toLowerCase() != 'negative') outOfRange++;
    }

    if (outOfRange == 0) return HealthStatus.normal;
    if (outOfRange <= 2) return HealthStatus.attention;
    return HealthStatus.abnormal;
  }

  Color statusColor(HealthStatus s) {
    switch (s) {
      case HealthStatus.normal:
        return Colors.green;
      case HealthStatus.attention:
        return const Color(0xFFFF8B00);
      case HealthStatus.abnormal:
        return const Color(0xFFFF0004);
    }
  }

  String statusText(HealthStatus s) {
    switch (s) {
      case HealthStatus.normal:
        return 'Normal';
      case HealthStatus.attention:
        return 'Attention';
      case HealthStatus.abnormal:
        return 'Abnormal';
    }
  }

  void prev() {
    setState(() {
      currentIndex = (currentIndex - 1) % mockUrinalysisRecords.length;
      if (currentIndex < 0) currentIndex += mockUrinalysisRecords.length;
    });
  }

  void next() {
    setState(() {
      currentIndex = (currentIndex + 1) % mockUrinalysisRecords.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final record = mockUrinalysisRecords[currentIndex];
    final status = evaluate(record);

    final Widget homeContent = Column(
      children: [
        // top area (same spacing as provided mock)
        Container(
          width: double.infinity,
          // more top spacing, less bottom spacing
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 6),
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: widget.isReturningUser ? 'Welcome back, ' : 'Welcome, ', style: const TextStyle(color: Color(0xFF33E4DB), fontSize: 20, fontWeight: FontWeight.w700)),
                    TextSpan(text: _fullName ?? 'Jane Doe', style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              const Text('UCOLORPI Device', style: TextStyle(color: Color(0xFF33E4DB), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Status: ', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 6),
                      Text(
                        deviceConnected ? 'Connected' : (isConnecting ? 'Connecting...' : 'Disconnected'),
                        style: TextStyle(
                          color: deviceConnected ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: isConnecting
                        ? null
                        : () async {
                            if (!deviceConnected) {
                              setState(() => isConnecting = true);
                              // Simulate a connection attempt. Replace with real device discovery/connect logic later.
                              await Future.delayed(const Duration(seconds: 2));
                              setState(() {
                                isConnecting = false;
                                deviceConnected = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Device connected')));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ANewScanScreen()));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gradientEnd,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                    ),
                    child: isConnecting
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                              SizedBox(width: 10),
                              Text('Connecting...'),
                            ],
                          )
                        : Text(deviceConnected ? 'Start a New Scan' : 'Connect Device'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // middle gradient summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [gradientStart, gradientEnd]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: prev,
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Quick Summary Of Previous Test', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.95), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white54)),
                          child: Text('${_formatDate(record.date)}', style: const TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: next,
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Card with results
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Result: ', style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Icon(Icons.circle, color: statusColor(status), size: 12),
                                const SizedBox(width: 6),
                                Text(statusText(status), style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => FullReportPage(record: record)));
                          },
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), minimumSize: const Size(0, 28), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: const Text('View full result', style: TextStyle(color: Colors.white, fontSize: 13)),
                        )
                      ],
                    ),

                    const SizedBox(height: 8),

                    // results list
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(child: Text('Component', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Result', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 6),
                          _resultRow('Ph', record.ph),
                          const SizedBox(height: 6),
                          _resultRow('Specific Gravity', record.specificGravity),
                          const SizedBox(height: 6),
                          _resultRow('Glucose', record.glucose),
                          const SizedBox(height: 6),
                          _resultRow('Blood', record.blood),
                          const SizedBox(height: 6),
                          _resultRow('Ketone', record.ketone),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),

        // Quick health tips section
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      const Text('Quick Health Tips', style: TextStyle(color: Color(0xFF00BBD3), fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Text('Result: ', style: TextStyle(color: Colors.black54)),
                      Icon(Icons.circle, color: statusColor(status), size: 12),
                      const SizedBox(width: 6),
                      Text(statusText(status), style: const TextStyle(fontWeight: FontWeight.w600)),
                      MouseRegion(
                        key: _infoKey,
                        onEnter: (_) => _showStatusInfoOverlay(),
                        onExit: (_) => _hideStatusInfoOverlay(),
                        child: GestureDetector(
                          onTap: () {
                            // Fallback for touch devices: show dialog with same content
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: _statusInfoContent(),
                              ),
                            );
                          },
                          child: const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tip content
                  Text(_tipForStatus(status), style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 12),
                  Text('Next Step:', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  const Text('Perform Another Test Within 7 Days To Maintain Monitoring Consistency.', softWrap: true, style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: bgColor,
      // show Record or Settings depending on nav index
      body: navIndex == 1 ? const RecordHistoryPage() : (navIndex == 2 ? const SettingsMain() : homeContent),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFFFFF),
        selectedItemColor: const Color(0xFF39E8DB),
        unselectedItemColor: const Color(0xFF39E8DB),
        selectedIconTheme: const IconThemeData(color: Color(0xFF39E8DB), size: 22),
        unselectedIconTheme: const IconThemeData(color: Color(0xFF39E8DB), size: 20),
        showUnselectedLabels: true,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        currentIndex: navIndex,
        onTap: (i) => setState(() { navIndex = i; }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Record'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _resultRow(String component, String value) {
    return Row(
      children: [
        Expanded(child: Text(component, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60))),
        Expanded(child: Text(value, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
      ],
    );
  }

  void _showStatusInfoOverlay() {
    if (_statusInfoOverlay != null) return;
    final renderBox = _infoKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _statusInfoOverlay = OverlayEntry(builder: (context) {
      final double width = 320.0;
      double left = (offset.dx + size.width / 2) - width / 2;
      if (left < 8) left = 8;
      return Positioned(
        top: offset.dy + size.height + 8,
        left: left,
        width: width,
        child: Material(
          color: Colors.transparent,
          child: MouseRegion(
            onExit: (_) => _hideStatusInfoOverlay(),
            child: _statusInfoContent(),
          ),
        ),
      );
    });

    Overlay.of(context).insert(_statusInfoOverlay!);
  }

  void _hideStatusInfoOverlay() {
    _statusInfoOverlay?.remove();
    _statusInfoOverlay = null;
  }

  Widget _statusInfoContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(Icons.info, color: Color(0xFF2BBDC7), size: 18),
              SizedBox(width: 8),
              Text('RESULT STATUS INFO', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          _statusRow(Colors.green, 'NORMAL STATUS', 'All parameters are within the healthy range. No signs of infection, glucose, or protein detected.'),
          const SizedBox(height: 8),
          _statusRow(Color(0xFFFF8B00), 'ATTENTION STATUS', 'One or more readings are slightly outside normal. Re-test or monitor in the next 24 hours.'),
          const SizedBox(height: 8),
          _statusRow(Color(0xFFFF0004), 'ABNORMAL STATUS', 'Critical values detected. Consult your doctor.'),
        ],
      ),
    );
  }

  Widget _statusRow(Color color, String title, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle, color: color, size: 12),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatDate(DateTime d) {
    // Example: OCTOBER 28, 2025
    final month = _monthNames[d.month - 1].toUpperCase();
    return '$month ${d.day}, ${d.year}';
  }

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String _tipForStatus(HealthStatus s) {
    switch (s) {
      case HealthStatus.normal:
        return 'Your Readings Look Healthy! Keep Drinking Water Regularly.';
      case HealthStatus.attention:
        return 'There are minor deviations. Consider repeating test and consult a clinician if it persists.';
      case HealthStatus.abnormal:
        return 'Multiple parameters are outside the normal range. Please consult a healthcare professional.';
    }
  }
}
