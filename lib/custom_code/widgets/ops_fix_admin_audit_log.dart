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

class OpsFixAdminAuditLog extends StatefulWidget {
  const OpsFixAdminAuditLog({super.key, this.width, this.height});
  final double? width;
  final double? height;
  @override
  State<OpsFixAdminAuditLog> createState() => _OpsFixAdminAuditLogState();
}

class _OpsFixAdminAuditLogState extends State<OpsFixAdminAuditLog> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _events = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      var query = SupaFlow.client.from('ticket_events').select(
            'id,event_type,message,reason,actor_name_snapshot,actor_role_snapshot,from_status,to_status,created_at',
          );
      if (FFAppState().currentSiteId.isNotEmpty) {
        query = query.eq('site_id', FFAppState().currentSiteId);
      }
      final rows = await query.order('created_at', ascending: false).limit(100);
      if (!mounted) return;
      setState(() {
        _events = (rows as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _loading = false;
      });
    } catch (error) {
      debugPrint('Admin audit load failed: $error');
      if (mounted)
        setState(() {
          _loading = false;
          _error = 'Riwayat aktivitas belum dapat dimuat.';
        });
    }
  }

  String _value(Map<String, dynamic> event, String key) =>
      event[key]?.toString().trim() ?? '';

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
    if (from.isNotEmpty || to.isNotEmpty)
      return 'Status berubah dari ${_status(from)} menjadi ${_status(to)}.';
    if (message.isNotEmpty) return message;
    final reason = _value(event, 'reason');
    return reason.isEmpty ? 'Perubahan tercatat pada sistem.' : reason;
  }

  String _date(dynamic raw) {
    final date = DateTime.tryParse(raw?.toString() ?? '')?.toLocal();
    if (date == null) return 'Waktu tidak tersedia';
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} · ${two(date.hour)}:${two(date.minute)}';
  }

  Widget _card(Map<String, dynamic> event) {
    final actor = _value(event, 'actor_name_snapshot');
    final role = _value(event, 'actor_role_snapshot');
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE2E7))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                color: Color(0xFFF0EDFF), shape: BoxShape.circle),
            child:
                const Icon(Icons.history, size: 19, color: Color(0xFF6C5CE7))),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_title(_value(event, 'event_type')),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827))),
          const SizedBox(height: 4),
          Text(_description(event),
              style: const TextStyle(
                  fontSize: 13, height: 1.35, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          Text(
              actor.isEmpty
                  ? 'Sistem OpsFix'
                  : role.isEmpty
                      ? actor
                      : '$actor · ${_status(role)}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          const SizedBox(height: 3),
          Text(_date(event['created_at']),
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ])),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFDDE2E7))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('Riwayat aktivitas',
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827))),
            const SizedBox(height: 4),
            const Text('Catatan perubahan operasional terbaru.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Text(_error!,
                                style:
                                    const TextStyle(color: Color(0xFFDC2626))))
                        : _events.isEmpty
                            ? const Center(
                                child: Text(
                                    'Belum ada aktivitas yang tercatat.',
                                    style: TextStyle(color: Color(0xFF64748B))))
                            : RefreshIndicator(
                                onRefresh: _load,
                                child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: _events.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (_, index) =>
                                        _card(_events[index])))),
          ]),
        ),
      );
}
