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
import '/custom_code/widgets/ops_fix_reporter_home_content.dart';
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

class OpsFixResponsiveReporterHome extends StatelessWidget {
  const OpsFixResponsiveReporterHome({super.key, this.width, this.height});
  final double? width;
  final double? height;

  void _go(BuildContext context, String route) =>
      context.goNamed(route, extra: _opsFixReporterFade());
  void _push(BuildContext context, String route) =>
      context.pushNamed(route, extra: _opsFixReporterFade());

  Widget _circleButton(
          IconData icon, Color color, Color fill, VoidCallback action) =>
      IconButton(
        onPressed: action,
        icon: Icon(icon, color: color, size: 24),
        style: IconButton.styleFrom(
            backgroundColor: fill, minimumSize: const Size(42, 42)),
      );

  Widget _header(BuildContext context, {required bool desktop}) => Container(
        height: 72,
        padding:
            EdgeInsets.symmetric(horizontal: desktop ? 28 : 16, vertical: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
        child: Row(children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(desktop ? OpsFixI18n.t('Beranda pengguna') : 'OpsFix',
                    style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 22,
                        fontWeight: FontWeight.w600)),
                if (desktop)
                  Text(
                      OpsFixI18n.t(
                          'Pantau laporan dan perangkat lokasi aktif.'),
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ])),
          const OpsFixReporterHeaderActions(),
        ]),
      );

  Widget _bottomItem(
          BuildContext context, IconData icon, String label, String route,
          {bool active = false}) =>
      Expanded(
        child: InkWell(
          onTap: active ? null : () => _go(context, route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
                color: active ? const Color(0xFFF0EDFF) : Colors.transparent,
                borderRadius: BorderRadius.circular(12)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon,
                  size: 23,
                  color: active
                      ? const Color(0xFF6C5CE7)
                      : const Color(0xFF94A3B8)),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: active
                          ? const Color(0xFF6C5CE7)
                          : const Color(0xFF94A3B8))),
            ]),
          ),
        ),
      );

  Widget _bottomNav(BuildContext context) => Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB)))),
        child: Row(children: [
          _bottomItem(
              context, Icons.home, OpsFixI18n.t('Beranda'), 'homeUserPage',
              active: true),
          _bottomItem(context, Icons.add_circle_outline, OpsFixI18n.t('Lapor'),
              'reportIssuePage'),
          _bottomItem(context, Icons.confirmation_number_outlined,
              OpsFixI18n.t('Tiket'), 'myTicketsPage'),
        ]),
      );

  Widget _sideItem(
          BuildContext context, IconData icon, String label, String route,
          {bool active = false}) =>
      InkWell(
        onTap: active ? null : () => _go(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
              color: active ? const Color(0xFF6C5CE7) : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Icon(icon,
                size: 21,
                color: active ? Colors.white : const Color(0xFFAAB6CC)),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: active ? Colors.white : const Color(0xFFD8E0EF),
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500)),
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
              Text(OpsFixI18n.t('Portal pengguna'),
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11))
            ]),
          ]),
          const SizedBox(height: 36),
          _sideItem(context, Icons.home_outlined, OpsFixI18n.t('Beranda'),
              'homeUserPage',
              active: true),
          const SizedBox(height: 8),
          _sideItem(context, Icons.add_circle_outline,
              OpsFixI18n.t('Buat laporan'), 'reportIssuePage'),
          const SizedBox(height: 8),
          _sideItem(context, Icons.confirmation_number_outlined,
              OpsFixI18n.t('Tiket saya'), 'myTicketsPage'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFF13213A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF253451))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(OpsFixI18n.t('LOKASI AKTIF'),
                  style: TextStyle(
                      color: Color(0xFF70E1CB),
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 7),
              Text(
                  FFAppState().currentLocationName.trim().isEmpty
                      ? OpsFixI18n.t('Belum dipilih')
                      : FFAppState().currentLocationName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(FFAppState().currentLocationCode,
                  style:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ]),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    final content = const Expanded(child: OpsFixReporterHomeContent());
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(
          child: desktop
              ? Row(children: [
                  const OpsFixReporterSidebar(activeSection: 'home'),
                  Expanded(
                      child: Column(children: [
                    _header(context, desktop: true),
                    content
                  ])),
                ])
              : Column(children: [
                  _header(context, desktop: false),
                  content,
                  const OpsFixReporterBottomNav(activeSection: 'home')
                ]),
        ),
      ),
    );
  }
}
