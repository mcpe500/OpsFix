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
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixNotificationBell extends StatefulWidget {
  const OpsFixNotificationBell({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OpsFixNotificationBell> createState() => _OpsFixNotificationBellState();
}

class _OpsFixNotificationBellState extends State<OpsFixNotificationBell> {
  int _unread = 0;
  RealtimeChannel? _channel;
  Timer? _fallbackTimer;
  Timer? _debounce;

  String get _siteId => FFAppState().currentSiteId.trim();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _syncLanguage();
      await _loadUnread();
      _subscribe();
    });
    _fallbackTimer =
        Timer.periodic(const Duration(seconds: 60), (_) => _loadUnread());
  }

  Future<void> _syncLanguage() async {
    if (!mounted || currentUserUid.isEmpty) return;
    try {
      final row = await SupaFlow.client
          .from('users')
          .select('preferred_language')
          .eq('id', currentUserUid)
          .maybeSingle();
      if (!mounted) return;
      final remote = row?['preferred_language']?.toString().trim() ?? '';
      final local = OpsFixI18n.languageOf(context);
      if (remote == 'id' || remote == 'en') {
        if (remote != local) {
          FFAppState().update(() => FFAppState().appLanguage = remote);
          setAppLanguage(context, remote);
        }
      } else {
        await SupaFlow.client.rpc(
          'set_opsfix_preferred_language',
          params: {'p_language': local == 'en' ? 'en' : 'id'},
        );
      }
    } catch (error) {
      debugPrint('OpsFix language sync unavailable: ${error.runtimeType}');
    }
  }

  Future<void> _loadUnread() async {
    if (currentUserUid.isEmpty) return;
    try {
      var query = SupaFlow.client
          .from('notifications')
          .select('id')
          .eq('recipient_id', currentUserUid)
          .eq('is_read', false);
      if (_siteId.isNotEmpty) query = query.eq('site_id', _siteId);
      final rows = await query.limit(100);
      if (mounted) setState(() => _unread = rows.length);
    } catch (error) {
      debugPrint('OpsFix unread count unavailable: ${error.runtimeType}');
    }
  }

  void _scheduleReload() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 180), _loadUnread);
  }

  void _subscribe() {
    if (currentUserUid.isEmpty || _channel != null) return;
    _channel = SupaFlow.client
        .channel(
            'opsfix-bell-$currentUserUid-${_siteId.isEmpty ? 'all' : _siteId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'recipient_id',
            value: currentUserUid,
          ),
          callback: (_) => _scheduleReload(),
        )
        .subscribe();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _fallbackTimer?.cancel();
    final channel = _channel;
    if (channel != null) {
      unawaited(SupaFlow.client.removeChannel(channel));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = _unread > 99 ? '99+' : '$_unread';
    return SizedBox(
      width: widget.width ?? 42,
      height: widget.height ?? 42,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Tooltip(
              message: OpsFixI18n.t('Buka notifikasi', context),
              child: IconButton(
                onPressed: () async {
                  await context.pushNamed(
                    'NotificationsPage',
                    extra: _opsFixPageFade(),
                  );
                  await _loadUnread();
                },
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF64748B),
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC),
                  minimumSize: const Size(42, 42),
                ),
              ),
            ),
          ),
          if (_unread > 0)
            Positioned(
              right: -3,
              top: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
