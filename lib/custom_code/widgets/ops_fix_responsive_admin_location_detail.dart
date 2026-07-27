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
import '/custom_code/widgets/ops_fix_admin_location_detail_content.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OpsFixResponsiveAdminLocationDetail extends StatefulWidget {
  const OpsFixResponsiveAdminLocationDetail({
    super.key,
    this.width,
    this.height,
    required this.locationId,
  });

  final double? width;
  final double? height;
  final String locationId;

  @override
  State<OpsFixResponsiveAdminLocationDetail> createState() =>
      _OpsFixResponsiveAdminLocationDetailState();
}

class _OpsFixResponsiveAdminLocationDetailState
    extends State<OpsFixResponsiveAdminLocationDetail> {
  final _contentKey = GlobalKey<OpsFixAdminLocationDetailContentState>();

  void _go(BuildContext context, String route) => context.goNamed(route);

  Widget _header(BuildContext context, bool desktop) {
    final phone = MediaQuery.sizeOf(context).width < 480;
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali ke daftar lokasi',
            onPressed: () => _go(context, 'adminAssetsLocationsPage'),
            icon: const Icon(Icons.arrow_back_rounded),
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
                const Text(
                  'Lokasi & Unit',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (desktop)
                  const Text(
                    'Pantau lokasi dan kelola unit pemeliharaan.',
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
          const SizedBox(width: 10),
          if (phone)
            IconButton(
              tooltip: 'Tambah unit',
              onPressed: () => _contentKey.currentState?.openCreateForm(),
              icon: const Icon(Icons.add_rounded, color: Color(0xFF6C5CE7)),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF0EDFF),
                minimumSize: const Size(42, 42),
              ),
            )
          else
            FilledButton.icon(
              onPressed: () => _contentKey.currentState?.openCreateForm(),
              icon: const Icon(Icons.add_rounded, size: 19),
              label: const Text('Tambah unit'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
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
      child: OpsFixAdminLocationDetailContent(
        key: _contentKey,
        locationId: widget.locationId,
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
                          _header(context, true),
                          content,
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _header(context, false),
                    content,
                    _bottomNav(context),
                  ],
                ),
        ),
      ),
    );
  }
}
