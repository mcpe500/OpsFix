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
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/verify_ops_fix_completion.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OpsFixReporterTicketDetailContent extends StatefulWidget {
  const OpsFixReporterTicketDetailContent({
    super.key,
    this.width,
    this.height,
    this.ticketId = '',
  });

  final double? width;
  final double? height;
  final String ticketId;

  @override
  State<OpsFixReporterTicketDetailContent> createState() =>
      _OpsFixReporterTicketDetailContentState();
}

class _OpsFixReporterTicketDetailContentState
    extends State<OpsFixReporterTicketDetailContent> {
  bool _loading = true;
  String? _error;
  String? _busyAttemptId;
  Map<String, dynamic>? _ticket;
  List<Map<String, dynamic>> _attempts = const [];
  List<Map<String, dynamic>> _events = const [];
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant OpsFixReporterTicketDetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ticketId != widget.ticketId) _load();
  }

  List<Map<String, dynamic>> _maps(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  Future<void> _load({bool showLoading = true}) async {
    final request = ++_request;
    final ticketId = widget.ticketId.trim();
    final siteId = FFAppState().currentSiteId.trim();
    if (ticketId.isEmpty || siteId.isEmpty || currentUserUid.isEmpty) {
      if (!mounted || request != _request) return;
      setState(() {
        _loading = false;
        _error = 'invalid';
        _ticket = null;
        _attempts = const [];
        _events = const [];
      });
      return;
    }
    if (showLoading && mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final rawTicket = await SupaFlow.client
          .from('ticket_detail_v')
          .select()
          .eq('id', ticketId)
          .eq('reporter_id', currentUserUid)
          .eq('site_id', siteId)
          .maybeSingle();
      if (rawTicket == null) {
        if (!mounted || request != _request) return;
        setState(() {
          _loading = false;
          _error = 'not_found';
          _ticket = null;
          _attempts = const [];
          _events = const [];
        });
        return;
      }
      final results = await Future.wait<dynamic>([
        SupaFlow.client
            .from('ticket_events')
            .select()
            .eq('ticket_id', ticketId)
            .order('created_at', ascending: true),
        SupaFlow.client
            .from('completion_attempts')
            .select()
            .eq('ticket_id', ticketId)
            .order('attempt_number', ascending: true),
      ]);
      if (!mounted || request != _request) return;
      setState(() {
        _ticket = Map<String, dynamic>.from(rawTicket);
        _events = _maps(results[0]);
        _attempts = _maps(results[1]);
        _loading = false;
        _error = null;
      });
    } catch (error) {
      debugPrint('Reporter ticket detail load failed: ${error.runtimeType}');
      if (!mounted || request != _request) return;
      setState(() {
        _loading = false;
        if (_ticket == null) _error = 'network';
      });
    }
  }

  String _text(Map<String, dynamic> row, String key, [String fallback = '—']) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  String _status(String raw) => OpsFixI18n.t(
        switch (raw) {
          'reported' => 'Baru dilaporkan',
          'assigned' => 'Teknisi ditetapkan',
          'in_progress' => 'Sedang dikerjakan',
          'pending_verification' => 'Menunggu verifikasi',
          'reopened' => 'Dibuka kembali',
          'fixed' => 'Selesai',
          'waiting_parts' => 'Menunggu suku cadang',
          'on_hold' => 'Ditunda',
          'escalated' => 'Ditingkatkan',
          'rejected' => 'Ditolak',
          'cancelled' => 'Dibatalkan',
          _ => 'Status diperbarui',
        },
        context,
      );

  String _priority(String raw) => OpsFixI18n.t(
        switch (raw) {
          'critical' => 'Kritis',
          'high' => 'Tinggi',
          'medium' => 'Sedang',
          'low' => 'Rendah',
          _ => 'Belum ditetapkan',
        },
        context,
      );

  String _eventTitle(String raw) => OpsFixI18n.t(
        switch (raw) {
          'ticket_created' || 'reported' => 'Laporan dibuat',
          'assigned' || 'assignment_changed' => 'Teknisi ditetapkan',
          'work_started' || 'in_progress' => 'Pekerjaan dimulai',
          'completion_submitted' ||
          'pending_verification' =>
            'Hasil perbaikan dikirim',
          'completion_accepted' || 'fixed' => 'Perbaikan diterima',
          'completion_reopened' || 'reopened' => 'Tiket dibuka kembali',
          'affected_joined' => 'Pengguna lain terdampak',
          _ => 'Aktivitas tiket',
        },
        context,
      );

  Future<void> _verify(
    Map<String, dynamic> attempt,
    String decision,
  ) async {
    final attemptId = _text(attempt, 'id', '');
    if (_busyAttemptId != null || attemptId.isEmpty) return;
    setState(() => _busyAttemptId = attemptId);
    try {
      await verifyOpsFixCompletion(
        widget.ticketId.trim(),
        attemptId,
        decision,
        decision == 'accepted'
            ? 'Diterima oleh pelapor.'
            : 'Masalah masih terlihat.',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(OpsFixI18n.t(
            decision == 'accepted'
                ? 'Perbaikan diterima.'
                : 'Tiket dibuka kembali.',
            context,
          )),
        ),
      );
      await _load(showLoading: false);
    } catch (error) {
      debugPrint('Reporter verification failed: ${error.runtimeType}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            OpsFixI18n.t('Verifikasi gagal. Silakan coba lagi.', context),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _busyAttemptId = null);
    }
  }

  BoxDecoration _surface({Color color = Colors.white}) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      );

  Widget _hero(Map<String, dynamic> ticket) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1426),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              OpsFixI18n.t('PELACAKAN TIKET', context),
              style: const TextStyle(
                color: Color(0xFFA5B4FC),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: Text(
                  _text(ticket, 'ticket_code'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF99F6E4),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF17233D),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _status(_text(ticket, 'status', '')),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 14),
            Text(
              _text(ticket, 'target_label_snapshot'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _text(ticket, 'issue_type_snapshot'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 11),
            Text(
              _text(ticket, 'description'),
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 13),
            Row(children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF94A3B8),
                size: 18,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _text(ticket, 'location_name_snapshot'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                  ),
                ),
              ),
            ]),
          ],
        ),
      );

  Widget _fact(IconData icon, String label, String value) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 15, color: const Color(0xFF64748B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );

  Widget _information(Map<String, dynamic> ticket) => Container(
        padding: const EdgeInsets.all(17),
        decoration: _surface(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              OpsFixI18n.t('Informasi laporan', context),
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 13),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth >= 430 ? 2 : 1;
              const gap = 10.0;
              final itemWidth = columns == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - gap) / 2;
              final facts = <Widget>[
                _fact(
                  Icons.sync_outlined,
                  OpsFixI18n.t('Status', context),
                  _status(_text(ticket, 'status', '')),
                ),
                _fact(
                  Icons.priority_high,
                  OpsFixI18n.t('Prioritas', context),
                  _priority(_text(ticket, 'priority', '')),
                ),
                _fact(
                  Icons.computer_outlined,
                  OpsFixI18n.t('Unit', context),
                  _text(ticket, 'unit_code_snapshot'),
                ),
                _fact(
                  Icons.engineering_outlined,
                  OpsFixI18n.t('Teknisi', context),
                  _text(
                    ticket,
                    'technician_name_snapshot',
                    OpsFixI18n.t('Belum ditetapkan', context),
                  ),
                ),
                _fact(
                  Icons.category_outlined,
                  OpsFixI18n.t('Kategori', context),
                  _text(ticket, 'issue_category_snapshot'),
                ),
              ];
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: facts
                    .map((fact) => SizedBox(width: itemWidth, child: fact))
                    .toList(),
              );
            }),
          ],
        ),
      );

  Widget _attemptActions(Map<String, dynamic> attempt, double width) {
    final attemptId = _text(attempt, 'id', '');
    final busy = _busyAttemptId == attemptId;
    final accept = ElevatedButton.icon(
      onPressed:
          _busyAttemptId == null ? () => _verify(attempt, 'accepted') : null,
      icon: busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.check_circle_outline, size: 18),
      label: Text(OpsFixI18n.t('Terima', context)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
    final reopen = OutlinedButton.icon(
      onPressed:
          _busyAttemptId == null ? () => _verify(attempt, 'reopened') : null,
      icon: const Icon(Icons.restart_alt, size: 18),
      label: Text(OpsFixI18n.t('Buka lagi', context)),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6C5CE7),
        side: const BorderSide(color: Color(0xFF8B7CF6)),
        minimumSize: const Size(0, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
    if (width < 280) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [accept, const SizedBox(height: 9), reopen],
      );
    }
    return Row(children: [
      Expanded(child: accept),
      const SizedBox(width: 9),
      Expanded(child: reopen),
    ]);
  }

  Widget _attempt(Map<String, dynamic> attempt) => LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = constraints.maxWidth >= 700;
          final note = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  OpsFixI18n.tf(
                    'Percobaan {0}',
                    [attempt['attempt_number'] ?? '—'],
                    context,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                _text(attempt, 'note'),
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          );
          final actions = _attemptActions(
            attempt,
            horizontal ? 340 : constraints.maxWidth,
          );
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: horizontal
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: note),
                      const SizedBox(width: 24),
                      SizedBox(width: 340, child: actions),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      note,
                      const SizedBox(height: 13),
                      actions,
                    ],
                  ),
          );
        },
      );

  Widget _verification() => Container(
        padding: const EdgeInsets.all(17),
        decoration: _surface(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  color: Color(0xFF6C5CE7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      OpsFixI18n.t('Verifikasi perbaikan', context),
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      OpsFixI18n.t(
                        'Periksa catatan hasil teknisi. Terima jika masalah selesai, atau buka kembali bila masih bermasalah.',
                        context,
                      ),
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 15),
            if (_attempts.isEmpty)
              _empty(
                Icons.build_circle_outlined,
                OpsFixI18n.t('Belum ada hasil perbaikan.', context),
              )
            else
              ..._attempts.expand(
                (attempt) => [
                  _attempt(attempt),
                  if (attempt != _attempts.last) const SizedBox(height: 10),
                ],
              ),
          ],
        ),
      );

  Widget _timelineEvent(Map<String, dynamic> event) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.history,
                color: Color(0xFF6C5CE7),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _eventTitle(_text(event, 'event_type', '')),
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _text(event, 'message'),
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _timeline() => Container(
        padding: const EdgeInsets.all(17),
        decoration: _surface(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.timeline_outlined,
                  color: Color(0xFF6C5CE7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  OpsFixI18n.t('Linimasa tiket', context),
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 15),
            if (_events.isEmpty)
              _empty(
                Icons.history_toggle_off,
                OpsFixI18n.t('Belum ada aktivitas tiket.', context),
              )
            else
              ..._events.expand(
                (event) => [
                  _timelineEvent(event),
                  if (event != _events.last) const SizedBox(height: 9),
                ],
              ),
          ],
        ),
      );

  Widget _empty(IconData icon, String message) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(children: [
          Icon(icon, color: const Color(0xFF94A3B8), size: 28),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ]),
      );

  Widget _feedback() {
    final invalid = _error == 'invalid';
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: _surface(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(
            invalid ? Icons.link_off : Icons.lock_outline,
            color: const Color(0xFF6C5CE7),
            size: 34,
          ),
          const SizedBox(height: 12),
          Text(
            OpsFixI18n.t(
              invalid
                  ? 'Tiket tidak valid'
                  : 'Detail tiket tidak dapat diakses.',
              context,
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(OpsFixI18n.t('Coba lagi', context)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6C5CE7),
              side: const BorderSide(color: Color(0xFF8B7CF6)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _loaded(Map<String, dynamic> ticket, double availableWidth) {
    final topSplit = availableWidth >= 680;
    final hero = _hero(ticket);
    final information = _information(ticket);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (topSplit)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: hero),
              const SizedBox(width: 16),
              Expanded(flex: 7, child: information),
            ],
          )
        else ...[
          hero,
          const SizedBox(height: 16),
          information,
        ],
        const SizedBox(height: 16),
        _verification(),
        const SizedBox(height: 16),
        _timeline(),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(color: Color(0xFF6C5CE7)),
          const SizedBox(height: 12),
          Text(
            OpsFixI18n.t('Memuat detail tiket...', context),
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ]),
      );
    }
    if (_ticket == null) return _feedback();
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final padding = screenWidth < 480
          ? 14.0
          : screenWidth < 800
              ? 20.0
              : screenWidth < 1200
                  ? 24.0
                  : 28.0;
      final maxWidth = screenWidth >= 1200 ? 1280.0 : 1120.0;
      return RefreshIndicator(
        color: const Color(0xFF6C5CE7),
        onRefresh: () => _load(showLoading: false),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(padding),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: LayoutBuilder(
                builder: (context, contentConstraints) => _loaded(
                  _ticket!,
                  contentConstraints.maxWidth,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
