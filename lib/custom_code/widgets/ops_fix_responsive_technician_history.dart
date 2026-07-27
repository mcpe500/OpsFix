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

Map<String, dynamic> _historyFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 180),
      ),
    };

class OpsFixResponsiveTechnicianHistory extends StatefulWidget {
  const OpsFixResponsiveTechnicianHistory({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixResponsiveTechnicianHistory> createState() =>
      _OpsFixResponsiveTechnicianHistoryState();
}

class _OpsFixResponsiveTechnicianHistoryState
    extends State<OpsFixResponsiveTechnicianHistory> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _tickets = const [];

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
      var query = SupaFlow.client
          .from('ticket_cards_v')
          .select('id,ticket_code,status,target_label_snapshot,'
              'issue_type_snapshot,location_name_snapshot,'
              'unit_code_snapshot,updated_at')
          .eq('assigned_technician_id', currentUserUid)
          .inFilter('status', const ['fixed', 'closed']);
      final siteId = FFAppState().currentSiteId.trim();
      if (siteId.isNotEmpty) query = query.eq('site_id', siteId);
      final rows = await query.order('updated_at', ascending: false);
      if (!mounted) return;
      setState(() {
        _tickets = (rows as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _loading = false;
      });
    } catch (error) {
      debugPrint('Responsive technician history load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Riwayat pekerjaan belum dapat dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  String _text(Map<String, dynamic> row, String key, String fallback) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  DateTime? _time(dynamic raw) =>
      DateTime.tryParse(raw?.toString() ?? '')?.toLocal();

  String _date(dynamic raw) {
    final value = _time(raw);
    if (value == null) return 'Waktu tidak tersedia';
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year} · '
        '${two(value.hour)}:${two(value.minute)}';
  }

  int get _completedToday {
    final now = DateTime.now();
    return _tickets.where((ticket) {
      final value = _time(ticket['updated_at']);
      return value != null &&
          value.year == now.year &&
          value.month == now.month &&
          value.day == now.day;
    }).length;
  }

  void _go(String route) => context.goNamed(route, extra: _historyFade());
  void _push(String route) => context.pushNamed(route, extra: _historyFade());
  void _open(String id) {
    if (id.isEmpty) return;
    context.pushNamed('technicianTicketDetailPage',
        extra: _historyFade(),
        queryParameters:
            {'ticketId': serializeParam(id, ParamType.String)}.withoutNulls);
  }

  void _notificationInfo() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pembaruan tugas tersedia pada daftar tugas.')),
      );

  Widget _circleButton(
          IconData icon, Color color, Color fill, VoidCallback action) =>
      IconButton(
        onPressed: action,
        icon: Icon(icon, color: color, size: 24),
        style: IconButton.styleFrom(
            backgroundColor: fill, minimumSize: const Size(42, 42)),
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
                          Text('Riwayat pekerjaan',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827))),
                          Text(
                              'Tinjau pekerjaan yang telah selesai dan ditutup.',
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
          _sideItem(Icons.task_alt_outlined, 'Tugas', 'technicianTasksPage'),
          const SizedBox(height: 8),
          _sideItem(Icons.history, 'Riwayat', 'technicianHistoryPage',
              active: true),
          const Spacer(),
          Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: const Color(0xFF13213A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF253451))),
              child: const Row(children: [
                CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF6C5CE7),
                    child: Icon(Icons.person_outline,
                        color: Colors.white, size: 19)),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Profil teknisi',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      Text('Akun aktif',
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
          const Text('TEKNISI · RIWAYAT',
              style: TextStyle(
                  fontSize: 12,
                  letterSpacing: .35,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B))),
          const SizedBox(height: 9),
          Text('Pekerjaan yang\nsudah selesai.',
              maxLines: 2,
              style: TextStyle(
                  fontSize: desktop ? 44 : 38,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0B1324))),
          const SizedBox(height: 12),
          const Text(
              'Tinjau kembali perbaikan yang telah ditutup beserta lokasi '
              'dan detail laporannya.',
              style: TextStyle(
                  fontSize: 16, height: 1.45, color: Color(0xFF718096))),
        ],
      );

  Widget _statCard(IconData icon, Color accent, String value, String label) =>
      Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFDDE2E7))),
        child: Row(children: [
          Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: accent.withOpacity(.1),
                  borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: accent, size: 24)),
          const SizedBox(width: 13),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _loading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: accent))
                    : Text(value,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0B1324))),
                const SizedBox(height: 3),
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF64748B))),
              ])),
        ]),
      );

  Widget _stats() => Row(children: [
        Expanded(
            child: _statCard(Icons.task_alt, const Color(0xFF10B981),
                '${_tickets.length}', 'Total pekerjaan selesai')),
        const SizedBox(width: 10),
        Expanded(
            child: _statCard(Icons.today_outlined, const Color(0xFF6C5CE7),
                '$_completedToday', 'Selesai hari ini')),
      ]);

  Widget _card(Map<String, dynamic> ticket) {
    final closed = ticket['status']?.toString().toLowerCase() == 'closed';
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
            Row(children: [
              Expanded(
                  child: Text(_text(ticket, 'ticket_code', 'Tiket'),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4F46E5)))),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(14)),
                  child: Text(closed ? 'Ditutup' : 'Selesai',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF047857)))),
            ]),
            const SizedBox(height: 9),
            Text(_text(ticket, 'target_label_snapshot', 'Unit fasilitas'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827))),
            const SizedBox(height: 4),
            Text(_text(ticket, 'issue_type_snapshot', 'Gangguan fasilitas'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 11),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.location_on_outlined,
                  size: 18, color: Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(
                      '${_text(ticket, 'location_name_snapshot', 'Lokasi belum tersedia')} · '
                      '${_text(ticket, 'unit_code_snapshot', 'Unit belum tersedia')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF475569)))),
            ]),
            const SizedBox(height: 6),
            Text('Selesai ${_date(ticket['updated_at'])}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            const SizedBox(height: 12),
            OutlinedButton.icon(
                onPressed: () => _open(ticket['id']?.toString() ?? ''),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Lihat detail')),
          ]),
    );
  }

  Widget _historyGrid({required bool twoColumns}) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDDE2E7))),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Riwayat perbaikan',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827))),
              const SizedBox(height: 3),
              const Text('Pekerjaan selesai dan tiket yang telah ditutup.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 13),
              const Divider(height: 1),
              const SizedBox(height: 13),
              if (_loading)
                const Padding(
                    padding: EdgeInsets.all(28),
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
                        horizontal: 16, vertical: 30),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16)),
                    child:
                        const Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.history, color: Color(0xFF94A3B8), size: 32),
                      SizedBox(height: 9),
                      Text('Belum ada pekerjaan yang selesai.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569))),
                    ]))
              else if (twoColumns)
                LayoutBuilder(builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 12) / 2;
                  return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _tickets
                          .map((ticket) =>
                              SizedBox(width: cardWidth, child: _card(ticket)))
                          .toList());
                })
              else
                ..._tickets.asMap().entries.expand((entry) => [
                      _card(entry.value),
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
              child: InkWell(
                  onTap: () => _go('technicianTasksPage'),
                  borderRadius: BorderRadius.circular(14),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt,
                            color: Color(0xFF98A2B3), size: 26),
                        SizedBox(height: 5),
                        Text('Tugas',
                            style: TextStyle(color: Color(0xFF98A2B3))),
                      ]))),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0EDFF),
                      borderRadius: BorderRadius.circular(14)),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, color: Color(0xFF6C5CE7), size: 26),
                        SizedBox(height: 5),
                        Text('Riwayat',
                            style: TextStyle(color: Color(0xFF6C5CE7))),
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
                          Expanded(flex: 5, child: _intro(desktop: true)),
                          const SizedBox(width: 28),
                          Expanded(flex: 5, child: _stats()),
                        ])
                  else ...[
                    _intro(desktop: false),
                    const SizedBox(height: 18),
                    _stats(),
                  ],
                  const SizedBox(height: 22),
                  _historyGrid(twoColumns: desktop || tablet),
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
