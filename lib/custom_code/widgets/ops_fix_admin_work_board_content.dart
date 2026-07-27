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

class OpsFixAdminWorkBoardContent extends StatefulWidget {
  const OpsFixAdminWorkBoardContent({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<OpsFixAdminWorkBoardContent> createState() =>
      OpsFixAdminWorkBoardContentState();
}

class OpsFixAdminWorkBoardContentState
    extends State<OpsFixAdminWorkBoardContent> {
  static const _boardStatuses = [
    'reported',
    'assigned',
    'in_progress',
    'pending_verification',
  ];
  static const _selectFields =
      'id,site_id,ticket_code,status,priority,priority_rank,'
      'target_label_snapshot,location_code_snapshot,'
      'location_name_snapshot,technician_name_snapshot';

  List<Map<String, dynamic>> _tickets = [];
  String _selectedStatus = 'reported';
  bool _loading = true;
  bool _refreshing = false;
  String? _error;
  int _requestSerial = 0;

  List<_BoardLane> get _lanes => const [
        _BoardLane(
          status: 'reported',
          label: 'Baru dilaporkan',
          icon: Icons.campaign_outlined,
          color: Color(0xFF315BEF),
          tint: Color(0xFFEEF2FF),
        ),
        _BoardLane(
          status: 'assigned',
          label: 'Teknisi ditetapkan',
          icon: Icons.person_pin_circle_outlined,
          color: Color(0xFF6C5CE7),
          tint: Color(0xFFF0EDFF),
        ),
        _BoardLane(
          status: 'in_progress',
          label: 'Sedang dikerjakan',
          icon: Icons.engineering_outlined,
          color: Color(0xFFD97706),
          tint: Color(0xFFFFF3E0),
        ),
        _BoardLane(
          status: 'pending_verification',
          label: 'Menunggu verifikasi',
          icon: Icons.fact_check_outlined,
          color: Color(0xFF059669),
          tint: Color(0xFFE5F7F0),
        ),
      ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTickets());
  }

  @override
  void dispose() {
    _requestSerial++;
    super.dispose();
  }

  Future<void> refresh() => _loadTickets();

  Future<void> _loadTickets() async {
    final request = ++_requestSerial;
    final siteId = FFAppState().currentSiteId.trim();

    if (siteId.isEmpty) {
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _tickets = [];
        _error = 'Lokasi kerja belum dipilih. Masuk ulang lalu coba lagi.';
      });
      return;
    }

    if (mounted) {
      setState(() {
        _error = null;
        _loading = _tickets.isEmpty;
        _refreshing = _tickets.isNotEmpty;
      });
    }

    try {
      final response = await SupaFlow.client
          .from('ticket_cards_v')
          .select(_selectFields)
          .eq('site_id', siteId)
          .inFilter('status', _boardStatuses)
          .order('priority_rank', ascending: true);
      final rows = (response as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _tickets = rows;
        _loading = false;
        _refreshing = false;
        _error = null;
      });
    } catch (error) {
      debugPrint('Admin Work Board load failed: ${error.runtimeType}');
      if (!mounted || request != _requestSerial) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _error = 'Work Board belum dapat dimuat. Coba lagi.';
      });
    }
  }

  String _text(Map<String, dynamic> row, String key, String fallback) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  List<Map<String, dynamic>> _ticketsFor(String status) => _tickets
      .where((ticket) => _text(ticket, 'status', '') == status)
      .toList();

  String _priorityLabel(String value) => switch (value.toLowerCase()) {
        'critical' => 'Kritis',
        'high' => 'Tinggi',
        'medium' => 'Sedang',
        'low' => 'Rendah',
        _ => 'Belum ditentukan',
      };

  Color _priorityColor(String value) => switch (value.toLowerCase()) {
        'critical' => const Color(0xFFB91C1C),
        'high' => const Color(0xFFC2410C),
        'medium' => const Color(0xFF1D4ED8),
        'low' => const Color(0xFF15803D),
        _ => const Color(0xFF475569),
      };

  Color _priorityTint(String value) => switch (value.toLowerCase()) {
        'critical' => const Color(0xFFFEF2F2),
        'high' => const Color(0xFFFFF7ED),
        'medium' => const Color(0xFFEFF6FF),
        'low' => const Color(0xFFF0FDF4),
        _ => const Color(0xFFF1F5F9),
      };

  String _location(Map<String, dynamic> ticket) {
    final code = _text(ticket, 'location_code_snapshot', '');
    final name = _text(ticket, 'location_name_snapshot', '');
    final values = [code, name].where((value) => value.isNotEmpty).toList();
    return values.isEmpty ? 'Lokasi belum tersedia' : values.join(' · ');
  }

  void _openTicket(Map<String, dynamic> ticket) {
    final id = _text(ticket, 'id', '');
    if (id.isEmpty) return;
    context.pushNamed(
      'adminTicketDetailPage',
      queryParameters: {'ticketId': id},
    );
  }

  Widget _summary() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1426),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x17081225),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADMIN · WORK BOARD',
                    style: TextStyle(
                      color: Color(0xFF70E1CB),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Alur pekerjaan aktif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tiket dikelompokkan menurut status dan prioritas.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              constraints: const BoxConstraints(minWidth: 74),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF18243A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2B3952)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_tickets.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'TIKET AKTIF',
                    style: TextStyle(
                      color: Color(0xFF9DAAC0),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _ticketCard(
    Map<String, dynamic> ticket,
    _BoardLane lane,
  ) {
    final priority = _text(ticket, 'priority', '');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  color: lane.color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  _text(ticket, 'ticket_code', 'Kode belum tersedia'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _priorityTint(priority),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _priorityLabel(priority),
                  style: TextStyle(
                    color: _priorityColor(priority),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _text(ticket, 'target_label_snapshot', 'Target belum tersedia'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 14,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 11),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF64748B),
                size: 16,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _location(ticket),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.engineering_outlined,
                color: Color(0xFF64748B),
                size: 16,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _text(
                    ticket,
                    'technician_name_snapshot',
                    'Belum ditetapkan',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 38,
            child: OutlinedButton.icon(
              onPressed: () => _openTicket(ticket),
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Buka pekerjaan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: lane.color,
                side: BorderSide(color: lane.color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyLane(_BoardLane lane) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 26),
        decoration: BoxDecoration(
          color: lane.tint.withValues(alpha: 0.58),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(lane.icon, color: lane.color, size: 26),
            const SizedBox(height: 9),
            Text(
              'Belum ada tiket pada tahap ini.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );

  Widget _ticketList(
    _BoardLane lane, {
    required double availableWidth,
    bool allowTwoColumns = false,
  }) {
    final tickets = _ticketsFor(lane.status);
    if (tickets.isEmpty) return _emptyLane(lane);
    final twoColumns = allowTwoColumns;
    if (!twoColumns) {
      return Column(
        children: [
          for (var index = 0; index < tickets.length; index++) ...[
            if (index > 0) const SizedBox(height: 11),
            _ticketCard(tickets[index], lane),
          ],
        ],
      );
    }

    const gap = 12.0;
    final cardWidth = (availableWidth - gap) / 2;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final ticket in tickets)
          SizedBox(
            width: cardWidth,
            child: _ticketCard(ticket, lane),
          ),
      ],
    );
  }

  Widget _lane(
    _BoardLane lane, {
    required double availableWidth,
    bool allowTwoCardColumns = false,
  }) {
    final count = _ticketsFor(lane.status).length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: lane.tint,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(lane.icon, color: lane.color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lane.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: lane.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(minWidth: 30),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: lane.tint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: lane.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _ticketList(
            lane,
            availableWidth: availableWidth - 28,
            allowTwoColumns: allowTwoCardColumns && availableWidth >= 560,
          ),
        ],
      ),
    );
  }

  Widget _laneSelector() => SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _lanes.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final lane = _lanes[index];
            final selected = lane.status == _selectedStatus;
            final count = _ticketsFor(lane.status).length;
            return ChoiceChip(
              selected: selected,
              onSelected: (_) => setState(() => _selectedStatus = lane.status),
              avatar: Icon(
                lane.icon,
                size: 17,
                color: selected ? Colors.white : lane.color,
              ),
              label: Text('${lane.label}  $count'),
              labelStyle: TextStyle(
                color: selected ? Colors.white : const Color(0xFF334155),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              backgroundColor: Colors.white,
              selectedColor: lane.color,
              side: BorderSide(
                color: selected ? lane.color : const Color(0xFFDDE2E7),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            );
          },
        ),
      );

  Widget _singleLaneLayout(double availableWidth) {
    final lane = _lanes.firstWhere(
      (candidate) => candidate.status == _selectedStatus,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _laneSelector(),
        const SizedBox(height: 14),
        _lane(
          lane,
          availableWidth: availableWidth,
          allowTwoCardColumns: true,
        ),
      ],
    );
  }

  Widget _twoByTwoLayout(double availableWidth) {
    const gap = 18.0;
    final laneWidth = (availableWidth - gap) / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _lane(_lanes[0], availableWidth: laneWidth),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: _lane(_lanes[1], availableWidth: laneWidth),
            ),
          ],
        ),
        const SizedBox(height: gap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _lane(_lanes[2], availableWidth: laneWidth),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: _lane(_lanes[3], availableWidth: laneWidth),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fourLaneLayout(double availableWidth) {
    const gap = 16.0;
    final laneWidth = (availableWidth - gap * 3) / 4;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < _lanes.length; index++) ...[
          if (index > 0) const SizedBox(width: gap),
          Expanded(
            child: _lane(_lanes[index], availableWidth: laneWidth),
          ),
        ],
      ],
    );
  }

  Widget _loadingState() => const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
        ),
      );

  Widget _errorState() => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF1C9C9)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFDC2626),
                  size: 34,
                ),
                const SizedBox(height: 12),
                Text(
                  _error ?? 'Work Board tidak tersedia.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: refresh,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Coba lagi'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) return _loadingState();
    if (_error != null && _tickets.isEmpty) return _errorState();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 480
        ? 14.0
        : screenWidth < 800
            ? 20.0
            : screenWidth < 1200
                ? 24.0
                : 32.0;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          20,
          horizontalPadding,
          28,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final useSingleLane = screenWidth < 680 || availableWidth < 640;
                final useFourLanes =
                    screenWidth >= 1200 && availableWidth >= 1080;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _summary(),
                    if (_refreshing) ...[
                      const SizedBox(height: 10),
                      const LinearProgressIndicator(
                        minHeight: 2,
                        color: Color(0xFF6C5CE7),
                        backgroundColor: Color(0xFFE9E5FF),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (useSingleLane)
                      _singleLaneLayout(availableWidth)
                    else if (useFourLanes)
                      _fourLaneLayout(availableWidth)
                    else
                      _twoByTwoLayout(availableWidth),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardLane {
  const _BoardLane({
    required this.status,
    required this.label,
    required this.icon,
    required this.color,
    required this.tint,
  });

  final String status;
  final String label;
  final IconData icon;
  final Color color;
  final Color tint;
}
