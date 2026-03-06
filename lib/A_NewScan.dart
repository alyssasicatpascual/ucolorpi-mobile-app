import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'B_NewScan.dart';

class ANewScanScreen extends StatelessWidget {
  const ANewScanScreen({Key? key}) : super(key: key);

  static const bgColor = Color(0xFFF2F2F7);
  static const gradientStart = Color(0xFF33E4DB);
  static const gradientEnd = Color(0xFF00BBD3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      children: const [
                        Icon(Icons.chevron_left, color: Color(0xFF33E4DB)),
                        SizedBox(width: 6),
                        Text('Back', style: TextStyle(color: Color(0xFF33E4DB), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: SvgPicture.asset('assets/images/ucolorpi_icon.svg', width: 72, height: 72, color: gradientStart, semanticsLabel: 'UColorPi icon'),
                ),
                const SizedBox(height: 12),
                const Text('UCOLORPI Device', style: TextStyle(color: Color(0xFF33E4DB), fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Status: ', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text('Connected', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            Expanded(
              child: SafeArea(
                top: false,
                bottom: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    _infoCard(
                      title: 'Preparation Before Scanning',
                      items: const [
                        'Wash and dry your hands properly.',
                        'Collect a fresh urine sample in a clean container.',
                        'Dip the reagent strip into the urine making sure that all pads are fully soaked for about 1–2 seconds.',
                        'Remove the strip and tap it gently sideways to remove excess urine.',
                        'Place the dipstick flat on the U-COLORPI tray with the pads facing upward.',
                      ],
                    ),

                    const SizedBox(height: 12),

                    _infoCard(
                      title: 'Scanning Guidelines',
                      items: const [
                        'Place the device on a stable, flat surface.',
                        'Keep the dipstick still and centered on the tray.',
                        'Make sure the device cover is properly closed.',
                        'Wait for the results to appear on the LCD and/or the mobile application.',
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Start Scan button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BNewScanScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          foregroundColor: Colors.white,
                          backgroundColor: gradientEnd,
                        ),
                        child: const Text('Start Scan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(child: Text('Estimated Scan Time: 10-15 Seconds', style: TextStyle(color: Colors.black54, fontSize: 12))),
                    const SizedBox(height: 24),
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

  Widget _infoCard({required String title, required List<String> items}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12, top: 6),
            child: Icon(Icons.lightbulb_outline, color: Color(0xFFFFD54F)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .asMap()
                      .entries
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text('${e.key + 1}. ${e.value}', style: const TextStyle(color: Colors.black54)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
