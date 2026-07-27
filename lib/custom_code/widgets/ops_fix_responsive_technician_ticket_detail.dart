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
import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';

Map<String, dynamic> _detailFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 180),
      ),
    };

class OpsFixResponsiveTechnicianTicketDetail extends StatefulWidget {
  const OpsFixResponsiveTechnicianTicketDetail({
    super.key,
    this.width,
    this.height,
    this.ticketId,
  });

  final double? width;
  final double? height;
  final String? ticketId;

  @override
  State<OpsFixResponsiveTechnicianTicketDetail> createState() =>
      _OpsFixResponsiveTechnicianTicketDetailState();
}

class _OpsFixResponsiveTechnicianTicketDetailState
    extends State<OpsFixResponsiveTechnicianTicketDetail> {
  bool _loading = true;
  bool _starting = false;
  String? _error;
  Map<String, dynamic>? _ticket;
  List<Map<String, dynamic>> _events = const [];

  String get _ticketId => (widget.ticketId ?? '').trim();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_ticketId.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Tiket belum dipilih.';
      });
      return;
    }
    if (mounted)
      setState(() {
        _loading = true;
        _error = null;
      });
    try {
      var ticketQuery = SupaFlow.client
          .from('ticket_cards_v')
          .select('id,ticket_code,status,priority,target_label_snapshot,'
              'issue_type_snapshot,description,location_name_snapshot,'
              'unit_code_snapshot,reporter_name_snapshot,site_id')
          .eq('id', _ticketId)
          .eq('assigned_technician_id', currentUserUid);
      final siteId = FFAppState().currentSiteId.trim();
      if (siteId.isNotEmpty) ticketQuery = ticketQuery.eq('site_id', siteId);
      final results = await Future.wait([
        ticketQuery.maybeSingle(),
        SupaFlow.client
            .from('ticket_events')
            .select('event_type,message,actor_name_snapshot,created_at,'
                'from_status,to_status')
            .eq('ticket_id', _ticketId)
            .order('created_at', ascending: false),
      ]);
      if (!mounted) return;
      final row = results[0] as Map<String, dynamic>?;
      setState(() {
        _ticket = row == null ? null : Map<String, dynamic>.from(row);
        _events = (results[1] as List)
            .map((event) => Map<String, dynamic>.from(event as Map))
            .toList();
        _loading = false;
        _error = row == null ? 'Detail pekerjaan tidak ditemukan.' : null;
      });
    } catch (error) {
      debugPrint('Responsive technician detail load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Detail pekerjaan belum dapat dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  Future<void> _startWork() async {
    if (_starting || _ticketId.isEmpty) return;
    setState(() {
      _starting = true;
      _error = null;
    });
    try {
      await startOpsFixTicket(_ticketId);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pekerjaan berhasil dimulai.')),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() =>
            _error = 'Pekerjaan gagal dimulai. Muat ulang lalu coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  String _text(String key, String fallback) {
    final value = _ticket?[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  String get _rawStatus => _text('status', '').toLowerCase();
  String _statusLabel(String value) => switch (value.toLowerCase()) {
        'reported' => 'Baru dilaporkan',
        'assigned' => 'Siap dimulai',
        'in_progress' => 'Sedang dikerjakan',
        'pending_verification' => 'Menunggu verifikasi',
        'fixed' => 'Selesai',
        'closed' => 'Ditutup',
        'cancelled' => 'Dibatalkan',
        _ => 'Dalam penanganan',
      };
  String _priorityLabel(String value) => switch (value.toLowerCase()) {
        'critical' => 'Kritis',
        'high' => 'Tinggi',
        'medium' => 'Sedang',
        'low' => 'Rendah',
        _ => 'Belum ditentukan',
      };

  String _eventLabel(Map<String, dynamic> event) {
    final type = event['event_type']?.toString().toLowerCase() ?? '';
    final to = event['to_status']?.toString().toLowerCase() ?? '';
    if (to == 'assigned' || type.contains('assign'))
      return 'Teknisi ditugaskan';
    if (to == 'in_progress' || type.contains('start'))
      return 'Pekerjaan dimulai';
    if (to == 'pending_verification' || type.contains('completion')) {
      return 'Hasil dikirim untuk verifikasi';
    }
    if (to == 'fixed' || type.contains('fixed'))
      return 'Perbaikan dinyatakan selesai';
    if (to == 'closed' || type.contains('closed')) return 'Tiket ditutup';
    if (type.contains('report') || type.contains('create'))
      return 'Laporan dibuat';
    return 'Pembaruan pekerjaan';
  }

  String _date(dynamic raw) {
    final value = DateTime.tryParse(raw?.toString() ?? '')?.toLocal();
    if (value == null) return 'Waktu tidak tersedia';
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year} · '
        '${two(value.hour)}:${two(value.minute)}';
  }

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.goNamed('technicianTasksPage', extra: _detailFade());
    }
  }

  void _go(String route) => context.goNamed(route, extra: _detailFade());
  void _push(String route) => context.pushNamed(route, extra: _detailFade());

  Widget _header({required bool desktop}) => Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 16),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
        child: Row(children: [
          IconButton(
              onPressed: _back,
              icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
              style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Detail Pekerjaan',
                    style: TextStyle(
                        fontSize: desktop ? 21 : 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827))),
                if (desktop)
                  const Text('Tinjau informasi dan kelola progres pekerjaan.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ])),
          if (desktop) ...[
            IconButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Pembaruan tugas tersedia pada daftar tugas.'))),
                icon: const Icon(Icons.notifications_none,
                    color: Color(0xFF111827))),
            const SizedBox(width: 8),
            IconButton(
                onPressed: () => _push('TechnicianProfilePage'),
                icon:
                    const Icon(Icons.person_outline, color: Color(0xFF065F46)),
                style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFD1FAE5))),
          ],
        ]),
      );

  Widget _sideItem(IconData icon, String label, String route) => InkWell(
        onTap: () => _go(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(children: [
              Icon(icon, size: 21, color: const Color(0xFFAAB6CC)),
              const SizedBox(width: 12),
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFFD8E0EF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ])),
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
          _sideItem(Icons.history, 'Riwayat', 'technicianHistoryPage'),
          const Spacer(),
          InkWell(
              onTap: () => _push('TechnicianProfilePage'),
              borderRadius: BorderRadius.circular(14),
              child: Container(
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
                  ]))),
        ]),
      );

  BoxDecoration _cardDecoration({Color color = Colors.white}) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      );

  Widget _summaryCard() => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
            color: const Color(0xFF0B1426),
            borderRadius: BorderRadius.circular(24)),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                const Expanded(
                    child: Text('DETAIL PEKERJAAN',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF99F6E4),
                            letterSpacing: .3))),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: const Color(0xFF17233D),
                        borderRadius: BorderRadius.circular(14)),
                    child: Text(_statusLabel(_rawStatus),
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 14),
              Text(_text('ticket_code', 'Tiket'),
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFA5B4FC),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 7),
              Text(_text('target_label_snapshot', 'Unit fasilitas'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(_text('issue_type_snapshot', 'Gangguan fasilitas'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFE2E8F0),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 9),
              Text(_text('description', 'Tidak ada keterangan tambahan.'),
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFFCBD5E1), height: 1.4)),
            ]),
      );

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(top: 11),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 82,
              child: Text(label,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
          const SizedBox(width: 10),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w500))),
        ]),
      );

  Widget _informationCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: _cardDecoration(),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Informasi pekerjaan',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827))),
              _infoRow('Status', _statusLabel(_rawStatus)),
              _infoRow('Prioritas', _priorityLabel(_text('priority', ''))),
              _infoRow(
                  'Lokasi', _text('location_name_snapshot', 'Belum tersedia')),
              _infoRow('Unit', _text('unit_code_snapshot', 'Belum tersedia')),
              _infoRow(
                  'Pelapor', _text('reporter_name_snapshot', 'Belum tersedia')),
            ]),
      );

  Widget _notice(IconData icon, Color color, String title, String body) =>
      Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
              color: color.withOpacity(.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827))),
                  const SizedBox(height: 4),
                  Text(body,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          height: 1.35)),
                ])),
          ]));

  Widget _actionCard() {
    if (_rawStatus == 'assigned') {
      return Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Siap dikerjakan',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827))),
                const SizedBox(height: 5),
                const Text(
                    'Mulai pekerjaan saat Anda sudah berada di lokasi dan siap menangani unit.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const SizedBox(height: 14),
                FilledButton.icon(
                    onPressed: _starting ? null : _startWork,
                    icon: _starting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.play_arrow),
                    label: Text(_starting ? 'Memulai…' : 'Mulai pekerjaan')),
              ]));
    }
    if (_rawStatus == 'in_progress') {
      return Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Kirim hasil perbaikan',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827))),
                const SizedBox(height: 5),
                const Text(
                    'Tambahkan catatan dan foto hasil agar pelapor dapat memverifikasi pekerjaan.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const SizedBox(height: 12),
                OpsFixCompletionPanel(ticketId: _ticketId),
              ]));
    }
    if (_rawStatus == 'pending_verification') {
      return _notice(
          Icons.hourglass_top,
          const Color(0xFF2563EB),
          'Menunggu verifikasi',
          'Hasil perbaikan sudah dikirim. Pelapor sedang memeriksa pekerjaan Anda.');
    }
    if (_rawStatus == 'fixed' || _rawStatus == 'closed') {
      return _notice(
          Icons.check_circle_outline,
          const Color(0xFF059669),
          'Pekerjaan selesai',
          'Perbaikan telah diterima. Tidak ada tindakan lain yang perlu dilakukan.');
    }
    return _notice(
        Icons.info_outline,
        const Color(0xFF64748B),
        'Belum dapat dikerjakan',
        'Status tiket saat ini tidak memerlukan tindakan dari teknisi.');
  }

  Widget _historyCard() => Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Riwayat pekerjaan',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827))),
            const SizedBox(height: 4),
            const Text('Catatan perubahan sejak laporan dibuat.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 13),
            if (_events.isEmpty)
              const Text('Belum ada aktivitas yang tercatat.',
                  style: TextStyle(color: Color(0xFF64748B)))
            else
              for (var i = 0; i < _events.length; i++) ...[
                Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.history,
                              color: Color(0xFF6C5CE7), size: 19),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(_eventLabel(_events[i]),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF111827))),
                                const SizedBox(height: 3),
                                Text(
                                    '${_events[i]['actor_name_snapshot'] ?? 'Sistem'} · '
                                    '${_date(_events[i]['created_at'])}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B))),
                              ])),
                        ])),
                if (i < _events.length - 1) const SizedBox(height: 8),
              ],
          ]));

  Widget _statePanel() {
    if (_loading)
      return const Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: CircularProgressIndicator()));
    if (_error != null && _ticket == null) {
      return Container(
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 34),
            const SizedBox(height: 10),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFB91C1C))),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _load, child: const Text('Coba lagi')),
          ]));
    }
    return const SizedBox.shrink();
  }

  Widget _content({required bool desktop, required bool tablet}) =>
      RefreshIndicator(
          onRefresh: _load,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                  desktop ? 28 : 16, 22, desktop ? 28 : 16, 32),
              child: Center(
                  child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desktop ? 1280 : 960),
                child: _loading || _ticket == null
                    ? _statePanel()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            if (_error != null) ...[
                              _notice(
                                  Icons.error_outline,
                                  const Color(0xFFDC2626),
                                  'Terjadi kendala',
                                  _error!),
                              const SizedBox(height: 14),
                            ],
                            if (desktop)
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              _summaryCard(),
                                              const SizedBox(height: 16),
                                              _informationCard(),
                                            ])),
                                    const SizedBox(width: 22),
                                    Expanded(
                                        flex: 6,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              _actionCard(),
                                              const SizedBox(height: 16),
                                              _historyCard(),
                                            ])),
                                  ])
                            else if (tablet) ...[
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _summaryCard()),
                                    const SizedBox(width: 16),
                                    Expanded(child: _informationCard()),
                                  ]),
                              const SizedBox(height: 16),
                              _actionCard(),
                              const SizedBox(height: 16),
                              _historyCard(),
                            ] else ...[
                              _summaryCard(),
                              const SizedBox(height: 16),
                              _informationCard(),
                              const SizedBox(height: 16),
                              _actionCard(),
                              const SizedBox(height: 16),
                              _historyCard(),
                            ],
                          ]),
              ))));

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final desktop = screenWidth >= 1200;
    final tablet = screenWidth >= 480 && screenWidth < 1200;
    final pageContent = desktop
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
          ]);
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(child: pageContent),
      ),
    );
  }
}
