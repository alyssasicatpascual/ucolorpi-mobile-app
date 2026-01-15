import 'package:flutter/material.dart';
import 'mockData.dart';
import 'fullReport.dart';

class RecordHistoryPage extends StatefulWidget {
  const RecordHistoryPage({Key? key}) : super(key: key);

  @override
  State<RecordHistoryPage> createState() => _RecordHistoryPageState();
}

class _RecordHistoryPageState extends State<RecordHistoryPage> {
  List<UrinalysisRecord> _all = [];
  List<UrinalysisRecord> _filtered = [];
  String _query = '';
  bool _sortNewest = true;

  @override
  void initState() {
    super.initState();
    _all = List.from(mockUrinalysisRecords);
    _applyFilters();
  }

  // --- UPDATED LOGIC HERE ---
  String _statusText(UrinalysisRecord r) {
    int outOfRange = 0;

    // FIX: Updated pH logic to accept a healthy range (5.0 - 8.0)
    // Previously "if (ph != 7.0)" caused healthy pH 7.5 to count as an error.
    final ph = double.tryParse(r.ph) ?? 0.0;
    if (ph < 5.0 || ph > 8.0) outOfRange++;

    // Specific Gravity Logic (1.005 - 1.030)
    final sg = double.tryParse(r.specificGravity) ?? 0.0;
    if (!(sg >= 1.005 && sg <= 1.030)) outOfRange++;

    // Chemical Logic (Should be Negative)
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
      // Case-insensitive check for 'negative'
      if (v.toLowerCase() != 'negative') outOfRange++;
    }

    if (outOfRange == 0) return 'Normal';
    if (outOfRange <= 2) return 'Attention';
    return 'Abnormal';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green;
      case 'Attention':
        return const Color(0xFFFF8B00);
      default:
        return const Color(0xFFFF0004);
    }
  }

  // --- UPDATED SUMMARY LOGIC ---
  String _summary(UrinalysisRecord r) {
    final status = _statusText(r);
    
    switch (status) {
      case 'Normal':
        return 'All parameters are within the range';
      case 'Attention':
        return 'One or more readings are slightly outside normal';
      case 'Abnormal':
        return 'Critical values detected';
      default:
        return '';
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  void _applyFilters() {
    final q = _query.trim().toLowerCase();
    _filtered = _all.where((r) {
      if (q.isEmpty) return true;
      final dateStr = _formatDate(r.date).toLowerCase();
      final id = r.id.toLowerCase();
      final status = _statusText(r).toLowerCase();
      return dateStr.contains(q) || id.contains(q) || status.contains(q);
    }).toList();

    _filtered.sort((a, b) =>
        _sortNewest ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    setState(() {});
  }

  Widget _gradientButton(String text, VoidCallback onTap,
      {double width = 160}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF00BBD3).withOpacity(0.18),
                blurRadius: 8,
                offset: Offset(0, 4))
          ],
        ),
        child: Center(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: Column(
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF33E4DB), Color(0xFF00BBD3)]),
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('<',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Center(
                      child: Text('RECORD HISTORY',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18))),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      hintStyle: TextStyle(color: Colors.grey)),
                                  onChanged: (v) {
                                    _query = v;
                                    _applyFilters();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Sort',
                                style: TextStyle(color: Colors.black54)),
                            const SizedBox(width: 6),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<bool>(
                                isDense: true,
                                value: _sortNewest,
                                items: const [
                                  DropdownMenuItem(
                                      value: true,
                                      child: Text('New',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal))),
                                  DropdownMenuItem(
                                      value: false,
                                      child: Text('Old',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal))),
                                ],
                                onChanged: (v) {
                                  if (v == null) return;
                                  _sortNewest = v;
                                  _applyFilters();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: _filtered.isEmpty
                        ? const Center(
                            child: Text('No records match your search',
                                style: TextStyle(color: Colors.black54)))
                        : ListView.builder(
                            itemCount: _filtered.length,
                            itemBuilder: (context, i) {
                              final r = _filtered[i];
                              final status = _statusText(r);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  'DATE: ${_formatDate(r.date)}',
                                                  style: const TextStyle(
                                                      color: Colors.black54),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                  generateRecordId(r, _all),
                                                  style: const TextStyle(
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.right,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text('Result:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.circle,
                                                    color: _statusColor(status),
                                                    size: 12),
                                                const SizedBox(width: 6),
                                                Text(status,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(_summary(r),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54, 
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            const SizedBox(height: 12),
                                            Center(
                                                child: _gradientButton(
                                                    'View Full Report', () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          FullReportPage(
                                                              record: r)));
                                            }, width: 160)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}