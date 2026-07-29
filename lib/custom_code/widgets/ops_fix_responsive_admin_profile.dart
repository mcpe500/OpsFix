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

import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixResponsiveAdminProfile extends StatelessWidget {
  const OpsFixResponsiveAdminProfile({super.key, this.width, this.height});
  final double? width;
  final double? height;

  void _go(BuildContext context, String route) => context.goNamed(
        route,
        extra: _opsFixPageFade(),
      );

  Widget _header(BuildContext context, bool desktop) => Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(children: [
          IconButton(
            tooltip: OpsFixI18n.t('Kembali ke dashboard'),
            onPressed: () => _go(context, 'adminDashboardPage'),
            icon:
                const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF8FAFC),
              minimumSize: const Size(42, 42),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(OpsFixI18n.t('Profil Admin'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 21,
                        fontWeight: FontWeight.w700)),
                if (desktop)
                  Text(
                      OpsFixI18n.t(
                          'Identitas akun dan akses portal pengelola.'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
          const OpsFixManagerHeaderActions(),
        ]),
      );

  Widget _bottomItem(
          BuildContext context, IconData icon, String label, String route) =>
      Expanded(
        child: InkWell(
          onTap: () => _go(context, route),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 56,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 22, color: const Color(0xFF98A2B3)),
              const SizedBox(height: 4),
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
            ]),
          ),
        ),
      );

  Widget _bottomNav(BuildContext context) => Container(
        height: 72,
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(children: [
          _bottomItem(context, Icons.dashboard_outlined,
              OpsFixI18n.t('Beranda'), 'adminDashboardPage'),
          _bottomItem(context, Icons.confirmation_number_outlined,
              OpsFixI18n.t('Tiket'), 'adminTicketsPage'),
          _bottomItem(context, Icons.view_kanban_outlined,
              OpsFixI18n.t('Board'), 'adminWorkBoardPage'),
          _bottomItem(context, Icons.inventory_2_outlined, OpsFixI18n.t('Aset'),
              'adminAssetsLocationsPage'),
          _bottomItem(context, Icons.history_rounded, OpsFixI18n.t('Log'),
              'adminActivityLogPage'),
        ]),
      );

  Widget _sideItem(
          BuildContext context, IconData icon, String label, String route) =>
      InkWell(
        onTap: () => _go(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(children: [
            Icon(icon, size: 21, color: const Color(0xFF94A3B8)),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFFD5DCEA),
                        fontSize: 14,
                        fontWeight: FontWeight.w500))),
          ]),
        ),
      );

  Widget _sidebar(BuildContext context) => Container(
        width: 252,
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
        color: const Color(0xFF081225),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFF6C5CE7),
                child: Text('O',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700))),
            SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('OpsFix',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700)),
              Text(OpsFixI18n.t('Portal admin'),
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 36),
          _sideItem(context, Icons.dashboard_outlined,
              OpsFixI18n.t('Dashboard'), 'adminDashboardPage'),
          const SizedBox(height: 8),
          _sideItem(context, Icons.confirmation_number_outlined,
              OpsFixI18n.t('Tickets'), 'adminTicketsPage'),
          const SizedBox(height: 8),
          _sideItem(context, Icons.view_kanban_outlined,
              OpsFixI18n.t('Work board'), 'adminWorkBoardPage'),
          const SizedBox(height: 8),
          _sideItem(context, Icons.inventory_2_outlined,
              OpsFixI18n.t('Locations & assets'), 'adminAssetsLocationsPage'),
          const SizedBox(height: 8),
          _sideItem(context, Icons.history_rounded,
              OpsFixI18n.t('Activity log'), 'adminActivityLogPage'),
          const Spacer(),
          const OpsFixManagerProfileNav(),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    const content = Expanded(child: OpsFixAdminProfileContent());
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(
          child: desktop
              ? Row(children: [
                  _sidebar(context),
                  Expanded(
                      child:
                          Column(children: [_header(context, true), content])),
                ])
              : Column(children: [
                  _header(context, false),
                  content,
                  _bottomNav(context)
                ]),
        ),
      ),
    );
  }
}
