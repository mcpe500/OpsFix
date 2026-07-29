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
import '/custom_code/widgets/ops_fix_ticket_time_panel.dart';
import '/custom_code/widgets/ops_fix_technician_assignment_panel.dart';
import '/custom_code/widgets/ops_fix_ticket_activity_panel.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixAdminTicketDetailContent extends StatefulWidget {
  const OpsFixAdminTicketDetailContent({
    super.key,
    this.width,
    this.height,
    required this.ticketId,
  });

  final double? width;
  final double? height;
  final String? ticketId;

  @override
  State<OpsFixAdminTicketDetailContent> createState() =>
      _OpsFixAdminTicketDetailContentState();
}

class _OpsFixAdminTicketDetailContentState
    extends State<OpsFixAdminTicketDetailContent> {
  static const _selectFields =
      'id,site_id,ticket_code,status,target_label_snapshot,issue_category_snapshot,issue_type_snapshot,description,priority,location_code_snapshot,location_name_snapshot,unit_code_snapshot,unit_name_snapshot,unit_position_snapshot,reporter_name_snapshot,technician_name_snapshot';

  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _ticket;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTicket());
  }

  Future<void> _loadTicket() async {
    final ticketId = (widget.ticketId ?? '').trim();
    final siteId = FFAppState().currentSiteId.trim();

    if (ticketId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = OpsFixI18n.t('Tautan tiket tidak valid.');
        _ticket = null;
      });
      return;
    }
    if (siteId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = OpsFixI18n.t(
            'Lokasi kerja belum dipilih. Masuk ulang lalu coba lagi.');
        _ticket = null;
      });
      return;
    }

    try {
      final row = await SupaFlow.client
          .from('ticket_detail_v')
          .select(_selectFields)
          .eq('id', ticketId)
          .eq('site_id', siteId)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _ticket = row == null ? null : Map<String, dynamic>.from(row);
        _error = row == null
            ? OpsFixI18n.t('Tiket tidak ditemukan atau tidak dapat diakses.')
            : null;
      });
    } catch (error) {
      debugPrint('Admin ticket detail load failed: ${error.runtimeType}');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = OpsFixI18n.t('Detail tiket belum dapat dimuat. Coba lagi.');
        _ticket = null;
      });
    }
  }

  String _text(String key, String fallback) {
    final value = _ticket?[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
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
        'reported' => const Color(0xFFB45309),
        'assigned' => const Color(0xFF1D4ED8),
        'in_progress' => const Color(0xFF6D28D9),
        'pending_verification' => const Color(0xFF0F766E),
        'reopened' => const Color(0xFFBE123C),
        'fixed' => const Color(0xFF15803D),
        _ => const Color(0xFF475569),
      };

  Color _statusBackground(String value) => switch (value.toLowerCase()) {
        'reported' => const Color(0xFFFFF7ED),
        'assigned' => const Color(0xFFEFF6FF),
        'in_progress' => const Color(0xFFF5F3FF),
        'pending_verification' => const Color(0xFFF0FDFA),
        'reopened' => const Color(0xFFFFF1F2),
        'fixed' => const Color(0xFFF0FDF4),
        _ => const Color(0xFFF1F5F9),
      };

  String _priorityLabel(String value) => switch (value.toLowerCase()) {
        'critical' => OpsFixI18n.t('Kritis'),
        'high' => OpsFixI18n.t('Tinggi'),
        'medium' => OpsFixI18n.t('Sedang'),
        'low' => OpsFixI18n.t('Rendah'),
        _ => OpsFixI18n.t('Belum ditentukan'),
      };

  Color _priorityColor(String value) => switch (value.toLowerCase()) {
        'critical' => const Color(0xFFB91C1C),
        'high' => const Color(0xFFC2410C),
        'medium' => const Color(0xFF1D4ED8),
        'low' => const Color(0xFF15803D),
        _ => const Color(0xFF475569),
      };

  Widget _chip({
    required String label,
    required Color foreground,
    required Color background,
    IconData? icon,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: foreground),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _hero() {
    final status = _text('status', '');
    final priority = _text('priority', '');
    final issueCategory = _text('issue_category_snapshot', '');
    final issueType = _text(
        'issue_type_snapshot', OpsFixI18n.t('Jenis gangguan belum tersedia'));
    final issueLabel =
        issueCategory.isEmpty ? issueType : '$issueCategory · $issueType';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1426),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18081225),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                _text('ticket_code', OpsFixI18n.t('Kode tiket belum tersedia')),
                style: const TextStyle(
                  color: Color(0xFF70E1CB),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
              _chip(
                label: _statusLabel(status),
                foreground: _statusColor(status),
                background: _statusBackground(status),
              ),
              _chip(
                label: _priorityLabel(priority),
                foreground: _priorityColor(priority),
                background: Colors.white,
                icon: Icons.flag_outlined,
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            _text('target_label_snapshot',
                OpsFixI18n.t('Target tiket tidak tersedia')),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            issueLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFB8C4D8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            _text('description',
                OpsFixI18n.t('Deskripsi laporan belum tersedia.')),
            style: const TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contextRow(
    IconData icon,
    String label,
    String value, {
    bool last = false,
  }) =>
      Container(
        padding: EdgeInsets.only(bottom: last ? 0 : 13),
        margin: EdgeInsets.only(bottom: last ? 0 : 13),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFEEF1F4)),
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: const Color(0xFF6C5CE7)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _contextCard() {
    final locationCode = _text('location_code_snapshot', '');
    final locationName = _text(
      'location_name_snapshot',
      OpsFixI18n.t('Lokasi belum tersedia'),
    );
    final location =
        locationCode.isEmpty ? locationName : '$locationCode · $locationName';
    final unitCode = _text('unit_code_snapshot', '');
    final unitName = _text('unit_name_snapshot', '');
    final unit =
        [unitCode, unitName].where((value) => value.isNotEmpty).join(' · ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            OpsFixI18n.t('Konteks fasilitas'),
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            OpsFixI18n.t('Lokasi, unit, pelapor, dan teknisi yang terkait.'),
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(height: 17),
          _contextRow(
              Icons.location_on_outlined, OpsFixI18n.t('Lokasi'), location),
          _contextRow(
            Icons.computer_outlined,
            OpsFixI18n.t('Unit'),
            unit.isEmpty ? OpsFixI18n.t('Laporan tingkat lokasi') : unit,
          ),
          _contextRow(
            Icons.place_outlined,
            OpsFixI18n.t('Posisi'),
            _text('unit_position_snapshot', OpsFixI18n.t('Belum ditentukan')),
          ),
          _contextRow(
            Icons.person_outline,
            OpsFixI18n.t('Pelapor'),
            _text('reporter_name_snapshot',
                OpsFixI18n.t('Pelapor tidak tersedia')),
          ),
          _contextRow(
            Icons.engineering_outlined,
            OpsFixI18n.t('Teknisi'),
            _text('technician_name_snapshot', OpsFixI18n.t('Belum ditetapkan')),
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _timePanel() => SizedBox(
        width: double.infinity,
        child: OpsFixTicketTimePanel(ticketId: widget.ticketId),
      );

  Widget _assignmentPanel() => SizedBox(
        width: double.infinity,
        child: OpsFixTechnicianAssignmentPanel(
          siteId: FFAppState().currentSiteId,
          ticketId: widget.ticketId,
        ),
      );

  Widget _activityPanel() => SizedBox(
        width: double.infinity,
        child: OpsFixTicketActivityPanel(ticketId: widget.ticketId),
      );

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback action,
    required bool primary,
  }) =>
      SizedBox(
        height: 48,
        child: primary
            ? FilledButton.icon(
                onPressed: action,
                icon: Icon(icon, size: 18),
                label: Text(label),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            : OutlinedButton.icon(
                onPressed: action,
                icon: Icon(icon, size: 18),
                label: Text(label),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6C5CE7),
                  side: const BorderSide(color: Color(0xFF6C5CE7)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
      );

  Widget _actions(BuildContext context, double availableWidth) {
    final tickets = _actionButton(
      label: OpsFixI18n.t('Semua tiket'),
      icon: Icons.list_alt,
      action: () => context.goNamed(
        'adminTicketsPage',
        extra: _opsFixPageFade(),
      ),
      primary: false,
    );
    final board = _actionButton(
      label: OpsFixI18n.t('Board pekerjaan'),
      icon: Icons.view_kanban,
      action: () => context.goNamed(
        'adminWorkBoardPage',
        extra: _opsFixPageFade(),
      ),
      primary: true,
    );

    if (availableWidth < 400) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tickets,
          const SizedBox(height: 10),
          board,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: tickets),
        const SizedBox(width: 10),
        Expanded(child: board),
      ],
    );
  }

  Widget _loadingState() => const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
        ),
      );

  Widget _errorState(BuildContext context) => Center(
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
                  _error ?? OpsFixI18n.t('Detail tiket tidak tersedia.'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.goNamed(
                        'adminTicketsPage',
                        extra: _opsFixPageFade(),
                      ),
                      child: Text(OpsFixI18n.t('Kembali ke tiket')),
                    ),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _loading = true;
                          _error = null;
                        });
                        _loadTicket();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                      ),
                      child: Text(OpsFixI18n.t('Coba lagi')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _phoneLayout(BuildContext context, double availableWidth) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _hero(),
          const SizedBox(height: 16),
          _contextCard(),
          const SizedBox(height: 16),
          _timePanel(),
          const SizedBox(height: 16),
          _assignmentPanel(),
          const SizedBox(height: 16),
          _activityPanel(),
          const SizedBox(height: 16),
          _actions(context, availableWidth),
        ],
      );

  Widget _tabletLayout(BuildContext context, double availableWidth) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _hero(),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _contextCard()),
              const SizedBox(width: 18),
              Expanded(flex: 2, child: _timePanel()),
            ],
          ),
          const SizedBox(height: 18),
          _assignmentPanel(),
          const SizedBox(height: 18),
          _activityPanel(),
          const SizedBox(height: 18),
          _actions(context, availableWidth),
        ],
      );

  Widget _largeTabletLayout(
    BuildContext context,
    double availableWidth,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _hero(),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _contextCard(),
                    const SizedBox(height: 20),
                    _activityPanel(),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _timePanel(),
                    const SizedBox(height: 20),
                    _assignmentPanel(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _actions(context, availableWidth),
        ],
      );

  Widget _desktopLayout(BuildContext context, double availableWidth) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _hero(),
                const SizedBox(height: 22),
                _contextCard(),
                const SizedBox(height: 22),
                _activityPanel(),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _timePanel(),
                const SizedBox(height: 22),
                _assignmentPanel(),
                const SizedBox(height: 22),
                _actions(context, availableWidth * 5 / 12),
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) return _loadingState();
    if (_error != null || _ticket == null) return _errorState(context);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 480
        ? 14.0
        : screenWidth < 800
            ? 20.0
            : screenWidth < 1200
                ? 24.0
                : 32.0;
    final maxWidth = screenWidth < 800
        ? 960.0
        : screenWidth < 1200
            ? 1120.0
            : 1280.0;

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
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                if (screenWidth >= 1200) {
                  return _desktopLayout(context, availableWidth);
                }
                if (screenWidth >= 800) {
                  return _largeTabletLayout(context, availableWidth);
                }
                if (availableWidth >= 680) {
                  return _tabletLayout(context, availableWidth);
                }
                return _phoneLayout(context, availableWidth);
              },
            ),
          ),
        ),
      ),
    );
  }
}
