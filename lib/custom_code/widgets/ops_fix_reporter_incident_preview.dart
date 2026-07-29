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
import '/custom_code/widgets/ops_fix_language_setting.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _previewFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixReporterIncidentPreview extends StatefulWidget {
  const OpsFixReporterIncidentPreview({
    super.key,
    this.width,
    this.height,
    this.locationId = '',
  });
  final double? width;
  final double? height;
  final String locationId;

  @override
  State<OpsFixReporterIncidentPreview> createState() =>
      _OpsFixReporterIncidentPreviewState();
}

class _OpsFixReporterIncidentPreviewState
    extends State<OpsFixReporterIncidentPreview> {
  bool _loading = true;
  List<Map<String, dynamic>> _rows = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.locationId.trim().isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final raw = await SupaFlow.client.rpc(
        'list_opsfix_location_active_incidents',
        params: {
          'p_location_id': widget.locationId.trim(),
          'p_limit': 3,
          'p_offset': 0,
        },
      );
      final response =
          raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
      final values = response['incidents'] is List
          ? response['incidents'] as List
          : const <dynamic>[];
      if (!mounted) return;
      setState(() {
        _rows = values
            .map((value) => Map<String, dynamic>.from(value as Map))
            .toList();
        _loading = false;
      });
    } catch (error) {
      debugPrint('Incident preview load failed: ${error.runtimeType}');
      if (mounted) setState(() => _loading = false);
    }
  }

  void _open([String ticketId = '']) => context.pushNamed(
        'ReporterLocationTicketsPage',
        extra: _previewFade(),
        queryParameters: {
          'locationId': serializeParam(widget.locationId, ParamType.String),
          if (ticketId.isNotEmpty)
            'ticketId': serializeParam(ticketId, ParamType.String),
        }.withoutNulls,
      );

  String _status(String raw) => switch (raw) {
        'reported' => OpsFixI18n.t('Baru dilaporkan'),
        'assigned' => OpsFixI18n.t('Teknisi ditetapkan'),
        'in_progress' => OpsFixI18n.t('Sedang dikerjakan'),
        'pending_verification' => OpsFixI18n.t('Menunggu verifikasi'),
        'reopened' => OpsFixI18n.t('Dibuka kembali'),
        _ => OpsFixI18n.t('Status diperbarui'),
      };

  Widget _card(Map<String, dynamic> row) => InkWell(
        onTap: () => _open(row['ticket_id']?.toString() ?? ''),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(children: [
            const CircleAvatar(
              radius: 19,
              backgroundColor: Color(0xFFF0EDFF),
              child: Icon(Icons.campaign_outlined,
                  size: 19, color: Color(0xFF6C5CE7)),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row['target_label']?.toString() ??
                        OpsFixI18n.t('Fasilitas'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    row['issue_type']?.toString() ??
                        OpsFixI18n.t('Gangguan fasilitas'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_status(row['status']?.toString() ?? '')} · '
                    '${OpsFixI18n.tf('{0} orang terdampak', [
                          row['affected_count'] ?? 1
                        ])}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 11, color: Color(0xFF5B4CE3)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
          height: 92, child: Center(child: CircularProgressIndicator()));
    }
    if (_rows.isEmpty) return const SizedBox.shrink();
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Icon(Icons.campaign_outlined, color: Color(0xFF6C5CE7)),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(OpsFixI18n.t('Gangguan aktif di lokasi ini'),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                Text(
                    OpsFixI18n.t(
                        'Laporan terbuka dari pengguna di lokasi aktif.'),
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: _open,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: Text(OpsFixI18n.t('Lihat semua')),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6C5CE7),
              side: const BorderSide(color: Color(0xFF8B7CF6)),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ]),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth >= 900
              ? 3
              : constraints.maxWidth >= 560
                  ? 2
                  : 1;
          const gap = 10.0;
          final cardWidth = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: _rows
                .map((row) => SizedBox(width: cardWidth, child: _card(row)))
                .toList(),
          );
        }),
      ]),
    );
  }
}
