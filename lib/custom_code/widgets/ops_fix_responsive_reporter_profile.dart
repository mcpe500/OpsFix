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
            ? OpsFixI18n.t(
                'Profil akun belum lengkap. Informasi sesi tetap dapat digunakan.')
            : null;
      });
    } catch (error) {
      debugPrint('Reporter profile load failed: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = OpsFixI18n.t(
            'Profil belum dapat dimuat. Periksa koneksi lalu coba kembali.');
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
    return OpsFixI18n.t('Pengguna OpsFix');
  }

  String get _roleLabel => switch (_value('role').toLowerCase()) {
        'reporter' || 'user' => OpsFixI18n.t('Pelapor fasilitas'),
        'technician' => OpsFixI18n.t('Teknisi'),
        'manager' || 'admin' => OpsFixI18n.t('Pengelola'),
        _ => OpsFixI18n.t('Pelapor fasilitas'),
      };

  String get _statusLabel {
    final raw = _profile?['is_active'];
    return raw is bool && !raw
        ? OpsFixI18n.t('Tidak aktif')
        : OpsFixI18n.t('Aktif');
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
          ? OpsFixI18n.t(
              'Proses keluar terlalu lama. Periksa koneksi lalu coba kembali.')
          : OpsFixI18n.t(
              'Belum dapat keluar dari akun. Periksa koneksi lalu coba kembali.');
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
                Text(OpsFixI18n.t('Profil Pengguna'),
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                if (desktop)
                  Text(OpsFixI18n.t('Informasi akun dan akses portal Anda.'),
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          const OpsFixReporterHeaderActions(profileActive: true),
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
          _sideItem(
              Icons.home_outlined, OpsFixI18n.t('Beranda'), 'homeUserPage'),
          const SizedBox(height: 8),
          _sideItem(Icons.add_circle_outline, OpsFixI18n.t('Buat laporan'),
              'reportIssuePage'),
          const SizedBox(height: 8),
          _sideItem(Icons.confirmation_number_outlined,
              OpsFixI18n.t('Tiket saya'), 'myTicketsPage'),
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
                    Text(OpsFixI18n.t('Profil pengguna'),
                        style:
                            TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      );

  Widget _avatar({double size = 84}) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF6C5CE7),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x337C6DF2), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          _initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * .36,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  Widget _identityCard({required bool horizontal}) {
    final details = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          _displayName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: horizontal ? TextAlign.start : TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          currentUserEmail.trim().isEmpty
              ? OpsFixI18n.t('Email tidak tersedia')
              : currentUserEmail,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: horizontal ? TextAlign.start : TextAlign.center,
          style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF17233D),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            _roleLabel,
            style: const TextStyle(
              color: Color(0xFF99F6E4),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1426),
        borderRadius: BorderRadius.circular(22),
      ),
      child: horizontal
          ? Row(children: [
              _avatar(),
              const SizedBox(width: 18),
              Expanded(child: details),
            ])
          : Column(children: [_avatar(), const SizedBox(height: 14), details]),
    );
  }

  Widget _fact(IconData icon, String label, String value) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6EAF0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFF),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: const Color(0xFF6C5CE7), size: 20),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _information({required int columns}) {
    final facts = [
      _fact(
        Icons.mail_outline_rounded,
        OpsFixI18n.t('Email'),
        currentUserEmail.trim().isEmpty
            ? OpsFixI18n.t('Email tidak tersedia')
            : currentUserEmail,
      ),
      _fact(
        Icons.badge_outlined,
        OpsFixI18n.t('ID pengguna'),
        currentUserUid.trim().isEmpty
            ? OpsFixI18n.t('ID tidak tersedia')
            : currentUserUid,
      ),
      _fact(Icons.manage_accounts_outlined, OpsFixI18n.t('Peran'), _roleLabel),
      _fact(Icons.check_circle_outline_rounded, OpsFixI18n.t('Status akun'),
          _statusLabel),
    ];

    Widget body;
    if (columns >= 4) {
      body = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: facts[0]),
        const SizedBox(width: 10),
        Expanded(child: facts[1]),
        const SizedBox(width: 10),
        Expanded(child: facts[2]),
        const SizedBox(width: 10),
        Expanded(child: facts[3]),
      ]);
    } else if (columns >= 2) {
      body = Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: facts[0]),
          const SizedBox(width: 10),
          Expanded(child: facts[1]),
        ]),
        const SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: facts[2]),
          const SizedBox(width: 10),
          Expanded(child: facts[3]),
        ]),
      ]);
    } else {
      body = Column(children: [
        facts[0],
        const SizedBox(height: 10),
        facts[1],
        const SizedBox(height: 10),
        facts[2],
        const SizedBox(height: 10),
        facts[3],
      ]);
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(OpsFixI18n.t('Informasi akun'),
              style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          body,
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
                  tooltip: OpsFixI18n.t('Coba lagi'),
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
        ],
      ),
    );
  }

  Widget _session({required bool horizontal}) {
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(OpsFixI18n.t('Sesi akun'),
            style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        Text(OpsFixI18n.t('Keluar dengan aman dari portal pengguna.'),
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
      ],
    );
    final action = FilledButton.icon(
      onPressed: _signingOut ? null : _logout,
      icon: _signingOut
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.logout_rounded, size: 19),
      label: Text(_signingOut
          ? OpsFixI18n.t('Sedang keluar…')
          : OpsFixI18n.t('Keluar dari akun')),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFDC2626),
        minimumSize:
            horizontal ? const Size(210, 48) : const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: horizontal
          ? Row(children: [
              Expanded(child: copy),
              const SizedBox(width: 18),
              action,
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [copy, const SizedBox(height: 14), action],
            ),
    );
  }

  Widget _content({required bool desktop, required bool tablet}) {
    final padding = desktop ? 28.0 : 16.0;
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(padding, 20, padding, 28),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(builder: (context, constraints) {
              final available = constraints.maxWidth;
              if (available < 480) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _identityCard(horizontal: false),
                    const SizedBox(height: 14),
                    _information(columns: 1),
                    const SizedBox(height: 14),
                    _session(horizontal: false),
                  ],
                );
              }
              if (available < 900) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _identityCard(horizontal: true),
                    const SizedBox(height: 16),
                    _information(columns: 2),
                    const SizedBox(height: 16),
                    _session(horizontal: available >= 600),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _identityCard(horizontal: true),
                  const SizedBox(height: 18),
                  _information(columns: 4),
                  const SizedBox(height: 18),
                  _session(horizontal: true),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: const OpsFixLanguageSetting(),
          ),
        ),
      ],
    );
  }

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
                  const OpsFixReporterSidebar(profileActive: true),
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
                  const OpsFixReporterBottomNav(),
                ]),
        ),
      ),
    );
  }
}
