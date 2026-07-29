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

import 'dart:async';
import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixAdminTicketsContent extends StatefulWidget {
  const OpsFixAdminTicketsContent({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OpsFixAdminTicketsContent> createState() =>
      _OpsFixAdminTicketsContentState();
}

class _OpsFixAdminTicketsContentState extends State<OpsFixAdminTicketsContent> {
  static const _selectFields =
      'id,ticket_code,status,assignment_state,assigned_technician_id,affected_count,target_label_snapshot,description,location_code_snapshot,location_name_snapshot,priority,priority_rank,is_open,created_at,updated_at,resolution_due_at';

  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  List<Map<String, dynamic>> _tickets = [];
  String? _status;
  String? _priority;
  String? _quickView;
  bool _routeInitialized = false;
  String _sort = 'operational';
  bool _initialLoading = true;
  bool _refreshing = false;
  String? _error;
  int _requestSerial = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_routeInitialized) return;
    _routeInitialized = true;
    final requested =
        GoRouterState.of(context).uri.queryParameters['initialView'];
    if (const {'unassigned', 'critical', 'completed', 'overdue'}
        .contains(requested)) {
      _quickView = requested;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTickets());
  }

  @override
  void dispose() {
    _requestSerial++;
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String _safeSearch(String value) => value
      .trim()
      .replaceAll(RegExp(r'[,()]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  Future<void> _loadTickets() async {
    final request = ++_requestSerial;
    final siteId = FFAppState().currentSiteId.trim();

    if (siteId.isEmpty) {
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _initialLoading = false;
        _refreshing = false;
        _error = OpsFixI18n.t(
            'Lokasi kerja belum dipilih. Masuk ulang lalu coba lagi.');
        _tickets = [];
      });
      return;
    }

    if (mounted) {
      setState(() {
        _error = null;
        _initialLoading = _tickets.isEmpty;
        _refreshing = _tickets.isNotEmpty;
      });
    }

    try {
      dynamic query = SupaFlow.client
          .from('ticket_cards_v')
          .select(_selectFields)
          .eq('site_id', siteId);

      switch (_quickView) {
        case 'unassigned':
          query = query
              .eq('is_open', true)
              .isFilter('assigned_technician_id', null);
        case 'critical':
          query = query.eq('is_open', true).eq('priority', 'critical');
        case 'completed':
          query = query.inFilter('status', const ['fixed', 'closed']);
        case 'overdue':
          query = query.eq('is_open', true).lt(
              'resolution_due_at', DateTime.now().toUtc().toIso8601String());
      }

      if (_status != null) query = query.eq('status', _status!);
      if (_priority != null) query = query.eq('priority', _priority!);

      final search = _safeSearch(_searchController.text);
      if (search.isNotEmpty) {
        final pattern = '%$search%';
        query = query.or(
          'ticket_code.ilike.$pattern,location_code_snapshot.ilike.$pattern,location_name_snapshot.ilike.$pattern,target_label_snapshot.ilike.$pattern,description.ilike.$pattern',
        );
      }

      switch (_sort) {
        case 'updated_desc':
          query = query.order('updated_at', ascending: false);
        case 'updated_asc':
          query = query.order('updated_at', ascending: true);
        case 'created_desc':
          query = query.order('created_at', ascending: false);
        case 'sla_due':
          query = query
              .order(
                'resolution_due_at',
                ascending: true,
                nullsFirst: false,
              )
              .order('priority_rank', ascending: true);
        default:
          query = query
              .order('is_open')
              .order('priority_rank', ascending: true)
              .order('updated_at');
      }

      final response = await query;
      final rows = (response as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _tickets = rows;
        _initialLoading = false;
        _refreshing = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _initialLoading = false;
        _refreshing = false;
        _error = OpsFixI18n.t(
            'Tiket tidak dapat dimuat. Periksa koneksi lalu coba lagi.');
      });
    }
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      _loadTickets,
    );
  }

  int get _activeFilterCount =>
      (_status == null ? 0 : 1) +
      (_priority == null ? 0 : 1) +
      (_quickView == null ? 0 : 1);

  String _quickViewLabel(String value) => switch (value) {
        'unassigned' => OpsFixI18n.t('Belum ditugaskan'),
        'critical' => OpsFixI18n.t('Prioritas kritis'),
        'completed' => OpsFixI18n.t('Tiket selesai terbaru'),
        'overdue' => OpsFixI18n.t('Tiket terlambat'),
        _ => OpsFixI18n.t('Filter dashboard'),
      };

  Future<void> _clearQuickView() async {
    if (!mounted) return;
    setState(() => _quickView = null);
    await _loadTickets();
  }

  Widget _quickViewChip() => Align(
        alignment: Alignment.centerLeft,
        child: InputChip(
          avatar: const Icon(Icons.dashboard_customize_outlined, size: 17),
          label: Text(_quickViewLabel(_quickView!)),
          onDeleted: _clearQuickView,
          deleteIcon: const Icon(Icons.close, size: 17),
          backgroundColor: const Color(0xFFF0EDFF),
          side: const BorderSide(color: Color(0xFFD8D1FF)),
          labelStyle: const TextStyle(
            color: Color(0xFF5B4BD8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Future<void> _openFilters() async {
    final phone = MediaQuery.sizeOf(context).width < 480;
    final panel = _TicketFilterPanel(
      initialStatus: _status,
      initialPriority: _priority,
      sheet: phone,
    );
    final Map<String, String?>? result;

    if (phone) {
      result = await showModalBottomSheet<Map<String, String?>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => panel,
      );
    } else {
      result = await showDialog<Map<String, String?>>(
        context: context,
        builder: (_) => Dialog(
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: panel,
          ),
        ),
      );
    }

    if (result == null) return;
    final selectedStatus = result['status'];
    final selectedPriority = result['priority'];
    if (!mounted) return;
    setState(() {
      _quickView = null;
      _status = selectedStatus;
      _priority = selectedPriority;
    });
    await _loadTickets();
  }

  void _showManualTicketMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          OpsFixI18n.t(
              'Form tiket manual dapat ditambahkan pada tahap berikutnya.'),
        ),
        duration: Duration(milliseconds: 4000),
      ),
    );
  }

  String _text(
    Map<String, dynamic> row,
    String key, [
    // Sentinel rather than the literal: a default parameter value has to be a
    // compile-time constant, so the translation happens below instead.
    String? fallback,
  ]) {
    final value = row[key]?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
    return fallback ?? OpsFixI18n.t('Belum tersedia');
  }

  String _statusLabel(String value) => switch (value.toLowerCase()) {
        'reported' => OpsFixI18n.t('Baru dilaporkan'),
        'assigned' => OpsFixI18n.t('Teknisi ditetapkan'),
        'in_progress' => OpsFixI18n.t('Sedang dikerjakan'),
        'pending_verification' => OpsFixI18n.t('Menunggu verifikasi'),
        'reopened' => OpsFixI18n.t('Dibuka kembali'),
        'fixed' => OpsFixI18n.t('Selesai'),
        _ => OpsFixI18n.t('Status diperbarui'),
      };

  Color _statusColor(String value) => switch (value.toLowerCase()) {
        'reported' => const Color(0xFF2563EB),
        'assigned' => const Color(0xFF6C5CE7),
        'in_progress' => const Color(0xFFD97706),
        'pending_verification' => const Color(0xFF0284C7),
        'reopened' => const Color(0xFF7C3AED),
        'fixed' => const Color(0xFF059669),
        _ => const Color(0xFF64748B),
      };

  Widget _statusBadge(Map<String, dynamic> ticket) {
    final raw = _text(ticket, 'status', '');
    final color = _statusColor(raw);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        _statusLabel(raw),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _priorityBadge(Map<String, dynamic> ticket) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          _text(ticket, 'priority', '-'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFB45309),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  void _openTicket(Map<String, dynamic> ticket) {
    final id = _text(ticket, 'id', '');
    if (id.isEmpty) return;
    context.pushNamed(
      'adminTicketDetailPage',
      queryParameters: {'ticketId': id},
      extra: _opsFixPageFade(),
    );
  }

  Widget _detailButton(Map<String, dynamic> ticket, {bool fill = false}) =>
      SizedBox(
        width: fill ? double.infinity : 126,
        height: 40,
        child: OutlinedButton.icon(
          onPressed: () => _openTicket(ticket),
          icon: const Icon(Icons.arrow_outward, size: 18),
          label: Text(OpsFixI18n.t('Lihat detail')),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF6C5CE7),
            side: const BorderSide(color: Color(0xFF6C5CE7)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      );

  int _affectedCount(Map<String, dynamic> ticket) =>
      int.tryParse(ticket['affected_count']?.toString() ?? '') ?? 1;

  Widget? _affectedIndicator(Map<String, dynamic> ticket) {
    final count = _affectedCount(ticket);
    if (count <= 1) return null;
    final label = OpsFixI18n.tf('{0} orang terdampak', [count]);
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 112),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF0EDFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.group_outlined,
                color: Color(0xFF5B4CE3),
                size: 15,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  OpsFixI18n.tf('{0} terdampak', [count]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF5B4CE3),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentSlot({
    required Widget child,
    required bool equalized,
    required double height,
  }) =>
      equalized
          ? SizedBox(
              height: height,
              child: Align(alignment: Alignment.topLeft, child: child),
            )
          : child;

  Widget _ticketHeader(Map<String, dynamic> ticket) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              _text(ticket, 'ticket_code'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: _statusBadge(ticket),
          ),
        ],
      );

  Widget _ticketFooter(Map<String, dynamic> ticket) {
    final affected = _affectedIndicator(ticket);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Wrap(
            spacing: 7,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _priorityBadge(ticket),
              if (affected != null) affected,
            ],
          ),
        ),
        const SizedBox(width: 10),
        _detailButton(ticket),
      ],
    );
  }

  Widget _verticalTicketCard(
    Map<String, dynamic> ticket, {
    required bool equalized,
  }) =>
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ticketHeader(ticket),
            const SizedBox(height: 10),
            _contentSlot(
              equalized: equalized,
              height: 38,
              child: Text(
                _text(ticket, 'target_label_snapshot'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 7),
            _contentSlot(
              equalized: equalized,
              height: 34,
              child: Text(
                _text(ticket, 'description'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 9),
              child: Divider(height: 1),
            ),
            _contentSlot(
              equalized: equalized,
              height: 18,
              child: Text(
                _text(ticket, 'location_name_snapshot'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _ticketFooter(ticket),
          ],
        ),
      );

  Widget _horizontalTicketCard(Map<String, dynamic> ticket) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _text(ticket, 'ticket_code'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _text(ticket, 'target_label_snapshot'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    _text(ticket, 'description'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _text(ticket, 'location_name_snapshot'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 178,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: _statusBadge(ticket),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 7,
                    runSpacing: 6,
                    children: [
                      _priorityBadge(ticket),
                      if (_affectedCount(ticket) > 1)
                        _affectedIndicator(ticket)!,
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: _detailButton(ticket, fill: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _searchField() => TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText:
              OpsFixI18n.t('Cari berdasarkan ID, lokasi, atau deskripsi...'),
          prefixIcon: const Icon(Icons.search, size: 21),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  tooltip: OpsFixI18n.t('Hapus pencarian'),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                    _loadTickets();
                  },
                  icon: const Icon(Icons.close, size: 19),
                ),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDE2E7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF6C5CE7),
              width: 1.4,
            ),
          ),
        ),
      );

  Widget _filterButton() => SizedBox(
        height: 48,
        child: OutlinedButton.icon(
          onPressed: _openFilters,
          icon: const Icon(Icons.tune, size: 19),
          label: Text(
            _activeFilterCount == 0
                ? OpsFixI18n.t('Filter')
                : 'Filter ($_activeFilterCount)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF374151),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: _activeFilterCount == 0
                  ? const Color(0xFFDDE2E7)
                  : const Color(0xFF6C5CE7),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      );

  String _sortLabel(String value) => switch (value) {
        'updated_desc' => OpsFixI18n.t('Terakhir diperbarui'),
        'updated_asc' => OpsFixI18n.t('Paling lama diperbarui'),
        'created_desc' => OpsFixI18n.t('Laporan terbaru'),
        'sla_due' => OpsFixI18n.t('Tenggat SLA terdekat'),
        _ => OpsFixI18n.t('Prioritas operasional'),
      };

  Widget _sortButton() => PopupMenuButton<String>(
        tooltip: OpsFixI18n.t('Urutkan tiket'),
        initialValue: _sort,
        onSelected: (value) {
          if (value == _sort) return;
          setState(() => _sort = value);
          _loadTickets();
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'operational',
            child: Text(OpsFixI18n.t('Prioritas operasional')),
          ),
          PopupMenuItem(
            value: 'updated_desc',
            child: Text(OpsFixI18n.t('Terakhir diperbarui')),
          ),
          PopupMenuItem(
            value: 'updated_asc',
            child: Text(OpsFixI18n.t('Paling lama diperbarui')),
          ),
          PopupMenuItem(
            value: 'created_desc',
            child: Text(OpsFixI18n.t('Laporan terbaru')),
          ),
          PopupMenuItem(
            value: 'sla_due',
            child: Text(OpsFixI18n.t('Tenggat SLA terdekat')),
          ),
        ],
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDDE2E7)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.swap_vert, size: 19, color: Color(0xFF374151)),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _sortLabel(_sort),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Color(0xFF64748B),
              ),
            ],
          ),
        ),
      );

  Widget _toolbar(double availableWidth, bool phone) {
    if (phone) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _searchField(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _filterButton()),
              const SizedBox(width: 10),
              Expanded(child: _sortButton()),
            ],
          ),
        ],
      );
    }

    final compact = availableWidth < 800;
    return Row(
      children: [
        Expanded(child: _searchField()),
        const SizedBox(width: 10),
        SizedBox(width: compact ? 112 : 140, child: _filterButton()),
        const SizedBox(width: 10),
        SizedBox(width: compact ? 150 : 190, child: _sortButton()),
      ],
    );
  }

  Widget _registryHeader(double availableWidth) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            OpsFixI18n.t('ADMIN · TICKET REGISTRY'),
            style: TextStyle(
              color: Color(0xFF6C5CE7),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: .35,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  OpsFixI18n.t('Semua tiket dalam satu antrean.'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 42,
                child: FilledButton.icon(
                  onPressed: _showManualTicketMessage,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: Text(OpsFixI18n.t('Tambah')),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            OpsFixI18n.t(
                'Pantau progres laporan, prioritas penanganan, lokasi, dan teknisi dalam satu antrean.'),
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      );

  Widget _errorPanel() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          border: Border.all(color: const Color(0xFFFED7AA)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_off_outlined, color: Color(0xFFC2410C)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _error ?? OpsFixI18n.t('Tiket tidak dapat dimuat.'),
                style: const TextStyle(
                  color: Color(0xFF9A3412),
                  fontSize: 13,
                ),
              ),
            ),
            TextButton(
                onPressed: _loadTickets,
                child: Text(OpsFixI18n.t('Coba lagi'))),
          ],
        ),
      );

  Widget _emptyPanel() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 42),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDDE2E7)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 36,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(height: 10),
            Text(
              OpsFixI18n.t('Tidak ada tiket yang sesuai.'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              OpsFixI18n.t(
                  'Ubah pencarian atau filter untuk melihat antrean lain.'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
      );

  Widget _ticketGrid(double availableWidth, double screenWidth) {
    if (_initialLoading) {
      return const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null && _tickets.isEmpty) return _errorPanel();
    if (_tickets.isEmpty) return _emptyPanel();

    final columns = availableWidth >= 1080
        ? 3
        : availableWidth >= 680
            ? 2
            : 1;
    const gap = 16.0;
    final cardWidth = (availableWidth - (columns - 1) * gap) / columns;
    final horizontal = screenWidth >= 480 && availableWidth < 680;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final ticket in _tickets)
          SizedBox(
            width: cardWidth,
            child: horizontal
                ? IntrinsicHeight(child: _horizontalTicketCard(ticket))
                : _verticalTicketCard(
                    ticket,
                    equalized: screenWidth >= 480,
                  ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final phone = screenWidth < 480;
    final maxWidth = screenWidth >= 1200
        ? 1280.0
        : screenWidth >= 800
            ? 1120.0
            : 960.0;
    final horizontalPadding = screenWidth >= 800
        ? 24.0
        : screenWidth >= 480
            ? 20.0
            : 14.0;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RefreshIndicator(
        onRefresh: _loadTickets,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            18,
            horizontalPadding,
            28,
          ),
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _registryHeader(availableWidth),
                        const SizedBox(height: 18),
                        _toolbar(availableWidth, phone),
                        if (_quickView != null) ...[
                          const SizedBox(height: 10),
                          _quickViewChip(),
                        ],
                        if (_refreshing) ...[
                          const SizedBox(height: 8),
                          const LinearProgressIndicator(minHeight: 2),
                        ],
                        if (_error != null && _tickets.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _errorPanel(),
                        ],
                        const SizedBox(height: 18),
                        _ticketGrid(availableWidth, screenWidth),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketFilterPanel extends StatefulWidget {
  const _TicketFilterPanel({
    required this.initialStatus,
    required this.initialPriority,
    required this.sheet,
  });

  final String? initialStatus;
  final String? initialPriority;
  final bool sheet;

  @override
  State<_TicketFilterPanel> createState() => _TicketFilterPanelState();
}

class _TicketFilterPanelState extends State<_TicketFilterPanel> {
  late String _status;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus ?? '';
    _priority = widget.initialPriority ?? '';
  }

  void _close({required bool reset}) {
    Navigator.of(context).pop(<String, String?>{
      'status': reset || _status.isEmpty ? null : _status,
      'priority': reset || _priority.isEmpty ? null : _priority,
    });
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.sheet ? 24 : 20),
          bottom: Radius.circular(widget.sheet ? 0 : 20),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        OpsFixI18n.t('Filter tiket'),
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: OpsFixI18n.t('Tutup'),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _status,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: OpsFixI18n.t('Status'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                        value: '', child: Text(OpsFixI18n.t('Semua status'))),
                    DropdownMenuItem(
                      value: 'reported',
                      child: Text(OpsFixI18n.t('Baru dilaporkan')),
                    ),
                    DropdownMenuItem(
                      value: 'assigned',
                      child: Text(OpsFixI18n.t('Teknisi ditetapkan')),
                    ),
                    DropdownMenuItem(
                      value: 'in_progress',
                      child: Text(OpsFixI18n.t('Sedang dikerjakan')),
                    ),
                    DropdownMenuItem(
                      value: 'pending_verification',
                      child: Text(OpsFixI18n.t('Menunggu verifikasi')),
                    ),
                    DropdownMenuItem(
                      value: 'reopened',
                      child: Text(OpsFixI18n.t('Dibuka kembali')),
                    ),
                    DropdownMenuItem(
                      value: 'fixed',
                      child: Text(OpsFixI18n.t('Selesai')),
                    ),
                  ],
                  onChanged: (value) => setState(() => _status = value ?? ''),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _priority,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: OpsFixI18n.t('Prioritas'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(OpsFixI18n.t('Semua prioritas')),
                    ),
                    DropdownMenuItem(
                        value: 'critical', child: Text(OpsFixI18n.t('Kritis'))),
                    DropdownMenuItem(
                        value: 'high', child: Text(OpsFixI18n.t('Tinggi'))),
                    DropdownMenuItem(
                        value: 'medium', child: Text(OpsFixI18n.t('Sedang'))),
                    DropdownMenuItem(
                        value: 'low', child: Text(OpsFixI18n.t('Rendah'))),
                  ],
                  onChanged: (value) => setState(() => _priority = value ?? ''),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _close(reset: true),
                        child: Text(OpsFixI18n.t('Reset')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _close(reset: false),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                        ),
                        child: Text(OpsFixI18n.t('Terapkan')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
