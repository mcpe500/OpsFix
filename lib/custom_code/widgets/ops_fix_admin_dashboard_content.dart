// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OpsFixAdminDashboardContent extends StatefulWidget {
  const OpsFixAdminDashboardContent({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OpsFixAdminDashboardContent> createState() =>
      _OpsFixAdminDashboardContentState();
}

class _OpsFixAdminDashboardContentState
    extends State<OpsFixAdminDashboardContent> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _kpi;
  List<Map<String, dynamic>> _tickets = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final siteId = FFAppState().currentSiteId.trim();
      if (siteId.isEmpty) {
        throw StateError('missing_site');
      }

      final results = await Future.wait<dynamic>([
        SupaFlow.client
            .from('manager_site_kpis_v')
            .select(
              'site_id,open_tickets,unassigned_tickets,overdue_tickets,'
              'critical_open_tickets,fixed_this_month,'
              'average_resolution_minutes',
            )
            .eq('site_id', siteId)
            .limit(1),
        SupaFlow.client
            .from('ticket_cards_v')
            .select(
              'id,site_id,ticket_code,target_label_snapshot,status,'
              'priority,updated_at',
            )
            .eq('site_id', siteId)
            .order('updated_at'),
      ]);

      final kpiRows = results[0] as List;
      final ticketRows = results[1] as List;
      if (!mounted) {
        return;
      }

      setState(() {
        _kpi = kpiRows.isEmpty
            ? null
            : Map<String, dynamic>.from(kpiRows.first as Map);
        _tickets = ticketRows
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _loading = false;
      });
    } catch (error) {
      debugPrint('Admin dashboard load failed: ${error.runtimeType}');
      if (mounted) {
        setState(() {
          _loading = false;
          _error =
              'Dashboard belum dapat dimuat. Tarik ke bawah untuk mencoba lagi.';
        });
      }
    }
  }

  int _count(String key) {
    final raw = _kpi?[key];
    if (raw is num) {
      return raw.toInt();
    }
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  String _text(Map<String, dynamic> row, String key, [String fallback = '']) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  Widget _hero() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF081222),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ADMIN OPERATIONS',
              style: TextStyle(
                color: Color(0xFF9EEAD8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kendalikan antrean.\nJaga bukti perbaikan.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Selamat datang kembali di pusat operasi OpsFix.',
              style: TextStyle(
                color: Color(0xFFD8E0EF),
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF26354D)),
            const SizedBox(height: 12),
            Row(
              children: [
                _heroStat(_count('open_tickets'), 'Tiket aktif'),
                const SizedBox(width: 12),
                _heroStat(_count('unassigned_tickets'), 'Belum ditugaskan'),
                const SizedBox(width: 12),
                _heroStat(_count('fixed_this_month'), 'Selesai bulan ini'),
              ],
            ),
          ],
        ),
      );

  Widget _heroStat(int value, String label) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFB8C0D0),
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
      );

  Widget _metric(
    IconData icon,
    Color color,
    int value,
    String label,
    String caption,
  ) =>
      Container(
        height: 112,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 22),
            Text(
              '$value',
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _metricsGrid() {
    final cards = <Widget>[
      _metric(
        Icons.assignment_late_outlined,
        const Color(0xFFF59E0B),
        _count('unassigned_tickets'),
        'Belum ditugaskan',
        'Menunggu tindakan',
      ),
      _metric(
        Icons.priority_high,
        const Color(0xFFEF4444),
        _count('critical_open_tickets'),
        'Prioritas kritis',
        'Tiket kritis',
      ),
      _metric(
        Icons.timer_outlined,
        const Color(0xFF6C5CE7),
        _count('average_resolution_minutes'),
        'Rata-rata resolusi',
        'Menit selesai',
      ),
      _metric(
        Icons.warning_amber_outlined,
        const Color(0xFFF97316),
        _count('overdue_tickets'),
        'Tiket terlambat',
        'Melewati SLA',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final cardWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards
              .map((card) => SizedBox(width: cardWidth, child: card))
              .toList(),
        );
      },
    );
  }

  Widget _ticketCard(Map<String, dynamic> ticket) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.confirmation_number,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _text(ticket, 'ticket_code', 'Tiket'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _text(ticket, 'target_label_snapshot', 'Lokasi'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _text(ticket, 'status', 'reported'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6C5CE7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                final ticketId = _text(ticket, 'id');
                if (ticketId.isEmpty) {
                  return;
                }
                context.pushNamed(
                  'adminTicketDetailPage',
                  queryParameters: {
                    'ticketId': serializeParam(ticketId, ParamType.String),
                  }.withoutNulls,
                );
              },
              icon: const Icon(
                Icons.chevron_right,
                color: Color(0xFF6C5CE7),
                size: 22,
              ),
            ),
          ],
        ),
      );

  Widget _priorityQueue(int columns) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Antrean prioritas',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.goNamed('adminWorkBoardPage'),
                  child: const Text('Buka board'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_tickets.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      color: Color(0xFF94A3B8),
                      size: 36,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tidak ada tiket untuk ditampilkan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: columns == 1 ? 360 : 380,
                child: GridView.builder(
                  primary: false,
                  padding: EdgeInsets.zero,
                  itemCount: _tickets.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 96,
                  ),
                  itemBuilder: (context, index) => _ticketCard(_tickets[index]),
                ),
              ),
          ],
        ),
      );

  Widget _loadedLayout(double screenWidth) {
    final large = screenWidth >= 800;
    final queueColumns = screenWidth >= 600 ? 2 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (large)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _hero()),
              const SizedBox(width: 18),
              Expanded(flex: 7, child: _metricsGrid()),
            ],
          )
        else ...[
          _hero(),
          const SizedBox(height: 16),
          _metricsGrid(),
        ],
        const SizedBox(height: 18),
        _priorityQueue(queueColumns),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxWidth = screenWidth >= 1200
        ? 1280.0
        : screenWidth >= 480
            ? 960.0
            : double.infinity;
    final horizontal = screenWidth >= 1200
        ? 24.0
        : screenWidth >= 480
            ? 20.0
            : 14.0;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(horizontal, 18, horizontal, 28),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: _loading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _error != null
                        ? Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFBE123C),
                              ),
                            ),
                          )
                        : _loadedLayout(screenWidth),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
