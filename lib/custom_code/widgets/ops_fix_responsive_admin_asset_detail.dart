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
import 'package:go_router/go_router.dart';
import '/custom_code/widgets/ops_fix_admin_asset_detail_content.dart';

class OpsFixResponsiveAdminAssetDetail extends StatefulWidget {
  const OpsFixResponsiveAdminAssetDetail({
    super.key,
    this.width,
    this.height,
    required this.unitId,
    required this.locationId,
    this.assetCode,
  });

  final double? width;
  final double? height;
  final String unitId;
  final String locationId;
  final String? assetCode;

  @override
  State<OpsFixResponsiveAdminAssetDetail> createState() =>
      _OpsFixResponsiveAdminAssetDetailState();
}

class _OpsFixResponsiveAdminAssetDetailState
    extends State<OpsFixResponsiveAdminAssetDetail> {
  final _contentKey = GlobalKey<OpsFixAdminAssetDetailContentState>();

  void _go(BuildContext context, String route) {
    context.pushNamed(route);
  }

  void _back(BuildContext context) {
    final content = _contentKey.currentState;
    if (content != null) {
      content.backToLocation();
      return;
    }
    if (widget.locationId.trim().isNotEmpty) {
      context.pushNamed(
        'AdminAssetLocationDetailPage',
        queryParameters: {'locationId': widget.locationId.trim()},
      );
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Widget _header(BuildContext context, {required bool desktop}) => Container(
        height: desktop ? 82 : 68,
        padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => _back(context),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF8FAFC),
              ),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Aset',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (desktop)
                    const Text(
                      'Identitas, kondisi, dan riwayat pemeliharaan unit',
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
            const SizedBox(width: 8),
            const OpsFixManagerHeaderActions(),
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
            padding: const EdgeInsets.symmetric(vertical: 5),
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
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
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
        child: Row(
          children: [
            _bottomItem(
              context,
              Icons.dashboard_outlined,
              'Beranda',
              'adminDashboardPage',
            ),
            _bottomItem(
              context,
              Icons.confirmation_number_outlined,
              'Tiket',
              'adminTicketsPage',
            ),
            _bottomItem(
              context,
              Icons.view_kanban_outlined,
              'Board',
              'adminWorkBoardPage',
            ),
            _bottomItem(
              context,
              Icons.inventory_2,
              'Aset',
              'adminAssetsLocationsPage',
              active: true,
            ),
            _bottomItem(
              context,
              Icons.history,
              'Log',
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

  Widget _sidebar(BuildContext context) => Container(
        width: 252,
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
        color: const Color(0xFF081225),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
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
                      'Portal pengelola',
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
              'Dashboard',
              'adminDashboardPage',
            ),
            const SizedBox(height: 8),
            _sideItem(
              context,
              Icons.confirmation_number_outlined,
              'Tickets',
              'adminTicketsPage',
            ),
            const SizedBox(height: 8),
            _sideItem(
              context,
              Icons.view_kanban_outlined,
              'Work board',
              'adminWorkBoardPage',
            ),
            const SizedBox(height: 8),
            _sideItem(
              context,
              Icons.inventory_2,
              'Locations & assets',
              'adminAssetsLocationsPage',
              active: true,
            ),
            const SizedBox(height: 8),
            _sideItem(
              context,
              Icons.history,
              'Activity log',
              'adminActivityLogPage',
            ),
            const Spacer(),
            const OpsFixManagerProfileNav(),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    final content = Expanded(
      child: OpsFixAdminAssetDetailContent(
        key: _contentKey,
        unitId: widget.unitId,
        locationId: widget.locationId,
        assetCode: widget.assetCode ?? '',
      ),
    );
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
