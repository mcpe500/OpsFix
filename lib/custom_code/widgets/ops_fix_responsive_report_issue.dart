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
import '/custom_code/widgets/ops_fix_reporter_issue_form.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _opsFixReporterFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixResponsiveReportIssue extends StatelessWidget {
  const OpsFixResponsiveReportIssue({
    super.key,
    this.width,
    this.height,
    this.locationId = '',
    this.unitId = '',
    this.unitCode = '',
  });

  final double? width;
  final double? height;
  final String locationId;
  final String unitId;
  final String unitCode;

  void _go(BuildContext context, String route) =>
      context.goNamed(route, extra: _opsFixReporterFade());
  void _push(BuildContext context, String route) =>
      context.pushNamed(route, extra: _opsFixReporterFade());
  void _back(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      _go(context, 'homeUserPage');
    }
  }

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
            EdgeInsets.symmetric(horizontal: desktop ? 28 : 14, vertical: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
        child: Row(children: [
          if (!desktop) ...[
            _circleButton(Icons.arrow_back, const Color(0xFF111827),
                const Color(0xFFF8FAFC), () => _back(context)),
            const SizedBox(width: 10),
          ],
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: desktop
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                const Text('Buat Laporan',
                    style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 21,
                        fontWeight: FontWeight.w600)),
                if (desktop)
                  const Text(
                      'Lengkapi laporan agar teknisi menerima konteks yang tepat.',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ])),
          _circleButton(
              Icons.notifications_none,
              const Color(0xFF64748B),
              const Color(0xFFF8FAFC),
              () => _push(context, 'NotificationsPage')),
          if (desktop) ...[
            const SizedBox(width: 8),
            _circleButton(Icons.person_outline, const Color(0xFF065F46),
                const Color(0xFFD1FAE5), () => _push(context, 'ProfilePage')),
          ],
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
          const Row(children: [
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
              Text('Portal pengguna',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11))
            ]),
          ]),
          const SizedBox(height: 36),
          _sideItem(context, Icons.home_outlined, 'Beranda', 'homeUserPage'),
          const SizedBox(height: 8),
          _sideItem(context, Icons.add_circle_outline, 'Buat laporan',
              'reportIssuePage',
              active: true),
          const SizedBox(height: 8),
          _sideItem(context, Icons.confirmation_number_outlined, 'Tiket saya',
              'myTicketsPage'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFF13213A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF253451))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('LOKASI LAPORAN',
                  style: TextStyle(
                      color: Color(0xFF70E1CB),
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 7),
              Text(
                  FFAppState().currentLocationName.trim().isEmpty
                      ? 'Belum dipilih'
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

  Widget _contextHero() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: const Color(0xFF081225),
            borderRadius: BorderRadius.circular(24)),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('BUAT LAPORAN',
              style: TextStyle(
                  color: Color(0xFF35D0BA),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 13),
          const Text('Apa yang bermasalah?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 9),
          const Text(
              'Pilih jenis gangguan, jelaskan gejalanya, lalu sertakan foto agar teknisi menerima konteks yang tepat.',
              style: TextStyle(
                  color: Color(0xFFD8E0EF), fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFF172642),
                borderRadius: BorderRadius.circular(15)),
            child: Row(children: [
              const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF0D9488),
                  child:
                      Icon(Icons.location_on, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Lokasi laporan',
                        style:
                            TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                    const SizedBox(height: 3),
                    Text(
                        FFAppState().currentLocationName.trim().isEmpty
                            ? 'Lokasi belum dipilih'
                            : FFAppState().currentLocationName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    Text(FFAppState().currentLocationCode,
                        style: const TextStyle(
                            color: Color(0xFFB8C2D8), fontSize: 11)),
                  ])),
            ]),
          ),
        ]),
      );

  Widget _guide() => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDDE2E7))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Langkah pelaporan',
              style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          const Text(
              '1. Pilih perangkat dan jenis gangguan\n2. Jelaskan gejala dan sertakan foto\n3. Kirim laporan untuk ditangani teknisi',
              style: TextStyle(
                  color: Color(0xFF64748B), fontSize: 12, height: 1.7)),
          if (unitCode.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0EDFF),
                    borderRadius: BorderRadius.circular(12)),
                child: Text('Perangkat dipilih: $unitCode',
                    style: const TextStyle(
                        color: Color(0xFF5B4CE3),
                        fontSize: 12,
                        fontWeight: FontWeight.w600))),
          ],
        ]),
      );

  Widget _form() =>
      OpsFixReporterIssueForm(locationId: locationId, unitId: unitId);

  Widget _mobileTablet(double screenWidth) => Column(children: [
        _headerPlaceholder(),
      ]);

  Widget _headerPlaceholder() => const SizedBox.shrink();

  Widget _scrollContent({required bool desktop}) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding:
            EdgeInsets.fromLTRB(desktop ? 28 : 16, 18, desktop ? 28 : 16, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktop ? 1120 : 960),
            child: desktop
                ? _form()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _contextHero(),
                      const SizedBox(height: 16),
                      _form()
                    ],
                  ),
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
                  _sidebar(context),
                  Expanded(
                      child: Column(children: [
                    _header(context, desktop: true),
                    Expanded(child: _scrollContent(desktop: true))
                  ])),
                ])
              : Column(children: [
                  _header(context, desktop: false),
                  Expanded(child: _scrollContent(desktop: false))
                ]),
        ),
      ),
    );
  }
}
