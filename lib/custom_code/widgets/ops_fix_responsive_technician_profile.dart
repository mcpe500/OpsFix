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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _profileFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 180),
      ),
    };

class OpsFixResponsiveTechnicianProfile extends StatefulWidget {
  const OpsFixResponsiveTechnicianProfile({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixResponsiveTechnicianProfile> createState() =>
      _OpsFixResponsiveTechnicianProfileState();
}

class _OpsFixResponsiveTechnicianProfileState
    extends State<OpsFixResponsiveTechnicianProfile> {
  bool _loading = true;
  bool _loggingOut = false;
  String? _loadError;
  String? _logoutError;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted)
      setState(() {
        _loading = true;
        _loadError = null;
      });
    final uid = currentUserUid.trim();
    if (uid.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError =
            'Sesi akun tidak tersedia. Anda tetap dapat keluar dari akun.';
      });
      return;
    }
    try {
      final row = await SupaFlow.client
          .from('users')
          .select('display_name,role,is_active')
          .eq('id', uid)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _profile = row == null ? null : Map<String, dynamic>.from(row);
        _loading = false;
        _loadError = row == null
            ? 'Profil teknisi belum tersedia. Identitas sesi tetap dapat digunakan.'
            : null;
      });
    } catch (error) {
      debugPrint('Responsive technician profile load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError =
            'Profil belum dapat dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  String get _email {
    final value = currentUserEmail.trim();
    return value.isEmpty ? 'Email belum tersedia' : value;
  }

  String get _name {
    final value = _profile?['display_name']?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
    final email = currentUserEmail.trim();
    if (email.contains('@') && email.split('@').first.trim().isNotEmpty) {
      final raw =
          email.split('@').first.replaceAll(RegExp(r'[._-]+'), ' ').trim();
      if (raw.isNotEmpty) {
        return raw
            .split(' ')
            .where((part) => part.isNotEmpty)
            .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
            .join(' ');
      }
    }
    return 'Teknisi OpsFix';
  }

  String get _initial {
    final value = _name.trim();
    return value.isEmpty ? 'T' : value[0].toUpperCase();
  }

  String get _role {
    final value = _profile?['role']?.toString().toLowerCase().trim() ?? '';
    return value == 'technician' || value.isEmpty ? 'Teknisi lapangan' : value;
  }

  String get _status {
    final raw = _profile?['is_active'];
    if (raw == null) return 'Status belum tersedia';
    return raw == true ? 'Aktif' : 'Tidak aktif';
  }

  bool get _active => _profile?['is_active'] == true;

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.goNamed('technicianTasksPage', extra: _profileFade());
    }
  }

  void _go(String route) => context.goNamed(route, extra: _profileFade());

  Future<void> _logout() async {
    if (_loggingOut) return;
    setState(() {
      _loggingOut = true;
      _logoutError = null;
    });
    try {
      GoRouter.of(context).prepareAuthEvent();
      await SupaFlow.client.auth
          .signOut(scope: SignOutScope.local)
          .timeout(const Duration(seconds: 10));
      GoRouter.of(context).clearRedirectLocation();
      if (!mounted) return;
      context.goNamed('loginPage', extra: _profileFade());
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _loggingOut = false;
        _logoutError =
            'Keluar dari akun memerlukan waktu terlalu lama. Coba lagi.';
      });
    } catch (error) {
      debugPrint('Technician logout failed: $error');
      if (!mounted) return;
      setState(() {
        _loggingOut = false;
        _logoutError =
            'Belum dapat keluar dari akun. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  Widget _header({required bool desktop}) => Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 16),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
        child: Row(children: [
          IconButton(
              onPressed: _back,
              icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
              style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Profil Teknisi',
                    style: TextStyle(
                        fontSize: desktop ? 21 : 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827))),
                if (desktop)
                  const Text('Informasi akun dan akses portal teknisi.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ])),
          if (desktop)
            IconButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Pembaruan tugas tersedia pada daftar tugas.'))),
                icon: const Icon(Icons.notifications_none,
                    color: Color(0xFF111827))),
        ]),
      );

  Widget _sideItem(IconData icon, String label, String route) => InkWell(
        onTap: () => _go(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(children: [
              Icon(icon, size: 21, color: const Color(0xFFAAB6CC)),
              const SizedBox(width: 12),
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFFD8E0EF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ])),
      );

  Widget _sidebar() => Container(
        width: 252,
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
        color: const Color(0xFF081225),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Row(children: [
            CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFF6C5CE7),
                child: Icon(Icons.engineering_outlined,
                    color: Colors.white, size: 23)),
            SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('OpsFix',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700)),
              Text('Portal teknisi',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 36),
          _sideItem(Icons.task_alt_outlined, 'Tugas', 'technicianTasksPage'),
          const SizedBox(height: 8),
          _sideItem(Icons.history, 'Riwayat', 'technicianHistoryPage'),
          const Spacer(),
          Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: const Color(0xFF1E2B47),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF6C5CE7))),
              child: Row(children: [
                CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF6C5CE7),
                    child: Text(_initial,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700))),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(_name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Text('Profil teknisi',
                          style: TextStyle(
                              color: Color(0xFF94A3B8), fontSize: 10)),
                    ])),
              ])),
        ]),
      );

  BoxDecoration _cardDecoration({Color color = Colors.white}) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      );

  Widget _identityCard() => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: const Color(0xFF0B1324),
          borderRadius: BorderRadius.circular(22)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(
            radius: 38,
            backgroundColor: const Color(0xFF6C5CE7),
            child: Text(_initial,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700))),
        const SizedBox(height: 13),
        Text(_name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        Text(_email,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFFB8C1D9), fontSize: 14)),
        const SizedBox(height: 11),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0x2234D399),
                borderRadius: BorderRadius.circular(20)),
            child: const Text('Teknisi',
                style: TextStyle(
                    color: Color(0xFF6EE7B7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600))),
      ]));

  Widget _infoRow(IconData icon, String label, String value,
          {Color accent = const Color(0xFF6C5CE7)}) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: accent.withOpacity(.1),
                    borderRadius: BorderRadius.circular(13)),
                child: Icon(icon, color: accent, size: 20)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w500)),
                ])),
          ]));

  Widget _accountCard() => Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Informasi akun',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827))),
            const SizedBox(height: 4),
            _infoRow(Icons.mail_outline, 'Email', _email),
            const Divider(height: 1),
            _infoRow(Icons.verified_user_outlined, 'Peran', _role),
            const Divider(height: 1),
            _infoRow(Icons.check_circle_outline, 'Status akun', _status,
                accent: _active
                    ? const Color(0xFF059669)
                    : const Color(0xFF64748B)),
            if (_loadError != null) ...[
              const SizedBox(height: 12),
              Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFED7AA))),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xFFEA580C), size: 20),
                        const SizedBox(width: 9),
                        Expanded(
                            child: Text(_loadError!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9A3412),
                                    height: 1.35))),
                        IconButton(
                            onPressed: _loading ? null : _load,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.refresh,
                                color: Color(0xFFEA580C), size: 19)),
                      ])),
            ],
            if (_loading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(minHeight: 3),
            ],
            if (_logoutError != null) ...[
              const SizedBox(height: 12),
              Text(_logoutError!,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFFB91C1C))),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
                onPressed: _loggingOut ? null : _logout,
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                icon: _loggingOut
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.logout, size: 20),
                label:
                    Text(_loggingOut ? 'Sedang keluar…' : 'Keluar dari akun')),
          ]));

  Widget _content({required bool desktop, required bool tablet}) =>
      SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding:
              EdgeInsets.fromLTRB(desktop ? 28 : 16, 24, desktop ? 28 : 16, 32),
          child: Center(
              child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktop ? 1120 : 900),
            child: desktop || tablet
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 5, child: _identityCard()),
                    const SizedBox(width: 20),
                    Expanded(flex: 6, child: _accountCard()),
                  ])
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        _identityCard(),
                        const SizedBox(height: 16),
                        _accountCard(),
                      ]),
          )));

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final desktop = screenWidth >= 1200;
    final tablet = screenWidth >= 480 && screenWidth < 1200;
    final pageContent = desktop
        ? Row(children: [
            _sidebar(),
            Expanded(
                child: Column(children: [
              _header(desktop: true),
              Expanded(child: _content(desktop: true, tablet: false)),
            ])),
          ])
        : Column(children: [
            _header(desktop: false),
            Expanded(child: _content(desktop: false, tablet: tablet)),
          ]);
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: ColoredBox(
            color: const Color(0xFFF3F5F2),
            child: SafeArea(child: pageContent)));
  }
}
