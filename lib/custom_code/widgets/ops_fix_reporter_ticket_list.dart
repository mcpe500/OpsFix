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
import 'package:intl/intl.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _opsFixReporterFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

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
  String? _selectedId;
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
      final loaded = (rows as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
      setState(() {
        _tickets = loaded;
        _loading = false;
        _error = null;
        final visible = _visibleTickets(loaded);
        final selectedStillVisible =
            visible.any((row) => row['id']?.toString() == _selectedId);
        if (!selectedStillVisible) {
          _selectedId =
              visible.isEmpty ? null : visible.first['id']?.toString();
        }
      });
    } catch (error) {
      debugPrint('Reporter tickets load failed: $error');
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Daftar tiket belum dapat dimuat. Tarik untuk mencoba lagi.';
        });
      }
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

  List<Map<String, dynamic>> _visibleTickets(
          [List<Map<String, dynamic>>? source]) =>
      (source ?? _tickets)
          .where((ticket) => _matches(_text(ticket, 'status', '')))
          .toList();

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

  Color _statusColor(String status) => switch (status) {
        'reported' => const Color(0xFF2563EB),
        'assigned' => const Color(0xFF6C5CE7),
        'in_progress' => const Color(0xFFD97706),
        'pending_verification' => const Color(0xFF0284C7),
        'fixed' || 'closed' => const Color(0xFF059669),
        'rejected' || 'cancelled' => const Color(0xFFDC2626),
        _ => const Color(0xFF64748B),
      };

  String _text(Map<String, dynamic> row, String key, String fallback) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  String _updatedLabel(Map<String, dynamic> ticket) {
    final value = ticket['updated_at']?.toString();
    final parsed = value == null ? null : DateTime.tryParse(value)?.toLocal();
    return parsed == null
        ? 'Waktu belum tersedia'
        : DateFormat('d MMM yyyy · HH:mm', 'id_ID').format(parsed);
  }

  void _open(String id) {
    if (id.isEmpty) return;
    context.pushNamed(
      'ticketDetailPage',
      extra: _opsFixReporterFade(),
      queryParameters:
          {'ticketId': serializeParam(id, ParamType.String)}.withoutNulls,
    );
  }

  void _setFilter(String key) {
    setState(() {
      _filter = key;
      final visible = _visibleTickets();
      _selectedId = visible.isEmpty ? null : visible.first['id']?.toString();
    });
  }

  Widget _filterButton(String key, String label) {
    final selected = _filter == key;
    return InkWell(
      onTap: () => _setFilter(key),
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

  Widget _filtersCard() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                .toList(),
          ),
        ]),
      );

  Widget _statusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(_statusLabel(status),
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _ticketCard(Map<String, dynamic> ticket,
      {bool compact = false, bool selectable = false}) {
    final id = _text(ticket, 'id', '');
    final status = _text(ticket, 'status', '');
    final selected = selectable && id == _selectedId;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: selectable
            ? () => setState(() => _selectedId = id)
            : () => _open(id),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.all(compact ? 14 : 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF7F5FF) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  selected ? const Color(0xFF6C5CE7) : const Color(0xFFDDE2E7),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Text(_text(ticket, 'ticket_code', 'Tiket'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: compact ? 15 : 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827))),
                ),
                const SizedBox(width: 8),
                _statusBadge(status),
              ]),
              const SizedBox(height: 9),
              Text(_text(ticket, 'target_label_snapshot', 'Fasilitas'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: compact ? 14 : 17,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF111827))),
              const SizedBox(height: 5),
              Text(_text(ticket, 'issue_type_snapshot', 'Gangguan fasilitas'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 12),
              Text(
                _text(
                    ticket, 'location_name_snapshot', 'Lokasi belum tersedia'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 3),
              Text(
                _text(ticket, 'technician_name_snapshot', 'Belum ada teknisi'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              if (!selectable) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _open(id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6C5CE7),
                    side: const BorderSide(color: Color(0xFF6C5CE7)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Lihat detail'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 90),
          Icon(Icons.confirmation_number_outlined,
              size: 46, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text('Tidak ada tiket untuk status ini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B))),
        ],
      );

  Widget _mobileList(List<Map<String, dynamic>> visible) => RefreshIndicator(
        onRefresh: _load,
        child: visible.isEmpty
            ? _emptyState()
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: visible.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _ticketCard(visible[index]),
              ),
      );

  Widget _tabletGrid(List<Map<String, dynamic>> visible) => RefreshIndicator(
        onRefresh: _load,
        child: visible.isEmpty
            ? _emptyState()
            : GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: visible.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 252,
                ),
                itemBuilder: (_, index) => _ticketCard(visible[index]),
              ),
      );

  Widget _preview(Map<String, dynamic>? ticket) {
    if (ticket == null) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: const Center(
          child: Text('Pilih tiket untuk melihat ringkasannya.',
              style: TextStyle(color: Color(0xFF64748B))),
        ),
      );
    }
    final id = _text(ticket, 'id', '');
    final status = _text(ticket, 'status', '');
    Widget row(String label, String value, IconData icon) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: 19, color: const Color(0xFF6C5CE7)),
            const SizedBox(width: 11),
            SizedBox(
              width: 105,
              child: Text(label,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
            ),
          ]),
        );
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827))),
            ),
            _statusBadge(status),
          ]),
          const SizedBox(height: 8),
          Text(_text(ticket, 'target_label_snapshot', 'Fasilitas'),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827))),
          const SizedBox(height: 5),
          Text(_text(ticket, 'issue_type_snapshot', 'Gangguan fasilitas'),
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 8),
          row(
              'Lokasi',
              _text(ticket, 'location_name_snapshot', 'Belum tersedia'),
              Icons.location_on_outlined),
          row(
              'Teknisi',
              _text(ticket, 'technician_name_snapshot', 'Belum ada teknisi'),
              Icons.engineering_outlined),
          row('Diperbarui', _updatedLabel(ticket), Icons.schedule_outlined),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _open(id),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Lihat detail lengkap'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktop(List<Map<String, dynamic>> visible) {
    Map<String, dynamic>? selected;
    for (final ticket in visible) {
      if (ticket['id']?.toString() == _selectedId) selected = ticket;
    }
    selected ??= visible.isEmpty ? null : visible.first;
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SizedBox(
        width: 410,
        child: RefreshIndicator(
          onRefresh: _load,
          child: visible.isEmpty
              ? _emptyState()
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: visible.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) => _ticketCard(visible[index],
                      compact: true, selectable: true),
                ),
        ),
      ),
      const SizedBox(width: 18),
      Expanded(
        child: SingleChildScrollView(
          child: _preview(selected),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleTickets();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;
        final tablet = constraints.maxWidth >= 600 && !desktop;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _filtersCard(),
            const SizedBox(height: 14),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 90),
                              Text(_error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xFFDC2626))),
                            ],
                          ),
                        )
                      : desktop
                          ? _desktop(visible)
                          : tablet
                              ? _tabletGrid(visible)
                              : _mobileList(visible),
            ),
          ],
        );
      }),
    );
  }
}
