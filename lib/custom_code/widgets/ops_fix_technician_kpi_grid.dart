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

class OpsFixTechnicianKpiGrid extends StatefulWidget {
  const OpsFixTechnicianKpiGrid({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixTechnicianKpiGrid> createState() =>
      _OpsFixTechnicianKpiGridState();
}

class _OpsFixTechnicianKpiGridState extends State<OpsFixTechnicianKpiGrid> {
  bool _loading = true;
  Map<String, int> _counts = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      var query = SupaFlow.client
          .from('ticket_cards_v')
          .select('status,updated_at')
          .eq('assigned_technician_id', currentUserUid);
      final siteId = FFAppState().currentSiteId.trim();
      if (siteId.isNotEmpty) query = query.eq('site_id', siteId);
      final rows = await query;
      final now = DateTime.now();
      var assigned = 0;
      var inProgress = 0;
      var pendingVerification = 0;
      var fixedToday = 0;
      for (final raw in rows) {
        final row = Map<String, dynamic>.from(raw);
        final status = row['status']?.toString().toLowerCase() ?? '';
        if (status == 'assigned') assigned++;
        if (status == 'in_progress') inProgress++;
        if (status == 'pending_verification') pendingVerification++;
        if (status == 'fixed') {
          final updated =
              DateTime.tryParse(row['updated_at']?.toString() ?? '')?.toLocal();
          if (updated != null &&
              updated.year == now.year &&
              updated.month == now.month &&
              updated.day == now.day) {
            fixedToday++;
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _counts = {
          'assigned': assigned,
          'in_progress': inProgress,
          'pending_verification': pendingVerification,
          'fixed_today': fixedToday,
        };
        _loading = false;
      });
    } catch (error) {
      debugPrint('Technician KPI load failed: $error');
      if (mounted) setState(() => _loading = false);
    }
  }

  int _count(String key) => _counts[key] ?? 0;

  Widget _card(String title, String key, String caption, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: accent))
                : Text('${_count(key)}',
                    style: const TextStyle(
                        fontSize: 25,
                        color: Color(0xFF0B1324),
                        fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(caption,
                style: const TextStyle(fontSize: 13, color: Color(0xFF718096))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _card(OpsFixI18n.t('Siap dimulai'), 'assigned',
                OpsFixI18n.t('Belum dimulai'), const Color(0xFF6C5CE7)),
            const SizedBox(width: 10),
            _card(OpsFixI18n.t('Sedang dikerjakan'), 'in_progress',
                OpsFixI18n.t('Dalam proses'), const Color(0xFFF59E0B)),
          ]),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _card(OpsFixI18n.t('Menunggu verifikasi'), 'pending_verification',
                OpsFixI18n.t('Menunggu pelapor'), const Color(0xFF2563EB)),
            const SizedBox(width: 10),
            _card(OpsFixI18n.t('Selesai hari ini'), 'fixed_today',
                OpsFixI18n.t('Perbaikan selesai'), const Color(0xFF10B981)),
          ]),
        ],
      ),
    );
  }
}
