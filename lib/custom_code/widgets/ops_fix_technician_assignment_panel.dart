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
import 'package:go_router/go_router.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixTechnicianAssignmentPanel extends StatefulWidget {
  const OpsFixTechnicianAssignmentPanel({
    super.key,
    this.width,
    this.height,
    required this.ticketId,
    required this.siteId,
  });

  final double? width;
  final double? height;
  final String? ticketId;
  final String? siteId;

  @override
  State<OpsFixTechnicianAssignmentPanel> createState() =>
      _OpsFixTechnicianAssignmentPanelState();
}

class _OpsFixTechnicianAssignmentPanelState
    extends State<OpsFixTechnicianAssignmentPanel> {
  bool _loading = true;
  String? _busyId;
  String? _message;
  bool _messageIsError = false;
  List<Map<String, dynamic>> _technicians = const [];
  String _ticketStatus = '';
  String _ticketSiteId = '';
  String _assignedTechnicianName = '';
  String _assignedTechnicianId = '';

  @override
  void initState() {
    super.initState();
    _loadTechnicians();
  }

  Future<void> _loadTechnicians() async {
    final ticketId = (widget.ticketId ?? '').trim();
    if (ticketId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _message = OpsFixI18n.t('Tiket belum dipilih.');
        _messageIsError = true;
      });
      return;
    }
    try {
      final ticket = await SupaFlow.client
          .from('tickets')
          .select(
              'site_id, status, assigned_technician_id, technician_name_snapshot')
          .eq('id', ticketId)
          .maybeSingle();
      if (ticket == null) {
        throw Exception(OpsFixI18n.t('Ticket not found or access denied.'));
      }
      final siteId = ticket['site_id']?.toString().trim() ?? '';
      final status = ticket['status']?.toString().trim().toLowerCase() ?? '';
      final assignedName =
          ticket['technician_name_snapshot']?.toString().trim() ?? '';
      final assignedId =
          ticket['assigned_technician_id']?.toString().trim() ?? '';
      if (siteId.isEmpty) {
        throw Exception(OpsFixI18n.t('Ticket site is missing.'));
      }
      const lockedStatuses = {
        'pending_verification',
        'fixed',
        'closed',
        'cancelled',
        'rejected',
      };
      if (lockedStatuses.contains(status)) {
        if (!mounted) return;
        setState(() {
          _ticketSiteId = siteId;
          _ticketStatus = status;
          _assignedTechnicianName = assignedName;
          _assignedTechnicianId = assignedId;
          _technicians = const [];
          _loading = false;
        });
        return;
      }
      final scopes = await SupaFlow.client
          .from('user_site_scopes')
          .select('user_id')
          .eq('site_id', siteId);
      final userIds = scopes
          .map((row) => row['user_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();
      if (userIds.isEmpty) {
        if (!mounted) return;
        setState(() {
          _ticketSiteId = siteId;
          _ticketStatus = status;
          _assignedTechnicianName = assignedName;
          _assignedTechnicianId = assignedId;
          _technicians = const [];
          _loading = false;
        });
        return;
      }
      final rows = await SupaFlow.client
          .from('users')
          .select('id, display_name, phone, avatar_url')
          .inFilter('id', userIds)
          .eq('role', 'technician')
          .eq('is_active', true)
          .order('display_name');
      if (!mounted) return;
      setState(() {
        _ticketSiteId = siteId;
        _ticketStatus = status;
        _assignedTechnicianName = assignedName;
        _technicians = rows
            .map<Map<String, dynamic>>(
              (row) => Map<String, dynamic>.from(row),
            )
            .toList();
        _loading = false;
      });
    } catch (error) {
      debugPrint('OpsFix assignment load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _message =
            OpsFixI18n.t('Data penugasan tidak dapat dimuat. Coba lagi.');
        _messageIsError = true;
      });
    }
  }

  Future<void> _assign(Map<String, dynamic> technician) async {
    if (_busyId != null) return;
    final ticketId = (widget.ticketId ?? '').trim();
    final technicianId = technician['id']?.toString() ?? '';
    final technicianName = technician['display_name']?.toString().trim() ?? '';
    if (ticketId.isEmpty || _ticketSiteId.isEmpty || technicianId.isEmpty) {
      setState(() {
        _message = 'Data penugasan belum lengkap.';
        _messageIsError = true;
      });
      return;
    }
    setState(() {
      _busyId = technicianId;
      _message = null;
    });
    try {
      final scope = await SupaFlow.client
          .from('user_site_scopes')
          .select('id')
          .eq('site_id', _ticketSiteId)
          .eq('user_id', technicianId)
          .limit(1)
          .maybeSingle();
      if (scope == null) {
        throw Exception(
            OpsFixI18n.t('Technician is not assigned to this site.'));
      }
      final current = await SupaFlow.client
          .from('tickets')
          .select('version, status, site_id')
          .eq('id', ticketId)
          .maybeSingle();
      if (current == null || current['site_id']?.toString() != _ticketSiteId) {
        throw Exception(OpsFixI18n.t('Ticket not found or access denied.'));
      }
      final status = current['status']?.toString().toLowerCase() ?? '';
      const lockedStatuses = {
        'pending_verification',
        'fixed',
        'closed',
        'cancelled',
        'rejected',
      };
      if (lockedStatuses.contains(status)) {
        throw Exception(
            OpsFixI18n.t('Ticket status no longer allows assignment.'));
      }
      final version = (current['version'] as num?)?.toInt() ?? 0;
      final updated = await SupaFlow.client
          .from('tickets')
          .update({
            'assigned_technician_id': technicianId,
            'version': version + 1,
          })
          .eq('id', ticketId)
          .eq('version', version)
          .select('id');
      if (updated.isEmpty) {
        throw Exception(OpsFixI18n.t('Ticket changed. Refresh and try again.'));
      }
      if (!mounted) return;
      setState(() {
        _busyId = null;
        _message =
            '${technicianName.isEmpty ? OpsFixI18n.t('Teknisi') : technicianName} berhasil ditetapkan.';
        _messageIsError = false;
      });
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      GoRouter.of(context).pushReplacementNamed(
        'adminTicketDetailPage',
        queryParameters: {'ticketId': ticketId},
        extra: _opsFixPageFade(),
      );
    } catch (error) {
      debugPrint('OpsFix assignment failed: $error');
      if (!mounted) return;
      setState(() {
        _busyId = null;
        _message = OpsFixI18n.t(
            'Penugasan tidak dapat disimpan. Muat ulang tiket lalu coba lagi.');
        _messageIsError = true;
      });
    }
  }

  String _initial(String name) {
    final value = name.trim();
    return value.isEmpty ? 'T' : value.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const lockedStatuses = {
      'pending_verification',
      'fixed',
      'closed',
      'cancelled',
      'rejected',
    };

    Widget shell(List<Widget> children) => Container(
          width: widget.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDDE2E7)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        );

    if (_loading) {
      return shell(const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Center(child: CircularProgressIndicator()),
        ),
      ]);
    }

    if (lockedStatuses.contains(_ticketStatus)) {
      final statusLabel = _ticketStatus == 'pending_verification'
          ? OpsFixI18n.t('Menunggu verifikasi')
          : _ticketStatus == 'fixed'
              ? OpsFixI18n.t('Selesai')
              : OpsFixI18n.t('Ditutup');
      return shell([
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFEDE9FE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, color: Color(0xFF6C5CE7)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    OpsFixI18n.tf('Penugasan {0}', [statusLabel]),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _assignedTechnicianName.isEmpty
                        ? OpsFixI18n.t(
                            'Status tiket ini tidak menerima penugasan baru.')
                        : OpsFixI18n.tf(
                            'Ditangani oleh {0}', [_assignedTechnicianName]),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]);
    }

    final assignedNameKey = _assignedTechnicianName
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');
    final seenCandidateKeys = <String>{};
    final candidates = _technicians.where((item) {
      final id = item['id']?.toString().trim() ?? '';
      final nameKey = (item['display_name']?.toString() ?? '')
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'\s+'), ' ');
      final isCurrent = id == _assignedTechnicianId ||
          (assignedNameKey.isNotEmpty && nameKey == assignedNameKey);
      final candidateKey = nameKey.isNotEmpty ? nameKey : id;
      return !isCurrent &&
          candidateKey.isNotEmpty &&
          seenCandidateKeys.add(candidateKey);
    }).toList();
    final hasCurrentTechnician =
        _assignedTechnicianId.isNotEmpty || _assignedTechnicianName.isNotEmpty;

    return shell([
      Text(
        hasCurrentTechnician
            ? OpsFixI18n.t('Kelola penugasan')
            : OpsFixI18n.t('Tetapkan teknisi'),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w700,
            ),
      ),
      const SizedBox(height: 5),
      Text(
        hasCurrentTechnician
            ? OpsFixI18n.t(
                'Tiket ini sudah memiliki teknisi. Pilih pengganti hanya jika diperlukan.')
            : OpsFixI18n.t(
                'Pilih teknisi aktif yang memiliki akses ke lokasi tiket.'),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF64748B),
            ),
      ),
      if (hasCurrentTechnician) ...[
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.engineering_outlined,
                  color: Color(0xFF047857),
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _assignedTechnicianName.isEmpty
                          ? OpsFixI18n.t('Teknisi telah ditetapkan')
                          : _assignedTechnicianName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      OpsFixI18n.t('Sedang bertugas'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF047857),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  OpsFixI18n.t('Aktif'),
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      if (candidates.isNotEmpty) ...[
        const SizedBox(height: 16),
        Text(
          hasCurrentTechnician
              ? OpsFixI18n.t('Teknisi pengganti')
              : OpsFixI18n.t('Teknisi tersedia'),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 9),
        for (var index = 0; index < candidates.length; index++) ...[
          _technicianCard(context, candidates[index], colors),
          if (index < candidates.length - 1) const SizedBox(height: 9),
        ],
      ] else ...[
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            hasCurrentTechnician
                ? OpsFixI18n.t(
                    'Tidak ada teknisi lain yang tersedia untuk mengganti penugasan.')
                : OpsFixI18n.t(
                    'Belum ada teknisi aktif untuk lokasi tiket ini.'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF64748B),
                ),
          ),
        ),
      ],
      if (_message != null) ...[
        const SizedBox(height: 12),
        Text(
          _message!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _messageIsError
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF047857),
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    ]);
  }

  Widget _technicianCard(
    BuildContext context,
    Map<String, dynamic> technician,
    ColorScheme colors,
  ) {
    final id = technician['id']?.toString() ?? '';
    final name = technician['display_name']?.toString().trim() ?? '';
    final busy = _busyId == id;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEDE9FE),
            child: Text(
              _initial(name),
              style: const TextStyle(
                color: Color(0xFF6C5CE7),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? OpsFixI18n.t('Teknisi OpsFix') : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  OpsFixI18n.t('Tersedia di lokasi tiket'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: busy ? null : () => _assign(technician),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              minimumSize: const Size(0, 38),
            ),
            child: busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(hasCurrentAssignment
                    ? OpsFixI18n.t('Ganti')
                    : OpsFixI18n.t('Tetapkan')),
          ),
        ],
      ),
    );
  }

  bool get hasCurrentAssignment =>
      _assignedTechnicianId.isNotEmpty || _assignedTechnicianName.isNotEmpty;
}
