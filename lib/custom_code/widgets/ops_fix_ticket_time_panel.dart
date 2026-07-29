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
import '/custom_code/widgets/ops_fix_language_setting.dart';

class OpsFixTicketTimePanel extends StatefulWidget {
  const OpsFixTicketTimePanel({
    super.key,
    this.width,
    this.height,
    required this.ticketId,
  });

  final double? width;
  final double? height;
  final String? ticketId;

  @override
  State<OpsFixTicketTimePanel> createState() => _OpsFixTicketTimePanelState();
}

class _OpsFixTicketTimePanelState extends State<OpsFixTicketTimePanel> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _ticket = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ticketId = (widget.ticketId ?? '').trim();
    if (ticketId.isEmpty) {
      setState(() {
        _loading = false;
        _error = OpsFixI18n.t('Tiket belum dipilih.');
      });
      return;
    }
    try {
      final row = await SupaFlow.client
          .from('ticket_detail_v')
          .select('response_due_at, resolution_due_at, created_at, updated_at')
          .eq('id', ticketId)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _ticket = row == null ? const {} : Map<String, dynamic>.from(row);
        _loading = false;
        _error = row == null
            ? OpsFixI18n.t('Informasi waktu tiket tidak tersedia.')
            : null;
      });
    } catch (error) {
      debugPrint('OpsFix ticket time load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = OpsFixI18n.t('Informasi waktu belum dapat dimuat.');
      });
    }
  }

  String _format(dynamic raw) {
    if (raw == null) return OpsFixI18n.t('Belum ditentukan');
    final parsed = raw is DateTime ? raw : DateTime.tryParse(raw.toString());
    if (parsed == null) return OpsFixI18n.t('Belum ditentukan');
    final local = parsed.toLocal();
    // Month abbreviations differ between the two languages (Mei/May,
    // Agu/Aug, Okt/Oct, Des/Dec). Kept as two const lists and chosen at
    // render time: routing them through OpsFixI18n would mean demoting the
    // list to `final`, which freezes it at first access so it could never
    // follow a language change.
    const monthsId = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    const monthsEn = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final months = OpsFixI18n.isEnglish(context) ? monthsEn : monthsId;
    String two(int value) => value.toString().padLeft(2, '0');
    return '${local.day} ${months[local.month - 1]} ${local.year}, ${two(local.hour)}.${two(local.minute)}';
  }

  Widget _row(BuildContext context, String label, dynamic value) => Padding(
        padding: const EdgeInsets.only(top: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _format(value),
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Text(
            OpsFixI18n.t('Target waktu penanganan'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            OpsFixI18n.t('Batas waktu layanan dan catatan pembaruan tiket.'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF64748B),
                ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                _error!,
                style: const TextStyle(color: Color(0xFFB45309)),
              ),
            )
          else ...[
            const Divider(height: 24),
            _row(context, OpsFixI18n.t('Batas respons awal'),
                _ticket['response_due_at']),
            _row(context, OpsFixI18n.t('Target penyelesaian'),
                _ticket['resolution_due_at']),
            _row(
                context, OpsFixI18n.t('Laporan dibuat'), _ticket['created_at']),
            _row(context, OpsFixI18n.t('Terakhir diperbarui'),
                _ticket['updated_at']),
          ],
        ],
      ),
    );
  }
}
