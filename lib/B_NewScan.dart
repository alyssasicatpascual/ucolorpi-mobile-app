import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'homepage.dart';

class BNewScanScreen extends StatefulWidget {
  const BNewScanScreen({Key? key}) : super(key: key);

  static const bgColor = Color(0xFFF2F2F7);
  static const gradientStart = Color(0xFF33E4DB);
  static const gradientEnd = Color(0xFF00BBD3);

  @override
  _BNewScanScreenState createState() => _BNewScanScreenState();
}

class _BNewScanScreenState extends State<BNewScanScreen> {
  double _progress = 0.0;
  Timer? _timer;
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    // Start scanning immediately.
    _startSimulatedProgress();
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SCAN COMPLETE!',
                style: TextStyle(
                  color: BNewScanScreen.gradientStart,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              // Wrapped in IntrinsicHeight so buttons match height
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildGradientButton('View Full Report', () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Full report not yet implemented')),
                        );
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGradientButton('Go Home', () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (route) => false,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Dynamic padding allows button to grow with text (fixes the clipping issue)
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [BNewScanScreen.gradientStart, BNewScanScreen.gradientEnd],
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _startSimulatedProgress() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (t) {
      setState(() {
        _progress += 0.02;
        if (_progress >= 1.0) {
          _progress = 1.0;
          t.cancel();
          if (!_hasShownDialog) {
            _hasShownDialog = true;
            Future.microtask(() => _showCompleteDialog());
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if finished for the text status
    final bool isCompleted = _progress >= 1.0;

    return Scaffold(
      backgroundColor: BNewScanScreen.bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // --- Top logo & status ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/images/ucolorpi_icon.svg',
                      width: 72,
                      height: 72,
                      color: BNewScanScreen.gradientStart,
                      semanticsLabel: 'UColorPi icon',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'UCOLORPI Device',
                    style: TextStyle(
                      color: Color(0xFF33E4DB),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Status: ', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        'Analyzing Dipstick',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // --- Progress card ---
            Expanded(
              child: SafeArea(
                top: false,
                bottom: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: BNewScanScreen.gradientStart,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/ucolorpi_icon.svg',
                                    width: 36,
                                    height: 36,
                                    color: Colors.white,
                                    semanticsLabel: 'UColorPi icon',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // --- Middle Text & Bar ---
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // FIX 1: Conditional text & maxLines prevents jumping/wrapping
                                    Text(
                                      isCompleted ? 'Completed' : 'Scanning in Progress...',
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: LinearProgressIndicator(
                                        value: _progress,
                                        minHeight: 8,
                                        color: BNewScanScreen.gradientStart,
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(width: 12),

                              // --- Percentage Text ---
                              // FIX 2: Fixed width SizedBox prevents layout shift when numbers grow
                              SizedBox(
                                width: 45, 
                                child: Text(
                                  '${(_progress * 100).round()}%',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Please wait while we analyze your sample.',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'NOTE: ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Avoid Moving The Device Or Removing The Dipstick During The Scan.',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}