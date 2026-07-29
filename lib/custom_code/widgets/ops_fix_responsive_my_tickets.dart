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
import '/custom_code/widgets/ops_fix_reporter_ticket_list.dart';
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

class OpsFixResponsiveMyTickets extends StatelessWidget {
  const OpsFixResponsiveMyTickets({super.key, this.width, this.height});
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
        padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(desktop ? OpsFixI18n.t('Tiket saya') : 'OpsFix',
                    style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                if (desktop)
                  Text(
                      OpsFixI18n.t(
                          'Pantau perkembangan seluruh laporan fasilitas.'),
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          const OpsFixReporterHeaderActions(),
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
            borderRadius: BorderRadius.circular(12),
          ),
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
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 36),
          _sideItem(context, Icons.home_outlined, OpsFixI18n.t('Beranda'),
              'homeUserPage'),
          const SizedBox(height: 8),
          _sideItem(context, Icons.add_circle_outline,
              OpsFixI18n.t('Buat laporan'), 'reportIssuePage'),
          const SizedBox(height: 8),
          _sideItem(context, Icons.confirmation_number_outlined,
              OpsFixI18n.t('Tiket saya'), 'myTicketsPage',
              active: true),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF13213A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF253451)),
            ),
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
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(FFAppState().currentLocationCode,
                  style:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ]),
          ),
        ]),
      );

  Widget _intro(BuildContext context, {required bool desktop}) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(OpsFixI18n.t('TICKET TRACKING'),
                  style: TextStyle(
                      color: Color(0xFF6C5CE7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 5),
              Text(OpsFixI18n.t('Pantau laporan saya.'),
                  style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 25,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 5),
              Text(
                  OpsFixI18n.t(
                      'Lihat status terbaru, teknisi yang menangani, dan riwayat laporan fasilitasmu.'),
                  style: TextStyle(
                      color: Color(0xFF64748B), fontSize: 14, height: 1.4)),
            ]),
          ),
          if (desktop) ...[
            const SizedBox(width: 20),
            FilledButton.icon(
              onPressed: () => _pushReport(context),
              icon: const Icon(Icons.add),
              label: Text(OpsFixI18n.t('Laporan baru')),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ],
      );

  static void _pushReport(BuildContext context) => context.pushNamed(
        'reportIssuePage',
        extra: _opsFixReporterFade(),
        queryParameters: {
          'locationId':
              serializeParam(FFAppState().currentLocationId, ParamType.String),
        }.withoutNulls,
      );

  Widget _bottomItem(
          BuildContext context, IconData icon, String label, String route,
          {bool active = false}) =>
      Expanded(
        child: InkWell(
          onTap: active ? null : () => _go(context, route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: active ? const Color(0xFFF0EDFF) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon,
                  size: 24,
                  color: active
                      ? const Color(0xFF6C5CE7)
                      : const Color(0xFF98A2B3)),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: active
                          ? const Color(0xFF6C5CE7)
                          : const Color(0xFF98A2B3))),
            ]),
          ),
        ),
      );

  Widget _bottomNav(BuildContext context) => Container(
        height: 72,
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(children: [
          _bottomItem(context, Icons.home_outlined, OpsFixI18n.t('Beranda'),
              'homeUserPage'),
          const SizedBox(width: 6),
          _bottomItem(context, Icons.add_circle_outline, OpsFixI18n.t('Lapor'),
              'reportIssuePage'),
          const SizedBox(width: 6),
          _bottomItem(context, Icons.confirmation_number, OpsFixI18n.t('Tiket'),
              'myTicketsPage',
              active: true),
        ]),
      );

  Widget _content(BuildContext context, {required bool desktop}) => Padding(
        padding: EdgeInsets.fromLTRB(
            desktop ? 28 : 16, 18, desktop ? 28 : 16, desktop ? 24 : 10),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktop ? 1280 : 960),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _intro(context, desktop: desktop),
                  if (!desktop) ...[
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: () => _pushReport(context),
                      icon: const Icon(Icons.add),
                      label: Text(OpsFixI18n.t('Laporan baru')),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        backgroundColor: const Color(0xFF6C5CE7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Expanded(child: OpsFixReporterTicketList()),
                ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(
          child: desktop
              ? Row(children: [
                  const OpsFixReporterSidebar(activeSection: 'tickets'),
                  Expanded(
                    child: Column(children: [
                      _header(context, desktop: true),
                      Expanded(child: _content(context, desktop: true)),
                    ]),
                  ),
                ])
              : Column(children: [
                  _header(context, desktop: false),
                  Expanded(child: _content(context, desktop: false)),
                  const OpsFixReporterBottomNav(activeSection: 'tickets'),
                ]),
        ),
      ),
    );
  }
}
