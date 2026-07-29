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
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixTechnicianActiveQueue extends StatefulWidget {
  const OpsFixTechnicianActiveQueue({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixTechnicianActiveQueue> createState() =>
      _OpsFixTechnicianActiveQueueState();
}

class _OpsFixTechnicianActiveQueueState
    extends State<OpsFixTechnicianActiveQueue> {
  bool _loading = true;
  String _name = '';
  String? _error;
  List<Map<String, dynamic>> _tickets = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final siteId = FFAppState().currentSiteId.trim();
      var ticketQuery = SupaFlow.client
          .from('ticket_cards_v')
          .select(
              'id,ticket_code,status,priority,target_label_snapshot,issue_type_snapshot,description,location_name_snapshot,unit_code_snapshot,updated_at')
          .eq('assigned_technician_id', currentUserUid)
          .eq('is_open', true);
      if (siteId.isNotEmpty) ticketQuery = ticketQuery.eq('site_id', siteId);
      final results = await Future.wait([
        SupaFlow.client
            .from('users')
            .select('display_name')
            .eq('id', currentUserUid)
            .maybeSingle(),
        ticketQuery
            .order('priority_rank', ascending: true)
            .order('updated_at', ascending: false),
      ]);
      if (!mounted) return;
      setState(() {
        final user = results[0] as Map<String, dynamic>?;
        _name = user?['display_name']?.toString().trim() ?? '';
        _tickets = (results[1] as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _loading = false;
        _error = null;
      });
    } catch (error) {
      debugPrint('Technician queue load failed: $error');
      if (mounted)
        setState(() {
          _loading = false;
          _error = OpsFixI18n.t(
              'Antrean belum dapat dimuat. Tarik layar untuk mencoba lagi.');
        });
    }
  }

  String _status(String raw) => switch (raw.toLowerCase()) {
        'assigned' => OpsFixI18n.t('Siap dimulai'),
        'in_progress' => OpsFixI18n.t('Sedang dikerjakan'),
        'pending_verification' => OpsFixI18n.t('Menunggu verifikasi'),
        _ => OpsFixI18n.t('Dalam penanganan'),
      };

  Color _statusColor(String raw) => switch (raw.toLowerCase()) {
        'assigned' => const Color(0xFF4F46E5),
        'in_progress' => const Color(0xFFD97706),
        'pending_verification' => const Color(0xFF2563EB),
        _ => const Color(0xFF64748B),
      };

  void _open(String id) {
    context.pushNamed(
      'technicianTicketDetailPage',
      queryParameters:
          {'ticketId': serializeParam(id, ParamType.String)}.withoutNulls,
      extra: _opsFixPageFade(),
    );
  }

  Widget _ticketCard(Map<String, dynamic> ticket) {
    final status = ticket['status']?.toString() ?? '';
    final title = ticket['target_label_snapshot']?.toString().trim();
    final issue = ticket['issue_type_snapshot']?.toString().trim();
    final description = ticket['description']?.toString().trim();
    final location = ticket['location_name_snapshot']?.toString().trim();
    final unit = ticket['unit_code_snapshot']?.toString().trim();
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Text(
                    ticket['ticket_code']?.toString() ?? OpsFixI18n.t('Tiket'),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4F46E5)))),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(_status(status),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _statusColor(status))),
            ),
          ]),
          if (title != null && title.isNotEmpty) ...[
            const SizedBox(height: 9),
            Text(title,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827))),
          ],
          if (issue != null && issue.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(issue,
                style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
          ],
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF64748B), height: 1.35)),
          ],
          if ((location != null && location.isNotEmpty) ||
              (unit != null && unit.isNotEmpty)) ...[
            const SizedBox(height: 11),
            Row(children: [
              const Icon(Icons.location_on_outlined,
                  size: 17, color: Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(
                      [location, unit]
                          .whereType<String>()
                          .where((v) => v.isNotEmpty)
                          .join(' · '),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF64748B)))),
            ]),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _open(ticket['id']?.toString() ?? ''),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(OpsFixI18n.t('Buka pekerjaan')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        width: widget.width,
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
            Text(OpsFixI18n.t('Antrean aktif'),
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827))),
            const SizedBox(height: 4),
            Text(
              _name.isEmpty
                  ? OpsFixI18n.t('Pekerjaan aktif yang ditugaskan kepada Anda.')
                  : OpsFixI18n.tf(
                      OpsFixI18n.t(
                          'Pekerjaan aktif yang ditugaskan kepada {0}.'),
                      [_name]),
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 14),
            if (_loading)
              const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()))
            else if (_error != null)
              Text(_error!, style: const TextStyle(color: Color(0xFFDC2626)))
            else if (_tickets.isEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.task_alt, color: Color(0xFF94A3B8), size: 30),
                  SizedBox(height: 8),
                  Text(OpsFixI18n.t('Tidak ada pekerjaan aktif.'),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569))),
                ]),
              )
            else
              for (var i = 0; i < _tickets.length; i++) ...[
                _ticketCard(_tickets[i]),
                if (i < _tickets.length - 1) const SizedBox(height: 10),
              ],
          ],
        ),
      );
}
