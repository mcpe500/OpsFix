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

class OpsFixTicketActivityPanel extends StatefulWidget {
  const OpsFixTicketActivityPanel({
    super.key,
    this.width,
    this.height,
    required this.ticketId,
  });

  final double? width;
  final double? height;
  final String? ticketId;

  @override
  State<OpsFixTicketActivityPanel> createState() =>
      _OpsFixTicketActivityPanelState();
}

class _OpsFixTicketActivityPanelState extends State<OpsFixTicketActivityPanel> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _events = const [];

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
        _error = 'Tiket belum dipilih.';
      });
      return;
    }
    try {
      final rows = await SupaFlow.client
          .from('ticket_events')
          .select(
              'event_type, actor_name_snapshot, message, created_at, from_status, to_status')
          .eq('ticket_id', ticketId)
          .order('created_at', ascending: false);
      if (!mounted) return;
      setState(() {
        _events = rows
            .map<Map<String, dynamic>>(
              (row) => Map<String, dynamic>.from(row),
            )
            .toList();
        _loading = false;
      });
    } catch (error) {
      debugPrint('OpsFix ticket activity load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Riwayat aktivitas belum dapat dimuat.';
      });
    }
  }

  String _eventLabel(Map<String, dynamic> event) {
    final type = event['event_type']?.toString().toLowerCase() ?? '';
    switch (type) {
      case 'created':
      case 'ticket_created':
        return 'Laporan dibuat';
      case 'assigned':
      case 'technician_assigned':
        return 'Teknisi ditetapkan';
      case 'status_changed':
        return 'Status diperbarui';
      case 'work_started':
        return 'Pengerjaan dimulai';
      case 'completed':
      case 'fixed':
        return 'Pengerjaan selesai';
      case 'verified':
        return 'Hasil diverifikasi';
      default:
        final message = event['message']?.toString().trim() ?? '';
        return message.isNotEmpty ? message : 'Aktivitas tiket';
    }
  }

  String _formatTime(dynamic raw) {
    final parsed =
        raw is DateTime ? raw : DateTime.tryParse(raw?.toString() ?? '');
    if (parsed == null) return 'Waktu tidak tersedia';
    final local = parsed.toLocal();
    const months = [
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
    String two(int value) => value.toString().padLeft(2, '0');
    return '${local.day} ${months[local.month - 1]} ${local.year}, '
        '${two(local.hour)}.${two(local.minute)}';
  }

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
            'Riwayat aktivitas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Perubahan status, penugasan, dan pekerjaan pada tiket ini.',
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
          else if (_events.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Belum ada aktivitas yang tercatat.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            )
          else ...[
            const SizedBox(height: 16),
            for (var index = 0; index < _events.length; index++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C5CE7),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _eventLabel(_events[index]),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF111827),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_events[index]['actor_name_snapshot'] ?? 'Sistem'} · '
                          '${_formatTime(_events[index]['created_at'])}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF64748B),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (index < _events.length - 1)
                const Padding(
                  padding: EdgeInsets.only(left: 4, top: 8, bottom: 8),
                  child: SizedBox(
                    height: 18,
                    child: VerticalDivider(
                      width: 2,
                      thickness: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }
}
