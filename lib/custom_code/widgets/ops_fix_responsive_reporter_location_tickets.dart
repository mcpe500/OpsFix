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
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _incidentFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixResponsiveReporterLocationTickets extends StatefulWidget {
  const OpsFixResponsiveReporterLocationTickets({
    super.key,
    this.width,
    this.height,
    this.locationId,
    this.ticketId,
  });
  final double? width;
  final double? height;
  final String? locationId;
  final String? ticketId;

  @override
  State<OpsFixResponsiveReporterLocationTickets> createState() =>
      _OpsFixResponsiveReporterLocationTicketsState();
}

class _OpsFixResponsiveReporterLocationTicketsState
    extends State<OpsFixResponsiveReporterLocationTickets> {
  bool _loading = true;
  String? _error;
  String _locationId = '';
  String _locationName = '';
  String _highlight = '';
  String _joining = '';
  List<Map<String, dynamic>> _rows = const [];

  @override
  void initState() {
    super.initState();
    final requestedLocation = (widget.locationId ?? '').trim();
    _locationId = requestedLocation.isNotEmpty
        ? requestedLocation
        : FFAppState().currentLocationId.trim();
    _highlight = (widget.ticketId ?? '').trim();
    _load();
  }

  Map<String, dynamic> _map(dynamic raw) =>
      raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};

  Future<void> _load() async {
    if (mounted)
      setState(() {
        _loading = true;
        _error = null;
      });
    try {
      if (_highlight.isNotEmpty) {
        final detail = _map(await SupaFlow.client.rpc(
          'get_opsfix_location_incident',
          params: {'p_ticket_id': _highlight},
        ));
        final incident = _map(detail['incident']);
        if (_locationId.isEmpty) {
          _locationId = incident['location_id']?.toString() ?? '';
        }
      }
      if (_locationId.isEmpty) throw StateError('missing_location');
      final response = _map(await SupaFlow.client.rpc(
        'list_opsfix_location_active_incidents',
        params: {'p_location_id': _locationId, 'p_limit': 100, 'p_offset': 0},
      ));
      if (response['ok'] != true) throw StateError('incident_access');
      final values = response['incidents'] is List
          ? response['incidents'] as List
          : const <dynamic>[];
      if (!mounted) return;
      setState(() {
        _locationName = response['location_name']?.toString() ?? '';
        _rows = values
            .map((value) => Map<String, dynamic>.from(value as Map))
            .toList();
        _loading = false;
      });
      if (_highlight.isNotEmpty &&
          !_rows.any((row) => row['ticket_id']?.toString() == _highlight)) {
        final detail = _map(await SupaFlow.client.rpc(
          'get_opsfix_location_incident',
          params: {'p_ticket_id': _highlight},
        ));
        final incident = _map(detail['incident']);
        if (incident.isNotEmpty && mounted) {
          setState(() => _rows = [incident, ..._rows]);
        }
      }
    } catch (error) {
      debugPrint('Location incidents load failed: ${error.runtimeType}');
      if (mounted)
        setState(() {
          _loading = false;
          _error = OpsFixI18n.t(
              'Gangguan lokasi belum dapat dimuat. Periksa akses atau koneksi.');
        });
    }
  }

  String _status(String raw) => switch (raw) {
        'reported' => OpsFixI18n.t('Baru dilaporkan'),
        'assigned' => OpsFixI18n.t('Teknisi ditetapkan'),
        'in_progress' => OpsFixI18n.t('Sedang dikerjakan'),
        'pending_verification' => OpsFixI18n.t('Menunggu verifikasi'),
        'reopened' => OpsFixI18n.t('Dibuka kembali'),
        'fixed' => OpsFixI18n.t('Selesai'),
        _ => OpsFixI18n.t('Status diperbarui'),
      };

  String _time(dynamic raw) {
    final parsed = DateTime.tryParse(raw?.toString() ?? '')?.toLocal();
    return parsed == null
        ? OpsFixI18n.t('Waktu belum tersedia')
        : DateFormat('d MMM yyyy · HH:mm', 'id_ID').format(parsed);
  }

  Future<void> _join(Map<String, dynamic> row) async {
    final id = row['ticket_id']?.toString() ?? '';
    if (id.isEmpty || _joining.isNotEmpty) return;
    setState(() => _joining = id);
    try {
      final result = _map(await SupaFlow.client.rpc(
        'join_opsfix_affected_ticket',
        params: {'p_ticket_id': id},
      ));
      if (!mounted) return;
      final updated = _map(result['incident']);
      setState(() {
        _joining = '';
        if (updated.isNotEmpty) {
          _rows = _rows
              .map((item) =>
                  item['ticket_id']?.toString() == id ? updated : item)
              .toList();
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['code'] == 'joined'
            ? OpsFixI18n.t('Anda sekarang mengikuti progres gangguan ini.')
            : OpsFixI18n.t('Status terdampak sudah tercatat.')),
      ));
    } catch (error) {
      debugPrint('Location incident join failed: ${error.runtimeType}');
      if (mounted) setState(() => _joining = '');
    }
  }

  void _openOwner(Map<String, dynamic> row) {
    context.pushNamed(
      'ticketDetailPage',
      extra: _incidentFade(),
      queryParameters: {
        'ticketId': serializeParam(
            row['ticket_id']?.toString() ?? '', ParamType.String),
      }.withoutNulls,
    );
  }

  Widget _card(Map<String, dynamic> row) {
    final id = row['ticket_id']?.toString() ?? '';
    final relationship = row['relationship']?.toString() ?? 'none';
    final highlighted = id == _highlight;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFF7F5FF) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              highlighted ? const Color(0xFF6C5CE7) : const Color(0xFFDDE2E7),
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
            child:
                Text(row['ticket_code']?.toString() ?? OpsFixI18n.t('Tiket')),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(_status(row['status']?.toString() ?? ''),
                style: const TextStyle(color: Color(0xFF5B4CE3), fontSize: 11)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(row['target_label']?.toString() ?? OpsFixI18n.t('Fasilitas'),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        Text(row['issue_type']?.toString() ?? OpsFixI18n.t('Gangguan'),
            style: const TextStyle(color: Color(0xFF64748B))),
        const SizedBox(height: 12),
        Text(
            OpsFixI18n.tf('{0} orang terdampak', [row['affected_count'] ?? 1])),
        const SizedBox(height: 4),
        Text(_time(row['updated_at']),
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        const Spacer(),
        const SizedBox(height: 14),
        if (relationship == 'owner')
          FilledButton(
            onPressed: () => _openOwner(row),
            child: Text(OpsFixI18n.t('Buka tiket')),
          )
        else if (relationship == 'supporter')
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.check),
            label: Text(OpsFixI18n.t('Anda juga terdampak')),
          )
        else
          FilledButton.icon(
            onPressed: _joining == id ? null : () => _join(row),
            icon: _joining == id
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.group_add_outlined),
            label: Text(OpsFixI18n.t('Saya juga terdampak')),
          ),
      ]),
    );
  }

  void _go(String route) => context.goNamed(route, extra: _incidentFade());

  Widget _navigation(bool desktop) {
    if (desktop) {
      return Container(
        width: 252,
        color: const Color(0xFF081225),
        padding: const EdgeInsets.fromLTRB(18, 26, 18, 22),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('OpsFix',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Colors.white70),
            title: Text(OpsFixI18n.t('Beranda'),
                style: const TextStyle(color: Colors.white)),
            onTap: () => _go('homeUserPage'),
          ),
          ListTile(
            selected: true,
            selectedTileColor: const Color(0xFF6C5CE7),
            leading: const Icon(Icons.campaign_outlined, color: Colors.white),
            title: Text(OpsFixI18n.t('Gangguan lokasi'),
                style: const TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading:
                const Icon(Icons.receipt_long_outlined, color: Colors.white70),
            title: Text(OpsFixI18n.t('Tiket saya'),
                style: const TextStyle(color: Colors.white)),
            onTap: () => _go('myTicketsPage'),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white70),
            title: Text(OpsFixI18n.t('Profil'),
                style: const TextStyle(color: Colors.white)),
            onTap: () => _go('ProfilePage'),
          ),
        ]),
      );
    }
    return NavigationBar(
      selectedIndex: 1,
      destinations: [
        NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: OpsFixI18n.t('Beranda')),
        NavigationDestination(
            icon: const Icon(Icons.campaign_outlined),
            label: OpsFixI18n.t('Gangguan')),
        NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            label: OpsFixI18n.t('Tiket')),
        NavigationDestination(
            icon: const Icon(Icons.person_outline),
            label: OpsFixI18n.t('Profil')),
      ],
      onDestinationSelected: (index) {
        if (index == 0) _go('homeUserPage');
        if (index == 2) _go('myTicketsPage');
        if (index == 3) _go('ProfilePage');
      },
    );
  }

  Widget _content(double width) {
    final columns = width >= 1080
        ? 3
        : width >= 680
            ? 2
            : 1;
    return RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
                width < 480 ? 14 : 20, 18, width < 480 ? 14 : 20, 28),
            sliver: SliverList.list(children: [
              Text(OpsFixI18n.t('Gangguan aktif'),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              Text(
                _locationName.isEmpty
                    ? OpsFixI18n.t('Lokasi aktif Anda')
                    : _locationName,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
            ]),
          ),
          if (_loading)
            const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: FilledButton(
                  onPressed: _load,
                  child: Text(OpsFixI18n.t('Coba lagi')),
                ),
              ),
            )
          else if (_rows.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                    OpsFixI18n.t('Belum ada gangguan aktif di lokasi ini.')),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                  width < 480 ? 14 : 20, 0, width < 480 ? 14 : 20, 28),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => _card(_rows[index]),
                  childCount: _rows.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 260,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context).width;
    final desktop = screen >= 1200;
    final body = Column(children: [
      Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFDDE2E7))),
        ),
        child: Row(children: [
          IconButton(
            onPressed: () => Navigator.of(context).canPop()
                ? Navigator.of(context).pop()
                : _go('homeUserPage'),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(OpsFixI18n.t('Gangguan lokasi'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700))),
          const OpsFixReporterHeaderActions(),
        ]),
      ),
      Expanded(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: _content(desktop ? screen - 252 : screen),
          ),
        ),
      ),
      if (!desktop) const OpsFixReporterBottomNav(activeSection: 'incidents'),
    ]);
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: desktop
            ? Row(children: [
                const OpsFixReporterSidebar(activeSection: 'incidents'),
                Expanded(child: body)
              ])
            : body,
      ),
    );
  }
}
