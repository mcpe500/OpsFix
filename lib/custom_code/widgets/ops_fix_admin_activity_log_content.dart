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

class OpsFixAdminActivityLogContent extends StatefulWidget {
  const OpsFixAdminActivityLogContent({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<OpsFixAdminActivityLogContent> createState() =>
      OpsFixAdminActivityLogContentState();
}

class OpsFixAdminActivityLogContentState
    extends State<OpsFixAdminActivityLogContent> {
  static const _selectFields =
      'id,event_type,message,reason,actor_name_snapshot,'
      'actor_role_snapshot,from_status,to_status,created_at';

  List<Map<String, dynamic>> _events = [];
  bool _loading = true;
  bool _refreshing = false;
  String? _error;
  int _requestSerial = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadEvents());
  }

  @override
  void dispose() {
    _requestSerial++;
    super.dispose();
  }

  Future<void> refresh() => _loadEvents();

  Future<void> _loadEvents() async {
    final request = ++_requestSerial;
    final siteId = FFAppState().currentSiteId.trim();

    if (siteId.isEmpty) {
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _events = [];
        _error = 'Site aktif belum tersedia. Masuk ulang lalu coba lagi.';
      });
      return;
    }

    if (mounted) {
      setState(() {
        _error = null;
        _loading = _events.isEmpty;
        _refreshing = _events.isNotEmpty;
      });
    }

    try {
      final response = await SupaFlow.client
          .from('ticket_events')
          .select(_selectFields)
          .eq('site_id', siteId)
          .order('created_at', ascending: false)
          .limit(100);
      final rows = (response as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _events = rows;
        _loading = false;
        _refreshing = false;
        _error = null;
      });
    } catch (error) {
      debugPrint('Admin activity log load failed: ${error.runtimeType}');
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _error = 'Riwayat aktivitas belum dapat dimuat. Coba lagi.';
      });
    }
  }

  String _value(Map<String, dynamic> event, String key) {
    return event[key]?.toString().trim() ?? '';
  }

  String _status(String value) => switch (value) {
        'reported' => 'Dilaporkan',
        'assigned' => 'Ditangani',
        'in_progress' => 'Sedang dikerjakan',
        'pending_verification' => 'Menunggu verifikasi',
        'fixed' => 'Selesai',
        'closed' => 'Ditutup',
        'reopened' => 'Dibuka kembali',
        'rejected' => 'Ditolak',
        'cancelled' => 'Dibatalkan',
        _ => value.isEmpty ? 'Belum tersedia' : value.replaceAll('_', ' '),
      };

  String _title(String type) => switch (type) {
        'ticket_created' => 'Laporan dibuat',
        'assignment_created' => 'Teknisi ditugaskan',
        'assignment_accepted' => 'Penugasan diterima',
        'work_started' => 'Pekerjaan dimulai',
        'completion_submitted' => 'Hasil perbaikan dikirim',
        'ticket_verified' => 'Perbaikan diverifikasi',
        'ticket_reopened' => 'Tiket dibuka kembali',
        'status_changed' => 'Status tiket diperbarui',
        _ => 'Aktivitas tiket',
      };

  String _description(Map<String, dynamic> event) {
    final message = _value(event, 'message');
    final from = _value(event, 'from_status');
    final to = _value(event, 'to_status');
    if (from.isNotEmpty || to.isNotEmpty) {
      return 'Status berubah dari ${_status(from)} menjadi ${_status(to)}.';
    }
    if (message.isNotEmpty) return message;
    final reason = _value(event, 'reason');
    return reason.isEmpty ? 'Perubahan tercatat pada sistem.' : reason;
  }

  DateTime? _dateValue(dynamic raw) {
    return DateTime.tryParse(raw?.toString() ?? '')?.toLocal();
  }

  String _date(dynamic raw) {
    final date = _dateValue(raw);
    if (date == null) return 'Waktu tidak tersedia';
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} · '
        '${two(date.hour)}:${two(date.minute)}';
  }

  String _actor(Map<String, dynamic> event) {
    final actor = _value(event, 'actor_name_snapshot');
    final role = _value(event, 'actor_role_snapshot');
    if (actor.isEmpty) return 'Sistem OpsFix';
    return role.isEmpty ? actor : '$actor · ${_status(role)}';
  }

  _EventVisual _visual(String type) {
    if (type == 'ticket_created') {
      return const _EventVisual(
        Icons.campaign_outlined,
        Color(0xFF2563EB),
        Color(0xFFEFF6FF),
      );
    }
    if (type.startsWith('assignment_')) {
      return const _EventVisual(
        Icons.person_pin_circle_outlined,
        Color(0xFF6C5CE7),
        Color(0xFFF0EDFF),
      );
    }
    if (type == 'work_started') {
      return const _EventVisual(
        Icons.engineering_outlined,
        Color(0xFFD97706),
        Color(0xFFFFF7ED),
      );
    }
    if (type == 'completion_submitted' || type == 'ticket_verified') {
      return const _EventVisual(
        Icons.task_alt_rounded,
        Color(0xFF059669),
        Color(0xFFECFDF5),
      );
    }
    if (type == 'ticket_reopened' || type == 'ticket_rejected') {
      return const _EventVisual(
        Icons.replay_rounded,
        Color(0xFFDC2626),
        Color(0xFFFEF2F2),
      );
    }
    return const _EventVisual(
      Icons.history_rounded,
      Color(0xFF64748B),
      Color(0xFFF1F5F9),
    );
  }

  int get _actorCount {
    return _events
        .map((event) => _value(event, 'actor_name_snapshot'))
        .where((actor) => actor.isNotEmpty)
        .toSet()
        .length;
  }

  String get _latestEventTime {
    if (_events.isEmpty) return 'Belum tersedia';
    return _date(_events.first['created_at']);
  }

  Widget _intro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1426),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADMIN · AUDIT LOG',
            style: TextStyle(
              color: Color(0xFFB9B1FF),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Setiap perubahan dapat diaudit.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Aktivitas diurutkan dari kejadian terbaru pada site aktif.',
            style: TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryFact(
    IconData icon,
    String label,
    String value, {
    bool compact = false,
  }) {
    return Container(
      padding: EdgeInsets.all(compact ? 13 : 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 19, color: const Color(0xFF6C5CE7)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: compact ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(double availableWidth) {
    final compact = availableWidth < 480;
    final facts = [
      _summaryFact(
        Icons.receipt_long_outlined,
        'Aktivitas dimuat',
        '${_events.length} dari maksimal 100',
        compact: compact,
      ),
      _summaryFact(
        Icons.group_outlined,
        'Aktor tercatat',
        '$_actorCount aktor',
        compact: compact,
      ),
      _summaryFact(
        Icons.schedule_rounded,
        'Aktivitas terbaru',
        _latestEventTime,
        compact: compact,
      ),
    ];

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          facts[0],
          const SizedBox(height: 9),
          facts[1],
          const SizedBox(height: 9),
          facts[2],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: facts[0]),
        const SizedBox(width: 10),
        Expanded(child: facts[1]),
        const SizedBox(width: 10),
        Expanded(child: facts[2]),
      ],
    );
  }

  Widget _topSection(double availableWidth) {
    if (availableWidth < 680) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _intro(),
          const SizedBox(height: 14),
          _summary(availableWidth),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _intro()),
        const SizedBox(width: 16),
        Expanded(flex: 7, child: _summary(availableWidth)),
      ],
    );
  }

  Widget _eventIcon(Map<String, dynamic> event, {double size = 38}) {
    final visual = _visual(_value(event, 'event_type'));
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: visual.tint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(visual.icon, size: 20, color: visual.color),
    );
  }

  Widget _eventBadge(Map<String, dynamic> event) {
    final visual = _visual(_value(event, 'event_type'));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: visual.tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _title(_value(event, 'event_type')),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: visual.color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _phoneCard(Map<String, dynamic> event) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eventIcon(event),
              const SizedBox(width: 11),
              Expanded(child: _eventBadge(event)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _description(event),
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 13,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 11),
          const Divider(height: 1, color: Color(0xFFE8ECF0)),
          const SizedBox(height: 10),
          Text(
            _actor(event),
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _date(event['created_at']),
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _structuredCard(
    Map<String, dynamic> event,
    double availableWidth,
  ) {
    final metadataWidth = availableWidth < 680 ? 155.0 : 210.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _eventIcon(event),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _eventBadge(event),
                const SizedBox(height: 8),
                Text(
                  _description(event),
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 13,
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: metadataWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AKTOR',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _actor(event),
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  _date(event['created_at']),
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    const style = TextStyle(
      color: Color(0xFF64748B),
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.55,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Color(0xFFDDE2E7)),
        ),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('AKTIVITAS', style: style)),
          SizedBox(width: 16),
          Expanded(flex: 5, child: Text('DETAIL', style: style)),
          SizedBox(width: 16),
          Expanded(flex: 3, child: Text('AKTOR', style: style)),
          SizedBox(width: 16),
          Expanded(flex: 2, child: Text('WAKTU', style: style)),
        ],
      ),
    );
  }

  Widget _tableRow(Map<String, dynamic> event, {required bool last}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: last
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFE8ECF0)),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _eventIcon(event, size: 34),
                const SizedBox(width: 10),
                Expanded(child: _eventBadge(event)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Text(
              _description(event),
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 13,
                height: 1.42,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              _actor(event),
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              _date(event['created_at']),
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventRegistry(double availableWidth) {
    if (_events.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 42),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              color: Color(0xFF94A3B8),
              size: 36,
            ),
            SizedBox(height: 10),
            Text(
              'Belum ada aktivitas yang tercatat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (availableWidth >= 900) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDDE2E7)),
          ),
          child: Column(
            children: [
              _tableHeader(),
              for (var index = 0; index < _events.length; index++)
                _tableRow(
                  _events[index],
                  last: index == _events.length - 1,
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        for (var index = 0; index < _events.length; index++) ...[
          if (availableWidth < 480)
            _phoneCard(_events[index])
          else
            _structuredCard(_events[index], availableWidth),
          if (index != _events.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _loadingState() {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 2.7,
          color: Color(0xFF6C5CE7),
        ),
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1C9C9)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFDC2626),
                size: 34,
              ),
              const SizedBox(height: 12),
              Text(
                _error ?? 'Riwayat aktivitas tidak tersedia.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: refresh,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba lagi'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return _loadingState();
    if (_error != null && _events.isEmpty) return _errorState();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 480
        ? 14.0
        : screenWidth < 800
            ? 20.0
            : screenWidth < 1200
                ? 24.0
                : 32.0;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RefreshIndicator(
        onRefresh: refresh,
        color: const Color(0xFF6C5CE7),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            28,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1440),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _topSection(availableWidth),
                        if (_refreshing) ...[
                          const SizedBox(height: 10),
                          const LinearProgressIndicator(
                            minHeight: 2,
                            color: Color(0xFF6C5CE7),
                            backgroundColor: Color(0xFFE9E5FF),
                          ),
                        ],
                        const SizedBox(height: 22),
                        const Text(
                          'Riwayat aktivitas',
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Catatan perubahan operasional terbaru.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _eventRegistry(availableWidth),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventVisual {
  const _EventVisual(this.icon, this.color, this.tint);

  final IconData icon;
  final Color color;
  final Color tint;
}
