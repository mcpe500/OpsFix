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
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _reporterSidebarFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixReporterSidebar extends StatefulWidget {
  const OpsFixReporterSidebar({
    super.key,
    this.width,
    this.height,
    this.activeSection = '',
    this.profileActive = false,
  });
  final double? width;
  final double? height;
  final String activeSection;
  final bool profileActive;

  @override
  State<OpsFixReporterSidebar> createState() => _OpsFixReporterSidebarState();
}

class _OpsFixReporterSidebarState extends State<OpsFixReporterSidebar> {
  String _name = '';
  String? _avatar;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (currentUserUid.isEmpty) return;
    try {
      final row = await SupaFlow.client
          .from('users')
          .select('display_name,avatar_url')
          .eq('id', currentUserUid)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _name = row?['display_name']?.toString().trim() ?? '';
        final raw = row?['avatar_url']?.toString().trim() ?? '';
        _avatar = raw.isEmpty ? null : raw;
      });
    } catch (error) {
      debugPrint('Reporter sidebar profile load failed: ${error.runtimeType}');
    }
  }

  void _go(String section) {
    if (section == widget.activeSection) return;
    final route = switch (section) {
      'home' => 'homeUserPage',
      'report' => 'reportIssuePage',
      'incidents' => 'ReporterLocationTicketsPage',
      _ => 'myTicketsPage',
    };
    context.goNamed(
      route,
      extra: _reporterSidebarFade(),
      queryParameters: section == 'incidents'
          ? {
              'locationId': serializeParam(
                  FFAppState().currentLocationId, ParamType.String),
            }.withoutNulls
          : const <String, String>{},
    );
  }

  Widget _item(String section, IconData icon, String label) {
    final active = widget.activeSection == section;
    return InkWell(
      onTap: active ? null : () => _go(section),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF6C5CE7) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(icon,
              size: 21, color: active ? Colors.white : const Color(0xFFAAB6CC)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFFD8E0EF),
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                )),
          ),
        ]),
      ),
    );
  }

  Widget _avatarFallback() => Center(
        child: Text(
          _name.isEmpty ? 'O' : _name.characters.first.toUpperCase(),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        width: widget.width ?? 252,
        height: widget.height,
        color: const Color(0xFF081225),
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
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
                      fontWeight: FontWeight.w800)),
            ),
            SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('OpsFix',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800)),
            ]),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 58, top: 2, bottom: 30),
            child: Text(OpsFixI18n.t('Portal pengguna'),
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
          ),
          _item('home', Icons.home_outlined, OpsFixI18n.t('Beranda')),
          const SizedBox(height: 7),
          _item(
              'report', Icons.add_circle_outline, OpsFixI18n.t('Buat laporan')),
          const SizedBox(height: 7),
          _item('incidents', Icons.campaign_outlined,
              OpsFixI18n.t('Gangguan lokasi')),
          const SizedBox(height: 7),
          _item('tickets', Icons.confirmation_number_outlined,
              OpsFixI18n.t('Tiket saya')),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF13213A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF253451)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(OpsFixI18n.t('LOKASI AKTIF'),
                  style: const TextStyle(
                    color: Color(0xFF70E1CB),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 5),
              Text(
                FFAppState().currentLocationName.trim().isEmpty
                    ? OpsFixI18n.t('Belum dipilih')
                    : FFAppState().currentLocationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Material(
            color: widget.profileActive
                ? const Color(0xFF253451)
                : const Color(0xFF13213A),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: widget.profileActive
                  ? null
                  : () => context.pushNamed(
                        'ProfilePage',
                        extra: _reporterSidebarFade(),
                      ),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  ClipOval(
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: _avatar == null
                          ? ColoredBox(
                              color: const Color(0xFF6C5CE7),
                              child: _avatarFallback())
                          : Image.network(_avatar!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => ColoredBox(
                                  color: const Color(0xFF6C5CE7),
                                  child: _avatarFallback())),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name.isEmpty
                              ? OpsFixI18n.t('Pengguna OpsFix')
                              : _name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(OpsFixI18n.t('Buka profil'),
                            style: const TextStyle(
                                color: Color(0xFF94A3B8), fontSize: 10)),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      );
}
