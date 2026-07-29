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
import '/custom_code/widgets/ops_fix_admin_activity_log_content.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixResponsiveAdminActivityLog extends StatelessWidget {
  const OpsFixResponsiveAdminActivityLog({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  void _go(BuildContext context, String route) => context.goNamed(
        route,
        extra: _opsFixPageFade(),
      );

  void _showExportMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          OpsFixI18n.t(
              'Ekspor log audit dapat ditambahkan pada tahap berikutnya.'),
        ),
        duration: Duration(milliseconds: 4000),
      ),
    );
  }

  Widget _header(BuildContext context, {required bool desktop}) {
    final compact = MediaQuery.sizeOf(context).width < 480;
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 16),
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
                  OpsFixI18n.t('Log Aktivitas Audit'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (desktop)
                  Text(
                    OpsFixI18n.t(
                        'Telusuri perubahan operasional terbaru pada site aktif.'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (compact)
            IconButton(
              tooltip: OpsFixI18n.t('Ekspor log'),
              onPressed: () => _showExportMessage(context),
              icon: const Icon(
                Icons.download_rounded,
                color: Color(0xFF6C5CE7),
              ),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF0EDFF),
                minimumSize: const Size(42, 42),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: () => _showExportMessage(context),
              icon: const Icon(Icons.download_rounded, size: 19),
              label: Text(OpsFixI18n.t('Ekspor')),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6C5CE7),
                side: const BorderSide(color: Color(0xFFC9C1FF)),
                minimumSize: const Size(108, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          const SizedBox(width: 8),
          const OpsFixManagerHeaderActions(),
        ],
      ),
    );
  }

  Widget _bottomItem(
    BuildContext context,
    IconData icon,
    String label,
    String route, {
    bool active = false,
  }) {
    return Expanded(
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
                color:
                    active ? const Color(0xFF6C5CE7) : const Color(0xFF98A2B3),
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
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          _bottomItem(
            context,
            Icons.dashboard_outlined,
            OpsFixI18n.t('Beranda'),
            'adminDashboardPage',
          ),
          _bottomItem(
            context,
            Icons.confirmation_number_outlined,
            OpsFixI18n.t('Tiket'),
            'adminTicketsPage',
          ),
          _bottomItem(
            context,
            Icons.view_kanban_outlined,
            OpsFixI18n.t('Board'),
            'adminWorkBoardPage',
          ),
          _bottomItem(
            context,
            Icons.inventory_2_outlined,
            OpsFixI18n.t('Aset'),
            'adminAssetsLocationsPage',
          ),
          _bottomItem(
            context,
            Icons.history_rounded,
            OpsFixI18n.t('Log'),
            'adminActivityLogPage',
            active: true,
          ),
        ],
      ),
    );
  }

  Widget _sideItem(
    BuildContext context,
    IconData icon,
    String label,
    String route, {
    bool active = false,
  }) {
    return InkWell(
      onTap: active ? null : () => _go(context, route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF6C5CE7) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: active ? Colors.white : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFFD5DCEA),
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebar(BuildContext context) {
    return Container(
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
          ),
          const SizedBox(height: 8),
          _sideItem(
            context,
            Icons.confirmation_number_outlined,
            OpsFixI18n.t('Tickets'),
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
            OpsFixI18n.t('Locations & assets'),
            'adminAssetsLocationsPage',
          ),
          const SizedBox(height: 8),
          _sideItem(
            context,
            Icons.history_rounded,
            OpsFixI18n.t('Activity log'),
            'adminActivityLogPage',
            active: true,
          ),
          const Spacer(),
          const OpsFixManagerProfileNav(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    const content = Expanded(child: OpsFixAdminActivityLogContent());

    return SizedBox(
      width: width,
      height: height,
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
