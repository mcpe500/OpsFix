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
import '/custom_code/widgets/ops_fix_reporter_header_actions.dart';
import '/custom_code/widgets/ops_fix_reporter_bottom_nav.dart';
import '/custom_code/widgets/ops_fix_reporter_sidebar.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _reporterDetailFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixResponsiveReporterTicketDetail extends StatelessWidget {
  const OpsFixResponsiveReporterTicketDetail({
    super.key,
    this.width,
    this.height,
    this.ticketId = '',
  });

  final double? width;
  final double? height;
  final String ticketId;

  void _back(BuildContext context) => context.goNamed(
        'myTicketsPage',
        extra: _reporterDetailFade(),
      );

  Widget _header(BuildContext context, {required bool desktop}) => Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(children: [
          IconButton(
            tooltip: OpsFixI18n.t('Kembali ke tiket saya', context),
            onPressed: () => _back(context),
            icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
            style: IconButton.styleFrom(
              minimumSize: const Size(42, 42),
              backgroundColor: const Color(0xFFF8FAFC),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OpsFixI18n.t('Detail Tiket', context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (desktop)
                  Text(
                    OpsFixI18n.t(
                      'Pantau status dan hasil perbaikan laporan Anda.',
                      context,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          const OpsFixReporterHeaderActions(),
        ]),
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
                      Expanded(
                        child: OpsFixReporterTicketDetailContent(
                          key: ValueKey(
                            'reporter-ticket-detail-desktop-$ticketId',
                          ),
                          ticketId: ticketId,
                        ),
                      ),
                    ]),
                  ),
                ])
              : Column(children: [
                  _header(context, desktop: false),
                  Expanded(
                    child: OpsFixReporterTicketDetailContent(
                      key: ValueKey(
                        'reporter-ticket-detail-mobile-$ticketId',
                      ),
                      ticketId: ticketId,
                    ),
                  ),
                  const OpsFixReporterBottomNav(activeSection: 'tickets'),
                ]),
        ),
      ),
    );
  }
}
