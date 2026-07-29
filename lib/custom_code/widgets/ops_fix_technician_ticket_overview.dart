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
import '/custom_code/widgets/ops_fix_language_setting.dart';

class OpsFixTechnicianTicketOverview extends StatefulWidget {
  const OpsFixTechnicianTicketOverview({
    super.key,
    this.width,
    this.height,
    required this.ticketId,
  });
  final double? width;
  final double? height;
  final String? ticketId;

  @override
  State<OpsFixTechnicianTicketOverview> createState() =>
      _OpsFixTechnicianTicketOverviewState();
}

class _OpsFixTechnicianTicketOverviewState
    extends State<OpsFixTechnicianTicketOverview> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _ticket;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = (widget.ticketId ?? '').trim();
    if (id.isEmpty) {
      setState(() {
        _loading = false;
        _error = OpsFixI18n.t('Tiket belum dipilih.');
      });
      return;
    }
    try {
      final row = await SupaFlow.client
          .from('ticket_cards_v')
          .select(
              'ticket_code,status,priority,target_label_snapshot,issue_type_snapshot,description,location_name_snapshot,unit_code_snapshot,reporter_name_snapshot')
          .eq('id', id)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _ticket = row == null ? null : Map<String, dynamic>.from(row);
        _loading = false;
        _error = row == null
            ? OpsFixI18n.t('Detail pekerjaan tidak ditemukan.')
            : null;
      });
    } catch (error) {
      debugPrint('Technician ticket overview load failed: $error');
      if (mounted)
        setState(() {
          _loading = false;
          _error = OpsFixI18n.t('Detail pekerjaan belum dapat dimuat.');
        });
    }
  }

  String _text(String key, String fallback) {
    final value = _ticket?[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  String _status(String value) => switch (value.toLowerCase()) {
        'reported' => OpsFixI18n.t('Baru dilaporkan'),
        'assigned' => OpsFixI18n.t('Siap dimulai'),
        'in_progress' => OpsFixI18n.t('Sedang dikerjakan'),
        'pending_verification' => OpsFixI18n.t('Menunggu verifikasi'),
        'fixed' => OpsFixI18n.t('Selesai'),
        'closed' => OpsFixI18n.t('Ditutup'),
        'cancelled' => OpsFixI18n.t('Dibatalkan'),
        _ => OpsFixI18n.t('Dalam penanganan'),
      };

  String _priority(String value) => switch (value.toLowerCase()) {
        'critical' => OpsFixI18n.t('Kritis'),
        'high' => OpsFixI18n.t('Tinggi'),
        'medium' => OpsFixI18n.t('Sedang'),
        'low' => OpsFixI18n.t('Rendah'),
        _ => OpsFixI18n.t('Belum ditentukan'),
      };

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(top: 10),
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Container(
        width: widget.width,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Text(_error!, style: const TextStyle(color: Color(0xFFDC2626))),
      );
    }

    final status = _text('status', '');
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1426),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Expanded(
                      child: Text(OpsFixI18n.t('DETAIL PEKERJAAN'),
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
                    child: Text(OpsFixI18n.t('Teknisi'),
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ]),
                const SizedBox(height: 12),
                Text(_text('ticket_code', OpsFixI18n.t('Tiket')),
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFA5B4FC),
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                    _text('target_label_snapshot',
                        OpsFixI18n.t('Unit fasilitas')),
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(
                    _text('issue_type_snapshot',
                        OpsFixI18n.t('Gangguan fasilitas')),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE2E8F0),
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 7),
                Text(
                    _text('description',
                        OpsFixI18n.t('Tidak ada keterangan tambahan.')),
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFFCBD5E1), height: 1.4)),
                const SizedBox(height: 10),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.location_on_outlined,
                      size: 18, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 7),
                  Expanded(
                      child: Text(
                          _text('location_name_snapshot',
                              OpsFixI18n.t('Lokasi belum tersedia')),
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFFE2E8F0)))),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFDDE2E7)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(OpsFixI18n.t('Informasi pekerjaan'),
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827))),
                _row(OpsFixI18n.t('Status'), _status(status)),
                _row(OpsFixI18n.t('Prioritas'),
                    _priority(_text('priority', ''))),
                _row(
                    OpsFixI18n.t('Lokasi'),
                    _text('location_name_snapshot',
                        OpsFixI18n.t('Belum tersedia'))),
                _row(
                    OpsFixI18n.t('Unit'),
                    _text(
                        'unit_code_snapshot', OpsFixI18n.t('Belum tersedia'))),
                _row(
                    OpsFixI18n.t('Pelapor'),
                    _text('reporter_name_snapshot',
                        OpsFixI18n.t('Belum tersedia'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
