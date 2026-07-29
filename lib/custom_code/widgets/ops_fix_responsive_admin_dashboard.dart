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
import '/custom_code/widgets/ops_fix_admin_dashboard_content.dart';
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

class OpsFixResponsiveAdminDashboard extends StatefulWidget {
  const OpsFixResponsiveAdminDashboard({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OpsFixResponsiveAdminDashboard> createState() =>
      _OpsFixResponsiveAdminDashboardState();
}

class _OpsFixResponsiveAdminDashboardState
    extends State<OpsFixResponsiveAdminDashboard> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    if (currentUserUid.isEmpty) return;
    try {
      final row = await SupaFlow.client
          .from('users')
          .select('avatar_url')
          .eq('id', currentUserUid)
          .maybeSingle();
      final avatar = row?['avatar_url']?.toString().trim();
      if (mounted) {
        setState(() {
          _avatarUrl = avatar == null || avatar.isEmpty ? null : avatar;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _avatarUrl = null);
    }
  }

  Widget _profileFallback() => const ColoredBox(
        color: Color(0xFF6C5CE7),
        child: Center(
          child: Icon(Icons.person_outline, color: Colors.white, size: 24),
        ),
      );

  Widget _profileButton(BuildContext context) => Tooltip(
        message: OpsFixI18n.t('Buka profil admin'),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await context.pushNamed(
                'AdminProfilePage',
                extra: _opsFixPageFade(),
              );
              await _loadAvatar();
            },
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: 42,
              child: ClipOval(
                child: _avatarUrl == null
                    ? _profileFallback()
                    : Image.network(
                        _avatarUrl!,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _profileFallback(),
                      ),
              ),
            ),
          ),
        ),
      );

  void _go(BuildContext context, String route) => context.goNamed(
        route,
        extra: _opsFixPageFade(),
      );
  void _push(BuildContext context, String route) => context.pushNamed(
        route,
        extra: _opsFixPageFade(),
      );

  Widget _circleButton(
    IconData icon,
    Color color,
    Color fill,
    VoidCallback action,
  ) =>
      IconButton(
        onPressed: action,
        icon: Icon(icon, color: color, size: 24),
        style: IconButton.styleFrom(
          backgroundColor: fill,
          minimumSize: const Size(42, 42),
        ),
      );

  Widget _header(BuildContext context, {required bool desktop}) => Container(
        height: 72,
        padding: EdgeInsets.symmetric(
          horizontal: desktop ? 28 : 16,
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desktop
                        ? OpsFixI18n.t('Dashboard admin')
                        : OpsFixI18n.t('OpsFix Admin'),
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (desktop)
                    Text(
                      OpsFixI18n.t(
                          'Pantau antrean, SLA, dan progres perbaikan lokasi.'),
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const OpsFixNotificationBell(),
            const SizedBox(width: 8),
            _profileButton(context),
          ],
        ),
      );

  Widget _bottomItem(
    BuildContext context,
    IconData icon,
    String label,
    String route, {
    bool active = false,
  }) =>
      Expanded(
        child: InkWell(
          onTap: active ? null : () => _go(context, route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: active ? const Color(0xFFF0EDFF) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: active
                      ? const Color(0xFF6C5CE7)
                      : const Color(0xFF98A2B3),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: active
                        ? const Color(0xFF6C5CE7)
                        : const Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _bottomNav(BuildContext context) => Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            _bottomItem(
              context,
              Icons.dashboard,
              OpsFixI18n.t('Beranda'),
              'adminDashboardPage',
              active: true,
            ),
            _bottomItem(
              context,
              Icons.confirmation_number,
              OpsFixI18n.t('Tiket'),
              'adminTicketsPage',
            ),
            _bottomItem(
              context,
              Icons.view_kanban,
              OpsFixI18n.t('Board'),
              'adminWorkBoardPage',
            ),
            _bottomItem(
              context,
              Icons.inventory_2,
              OpsFixI18n.t('Aset'),
              'adminAssetsLocationsPage',
            ),
            _bottomItem(
              context,
              Icons.history,
              OpsFixI18n.t('Log'),
              'adminActivityLogPage',
            ),
          ],
        ),
      );

  Widget _sideItem(
    BuildContext context,
    IconData icon,
    String label,
    String route, {
    bool active = false,
  }) =>
      InkWell(
        onTap: active ? null : () => _go(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF6C5CE7) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: active ? Colors.white : const Color(0xFFAAB6CC),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFFD8E0EF),
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _sidebar(BuildContext context) => Container(
        width: 252,
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
        color: const Color(0xFF081225),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: Color(0xFF6C5CE7),
                  child: Text(
                    'O',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OpsFix',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      OpsFixI18n.t('Portal admin'),
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 36),
            _sideItem(
              context,
              Icons.dashboard_outlined,
              OpsFixI18n.t('Dashboard'),
              'adminDashboardPage',
              active: true,
            ),
            const SizedBox(height: 8),
            _sideItem(
              context,
              Icons.confirmation_number_outlined,
              OpsFixI18n.t('Tiket'),
              'adminTicketsPage',
            ),
            const SizedBox(height: 8),
            _sideItem(
              context,
              Icons.view_kanban_outlined,
              OpsFixI18n.t('Work board'),
              'adminWorkBoardPage',
            ),
            const SizedBox(height: 8),
            _sideItem(
              context,
              Icons.inventory_2_outlined,
              OpsFixI18n.t('Lokasi & aset'),
              'adminAssetsLocationsPage',
            ),
            const SizedBox(height: 8),
            _sideItem(
              context,
              Icons.history,
              OpsFixI18n.t('Activity log'),
              'adminActivityLogPage',
            ),
            const Spacer(),
            InkWell(
              onTap: () => _push(context, 'AdminProfilePage'),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF13213A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF253451)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings_outlined,
                      color: Color(0xFF70E1CB),
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            OpsFixI18n.t('AKUN ADMIN'),
                            style: TextStyle(
                              color: Color(0xFF70E1CB),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            OpsFixI18n.t('Buka profil admin'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    const content = Expanded(child: OpsFixAdminDashboardContent());

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(
          child: desktop
              ? Row(
                  children: [
                    _sidebar(context),
                    Expanded(
                      child: Column(
                        children: [
                          _header(context, desktop: true),
                          content,
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _header(context, desktop: false),
                    content,
                    _bottomNav(context),
                  ],
                ),
        ),
      ),
    );
  }
}
