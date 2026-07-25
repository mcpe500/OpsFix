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
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OpsFixTechnicianCompletedHistory extends StatefulWidget {
  const OpsFixTechnicianCompletedHistory({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixTechnicianCompletedHistory> createState() =>
      _OpsFixTechnicianCompletedHistoryState();
}

class _OpsFixTechnicianCompletedHistoryState
    extends State<OpsFixTechnicianCompletedHistory> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _tickets = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      var query = SupaFlow.client
          .from('ticket_cards_v')
          .select(
              'id,ticket_code,status,target_label_snapshot,issue_type_snapshot,location_name_snapshot,unit_code_snapshot,updated_at')
          .eq('assigned_technician_id', currentUserUid)
          .inFilter('status', const ['fixed', 'closed']);
      final siteId = FFAppState().currentSiteId.trim();
      if (siteId.isNotEmpty) query = query.eq('site_id', siteId);
      final rows = await query.order('updated_at', ascending: false);
      if (!mounted) return;
      setState(() {
        _tickets = rows
            .map<Map<String, dynamic>>(
              (row) => Map<String, dynamic>.from(row),
            )
            .toList();
        _loading = false;
        _error = null;
      });
    } catch (error) {
      debugPrint('Technician completed history load failed: $error');
      if (mounted)
        setState(() {
          _loading = false;
          _error = 'Riwayat pekerjaan belum dapat dimuat.';
        });
    }
  }

  String _text(Map<String, dynamic> row, String key, String fallback) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  String _date(dynamic raw) {
    final value = DateTime.tryParse(raw?.toString() ?? '')?.toLocal();
    if (value == null) return 'Waktu tidak tersedia';
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year} · ${two(value.hour)}:${two(value.minute)}';
  }

  void _open(String id) {
    context.pushNamed(
      'technicianTicketDetailPage',
      queryParameters:
          {'ticketId': serializeParam(id, ParamType.String)}.withoutNulls,
    );
  }

  Widget _card(Map<String, dynamic> ticket) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(14)),
                child: Text(
                  ticket['status']?.toString() == 'closed'
                      ? 'Ditutup'
                      : 'Selesai',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF047857)),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Text(_text(ticket, 'target_label_snapshot', 'Unit fasilitas'),
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827))),
            const SizedBox(height: 4),
            Text(_text(ticket, 'issue_type_snapshot', 'Gangguan fasilitas'),
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 10),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.location_on_outlined,
                  size: 18, color: Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(
                      '${_text(ticket, 'location_name_snapshot', 'Lokasi belum tersedia')} · ${_text(ticket, 'unit_code_snapshot', 'Unit belum tersedia')}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF475569)))),
            ]),
            const SizedBox(height: 5),
            Text('Selesai ${_date(ticket['updated_at'])}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _open(ticket['id']?.toString() ?? ''),
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Lihat detail'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
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
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Text(_error!,
                              style: const TextStyle(color: Color(0xFFDC2626))))
                      : _tickets.isEmpty
                          ? const Center(
                              child: Text('Belum ada pekerjaan yang selesai.',
                                  style: TextStyle(color: Color(0xFF64748B))))
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: _tickets.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, index) => _card(_tickets[index]),
                            ),
            ),
          ],
        ),
      );
}
