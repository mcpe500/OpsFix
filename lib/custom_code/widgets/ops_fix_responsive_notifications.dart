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
import 'package:intl/intl.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

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
  RealtimeChannel? _channel;
  Timer? _reloadDebounce;

  String get _role => FFAppState().currentUserRole.trim().toLowerCase();
  bool get _isManager => _role == 'manager' || _role == 'admin';
  bool get _isTechnician => _role == 'technician';

  @override
  void initState() {
    super.initState();
    _load();
    _subscribe();
  }

  void _subscribe() {
    if (currentUserUid.isEmpty || _channel != null) return;
    _channel = SupaFlow.client
        .channel('opsfix-notifications-$currentUserUid')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'recipient_id',
            value: currentUserUid,
          ),
          callback: (_) {
            _reloadDebounce?.cancel();
            _reloadDebounce = Timer(const Duration(milliseconds: 180), _load);
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _reloadDebounce?.cancel();
    final channel = _channel;
    if (channel != null) {
      unawaited(SupaFlow.client.removeChannel(channel));
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      var query = SupaFlow.client
          .from('notifications')
          .select(
              'id,ticket_id,route_name,notification_type,title,body,title_id,body_id,title_en,body_en,is_read,created_at')
          .eq('recipient_id', currentUserUid);
      if (FFAppState().currentSiteId.isNotEmpty) {
        query = query.eq('site_id', FFAppState().currentSiteId);
      }
      final data = await query.order('created_at', ascending: false).limit(100);
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
        _error = OpsFixI18n.t(
            'Pembaruan belum dapat dimuat. Periksa koneksi lalu coba lagi.');
      });
    }
  }

  String _text(Map<String, dynamic> row, String key, String fallback) {
    final value = row[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  bool _read(Map<String, dynamic> row) => row['is_read'] == true;

  String _localized(
    Map<String, dynamic> row,
    String field,
    String fallback,
  ) {
    final language = OpsFixI18n.languageOf(context) == 'en' ? 'en' : 'id';
    final localized = row['${field}_$language']?.toString().trim() ?? '';
    if (localized.isNotEmpty) return localized;
    return _text(row, field, fallback);
  }

  String _time(Map<String, dynamic> row) {
    final parsed = DateTime.tryParse(_text(row, 'created_at', ''))?.toLocal();
    if (parsed == null) return OpsFixI18n.t('Waktu belum tersedia');
    final now = DateTime.now();
    final difference = now.difference(parsed);
    if (difference.inMinutes < 1) return OpsFixI18n.t('Baru saja');
    if (difference.inMinutes < 60)
      return OpsFixI18n.tf('{0} menit lalu', [difference.inMinutes]);
    if (difference.inHours < 24)
      return OpsFixI18n.tf('{0} jam lalu', [difference.inHours]);
    if (difference.inDays < 7)
      return OpsFixI18n.tf('{0} hari lalu', [difference.inDays]);
    return DateFormat('d MMM yyyy · HH:mm', 'id_ID').format(parsed);
  }

  IconData _typeIcon(String type) => switch (type) {
        'ticket_created' => Icons.confirmation_number_outlined,
        'assignment_offered' ||
        'assignment_accepted' =>
          Icons.engineering_outlined,
        'status_changed' => Icons.sync_outlined,
        'completion_submitted' || 'ticket_fixed' => Icons.check_circle_outline,
        'ticket_reopened' => Icons.replay_circle_filled_outlined,
        'sla_warning' => Icons.timer_outlined,
        _ => Icons.notifications_none,
      };

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    context.goNamed(
      _isManager
          ? 'adminDashboardPage'
          : _isTechnician
              ? 'technicianTasksPage'
              : 'homeUserPage',
      extra: _opsFixPageFade(),
    );
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(OpsFixI18n.t('Semua notifikasi ditandai sudah dibaca.')),
      ));
    } catch (error) {
      debugPrint('Mark all notifications failed: $error');
      if (!mounted) return;
      setState(() {
        _markingAll = false;
        _error =
            OpsFixI18n.t('Notifikasi belum dapat diperbarui. Coba kembali.');
      });
    }
  }

  Future<void> _openTicket(Map<String, dynamic> row) async {
    final id = _text(row, 'id', '');
    final ticketId = _text(row, 'ticket_id', '');
    if (ticketId.isEmpty) return;

    if (!_read(row) && id.isNotEmpty) {
      try {
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
      } catch (error) {
        debugPrint('Notification read update failed: ${error.runtimeType}');
      }
    }
    if (!mounted) return;

    final requestedRoute = _text(row, 'route_name', '');
    final route = _isManager
        ? 'adminTicketDetailPage'
        : _isTechnician
            ? 'technicianTicketDetailPage'
            : requestedRoute == 'ReporterLocationTicketsPage'
                ? 'ReporterLocationTicketsPage'
                : 'ticketDetailPage';
    context.pushNamed(
      route,
      extra: _opsFixPageFade(),
      queryParameters: {
        'ticketId': serializeParam(ticketId, ParamType.String),
      }.withoutNulls,
    );
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
          tooltip: OpsFixI18n.t('Kembali'),
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
              Text(OpsFixI18n.t('Pembaruan'),
                  style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 21,
                      fontWeight: FontWeight.w600)),
              if (desktop)
                Text(
                    unread == 0
                        ? OpsFixI18n.t('Semua notifikasi sudah dibaca.')
                        : OpsFixI18n.tf(
                            '{0} notifikasi belum dibaca.', [unread]),
                    style: const TextStyle(
                        color: Color(0xFF64748B), fontSize: 12)),
            ],
          ),
        ),
        IconButton(
          tooltip: OpsFixI18n.t('Tandai semua dibaca'),
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
        if (!_isManager && !_isTechnician) ...[
          const SizedBox(width: 8),
          const OpsFixReporterHeaderActions(showBell: false),
        ],
      ]),
    );
  }

  Widget _sideItem(IconData icon, String label, String route) => InkWell(
        onTap: () => context.goNamed(route, extra: _opsFixPageFade()),
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
      add(Icons.dashboard_outlined, OpsFixI18n.t('Beranda'),
          'adminDashboardPage');
      add(Icons.confirmation_number_outlined, OpsFixI18n.t('Tiket'),
          'adminTicketsPage');
      add(Icons.view_kanban_outlined, OpsFixI18n.t('Board'),
          'adminWorkBoardPage');
      add(Icons.inventory_2_outlined, OpsFixI18n.t('Aset'),
          'adminAssetsLocationsPage');
      add(Icons.history_outlined, OpsFixI18n.t('Log'), 'adminActivityLogPage');
    } else if (_isTechnician) {
      add(Icons.task_alt_outlined, OpsFixI18n.t('Tugas'),
          'technicianTasksPage');
      add(Icons.history_outlined, OpsFixI18n.t('Riwayat'),
          'technicianHistoryPage');
    } else {
      add(Icons.home_outlined, OpsFixI18n.t('Beranda'), 'homeUserPage');
      add(Icons.add_circle_outline, OpsFixI18n.t('Buat laporan'),
          'reportIssuePage');
      add(Icons.confirmation_number_outlined, OpsFixI18n.t('Tiket saya'),
          'myTicketsPage');
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
                      ? OpsFixI18n.t('Portal admin')
                      : _isTechnician
                          ? OpsFixI18n.t('Portal teknisi')
                          : OpsFixI18n.t('Portal pengguna'),
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
            child: Row(children: [
              Icon(Icons.notifications_none,
                  color: Color(0xFF70E1CB), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(OpsFixI18n.t('Pusat pembaruan akun'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
        ]),
      );

  Widget _bottomItem(
    IconData icon,
    String label,
    String route,
  ) =>
      Expanded(
        child: InkWell(
          onTap: () => context.pushNamed(
            route,
            extra: _opsFixPageFade(),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF94A3B8), size: 23),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _bottomNav() {
    final items = <Widget>[];
    void add(IconData icon, String label, String route) {
      items.add(_bottomItem(icon, label, route));
    }

    if (_isManager) {
      add(Icons.dashboard_outlined, OpsFixI18n.t('Beranda'),
          'adminDashboardPage');
      add(Icons.confirmation_number_outlined, OpsFixI18n.t('Tiket'),
          'adminTicketsPage');
      add(Icons.view_kanban_outlined, OpsFixI18n.t('Board'),
          'adminWorkBoardPage');
      add(Icons.inventory_2_outlined, OpsFixI18n.t('Aset'),
          'adminAssetsLocationsPage');
      add(Icons.history_outlined, OpsFixI18n.t('Log'), 'adminActivityLogPage');
    } else if (_isTechnician) {
      add(Icons.task_alt_outlined, OpsFixI18n.t('Tugas'),
          'technicianTasksPage');
      add(Icons.history_outlined, OpsFixI18n.t('Riwayat'),
          'technicianHistoryPage');
      add(Icons.person_outline, OpsFixI18n.t('Profil'),
          'TechnicianProfilePage');
    } else {
      add(Icons.home_outlined, OpsFixI18n.t('Beranda'), 'homeUserPage');
      add(Icons.add_circle_outline, OpsFixI18n.t('Lapor'), 'reportIssuePage');
      add(Icons.confirmation_number_outlined, OpsFixI18n.t('Tiket'),
          'myTicketsPage');
      add(Icons.person_outline, OpsFixI18n.t('Profil'), 'ProfilePage');
    }

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(children: items),
    );
  }

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
                  child: Text(
                      _localized(row, 'title', OpsFixI18n.t('Pembaruan akun')),
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
              Text(
                  _localized(row, 'body',
                      OpsFixI18n.t('Ada aktivitas terbaru pada akun Anda.')),
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
                    label: Text(OpsFixI18n.t('Buka tiket')),
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
        children: [
          SizedBox(height: 100),
          Icon(Icons.notifications_none, color: Color(0xFF94A3B8), size: 50),
          SizedBox(height: 14),
          Text(OpsFixI18n.t('Belum ada pembaruan'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text(OpsFixI18n.t('Aktivitas tiket terbaru akan muncul di sini.'),
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
                label: Text(OpsFixI18n.t('Coba lagi')),
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
                Text(OpsFixI18n.t('Aktivitas terbaru'),
                    style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(
                    OpsFixI18n.t(
                        'Pantau perkembangan tiket dan aktivitas terbaru akun Anda.'),
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
                  _isManager || _isTechnician
                      ? _sidebar()
                      : const OpsFixReporterSidebar(),
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
                  _isManager || _isTechnician
                      ? _bottomNav()
                      : const OpsFixReporterBottomNav(),
                ]),
        ),
      ),
    );
  }
}
