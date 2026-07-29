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
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

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
              'site_id,open_tickets,unassigned_tickets,overdue_tickets,critical_open_tickets,fixed_this_month,average_resolution_minutes',
            )
            .eq('site_id', siteId)
            .limit(1),
        SupaFlow.client
            .from('ticket_cards_v')
            .select(
              'id,site_id,ticket_code,status,assignment_state,priority,priority_rank,location_name_snapshot,unit_code_snapshot,unit_name_snapshot,target_label_snapshot,issue_type_snapshot,assigned_technician_id,technician_name_snapshot,resolution_due_at,is_open,created_at,updated_at',
            )
            .eq('site_id', siteId)
            .eq('is_open', true),
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
        final activeTickets = ticketRows
            .map((row) => Map<String, dynamic>.from(row as Map))
            .where((ticket) => ticket['is_open'] == true)
            .toList()
          ..sort(_compareQueueTickets);
        _tickets = activeTickets.take(6).toList(growable: false);
        _loading = false;
      });
    } catch (error) {
      debugPrint('Admin dashboard load failed: ${error.runtimeType}');
      if (mounted) {
        setState(() {
          _loading = false;
          _error = OpsFixI18n.t(
              'Dashboard belum dapat dimuat. Tarik ke bawah untuk mencoba lagi.');
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
            Text(
              OpsFixI18n.t('ADMIN OPERATIONS'),
              style: TextStyle(
                color: Color(0xFF9EEAD8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              <String>[
                OpsFixI18n.t('Kendalikan antrean.'),
                OpsFixI18n.t('Jaga bukti perbaikan.'),
              ].join('\n'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              OpsFixI18n.t('Selamat datang kembali di pusat operasi OpsFix.'),
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
                _heroStat(_count('open_tickets'), OpsFixI18n.t('Tiket aktif')),
                const SizedBox(width: 12),
                _heroStat(_count('unassigned_tickets'),
                    OpsFixI18n.t('Belum ditugaskan')),
                const SizedBox(width: 12),
                _heroStat(_count('fixed_this_month'),
                    OpsFixI18n.t('Selesai bulan ini')),
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

  String _formatResolution(int minutes) {
    if (minutes < 60) return '$minutes ${OpsFixI18n.t('m')}';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    return remaining == 0
        ? '$hours${OpsFixI18n.t('j')}'
        : '$hours${OpsFixI18n.t('j')} $remaining ${OpsFixI18n.t('m')}';
  }

  void _openMetricView(String initialView) {
    context.goNamed(
      'adminTicketsPage',
      queryParameters: {'initialView': initialView},
      extra: _opsFixPageFade(),
    );
  }

  Widget _metric(
    IconData icon,
    Color color,
    String value,
    String label,
    String caption,
    String initialView,
  ) =>
      Semantics(
        button: true,
        label: '$label, $value. $caption',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openMetricView(initialView),
            borderRadius: BorderRadius.circular(16),
            hoverColor: color.withOpacity(.045),
            focusColor: color.withOpacity(.08),
            splashColor: color.withOpacity(.10),
            child: Container(
              constraints: const BoxConstraints(minHeight: 128),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDDE2E7)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color.withOpacity(.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: 21),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: color,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 25,
                      height: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 10,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _metricsGrid() {
    final cards = <Widget>[
      _metric(
        Icons.person_add_alt_1_outlined,
        const Color(0xFFD97706),
        '${_count('unassigned_tickets')}',
        OpsFixI18n.t('Belum ditugaskan'),
        OpsFixI18n.t('Perlu ditetapkan'),
        'unassigned',
      ),
      _metric(
        Icons.report_problem_outlined,
        const Color(0xFFDC2626),
        '${_count('critical_open_tickets')}',
        OpsFixI18n.t('Prioritas kritis'),
        OpsFixI18n.t('Perlu tindakan segera'),
        'critical',
      ),
      _metric(
        Icons.timer_outlined,
        const Color(0xFF6C5CE7),
        _formatResolution(_count('average_resolution_minutes')),
        OpsFixI18n.t('Rata-rata resolusi'),
        OpsFixI18n.t('Waktu penyelesaian'),
        'completed',
      ),
      _metric(
        Icons.schedule_outlined,
        const Color(0xFFEA580C),
        '${_count('overdue_tickets')}',
        OpsFixI18n.t('Tiket terlambat'),
        OpsFixI18n.t('Melewati batas SLA'),
        'overdue',
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

  DateTime? _date(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value is DateTime) return value;
    return DateTime.tryParse(value?.toString() ?? '')?.toLocal();
  }

  int _priorityWeight(Map<String, dynamic> ticket) {
    switch (_text(ticket, 'priority').toLowerCase()) {
      case 'critical':
        return 0;
      case 'high':
        return 1;
      case 'medium':
        return 2;
      case 'low':
        return 3;
      default:
        final rank = ticket['priority_rank'];
        return rank is num ? rank.toInt() : 4;
    }
  }

  bool _isOverdue(Map<String, dynamic> ticket) {
    final due = _date(ticket, 'resolution_due_at');
    return due != null && due.isBefore(DateTime.now());
  }

  bool _isUnassigned(Map<String, dynamic> ticket) =>
      _text(ticket, 'assigned_technician_id').isEmpty;

  int _compareQueueTickets(
    Map<String, dynamic> left,
    Map<String, dynamic> right,
  ) {
    final overdue = (_isOverdue(right) ? 1 : 0) - (_isOverdue(left) ? 1 : 0);
    if (overdue != 0) return overdue;
    final priority = _priorityWeight(left).compareTo(_priorityWeight(right));
    if (priority != 0) return priority;
    final unassigned =
        (_isUnassigned(right) ? 1 : 0) - (_isUnassigned(left) ? 1 : 0);
    if (unassigned != 0) return unassigned;
    final leftDue = _date(left, 'resolution_due_at');
    final rightDue = _date(right, 'resolution_due_at');
    if (leftDue != null || rightDue != null) {
      if (leftDue == null) return 1;
      if (rightDue == null) return -1;
      final due = leftDue.compareTo(rightDue);
      if (due != 0) return due;
    }
    final leftCreated = _date(left, 'created_at') ?? DateTime(9999);
    final rightCreated = _date(right, 'created_at') ?? DateTime(9999);
    return leftCreated.compareTo(rightCreated);
  }

  String _statusLabel(String raw) {
    switch (raw.toLowerCase()) {
      case 'reported':
        return OpsFixI18n.t('Dilaporkan');
      case 'assigned':
        return OpsFixI18n.t('Ditangani');
      case 'in_progress':
        return OpsFixI18n.t('Sedang dikerjakan');
      case 'pending_verification':
        return OpsFixI18n.t('Menunggu verifikasi');
      case 'fixed':
      case 'closed':
        return OpsFixI18n.t('Selesai');
      default:
        return OpsFixI18n.t('Status belum tersedia');
    }
  }

  String _priorityLabel(String raw) {
    switch (raw.toLowerCase()) {
      case 'critical':
        return OpsFixI18n.t('Kritis');
      case 'high':
        return OpsFixI18n.t('Tinggi');
      case 'medium':
        return OpsFixI18n.t('Sedang');
      case 'low':
        return OpsFixI18n.t('Rendah');
      default:
        return OpsFixI18n.t('Normal');
    }
  }

  String _durationLabel(Duration duration) {
    final minutes = duration.inMinutes.abs();
    if (minutes < 60) return '$minutes ${OpsFixI18n.t('menit')}';
    final hours = duration.inHours.abs();
    if (hours < 24) return '$hours ${OpsFixI18n.t('jam')}';
    return '${duration.inDays.abs()} ${OpsFixI18n.t('hari')}';
  }

  String _slaLabel(Map<String, dynamic> ticket) {
    final due = _date(ticket, 'resolution_due_at');
    if (due == null) return OpsFixI18n.t('Batas SLA belum tersedia');
    final difference = due.difference(DateTime.now());
    return difference.isNegative
        ? OpsFixI18n.tf('Terlambat {0}', [_durationLabel(difference)])
        : OpsFixI18n.tf('Sisa {0}', [_durationLabel(difference)]);
  }

  Color _urgencyColor(Map<String, dynamic> ticket) {
    if (_isOverdue(ticket) ||
        _text(ticket, 'priority').toLowerCase() == 'critical') {
      return const Color(0xFFEF4444);
    }
    final due = _date(ticket, 'resolution_due_at');
    final approaching = due != null &&
        due.isAfter(DateTime.now()) &&
        due.difference(DateTime.now()) <= const Duration(hours: 2);
    if (_text(ticket, 'priority').toLowerCase() == 'high' || approaching) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF6C5CE7);
  }

  Widget _badge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w700),
        ),
      );

  void _openTicket(Map<String, dynamic> ticket) {
    final ticketId = _text(ticket, 'id');
    if (ticketId.isEmpty) return;
    context.pushNamed(
      'adminTicketDetailPage',
      queryParameters: {
        'ticketId': serializeParam(ticketId, ParamType.String),
      }.withoutNulls,
      extra: _opsFixPageFade(),
    );
  }

  Widget _ticketCard(Map<String, dynamic> ticket) {
    final urgency = _urgencyColor(ticket);
    final technician = _text(
      ticket,
      'technician_name_snapshot',
      OpsFixI18n.t('Belum ditugaskan'),
    );
    final device = _text(
      ticket,
      'unit_code_snapshot',
      _text(
        ticket,
        'target_label_snapshot',
        OpsFixI18n.t('Perangkat belum tersedia'),
      ),
    );
    final issue = _text(
      ticket,
      'issue_type_snapshot',
      OpsFixI18n.t('Gangguan belum tersedia'),
    );
    final location = _text(
      ticket,
      'location_name_snapshot',
      OpsFixI18n.t('Lokasi belum tersedia'),
    );
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final identity = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _text(ticket, 'ticket_code', OpsFixI18n.t('Tiket')),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$device · $issue',
          maxLines: wide ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF334155),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
      ],
    );
    final badges = Wrap(
      spacing: 8,
      runSpacing: 7,
      children: [
        _badge(_priorityLabel(_text(ticket, 'priority')), urgency),
        _badge(
          _statusLabel(_text(ticket, 'status')),
          const Color(0xFF6C5CE7),
        ),
      ],
    );
    final assignment = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          wide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          technician,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _isUnassigned(ticket)
                ? const Color(0xFFF59E0B)
                : const Color(0xFF334155),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _slaLabel(ticket),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: urgency,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    final content = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: identity),
              const SizedBox(width: 18),
              Expanded(flex: 3, child: badges),
              const SizedBox(width: 18),
              Expanded(flex: 3, child: assignment),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF6C5CE7),
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              identity,
              const SizedBox(height: 10),
              badges,
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: assignment),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF6C5CE7),
                  ),
                ],
              ),
            ],
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openTicket(ticket),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 5,
                child: ColoredBox(color: urgency),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityQueue(int columns) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      OpsFixI18n.t('Antrean prioritas'),
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      OpsFixI18n.t(
                          'Pantau tiket aktif yang paling membutuhkan perhatian.'),
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 12),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => context.goNamed(
                    'adminWorkBoardPage',
                    extra: _opsFixPageFade(),
                  ),
                  icon: const Icon(Icons.view_kanban_outlined, size: 18),
                  label: Text(OpsFixI18n.t('Lihat semua di board')),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (_tickets.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.task_alt,
                        color: Color(0xFF10B981), size: 36),
                    const SizedBox(height: 10),
                    Text(
                      OpsFixI18n.t('Belum ada tiket aktif dalam antrean.'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      OpsFixI18n.t(
                          'Semua tiket aktif saat ini sudah tertangani.'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ..._tickets.map(
                (ticket) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ticketCard(ticket),
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
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 268,
                  child: _hero(),
                ),
              ),
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
