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
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _technicianFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 180),
      ),
    };

class OpsFixResponsiveTechnicianTasks extends StatefulWidget {
  const OpsFixResponsiveTechnicianTasks({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixResponsiveTechnicianTasks> createState() =>
      _OpsFixResponsiveTechnicianTasksState();
}

class _OpsFixResponsiveTechnicianTasksState
    extends State<OpsFixResponsiveTechnicianTasks> {
  bool _loading = true;
  String? _error;
  String _name = '';
  List<Map<String, dynamic>> _tickets = const [];
  Map<String, int> _counts = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted)
      setState(() {
        _loading = true;
        _error = null;
      });
    try {
      final siteId = FFAppState().currentSiteId.trim();
      var openQuery = SupaFlow.client
          .from('ticket_cards_v')
          .select('id,ticket_code,status,priority,target_label_snapshot,'
              'issue_type_snapshot,description,location_name_snapshot,'
              'unit_code_snapshot,updated_at,priority_rank')
          .eq('assigned_technician_id', currentUserUid)
          .eq('is_open', true);
      var countQuery = SupaFlow.client
          .from('ticket_cards_v')
          .select('status,updated_at')
          .eq('assigned_technician_id', currentUserUid);
      if (siteId.isNotEmpty) {
        openQuery = openQuery.eq('site_id', siteId);
        countQuery = countQuery.eq('site_id', siteId);
      }
      final results = await Future.wait([
        SupaFlow.client
            .from('users')
            .select('display_name')
            .eq('id', currentUserUid)
            .maybeSingle(),
        openQuery
            .order('priority_rank', ascending: true)
            .order('updated_at', ascending: false),
        countQuery,
      ]);
      final now = DateTime.now();
      var assigned = 0;
      var inProgress = 0;
      var pending = 0;
      var fixedToday = 0;
      for (final raw in results[2] as List) {
        final row = Map<String, dynamic>.from(raw as Map);
        final status = row['status']?.toString().toLowerCase() ?? '';
        if (status == 'assigned') assigned++;
        if (status == 'in_progress') inProgress++;
        if (status == 'pending_verification') pending++;
        if (status == 'fixed') {
          final updated =
              DateTime.tryParse(row['updated_at']?.toString() ?? '')?.toLocal();
          if (updated != null &&
              updated.year == now.year &&
              updated.month == now.month &&
              updated.day == now.day) {
            fixedToday++;
          }
        }
      }
      if (!mounted) return;
      final user = results[0] as Map<String, dynamic>?;
      setState(() {
        _name = user?['display_name']?.toString().trim() ?? '';
        _tickets = (results[1] as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _counts = {
          'assigned': assigned,
          'in_progress': inProgress,
          'pending_verification': pending,
          'fixed_today': fixedToday,
        };
        _loading = false;
      });
    } catch (error) {
      debugPrint('Responsive technician tasks load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Daftar tugas belum dapat dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  String get _displayName => _name.isEmpty ? 'Teknisi OpsFix' : _name;
  String _status(String raw) => switch (raw.toLowerCase()) {
        'assigned' => 'Siap dimulai',
        'in_progress' => 'Sedang dikerjakan',
        'pending_verification' => 'Menunggu verifikasi',
        _ => 'Dalam penanganan',
      };
  Color _statusColor(String raw) => switch (raw.toLowerCase()) {
        'assigned' => const Color(0xFF4F46E5),
        'in_progress' => const Color(0xFFD97706),
        'pending_verification' => const Color(0xFF2563EB),
        _ => const Color(0xFF64748B),
      };

  void _go(String route) => context.goNamed(route, extra: _technicianFade());
  void _push(String route) =>
      context.pushNamed(route, extra: _technicianFade());
  void _open(String id) {
    if (id.isEmpty) return;
    context.pushNamed('technicianTicketDetailPage',
        extra: _technicianFade(),
        queryParameters:
            {'ticketId': serializeParam(id, ParamType.String)}.withoutNulls);
  }

  Widget _circleButton(
          IconData icon, Color color, Color fill, VoidCallback action) =>
      IconButton(
        onPressed: action,
        icon: Icon(icon, color: color, size: 24),
        style: IconButton.styleFrom(
            backgroundColor: fill, minimumSize: const Size(42, 42)),
      );

  void _notificationInfo() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pembaruan tugas tersedia pada daftar tugas.')),
      );

  Widget _header({required bool desktop}) => Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 16),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
        child: Row(children: [
          Expanded(
              child: desktop
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text('Daftar tugas',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827))),
                          Text(
                              'Kelola pekerjaan aktif sesuai prioritas dan status.',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF64748B))),
                        ])
                  : const Row(children: [
                      Icon(Icons.engineering_outlined,
                          color: Color(0xFF6C5CE7), size: 25),
                      SizedBox(width: 8),
                      Text('OpsFix',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827))),
                      SizedBox(width: 8),
                      DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color(0xFFF0EDFF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 5),
                              child: Text('Teknisi',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF6C5CE7))))),
                    ])),
          _circleButton(Icons.notifications_none, const Color(0xFF111827),
              const Color(0xFFF8FAFC), _notificationInfo),
          const SizedBox(width: 8),
          _circleButton(Icons.person_outline, const Color(0xFF065F46),
              const Color(0xFFD1FAE5), () => _push('TechnicianProfilePage')),
        ]),
      );

  Widget _sideItem(IconData icon, String label, String route,
          {bool active = false}) =>
      InkWell(
        onTap: active ? null : () => _go(route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
              color: active ? const Color(0xFF6C5CE7) : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Icon(icon,
                size: 21,
                color: active ? Colors.white : const Color(0xFFAAB6CC)),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: active ? Colors.white : const Color(0xFFD8E0EF),
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500)),
          ]),
        ),
      );

  Widget _sidebar() => Container(
        width: 252,
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
        color: const Color(0xFF081225),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Row(children: [
            CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFF6C5CE7),
                child: Icon(Icons.engineering_outlined,
                    color: Colors.white, size: 23)),
            SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('OpsFix',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700)),
              Text('Portal teknisi',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 36),
          _sideItem(Icons.task_alt_outlined, 'Tugas', 'technicianTasksPage',
              active: true),
          const SizedBox(height: 8),
          _sideItem(Icons.history, 'Riwayat', 'technicianHistoryPage'),
          const Spacer(),
          Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: const Color(0xFF13213A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF253451))),
              child: Row(children: [
                CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF6C5CE7),
                    child: Text(_displayName[0].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700))),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(_displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Text('Teknisi',
                          style: TextStyle(
                              color: Color(0xFF94A3B8), fontSize: 10)),
                    ])),
              ])),
        ]),
      );

  Widget _intro({required bool desktop}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('TEKNISI · ${_displayName.toUpperCase()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12,
                  letterSpacing: .35,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B))),
          const SizedBox(height: 9),
          Text('Tugas yang perlu\nAnda kerjakan.',
              maxLines: 2,
              style: TextStyle(
                  fontSize: desktop ? 46 : 44,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0B1324))),
          const SizedBox(height: 12),
          const Text(
              'Mulai tugas yang siap dikerjakan, lanjutkan pekerjaan aktif, '
              'lalu kirim hasil perbaikan.',
              style: TextStyle(
                  fontSize: 16, height: 1.45, color: Color(0xFF718096))),
          const SizedBox(height: 14),
          OutlinedButton(
              onPressed: () => _go('technicianHistoryPage'),
              child: const Text('Lihat riwayat')),
        ],
      );

  Widget _kpiCard(String title, String key, String caption, Color accent) =>
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFDDE2E7))),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              _loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: accent))
                  : Text('${_counts[key] ?? 0}',
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0B1324))),
              const SizedBox(height: 4),
              Text(caption,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF718096))),
            ]),
      );

  Widget _kpis(int columns) => LayoutBuilder(builder: (context, constraints) {
        const gap = 10.0;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        final cards = [
          _kpiCard('Siap dimulai', 'assigned', 'Belum dimulai',
              const Color(0xFF6C5CE7)),
          _kpiCard('Sedang dikerjakan', 'in_progress', 'Dalam proses',
              const Color(0xFFF59E0B)),
          _kpiCard('Menunggu verifikasi', 'pending_verification',
              'Menunggu pelapor', const Color(0xFF2563EB)),
          _kpiCard('Selesai hari ini', 'fixed_today', 'Perbaikan selesai',
              const Color(0xFF10B981)),
        ];
        return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cards
                .map((card) => SizedBox(width: cardWidth, child: card))
                .toList());
      });

  Widget _ticketCard(Map<String, dynamic> ticket) {
    final status = ticket['status']?.toString() ?? '';
    String value(String key) => ticket[key]?.toString().trim() ?? '';
    final title = value('target_label_snapshot');
    final issue = value('issue_type_snapshot');
    final description = value('description');
    final location = value('location_name_snapshot');
    final unit = value('unit_code_snapshot');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Text(
                      value('ticket_code').isEmpty
                          ? 'Tiket'
                          : value('ticket_code'),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4F46E5)))),
              const SizedBox(width: 8),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                      color: _statusColor(status).withOpacity(.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(_status(status),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _statusColor(status)))),
            ]),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 9),
              Text(title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827))),
            ],
            if (issue.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(issue,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF475569))),
            ],
            if (description.isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, height: 1.35, color: Color(0xFF64748B))),
            ],
            if (location.isNotEmpty || unit.isNotEmpty) ...[
              const SizedBox(height: 11),
              Row(children: [
                const Icon(Icons.location_on_outlined,
                    size: 17, color: Color(0xFF94A3B8)),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(
                        [location, unit].where((v) => v.isNotEmpty).join(' · '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF64748B)))),
              ]),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
                onPressed: () => _open(value('id')),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Buka pekerjaan')),
          ]),
    );
  }

  Widget _queue({required bool twoColumns}) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDDE2E7))),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Antrean aktif',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827))),
              const SizedBox(height: 4),
              Text('Pekerjaan aktif yang ditugaskan kepada $_displayName.',
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 14),
              if (_loading)
                const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()))
              else if (_error != null)
                Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(14)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(_error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFB91C1C))),
                      const SizedBox(height: 10),
                      OutlinedButton(
                          onPressed: _load, child: const Text('Coba lagi')),
                    ]))
              else if (_tickets.isEmpty)
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 28),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16)),
                    child:
                        const Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.task_alt, color: Color(0xFF94A3B8), size: 32),
                      SizedBox(height: 9),
                      Text('Belum ada tiket aktif',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569))),
                      SizedBox(height: 4),
                      Text(
                          'Tiket baru akan muncul di sini setelah Anda ditugaskan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF64748B))),
                    ]))
              else if (twoColumns)
                LayoutBuilder(builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 12) / 2;
                  return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _tickets
                          .map((ticket) => SizedBox(
                              width: cardWidth, child: _ticketCard(ticket)))
                          .toList());
                })
              else
                ..._tickets.asMap().entries.expand((entry) => [
                      _ticketCard(entry.value),
                      if (entry.key < _tickets.length - 1)
                        const SizedBox(height: 10),
                    ]),
            ]),
      );

  Widget _bottomNav() => Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB)))),
        child: Row(children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0EDFF),
                      borderRadius: BorderRadius.circular(14)),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt,
                            color: Color(0xFF6C5CE7), size: 26),
                        SizedBox(height: 5),
                        Text('Tugas',
                            style: TextStyle(color: Color(0xFF6C5CE7))),
                      ]))),
          Expanded(
              child: InkWell(
                  onTap: () => _go('technicianHistoryPage'),
                  borderRadius: BorderRadius.circular(14),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, color: Color(0xFF98A2B3), size: 26),
                        SizedBox(height: 5),
                        Text('Riwayat',
                            style: TextStyle(color: Color(0xFF98A2B3))),
                      ]))),
        ]),
      );

  Widget _content({required bool desktop, required bool tablet}) =>
      RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding:
              EdgeInsets.fromLTRB(desktop ? 28 : 16, 22, desktop ? 28 : 16, 30),
          child: Center(
              child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktop ? 1280 : 960),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (desktop)
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: _intro(desktop: true)),
                          const SizedBox(width: 28),
                          Expanded(flex: 6, child: _kpis(4)),
                        ])
                  else ...[
                    _intro(desktop: false),
                    const SizedBox(height: 18),
                    _kpis(tablet ? 4 : 2),
                  ],
                  const SizedBox(height: 22),
                  _queue(twoColumns: desktop),
                ]),
          )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final desktop = screenWidth >= 1200;
    final tablet = screenWidth >= 480 && screenWidth < 1200;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(
            child: desktop
                ? Row(children: [
                    _sidebar(),
                    Expanded(
                        child: Column(children: [
                      _header(desktop: true),
                      Expanded(child: _content(desktop: true, tablet: false)),
                    ])),
                  ])
                : Column(children: [
                    _header(desktop: false),
                    Expanded(child: _content(desktop: false, tablet: tablet)),
                    _bottomNav(),
                  ])),
      ),
    );
  }
}
