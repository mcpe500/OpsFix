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
import '/custom_code/widgets/ops_fix_language_setting.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _reporterBottomFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixReporterBottomNav extends StatelessWidget {
  const OpsFixReporterBottomNav({
    super.key,
    this.width,
    this.height,
    this.activeSection = '',
  });
  final double? width;
  final double? height;
  final String activeSection;

  void _go(BuildContext context, String section) {
    if (section == activeSection) return;
    final route = switch (section) {
      'home' => 'homeUserPage',
      'report' => 'reportIssuePage',
      'incidents' => 'ReporterLocationTicketsPage',
      _ => 'myTicketsPage',
    };
    context.goNamed(
      route,
      extra: _reporterBottomFade(),
      queryParameters: section == 'incidents'
          ? {
              'locationId': serializeParam(
                  FFAppState().currentLocationId, ParamType.String),
            }.withoutNulls
          : const <String, String>{},
    );
  }

  Widget _item(
    BuildContext context,
    String section,
    IconData icon,
    String label,
  ) {
    final active = activeSection == section;
    return Expanded(
      child: InkWell(
        onTap: active ? null : () => _go(context, section),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 56,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF0EDFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon,
                size: 23,
                color:
                    active ? const Color(0xFF6C5CE7) : const Color(0xFF94A3B8)),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color:
                    active ? const Color(0xFF6C5CE7) : const Color(0xFF64748B),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width >= 1200) {
      return const SizedBox.shrink();
    }
    return Container(
      width: width,
      height: height ?? 72,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(children: [
        _item(context, 'home', Icons.home_outlined, OpsFixI18n.t('Beranda')),
        _item(
            context, 'report', Icons.add_circle_outline, OpsFixI18n.t('Lapor')),
        _item(context, 'incidents', Icons.campaign_outlined,
            OpsFixI18n.t('Gangguan')),
        _item(context, 'tickets', Icons.confirmation_number_outlined,
            OpsFixI18n.t('Tiket')),
      ]),
    );
  }
}
