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
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _opsFixReporterFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixResponsiveNotifications extends StatefulWidget {
  const OpsFixResponsiveNotifications({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixResponsiveNotifications> createState() =>
      _OpsFixResponsiveNotificationsState();
}

class _OpsFixResponsiveNotificationsState
    extends State<OpsFixResponsiveNotifications> {
  bool _loading = true;
  bool _markingAll = false;
  String? _error;
  List<Map<String, dynamic>> _rows = const [];

  String get _role => FFAppState().currentUserRole.trim().toLowerCase();
  bool get _isManager => _role == 'manager' || _role == 'admin';
  bool get _isTechnician => _role == 'technician';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      var query = SupaFlow.client
          .from('notifications')
          .select(
              'id,ticket_id,notification_type,title,body,is_read,created_at')
          .eq('recipient_id', currentUserUid);
      if (FFAppState().currentSiteId.isNotEmpty) {
        query = query.eq('site_id', FFAppState().currentSiteId);
      }
      final data = await query.order('created_at', ascending: false);
      if (!mounted) return;
      setState(() {
        _rows = (data as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _loading = false;
        _error = null;
      });
    } catch (error) {
      debugPrint('Notifications load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Pembaruan belum dapat dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  String _text(Map<String, dynamic> row, String key, String fallback) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  bool _read(Map<String, dynamic> row) => row['is_read'] == true;

  String _time(Map<String, dynamic> row) {
    final parsed = DateTime.tryParse(_text(row, 'created_at', ''))?.toLocal();
    if (parsed == null) return 'Waktu belum tersedia';
    final now = DateTime.now();
    final difference = now.difference(parsed);
    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inMinutes < 60) return '${difference.inMinutes} menit lalu';
    if (difference.inHours < 24) return '${difference.inHours} jam lalu';
    if (difference.inDays < 7) return '${difference.inDays} hari lalu';
    return DateFormat('d MMM yyyy · HH:mm', 'id_ID').format(parsed);
  }

  IconData _typeIcon(String type) => switch (type) {
        'assignment' ||
        'assignment_created' ||
        'assignment_accepted' =>
          Icons.engineering_outlined,
        'status_changed' || 'ticket_updated' => Icons.sync_outlined,
        'completion_submitted' || 'fixed' => Icons.check_circle_outline,
        'ticket_created' => Icons.confirmation_number_outlined,
        _ => Icons.notifications_none,
      };

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    context.goNamed(_isManager
        ? 'adminDashboardPage'
        : _isTechnician
            ? 'technicianTasksPage'
            : 'homeUserPage');
  }

  Future<void> _markAll() async {
    if (_markingAll || !_rows.any((row) => !_read(row))) return;
    setState(() => _markingAll = true);
    try {
      await actions.markAllOpsFixNotificationsRead();
      if (!mounted) return;
      setState(() {
        _rows = _rows.map((row) => {...row, 'is_read': true}).toList();
        _markingAll = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Semua notifikasi ditandai sudah dibaca.'),
      ));
    } catch (error) {
      debugPrint('Mark all notifications failed: $error');
      if (!mounted) return;
      setState(() {
        _markingAll = false;
        _error = 'Notifikasi belum dapat diperbarui. Coba kembali.';
      });
    }
  }

  Future<void> _openTicket(Map<String, dynamic> row) async {
    final id = _text(row, 'id', '');
    final ticketId = _text(row, 'ticket_id', '');
    if (ticketId.isEmpty) return;
    try {
      if (!_read(row) && id.isNotEmpty) {
        await actions.markOpsFixNotificationRead(id);
        if (mounted) {
          setState(() {
            _rows = _rows
                .map((item) => item['id']?.toString() == id
                    ? {...item, 'is_read': true}
                    : item)
                .toList();
          });
        }
      }
      if (!mounted) return;
      final route = _isManager
          ? 'adminTicketDetailPage'
          : _isTechnician
              ? 'technicianTicketDetailPage'
              : 'ticketDetailPage';
      context.pushNamed(
        route,
        extra: (_isManager || _isTechnician) ? null : _opsFixReporterFade(),
        queryParameters: {
          'ticketId': serializeParam(ticketId, ParamType.String),
        }.withoutNulls,
      );
    } catch (error) {
      debugPrint('Open notification ticket failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Tiket belum dapat dibuka. Coba kembali.'),
      ));
    }
  }

  Widget _header({required bool desktop}) {
    final unread = _rows.where((row) => !_read(row)).length;
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(children: [
        IconButton(
          tooltip: 'Kembali',
          onPressed: _back,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF8FAFC),
              minimumSize: const Size(42, 42)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pembaruan',
                  style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 21,
                      fontWeight: FontWeight.w600)),
              if (desktop)
                Text(
                    unread == 0
                        ? 'Semua notifikasi sudah dibaca.'
                        : '$unread notifikasi belum dibaca.',
                    style: const TextStyle(
                        color: Color(0xFF64748B), fontSize: 12)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Tandai semua dibaca',
          onPressed: _markingAll || unread == 0 ? null : _markAll,
          icon: _markingAll
              ? const SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.done_all, size: 24),
          style: IconButton.styleFrom(
              foregroundColor: const Color(0xFF6C5CE7),
              backgroundColor: const Color(0xFFF0EDFF),
              minimumSize: const Size(42, 42)),
        ),
      ]),
    );
  }

  Widget _sideItem(IconData icon, String label, String route) => InkWell(
        onTap: () => context.goNamed(route,
            extra:
                (_isManager || _isTechnician) ? null : _opsFixReporterFade()),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(children: [
            Icon(icon, size: 21, color: const Color(0xFFAAB6CC)),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFFD8E0EF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      );

  List<Widget> _roleNavigation() {
    final items = <Widget>[];
    void add(IconData icon, String label, String route) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 7));
      items.add(_sideItem(icon, label, route));
    }

    if (_isManager) {
      add(Icons.dashboard_outlined, 'Beranda', 'adminDashboardPage');
      add(Icons.confirmation_number_outlined, 'Tiket', 'adminTicketsPage');
      add(Icons.view_kanban_outlined, 'Board', 'adminWorkBoardPage');
      add(Icons.inventory_2_outlined, 'Aset', 'adminAssetsLocationsPage');
      add(Icons.history_outlined, 'Log', 'adminActivityLogPage');
    } else if (_isTechnician) {
      add(Icons.task_alt_outlined, 'Tugas', 'technicianTasksPage');
      add(Icons.history_outlined, 'Riwayat', 'technicianHistoryPage');
    } else {
      add(Icons.home_outlined, 'Beranda', 'homeUserPage');
      add(Icons.add_circle_outline, 'Buat laporan', 'reportIssuePage');
      add(Icons.confirmation_number_outlined, 'Tiket saya', 'myTicketsPage');
    }
    return items;
  }

  Widget _sidebar() => Container(
        width: 252,
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
        color: const Color(0xFF081225),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            const CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFF6C5CE7),
                child: Text('O',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700))),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('OpsFix',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700)),
              Text(
                  _isManager
                      ? 'Portal pengelola'
                      : _isTechnician
                          ? 'Portal teknisi'
                          : 'Portal pengguna',
                  style:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 36),
          ..._roleNavigation(),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF13213A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF253451)),
            ),
            child: const Row(children: [
              Icon(Icons.notifications_none,
                  color: Color(0xFF70E1CB), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text('Pusat pembaruan akun',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
        ]),
      );

  Widget _notificationCard(Map<String, dynamic> row) {
    final read = _read(row);
    final ticketId = _text(row, 'ticket_id', '');
    final accent = read ? const Color(0xFF94A3B8) : const Color(0xFF6C5CE7);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: read ? Colors.white : const Color(0xFFF8F6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: read ? const Color(0xFFDDE2E7) : const Color(0xFFCFC7FF)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(_typeIcon(_text(row, 'notification_type', '')),
              color: accent, size: 21),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Text(_text(row, 'title', 'Pembaruan akun'),
                      style: TextStyle(
                          color: const Color(0xFF111827),
                          fontSize: 15,
                          fontWeight:
                              read ? FontWeight.w600 : FontWeight.w700)),
                ),
                if (!read) ...[
                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircleAvatar(
                        radius: 4, backgroundColor: Color(0xFF6C5CE7)),
                  ),
                ],
              ]),
              const SizedBox(height: 5),
              Text(_text(row, 'body', 'Ada aktivitas terbaru pada akun Anda.'),
                  style: const TextStyle(
                      color: Color(0xFF64748B), fontSize: 13, height: 1.4)),
              const SizedBox(height: 9),
              Row(children: [
                Expanded(
                  child: Text(_time(row),
                      style: const TextStyle(
                          color: Color(0xFF94A3B8), fontSize: 11)),
                ),
                if (ticketId.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _openTicket(row),
                    icon: const Icon(Icons.open_in_new, size: 17),
                    label: const Text('Buka tiket'),
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6C5CE7)),
                  ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _empty() => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 100),
          Icon(Icons.notifications_none, color: Color(0xFF94A3B8), size: 50),
          SizedBox(height: 14),
          Text('Belum ada pembaruan',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text('Aktivitas tiket terbaru akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      );

  Widget _list() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 90),
            const Icon(Icons.cloud_off_outlined,
                color: Color(0xFFDC2626), size: 44),
            const SizedBox(height: 12),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _load();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: _rows.isEmpty
          ? _empty()
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _rows.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) => _notificationCard(_rows[index]),
            ),
    );
  }

  Widget _content({required bool desktop}) => Padding(
        padding: EdgeInsets.fromLTRB(
            desktop ? 28 : 16, 20, desktop ? 28 : 16, desktop ? 24 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Aktivitas terbaru',
                    style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                const Text(
                    'Pantau perkembangan tiket dan aktivitas terbaru akun Anda.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                const SizedBox(height: 18),
                Expanded(child: _list()),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(
          child: desktop
              ? Row(children: [
                  _sidebar(),
                  Expanded(
                    child: Column(children: [
                      _header(desktop: true),
                      Expanded(child: _content(desktop: true)),
                    ]),
                  ),
                ])
              : Column(children: [
                  _header(desktop: false),
                  Expanded(child: _content(desktop: false)),
                ]),
        ),
      ),
    );
  }
}
