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
import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

class OpsFixTechnicianWorkStatusPanel extends StatefulWidget {
  const OpsFixTechnicianWorkStatusPanel({
    super.key,
    this.width,
    this.height,
    required this.ticketId,
  });
  final double? width;
  final double? height;
  final String? ticketId;

  @override
  State<OpsFixTechnicianWorkStatusPanel> createState() =>
      _OpsFixTechnicianWorkStatusPanelState();
}

class _OpsFixTechnicianWorkStatusPanelState
    extends State<OpsFixTechnicianWorkStatusPanel> {
  bool _loading = true;
  bool _starting = false;
  String _status = '';
  String? _error;
  List<Map<String, dynamic>> _events = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ticketId = (widget.ticketId ?? '').trim();
    if (ticketId.isEmpty) {
      setState(() {
        _loading = false;
        _error = OpsFixI18n.t('Tiket belum dipilih.');
      });
      return;
    }
    try {
      final results = await Future.wait([
        SupaFlow.client
            .from('tickets')
            .select('status')
            .eq('id', ticketId)
            .maybeSingle(),
        SupaFlow.client
            .from('ticket_events')
            .select(
                'event_type,message,actor_name_snapshot,created_at,from_status,to_status')
            .eq('ticket_id', ticketId)
            .order('created_at', ascending: false),
      ]);
      if (!mounted) return;
      setState(() {
        final ticket = results[0] as Map<String, dynamic>?;
        _status = ticket?['status']?.toString().toLowerCase() ?? '';
        _events = (results[1] as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _loading = false;
        _error = null;
      });
    } catch (error) {
      debugPrint('Technician work panel load failed: $error');
      if (mounted)
        setState(() {
          _loading = false;
          _error = OpsFixI18n.t('Informasi pekerjaan belum dapat dimuat.');
        });
    }
  }

  Future<void> _start() async {
    setState(() {
      _starting = true;
      _error = null;
    });
    try {
      await startOpsFixTicket((widget.ticketId ?? '').trim());
      await _load();
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(OpsFixI18n.t('Pekerjaan berhasil dimulai.'))),
        );
    } catch (error) {
      if (mounted)
        setState(() => _error = OpsFixI18n.t(
            'Pekerjaan gagal dimulai. Muat ulang lalu coba lagi.'));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  String _eventLabel(Map<String, dynamic> event) {
    final type = event['event_type']?.toString().toLowerCase() ?? '';
    final to = event['to_status']?.toString().toLowerCase() ?? '';
    if (to == 'assigned' || type.contains('assign'))
      return OpsFixI18n.t('Teknisi ditugaskan');
    if (to == 'in_progress' || type.contains('start'))
      return OpsFixI18n.t('Pekerjaan dimulai');
    if (to == 'pending_verification' || type.contains('completion'))
      return OpsFixI18n.t('Hasil dikirim untuk verifikasi');
    if (to == 'fixed' || type.contains('fixed'))
      return OpsFixI18n.t('Perbaikan dinyatakan selesai');
    if (to == 'closed' || type.contains('closed'))
      return OpsFixI18n.t('Tiket ditutup');
    if (type.contains('report') || type.contains('create'))
      return OpsFixI18n.t('Laporan dibuat');
    return OpsFixI18n.t('Pembaruan pekerjaan');
  }

  String _date(dynamic raw) {
    final value = DateTime.tryParse(raw?.toString() ?? '')?.toLocal();
    if (value == null) return OpsFixI18n.t('Waktu tidak tersedia');
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year} · ${two(value.hour)}:${two(value.minute)}';
  }

  Widget _notice(IconData icon, Color color, String title, String body) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(.25)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827))),
                const SizedBox(height: 4),
                Text(body,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF64748B), height: 1.35)),
              ])),
        ]),
      );

  Widget _action() {
    if (_status == 'assigned') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(OpsFixI18n.t('Siap dikerjakan'),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827))),
              const SizedBox(height: 5),
              Text(
                  OpsFixI18n.t(
                      'Mulai pekerjaan saat Anda sudah berada di lokasi dan siap menangani unit.'),
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 14),
              FilledButton.icon(
                  onPressed: _starting ? null : _start,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(_starting
                      ? OpsFixI18n.t('Memulai…')
                      : OpsFixI18n.t('Mulai pekerjaan'))),
            ]),
      );
    }
    if (_status == 'in_progress') {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(OpsFixI18n.t('Kirim hasil perbaikan'),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827))),
              const SizedBox(height: 5),
              Text(
                  OpsFixI18n.t(
                      'Tambahkan catatan dan foto hasil agar pelapor dapat memverifikasi pekerjaan.'),
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 12),
              OpsFixCompletionPanel(ticketId: (widget.ticketId ?? '').trim()),
            ]),
      );
    }
    if (_status == 'pending_verification') {
      return _notice(
          Icons.hourglass_top,
          const Color(0xFF2563EB),
          OpsFixI18n.t('Menunggu verifikasi'),
          OpsFixI18n.t(
              'Hasil perbaikan sudah dikirim. Pelapor sedang memeriksa pekerjaan Anda.'));
    }
    if (_status == 'fixed' || _status == 'closed') {
      return _notice(
          Icons.check_circle_outline,
          const Color(0xFF059669),
          OpsFixI18n.t('Pekerjaan selesai'),
          OpsFixI18n.t(
              'Perbaikan telah diterima. Tidak ada tindakan lain yang perlu dilakukan.'));
    }
    return _notice(
        Icons.info_outline,
        const Color(0xFF64748B),
        OpsFixI18n.t('Belum dapat dikerjakan'),
        OpsFixI18n.t(
            'Status tiket saat ini tidak memerlukan tindakan dari teknisi.'));
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      );

  Widget _history() => Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(OpsFixI18n.t('Riwayat pekerjaan'),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827))),
              const SizedBox(height: 4),
              Text(OpsFixI18n.t('Catatan perubahan sejak laporan dibuat.'),
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              if (_events.isEmpty) ...[
                const SizedBox(height: 14),
                Text(OpsFixI18n.t('Belum ada aktivitas yang tercatat.'),
                    style: TextStyle(color: Color(0xFF64748B))),
              ] else ...[
                const SizedBox(height: 12),
                for (var i = 0; i < _events.length; i++) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
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
                                    '${_events[i]['actor_name_snapshot'] ?? OpsFixI18n.t('Sistem')} · ${_date(_events[i]['created_at'])}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B))),
                              ])),
                        ]),
                  ),
                  if (i < _events.length - 1) const SizedBox(height: 8),
                ],
              ],
            ]),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()));
    return SizedBox(
      width: widget.width,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              _notice(Icons.error_outline, const Color(0xFFDC2626),
                  OpsFixI18n.t('Terjadi kendala'), _error!),
              const SizedBox(height: 12)
            ],
            _action(),
            const SizedBox(height: 16),
            _history(),
          ]),
    );
  }
}
