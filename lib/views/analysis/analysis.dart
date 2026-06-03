
import 'package:brando_app/helper/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ─── Data Models ─────────────────────────────────────────────────────────────

class CreditEntry {
  String type;
  double amount;
  CreditEntry({required this.type, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
    };
  }
}

class DebitEntry {
  String type;
  double amount;
  DebitEntry({required this.type, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
    };
  }
}

class LedgerEntry {
  String id;
  String vendorId;
  DateTime date;
  List<CreditEntry> creditItems;
  List<DebitEntry> debitItems;
  double credit;
  double debit;
  double balance;

  LedgerEntry({
    required this.id,
    required this.vendorId,
    required this.date,
    required this.creditItems,
    required this.debitItems,
    required this.credit,
    required this.debit,
    required this.balance,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    // Handle both cases: vendorId as String or as nested object
    String vendorIdValue = '';
    if (json['vendorId'] is Map) {
      vendorIdValue = json['vendorId']['_id']?.toString() ?? '';
    } else {
      vendorIdValue = json['vendorId']?.toString() ?? '';
    }

    return LedgerEntry(
      id: json['_id']?.toString() ?? '',
      vendorId: vendorIdValue,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      creditItems: _parseCreditItems(json['creditItems']),
      debitItems: _parseDebitItems(json['debitItems']),
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static List<CreditEntry> _parseCreditItems(dynamic items) {
    if (items == null) return [];
    if (items is! List) return [];

    return items.map((e) {
      if (e is Map<String, dynamic>) {
        return CreditEntry(
          type: e['type']?.toString() ?? '',
          amount: (e['amount'] as num?)?.toDouble() ?? 0.0,
        );
      }
      return CreditEntry(type: '', amount: 0.0);
    }).where((e) => e.amount > 0 || (e.type.isNotEmpty && e.type != 'Type here')).toList();
  }

  static List<DebitEntry> _parseDebitItems(dynamic items) {
    if (items == null) return [];
    if (items is! List) return [];

    return items.map((e) {
      if (e is Map<String, dynamic>) {
        return DebitEntry(
          type: e['type']?.toString() ?? '',
          amount: (e['amount'] as num?)?.toDouble() ?? 0.0,
        );
      }
      return DebitEntry(type: '', amount: 0.0);
    }).where((e) => e.amount > 0 || (e.type.isNotEmpty && e.type != 'Type here')).toList();
  }
}

class LedgerRow {
  Map<int, List<CreditEntry>> creditEntries;
  Map<int, List<DebitEntry>> debitEntries;
  Map<int, String> entryIds;

  LedgerRow()
      : creditEntries = {},
        debitEntries = {},
        entryIds = {};

  double creditTotal(int day) =>
      (creditEntries[day] ?? []).fold(0, (s, e) => s + e.amount);
  double debitTotal(int day) =>
      (debitEntries[day] ?? []).fold(0, (s, e) => s + e.amount);

  double get totalCredit => creditEntries.values
      .expand((entries) => entries)
      .fold(0, (s, e) => s + e.amount);
  
  double get totalDebit => debitEntries.values
      .expand((entries) => entries)
      .fold(0, (s, e) => s + e.amount);
}

// ─── Constants ───────────────────────────────────────────────────────────────

const _kDark = Color(0xFF1A1A2E);
const _kGreenDk = Color.fromARGB(255, 2, 40, 5);
const _kGreenBg = Color(0xFFE8F5E9);
const _kRedDk = Color(0xFFB71C1C);
const _kRedBg = Color(0xFFFFEBEE);
const _kHeaderBg = Color(0xFFEEEEEE);
const _kSubHdrBg = Color(0xFFF5F5F5);
const _kBorderC = Color(0xFF9E9E9E);
const _kBlue = Color(0xFF1976D2);

const double _rowH = 42.0;
const double _hdrH = 34.0;

const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

int _daysInMonth(int year, int month) {
  if (month == 11) {
    return DateTime(year + 1, 0, 0).day;
  } else {
    return DateTime(year, month + 2, 0).day;
  }
}

// ─── Responsive Column Widths ─────────────────────────────────────────────────

class _ColWidths {
  final double day;
  final double cr;
  final double dr;
  final double bal;
  final double action;

  const _ColWidths({
    required this.day,
    required this.cr,
    required this.dr,
    required this.bal,
    required this.action,
  });

  factory _ColWidths.fromScreenWidth(double screenWidth) {
    final usable = screenWidth - 24;

    final day = (usable * 0.11).clamp(38.0, 55.0);
    final cr = (usable * 0.21).clamp(64.0, 95.0);
    final dr = (usable * 0.21).clamp(64.0, 95.0);
    final bal = (usable * 0.21).clamp(64.0, 95.0);
    final action = (usable - day - cr - dr - bal - 1).clamp(60.0, 90.0);

    return _ColWidths(day: day, cr: cr, dr: dr, bal: bal, action: action);
  }
}

// API Constants
const String baseUrl = 'http://187.127.146.52:2003';

// ─── Main Screen ─────────────────────────────────────────────────────────────

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  int _curYear = DateTime.now().year;
  int _curMonth = DateTime.now().month - 1;
  bool _isLoading = false;
  int? _savingDay;

  final LedgerRow _ledger = LedgerRow();

  int get _days => _daysInMonth(_curYear, _curMonth);

  String get _currentMonthString =>
      '${_curYear}-${(_curMonth + 1).toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _fetchLedgerData();
  }

  void _shiftMonth(int dir) {
    setState(() {
      _curMonth += dir;
      if (_curMonth > 11) {
        _curMonth = 0;
        _curYear++;
      }
      if (_curMonth < 0) {
        _curMonth = 11;
        _curYear--;
      }
    });
    _fetchLedgerData();
  }

  Future<void> _fetchLedgerData() async {
    setState(() => _isLoading = true);
    try {
      final vendorId = await AppPreferences.getUserId();
      final url = '$baseUrl/api/vendors/ledgergetall/$vendorId';
      debugPrint('========== FETCHING LEDGER DATA ==========');
      debugPrint('URL: $url');

      final response = await http.get(Uri.parse(url));
      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          final data = jsonData['data'] as List?;
          
          setState(() {
            _ledger.creditEntries.clear();
            _ledger.debitEntries.clear();
            _ledger.entryIds.clear();

            if (data != null && data.isNotEmpty) {
              for (var entry in data) {
                _processLedgerEntry(entry);
              }
            }
          });
        }
      }
      debugPrint('==========================================');
    } catch (e, stackTrace) {
      debugPrint('Error fetching ledger: $e');
      debugPrint('StackTrace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load ledger data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _processLedgerEntry(dynamic entryData) {
    try {
      if (entryData == null) return;
      
      final entry = LedgerEntry.fromJson(entryData as Map<String, dynamic>);
      
      // Extract day from date
      final day = entry.date.day;
      
      // Only show entries for current month/year
      if (entry.date.year == _curYear && entry.date.month == (_curMonth + 1)) {
        _ledger.creditEntries[day] = entry.creditItems;
        _ledger.debitEntries[day] = entry.debitItems;
        _ledger.entryIds[day] = entry.id;
        debugPrint('Loaded day $day: Credit=${entry.credit}, Debit=${entry.debit}, ID=${entry.id}');
      }
    } catch (e) {
      debugPrint('Error processing ledger entry: $e');
    }
  }

  Future<void> _saveLedgerEntry(
      int day, List<CreditEntry> creditEntries, List<DebitEntry> debitEntries) async {
    debugPrint('========== SAVE BUTTON CLICKED ==========');
    debugPrint('Day: $day');
    debugPrint('Credit Entries: ${creditEntries.map((e) => '${e.type}: ${e.amount}').toList()}');
    debugPrint('Debit Entries: ${debitEntries.map((e) => '${e.type}: ${e.amount}').toList()}');

    setState(() => _savingDay = day);

    try {
      // Filter out empty entries
      final validCreditEntries = creditEntries
          .where((e) => e.amount > 0 && e.type.trim().isNotEmpty && e.type != 'Type here')
          .toList();
      
      final validDebitEntries = debitEntries
          .where((e) => e.amount > 0 && e.type.trim().isNotEmpty && e.type != 'Type here')
          .toList();

      // Check if there's anything to save
      if (validCreditEntries.isEmpty && validDebitEntries.isEmpty) {
        debugPrint('⚠️ No valid entries to save for day $day');
        setState(() => _savingDay = null);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid entries to save (amount must be > 0)')),
          );
        }
        return;
      }

      final payload = {
                "type": "user",
        "date": "${_curYear}-${(_curMonth + 1).toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}",
        "creditItems": validCreditEntries.map((e) => e.toJson()).toList(),
        "debitItems": validDebitEntries.map((e) => e.toJson()).toList(),
      };

      debugPrint("========== SAVE PAYLOAD ==========");
      debugPrint("Date: ${payload['date']}");
      debugPrint("Credit Items: ${payload['creditItems']}");
      debugPrint("Debit Items: ${payload['debitItems']}");
      debugPrint("==================================");

      http.Response response;
      final existingId = _ledger.entryIds[day];
      debugPrint('Existing Entry ID for day $day: $existingId');
      final vendorId = await AppPreferences.getUserId();

      if (existingId != null && existingId.isNotEmpty) {
        // Update existing entry
        final url = '$baseUrl/api/vendors/ledgerupdate/$existingId';
        debugPrint("🟡 PUT Request to: $url");

        response = await http.put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );
        debugPrint("🟢 PUT Response Status: ${response.statusCode}");
        debugPrint("🟢 PUT Response Body: ${response.body}");
      } else {
        // Create new entry
        final url = '$baseUrl/api/vendors/ledgercreate/$vendorId';
        debugPrint("🔵 POST Request to: $url");

        response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );
        debugPrint("🔵 POST Response Status: ${response.statusCode}");
        debugPrint("🔵 POST Response Body: ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        debugPrint("📦 Response JSON: $jsonData");

        if (jsonData['success'] == true) {
          debugPrint("✅ Save successful for day $day");
          
          // Update local data with response
          if (jsonData['data'] != null) {
            final savedEntry = LedgerEntry.fromJson(jsonData['data']);
            _ledger.creditEntries[day] = savedEntry.creditItems;
            _ledger.debitEntries[day] = savedEntry.debitItems;
            _ledger.entryIds[day] = savedEntry.id;
          }
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Day $day saved successfully')),
            );
            setState(() {}); // Refresh UI
          }
        } else {
          throw Exception('API returned success: false - ${jsonData['message']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving: $e');
      debugPrint('❌ StackTrace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save day $day: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _savingDay = null);
      }
      debugPrint('========== SAVE COMPLETED ==========');
    }
  }

  Future<void> _refresh() async {
    await _fetchLedgerData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cols = _ColWidths.fromScreenWidth(screenWidth);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 1,
          centerTitle: true,
          title: const Text(
            'Ledger Analysis',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: _isLoading
              ? _SkeletonLoader(cols: cols)
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _LedgerCard(
                        ledger: _ledger,
                        year: _curYear,
                        month: _curMonth,
                        days: _days,
                        cols: cols,
                        onPrevMonth: () => _shiftMonth(-1),
                        onNextMonth: () => _shiftMonth(1),
                        onSave: _saveLedgerEntry,
                        savingDay: _savingDay,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Skeleton Loader ─────────────────────────────────────────────────────────

class _SkeletonLoader extends StatelessWidget {
  final _ColWidths cols;
  const _SkeletonLoader({required this.cols});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black87, width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: _kDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    height: _hdrH,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...List.generate(
                    10,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Container(
                        height: _rowH,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const ShimmerEffect(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: Colors.grey[300],
          child: Row(
            children: List.generate(
              5,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: Colors.grey[200],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Ledger Card ─────────────────────────────────────────────────────────────

class _LedgerCard extends StatelessWidget {
  final LedgerRow ledger;
  final int year, month, days;
  final _ColWidths cols;
  final VoidCallback onPrevMonth, onNextMonth;
  final Future<void> Function(int day, List<CreditEntry> credits, List<DebitEntry> debits)
      onSave;
  final int? savingDay;

  const _LedgerCard({
    required this.ledger,
    required this.year,
    required this.month,
    required this.days,
    required this.cols,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onSave,
    required this.savingDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black87, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: _kDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: onPrevMonth,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Flexible(
                  child: Text(
                    'Ledger ${_months[month]} $year',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: onNextMonth,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Text(
              'Tap Credit/Debit cell to add entries | Tap Save to sync with server',
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ),
          _LedgerGrid(
            ledger: ledger,
            days: days,
            cols: cols,
            onSave: onSave,
            savingDay: savingDay,
          ),
        ],
      ),
    );
  }
}

// ─── Ledger Grid ─────────────────────────────────────────────────────────────

class _LedgerGrid extends StatefulWidget {
  final LedgerRow ledger;
  final int days;
  final _ColWidths cols;
  final Future<void> Function(int day, List<CreditEntry> credits, List<DebitEntry> debits)
      onSave;
  final int? savingDay;

  const _LedgerGrid({
    required this.ledger,
    required this.days,
    required this.cols,
    required this.onSave,
    required this.savingDay,
  });

  @override
  State<_LedgerGrid> createState() => _LedgerGridState();
}

class _LedgerGridState extends State<_LedgerGrid> {
  static const BorderSide _b = BorderSide(color: _kBorderC, width: 0.5);

  @override
  Widget build(BuildContext context) {
    double totalCredit = widget.ledger.totalCredit;
    double totalDebit = widget.ledger.totalDebit;
    final grandBalance = totalCredit - totalDebit;

    return Column(
      children: [
        _buildHeaderRow(),
        for (int d = 1; d <= widget.days; d++) _buildDayRow(context, d),
        _buildTotalsRow(totalCredit, totalDebit, grandBalance),
      ],
    );
  }

  Widget _buildHeaderRow() {
    final c = widget.cols;
    return Row(
      children: [
        _hdrCell('Day', c.day),
        _hdrCell('Credit', c.cr, textColor: _kGreenDk),
        _hdrCell('Debit', c.dr, textColor: _kRedDk),
        _hdrCell('Balance', c.bal),
        Container(width: 1, height: _hdrH, color: _kBorderC),
        _hdrCell('Update', c.action, textColor: _kBlue),
      ],
    );
  }

  Widget _buildDayRow(BuildContext ctx, int day) {
    final c = widget.cols;
    final creditTotal = widget.ledger.creditTotal(day);
    final debitTotal = widget.ledger.debitTotal(day);
    final bal = creditTotal - debitTotal;
    final hasCredit = creditTotal > 0;
    final hasDebit = debitTotal > 0;
    final hasChanges = hasCredit || hasDebit;
    final isSavingThisDay = widget.savingDay == day;

    return Row(
      children: [
        // Day number cell
        _staticCell('$day', c.day, bg: _kSubHdrBg, bold: true, fontSize: 11),

        // Credit tappable cell
        GestureDetector(
          onTap: () => _openCreditModal(ctx, day),
          child: Container(
            width: c.cr,
            height: _rowH,
            decoration: BoxDecoration(
              color: hasCredit ? _kGreenBg : Colors.white,
              border: const Border(
                right: BorderSide(color: _kBorderC, width: 0.5),
                bottom: BorderSide(color: _kBorderC, width: 0.5),
              ),
            ),
            alignment: Alignment.center,
            child: hasCredit
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          '₹${creditTotal.toStringAsFixed(0)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _kGreenDk,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.edit, size: 10, color: _kGreenDk),
                    ],
                  )
                : const Text(
                    'Tap +',
                    style: TextStyle(fontSize: 10, color: Colors.black38),
                  ),
          ),
        ),

        // Debit tappable cell
        GestureDetector(
          onTap: () => _openDebitModal(ctx, day),
          child: Container(
            width: c.dr,
            height: _rowH,
            decoration: BoxDecoration(
              color: hasDebit ? _kRedBg : Colors.white,
              border: const Border(
                right: BorderSide(color: _kBorderC, width: 0.5),
                bottom: BorderSide(color: _kBorderC, width: 0.5),
              ),
            ),
            alignment: Alignment.center,
            child: hasDebit
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          '₹${debitTotal.toStringAsFixed(0)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _kRedDk,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.edit, size: 10, color: _kRedDk),
                    ],
                  )
                : const Text(
                    'Tap +',
                    style: TextStyle(fontSize: 10, color: Colors.black38),
                  ),
          ),
        ),

        // Balance cell
        Container(
          width: c.bal,
          height: _rowH,
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: _kBorderC, width: 0.5),
              bottom: BorderSide(color: _kBorderC, width: 0.5),
            ),
          ),
          alignment: Alignment.center,
          child: (hasCredit || hasDebit)
              ? Text(
                  '₹${bal.toStringAsFixed(0)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: bal >= 0
                        ? const Color.fromARGB(255, 0, 150, 13)
                        : _kRedDk,
                  ),
                )
              : const Text('—',
                  style: TextStyle(fontSize: 11, color: Colors.black26)),
        ),

        // Divider
        Container(width: 1, height: _rowH, color: _kBorderC),

        // Action/Save cell
        Container(
          width: c.action,
          height: _rowH,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: _kBorderC, width: 0.5)),
          ),
          alignment: Alignment.center,
          child: hasChanges
              ? ElevatedButton(
                  onPressed: isSavingThisDay
                      ? null
                      : () async {
                          final currentCredits =
                              widget.ledger.creditEntries[day] ?? [];
                          final currentDebits =
                              widget.ledger.debitEntries[day] ?? [];
                          await widget.onSave(
                              day, currentCredits, currentDebits);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 4),
                    minimumSize: const Size(40, 26),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: isSavingThisDay
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTotalsRow(double totalCr, double totalDr, double grandBal) {
    final c = widget.cols;
    return Row(
      children: [
        Container(
          width: c.day,
          height: _rowH,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            color: Colors.yellow,
            border: Border(right: _b, top: _b),
          ),
          alignment: Alignment.center,
          child: const Text('Total',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        _totalValueCell(totalCr, const Color.fromARGB(255, 7, 52, 186), c.cr),
        _totalValueCell(totalDr, _kRedDk, c.dr),
        Container(
          width: c.bal,
          height: _rowH,
          decoration: const BoxDecoration(
            color: Colors.yellow,
            border: Border(right: _b, top: _b),
          ),
          alignment: Alignment.center,
          child: Text(
            '₹${grandBal.toStringAsFixed(0)}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: grandBal >= 0
                  ? const Color.fromARGB(255, 0, 172, 14)
                  : _kRedDk,
            ),
          ),
        ),
        Container(width: 1, height: _rowH, color: _kBorderC),
        Container(
          width: c.action,
          height: _rowH,
          decoration: const BoxDecoration(
            color: Colors.yellow,
            border: Border(top: _b),
          ),
        ),
      ],
    );
  }

  Widget _hdrCell(String text, double width, {Color? textColor}) {
    return Container(
      width: width,
      height: _hdrH,
      decoration: const BoxDecoration(
        color: _kHeaderBg,
        border: Border(
          right: BorderSide(color: _kBorderC, width: 0.5),
          bottom: BorderSide(color: _kBorderC, width: 0.5),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _staticCell(String text, double width,
      {Color bg = Colors.white, bool bold = false, double fontSize = 11}) {
    return Container(
      width: width,
      height: _rowH,
      decoration: BoxDecoration(
        color: bg,
        border: const Border(
          right: BorderSide(color: _kBorderC, width: 0.5),
          bottom: BorderSide(color: _kBorderC, width: 0.5),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _totalValueCell(double val, Color color, double width) {
    return Container(
      width: width,
      height: _rowH,
      decoration: const BoxDecoration(
        color: Colors.yellow,
        border: Border(right: _b, top: _b),
      ),
      alignment: Alignment.center,
      child: Text(
        val > 0 ? '₹${val.toStringAsFixed(0)}' : '—',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _openCreditModal(BuildContext ctx, int day) {
    final currentEntries = widget.ledger.creditEntries[day] ?? [];
    
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreditModal(
        day: day,
        entries: currentEntries.isEmpty 
            ? [CreditEntry(type: '', amount: 0)]
            : currentEntries.map((e) => CreditEntry(type: e.type, amount: e.amount)).toList(),
        onSave: (entries) {
          setState(() {
            widget.ledger.creditEntries[day] = entries.where((e) => e.amount > 0 && e.type.trim().isNotEmpty).toList();
          });
        },
      ),
    );
  }

  void _openDebitModal(BuildContext ctx, int day) {
    final currentEntries = widget.ledger.debitEntries[day] ?? [];
    
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DebitModal(
        day: day,
        entries: currentEntries.isEmpty 
            ? [DebitEntry(type: '', amount: 0)]
            : currentEntries.map((e) => DebitEntry(type: e.type, amount: e.amount)).toList(),
        onSave: (entries) {
          setState(() {
            widget.ledger.debitEntries[day] = entries.where((e) => e.amount > 0 && e.type.trim().isNotEmpty).toList();
          });
        },
      ),
    );
  }
}

// ─── Credit Modal ──────────────────────────────────────────────────────────────

class _CreditModal extends StatefulWidget {
  final int day;
  final List<CreditEntry> entries;
  final void Function(List<CreditEntry>) onSave;

  const _CreditModal({
    required this.day,
    required this.entries,
    required this.onSave,
  });

  @override
  State<_CreditModal> createState() => _CreditModalState();
}

class _CreditModalState extends State<_CreditModal> {
  late List<CreditEntry> _entries;
  late List<Key> _rowKeys;

  @override
  void initState() {
    super.initState();
    _entries = List.from(widget.entries);
    if (_entries.isEmpty) {
      _entries.add(CreditEntry(type: '', amount: 0));
    }
    _initializeRowKeys();
  }

  void _initializeRowKeys() {
    _rowKeys = List.generate(_entries.length, (i) => UniqueKey());
  }

  double get _total => _entries.fold(0, (s, e) => s + e.amount);

  void _addEntry() {
    setState(() {
      _entries.insert(0, CreditEntry(type: '', amount: 0));
      _rowKeys.insert(0, UniqueKey());
    });
  }

  void _removeEntry(int i) {
    setState(() {
      _entries.removeAt(i);
      _rowKeys.removeAt(i);
    });
  }

  void _save() {
    final validEntries = _entries.where((e) => e.amount > 0 && e.type.trim().isNotEmpty).toList();
    widget.onSave(validEntries);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kGreenBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Day ${widget.day}',
                      style: const TextStyle(
                          color: _kGreenDk,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Credit Entries',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kGreenDk,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Total: ₹${_total.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            // Column labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text('Type',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: Text('Amount (₹)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                  SizedBox(width: 36),
                ],
              ),
            ),
            // Entry rows — scrollable
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _entries.length,
                itemBuilder: (_, i) => _CreditEntryRow(
                  key: _rowKeys[i],
                  entry: _entries[i],
                  index: i,
                  onDelete: _entries.length > 1 ? () => _removeEntry(i) : null,
                  onChanged: () => setState(() {}),
                ),
              ),
            ),
            // Add entry button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TextButton.icon(
                onPressed: _addEntry,
                icon: const Icon(Icons.add_circle_outline, size: 16, color: _kDark),
                label: const Text('Add another entry',
                    style: TextStyle(color: _kDark, fontSize: 12)),
                style: TextButton.styleFrom(
                  backgroundColor: _kSubHdrBg,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            // Cancel / Save buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        side: const BorderSide(color: Colors.black26),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Save ₹${_total.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Credit Entry Row inside Modal ───────────────────────────────────────────────────

class _CreditEntryRow extends StatefulWidget {
  final CreditEntry entry;
  final int index;
  final VoidCallback? onDelete;
  final VoidCallback onChanged;

  const _CreditEntryRow({
    super.key,
    required this.entry,
    required this.index,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  State<_CreditEntryRow> createState() => _CreditEntryRowState();
}

class _CreditEntryRowState extends State<_CreditEntryRow> {
  late final TextEditingController _typeCtrl;
  late final TextEditingController _amtCtrl;

  @override
  void initState() {
    super.initState();
    _typeCtrl = TextEditingController(text: widget.entry.type);
    _amtCtrl = TextEditingController(
        text: widget.entry.amount > 0 ? widget.entry.amount.toStringAsFixed(0) : '');
  }

  @override
  void dispose() {
    _typeCtrl.dispose();
    _amtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _typeCtrl,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. sales, refund…',
                hintStyle: const TextStyle(fontSize: 11, color: Colors.black38),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _kBorderC)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _kBorderC)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _kGreenDk, width: 1.5)),
              ),
              onChanged: (v) {
                widget.entry.type = v;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextField(
              controller: _amtCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: _kGreenDk, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(fontSize: 11, color: Colors.black38),
                prefixText: '₹',
                prefixStyle: const TextStyle(color: _kGreenDk, fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _kBorderC)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _kBorderC)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _kGreenDk, width: 1.5)),
              ),
              onChanged: (v) {
                final parsed = double.tryParse(v) ?? 0;
                widget.entry.amount = parsed;
                widget.onChanged();
              },
            ),
          ),
          SizedBox(
            width: 36,
            child: widget.onDelete != null
                ? IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                    onPressed: widget.onDelete,
                    padding: EdgeInsets.zero,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─── Debit Modal ──────────────────────────────────────────────────────────────

class _DebitModal extends StatefulWidget {
  final int day;
  final List<DebitEntry> entries;
  final void Function(List<DebitEntry>) onSave;

  const _DebitModal({
    required this.day,
    required this.entries,
    required this.onSave,
  });

  @override
  State<_DebitModal> createState() => _DebitModalState();
}

class _DebitModalState extends State<_DebitModal> {
  late List<DebitEntry> _entries;
  late List<Key> _rowKeys;

  @override
  void initState() {
    super.initState();
    _entries = List.from(widget.entries);
    if (_entries.isEmpty) {
      _entries.add(DebitEntry(type: '', amount: 0));
    }
    _initializeRowKeys();
  }

  void _initializeRowKeys() {
    _rowKeys = List.generate(_entries.length, (i) => UniqueKey());
  }

  double get _total => _entries.fold(0, (s, e) => s + e.amount);

  void _addEntry() {
    setState(() {
      _entries.insert(0, DebitEntry(type: '', amount: 0));
      _rowKeys.insert(0, UniqueKey());
    });
  }

  void _removeEntry(int i) {
    setState(() {
      _entries.removeAt(i);
      _rowKeys.removeAt(i);
    });
  }

  void _save() {
    final validEntries = _entries.where((e) => e.amount > 0 && e.type.trim().isNotEmpty).toList();
    widget.onSave(validEntries);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kRedBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Day ${widget.day}',
                      style: const TextStyle(
                          color: _kRedDk,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Debit Entries',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kRedDk,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Total: ₹${_total.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            // Column labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text('Type',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: Text('Amount (₹)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                  SizedBox(width: 36),
                ],
              ),
            ),
            // Entry rows — scrollable
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _entries.length,
                itemBuilder: (_, i) => _DebitEntryRow(
                  key: _rowKeys[i],
                  entry: _entries[i],
                  index: i,
                  onDelete: _entries.length > 1 ? () => _removeEntry(i) : null,
                  onChanged: () => setState(() {}),
                ),
              ),
            ),
            // Add entry button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TextButton.icon(
                onPressed: _addEntry,
                icon: const Icon(Icons.add_circle_outline, size: 16, color: _kDark),
                label: const Text('Add another entry',
                    style: TextStyle(color: _kDark, fontSize: 12)),
                style: TextButton.styleFrom(
                  backgroundColor: _kSubHdrBg,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            // Cancel / Save buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        side: const BorderSide(color: Colors.black26),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Save ₹${_total.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Debit Entry Row inside Modal ───────────────────────────────────────────────────

class _DebitEntryRow extends StatefulWidget {
  final DebitEntry entry;
  final int index;
  final VoidCallback? onDelete;
  final VoidCallback onChanged;

  const _DebitEntryRow({
    super.key,
    required this.entry,
    required this.index,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  State<_DebitEntryRow> createState() => _DebitEntryRowState();
}

class _DebitEntryRowState extends State<_DebitEntryRow> {
  late final TextEditingController _typeCtrl;
  late final TextEditingController _amtCtrl;

  @override
  void initState() {
    super.initState();
    _typeCtrl = TextEditingController(text: widget.entry.type);
    _amtCtrl = TextEditingController(
        text: widget.entry.amount > 0 ? widget.entry.amount.toStringAsFixed(0) : '');
  }

  @override
  void dispose() {
    _typeCtrl.dispose();
    _amtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _typeCtrl,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. vegetables, fuel…',
                hintStyle: const TextStyle(fontSize: 11, color: Colors.black38),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _kBorderC)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _kBorderC)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _kRedDk, width: 1.5)),
              ),
              onChanged: (v) {
                widget.entry.type = v;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextField(
              controller: _amtCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: _kRedDk, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(fontSize: 11, color: Colors.black38),
                prefixText: '₹',
                prefixStyle: const TextStyle(color: _kRedDk, fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _kBorderC)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _kBorderC)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _kRedDk, width: 1.5)),
              ),
              onChanged: (v) {
                final parsed = double.tryParse(v) ?? 0;
                widget.entry.amount = parsed;
                widget.onChanged();
              },
            ),
          ),
          SizedBox(
            width: 36,
            child: widget.onDelete != null
                ? IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                    onPressed: widget.onDelete,
                    padding: EdgeInsets.zero,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}