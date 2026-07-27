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
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _opsFixReporterFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixResponsiveReporterProfile extends StatefulWidget {
  const OpsFixResponsiveReporterProfile({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixResponsiveReporterProfile> createState() =>
      _OpsFixResponsiveReporterProfileState();
}

class _OpsFixResponsiveReporterProfileState
    extends State<OpsFixResponsiveReporterProfile> {
  bool _loading = true;
  bool _signingOut = false;
  String? _error;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await SupaFlow.client
          .from('users')
          .select('id,display_name,role,is_active')
          .eq('id', currentUserUid)
          .limit(1);
      if (!mounted) return;
      setState(() {
        _profile =
            rows.isEmpty ? null : Map<String, dynamic>.from(rows.first as Map);
        _loading = false;
        _error = rows.isEmpty
            ? 'Profil akun belum lengkap. Informasi sesi tetap dapat digunakan.'
            : null;
      });
    } catch (error) {
      debugPrint('Reporter profile load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Profil belum dapat dimuat. Periksa koneksi lalu coba kembali.';
      });
    }
  }

  String _value(String key) => _profile?[key]?.toString().trim() ?? '';

  String get _displayName {
    final stored = _value('display_name');
    if (stored.isNotEmpty) return stored;
    final email = currentUserEmail.trim();
    if (email.contains('@')) {
      final local = email.split('@').first.replaceAll(RegExp(r'[._-]+'), ' ');
      if (local.isNotEmpty) {
        return local
            .split(' ')
            .where((part) => part.isNotEmpty)
            .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
            .join(' ');
      }
    }
    return 'Pengguna OpsFix';
  }

  String get _roleLabel => switch (_value('role').toLowerCase()) {
        'reporter' || 'user' => 'Pelapor fasilitas',
        'technician' => 'Teknisi',
        'manager' || 'admin' => 'Pengelola',
        _ => 'Pelapor fasilitas',
      };

  String get _statusLabel {
    final raw = _profile?['is_active'];
    return raw is bool && !raw ? 'Tidak aktif' : 'Aktif';
  }

  String get _initial {
    final name = _displayName.trim();
    return name.isEmpty ? 'O' : name[0].toUpperCase();
  }

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.goNamed('homeUserPage', extra: _opsFixReporterFade());
    }
  }

  Future<void> _logout() async {
    if (_signingOut) return;
    setState(() {
      _signingOut = true;
      _error = null;
    });
    GoRouter.of(context).prepareAuthEvent();

    Object? signOutError;
    final Future<void> signOutAttempt =
        authManager.signOut().then<void>((_) {}).catchError((Object error) {
      signOutError = error;
      debugPrint('Reporter logout server revoke failed: $error');
    });

    await Future.any<void>([
      signOutAttempt,
      Future<void>.delayed(const Duration(milliseconds: 1200)),
    ]);

    final localSessionCleared = SupaFlow.client.auth.currentSession == null;
    if (localSessionCleared) {
      GoRouter.of(context).clearRedirectLocation();
      if (!mounted) return;
      context.goNamed(
        'LoginPage',
        extra: _opsFixReporterFade(),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _signingOut = false;
      _error = signOutError == null
          ? 'Proses keluar terlalu lama. Periksa koneksi lalu coba kembali.'
          : 'Belum dapat keluar dari akun. Periksa koneksi lalu coba kembali.';
    });
  }

  Widget _circleButton(
          IconData icon, Color color, Color fill, VoidCallback action) =>
      IconButton(
        onPressed: action,
        icon: Icon(icon, color: color, size: 24),
        style: IconButton.styleFrom(
            backgroundColor: fill, minimumSize: const Size(42, 42)),
      );

  Widget _header({required bool desktop}) => Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(children: [
          if (!desktop) ...[
            _circleButton(Icons.arrow_back, const Color(0xFF111827),
                const Color(0xFFF8FAFC), _back),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: desktop
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                const Text('Profil Pengguna',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                if (desktop)
                  const Text('Informasi akun dan akses portal Anda.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          _circleButton(
              Icons.notifications_none,
              const Color(0xFF64748B),
              const Color(0xFFF8FAFC),
              () => context.pushNamed('NotificationsPage',
                  extra: _opsFixReporterFade())),
          if (!desktop) const SizedBox(width: 42),
        ]),
      );

  Widget _sideItem(IconData icon, String label, String route) => InkWell(
        onTap: () => context.goNamed(route, extra: _opsFixReporterFade()),
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
          ]),
        ),
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
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 36),
          _sideItem(Icons.home_outlined, 'Beranda', 'homeUserPage'),
          const SizedBox(height: 8),
          _sideItem(
              Icons.add_circle_outline, 'Buat laporan', 'reportIssuePage'),
          const SizedBox(height: 8),
          _sideItem(Icons.confirmation_number_outlined, 'Tiket saya',
              'myTicketsPage'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF13213A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF253451)),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: const Color(0xFF6C5CE7),
                child: Text(_initial,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const Text('Profil pengguna',
                        style:
                            TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      );

  Widget _identityCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1324),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: const Color(0xFF6C5CE7),
            child: Text(_initial,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 14),
          Text(_displayName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
              currentUserEmail.trim().isEmpty
                  ? 'Email belum tersedia'
                  : currentUserEmail,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFFB8C1D9), fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x2234D399),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_roleLabel,
                style: const TextStyle(
                    color: Color(0xFF6EE7B7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
      );

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF6C5CE7), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Color(0xFF64748B), fontSize: 11)),
                const SizedBox(height: 2),
                Text(value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ]),
      );

  Widget _accountCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Informasi akun',
                style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            _infoRow(
                Icons.mail_outline,
                'Email',
                currentUserEmail.trim().isEmpty
                    ? 'Email belum tersedia'
                    : currentUserEmail),
            const Divider(height: 1),
            _infoRow(Icons.badge_outlined, 'Peran', _roleLabel),
            const Divider(height: 1),
            _infoRow(Icons.check_circle_outline, 'Status akun', _statusLabel),
            if (_loading) ...[
              const SizedBox(height: 14),
              const LinearProgressIndicator(minHeight: 3),
            ],
            if (_error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  const Icon(Icons.info_outline,
                      color: Color(0xFFD97706), size: 20),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(_error!,
                        style: const TextStyle(
                            color: Color(0xFF92400E),
                            fontSize: 12,
                            height: 1.35)),
                  ),
                  IconButton(
                    tooltip: 'Coba lagi',
                    onPressed: _loading
                        ? null
                        : () {
                            setState(() {
                              _loading = true;
                              _error = null;
                            });
                            _load();
                          },
                    icon: const Icon(Icons.refresh,
                        color: Color(0xFFD97706), size: 20),
                  ),
                ]),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _signingOut ? null : _logout,
              icon: _signingOut
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.logout),
              label: Text(_signingOut ? 'Sedang keluar…' : 'Keluar dari akun'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: const Color(0xFFDC2626),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      );

  Widget _content({required bool desktop, required bool tablet}) =>
      SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding:
            EdgeInsets.fromLTRB(desktop ? 28 : 16, 22, desktop ? 28 : 16, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktop ? 1120 : 900),
            child: desktop || tablet
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 4, child: _identityCard()),
                    const SizedBox(width: 20),
                    Expanded(flex: 6, child: _accountCard()),
                  ])
                : Column(children: [
                    _identityCard(),
                    const SizedBox(height: 16),
                    _accountCard(),
                  ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final desktop = screenWidth >= 1200;
    final tablet = screenWidth >= 480 && !desktop;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(
          child: desktop
              ? Row(children: [
                  _sidebar(),
                  Expanded(
                    child: Column(children: [
                      _header(desktop: true),
                      Expanded(child: _content(desktop: true, tablet: false)),
                    ]),
                  ),
                ])
              : Column(children: [
                  _header(desktop: false),
                  Expanded(child: _content(desktop: false, tablet: tablet)),
                ]),
        ),
      ),
    );
  }
}
