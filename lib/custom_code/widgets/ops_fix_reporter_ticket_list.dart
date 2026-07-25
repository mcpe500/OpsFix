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

class OpsFixReporterTicketList extends StatefulWidget {
  const OpsFixReporterTicketList({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixReporterTicketList> createState() =>
      _OpsFixReporterTicketListState();
}

class _OpsFixReporterTicketListState extends State<OpsFixReporterTicketList> {
  bool _loading = true;
  String? _error;
  String _filter = 'all';
  List<Map<String, dynamic>> _tickets = const [];

  static const _filters = <String, String>{
    'all': 'Semua',
    'reported': 'Dilaporkan',
    'assigned': 'Ditangani',
    'working': 'Dikerjakan',
    'done': 'Selesai',
  };

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
              'id,ticket_code,status,target_label_snapshot,issue_type_snapshot,location_name_snapshot,technician_name_snapshot,updated_at')
          .eq('reporter_id', currentUserUid);
      if (FFAppState().currentSiteId.isNotEmpty) {
        query = query.eq('site_id', FFAppState().currentSiteId);
      }
      final rows = await query.order('updated_at', ascending: false);
      if (!mounted) return;
      setState(() {
        _tickets = (rows as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _loading = false;
      });
    } catch (error) {
      debugPrint('Reporter tickets load failed: $error');
      if (mounted)
        setState(() {
          _loading = false;
          _error = 'Daftar tiket belum dapat dimuat.';
        });
    }
  }

  bool _matches(String status) => switch (_filter) {
        'all' => true,
        'reported' => status == 'reported',
        'assigned' => status == 'assigned',
        'working' => const {'in_progress', 'pending_verification', 'reopened'}
            .contains(status),
        'done' => const {'fixed', 'closed'}.contains(status),
        _ => true,
      };

  String _statusLabel(String status) => switch (status) {
        'reported' => 'Dilaporkan',
        'assigned' => 'Ditangani',
        'in_progress' => 'Sedang dikerjakan',
        'pending_verification' => 'Menunggu verifikasi',
        'fixed' => 'Selesai',
        'closed' => 'Ditutup',
        'reopened' => 'Dibuka kembali',
        'rejected' => 'Ditolak',
        'cancelled' => 'Dibatalkan',
        _ => 'Status diperbarui',
      };

  String _text(Map<String, dynamic> row, String key, String fallback) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  void _open(String id) {
    if (id.isEmpty) return;
    context.pushNamed(
      'ticketDetailPage',
      queryParameters:
          {'ticketId': serializeParam(id, ParamType.String)}.withoutNulls,
    );
  }

  Widget _filterButton(String key, String label) {
    final selected = _filter == key;
    return InkWell(
      onTap: () => setState(() => _filter = key),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6C5CE7) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color:
                  selected ? const Color(0xFF6C5CE7) : const Color(0xFFE5E7EB)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF64748B))),
      ),
    );
  }

  Widget _ticketCard(Map<String, dynamic> ticket) {
    final status = _text(ticket, 'status', '');
    final technician =
        _text(ticket, 'technician_name_snapshot', 'Belum ada teknisi');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
                child: Text(_text(ticket, 'ticket_code', 'Tiket'),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827)))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(14)),
              child: Text(_statusLabel(status),
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5B4CE3))),
            ),
          ]),
          const SizedBox(height: 9),
          Text(_text(ticket, 'target_label_snapshot', 'Fasilitas'),
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827))),
          const SizedBox(height: 5),
          Text(_text(ticket, 'issue_type_snapshot', 'Gangguan fasilitas'),
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  _text(ticket, 'location_name_snapshot',
                      'Lokasi belum tersedia'),
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              const SizedBox(height: 4),
              Text(technician,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ]),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => _open(_text(ticket, 'id', '')),
            style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6C5CE7),
                side: const BorderSide(color: Color(0xFF6C5CE7)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9))),
            child: const Text('Lihat detail'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _tickets
        .where((ticket) => _matches(_text(ticket, 'status', '')))
        .toList();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFDDE2E7))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Status tiket',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
              const SizedBox(height: 10),
              Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: _filters.entries
                      .map((entry) => _filterButton(entry.key, entry.value))
                      .toList()),
            ]),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text(_error!,
                            style: const TextStyle(color: Color(0xFFDC2626))))
                    : visible.isEmpty
                        ? const Center(
                            child: Text('Tidak ada tiket untuk status ini.',
                                style: TextStyle(color: Color(0xFF64748B))))
                        : RefreshIndicator(
                            onRefresh: _load,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 12),
                              itemCount: visible.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, index) =>
                                  _ticketCard(visible[index]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
