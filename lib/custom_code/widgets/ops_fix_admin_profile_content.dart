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

import '/auth/supabase_auth/auth_util.dart';

class OpsFixAdminProfileContent extends StatefulWidget {
  const OpsFixAdminProfileContent({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixAdminProfileContent> createState() =>
      _OpsFixAdminProfileContentState();
}

class _OpsFixAdminProfileContentState extends State<OpsFixAdminProfileContent> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (currentUserUid.isEmpty) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Sesi admin tidak tersedia. Silakan masuk kembali.';
        });
      }
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final row = await SupaFlow.client
          .from('users')
          .select('id,display_name,role,phone,avatar_url,is_active')
          .eq('id', currentUserUid)
          .maybeSingle();
      if (!mounted) return;
      if (row == null || row['is_active'] != true) {
        setState(() {
          _loading = false;
          _profile = null;
          _error = row == null
              ? 'Profil admin tidak ditemukan.'
              : 'Profil admin sedang tidak aktif.';
        });
        return;
      }
      setState(() {
        _profile = Map<String, dynamic>.from(row);
        _loading = false;
      });
    } catch (error) {
      debugPrint('Admin profile load failed: ${error.runtimeType}');
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Profil admin belum dapat dimuat. Coba lagi.';
        });
      }
    }
  }

  String _text(String key, String fallback) {
    final value = _profile?[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  String get _roleLabel {
    return switch (_text('role', 'manager')) {
      'manager' => 'Manager',
      'technician' => 'Teknisi',
      'reporter' => 'Pelapor',
      final value => value.replaceAll('_', ' '),
    };
  }

  Widget _avatar({double size = 84}) {
    final url = _text('avatar_url', '');
    Widget fallback() => ColoredBox(
          color: const Color(0xFF6C5CE7),
          child: Center(
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: size * 0.48,
            ),
          ),
        );
    return SizedBox.square(
      dimension: size,
      child: ClipOval(
        child: url.isEmpty
            ? fallback()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback(),
              ),
      ),
    );
  }

  Widget _hero({required bool horizontal}) {
    final details = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          _text('display_name', 'Admin OpsFix'),
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
          currentUserEmail.isEmpty ? 'Email tidak tersedia' : currentUserEmail,
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
              Expanded(child: details)
            ])
          : Column(children: [_avatar(), const SizedBox(height: 14), details]),
    );
  }

  Widget _fact(IconData icon, String label, String value) {
    return Container(
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
  }

  Widget _information({required int columns}) {
    final facts = [
      _fact(Icons.mail_outline_rounded, 'Email',
          currentUserEmail.isEmpty ? 'Email tidak tersedia' : currentUserEmail),
      _fact(Icons.badge_outlined, 'ID pengguna',
          currentUserUid.isEmpty ? 'ID tidak tersedia' : currentUserUid),
      _fact(Icons.manage_accounts_outlined, 'Peran', _roleLabel),
      _fact(Icons.phone_outlined, 'Nomor telepon',
          _text('phone', 'Belum ditambahkan')),
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
          const Text('Informasi akun',
              style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          body,
        ],
      ),
    );
  }

  Future<void> _logout() async {
    if (_busy) return;
    setState(() => _busy = true);
    FFAppState().update(() {
      FFAppState().currentUserRole = '';
      FFAppState().currentSiteId = '';
      FFAppState().currentLocationId = '';
      FFAppState().currentLocationSlug = '';
      FFAppState().currentLocationCode = '';
      FFAppState().currentLocationName = '';
      FFAppState().pendingLocationSlug = '';
    });
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    GoRouter.of(context).clearRedirectLocation();
    if (!mounted) return;
    context.goNamedAuth('LoginPage', context.mounted);
  }

  Widget _session({required bool horizontal}) {
    final copy = const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sesi akun',
            style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        SizedBox(height: 5),
        Text('Keluar dengan aman dari portal pengelola.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
      ],
    );
    final action = FilledButton.icon(
      onPressed: _busy ? null : _logout,
      icon: _busy
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.logout_rounded, size: 19),
      label: Text(_busy ? 'Keluar…' : 'Keluar dari akun'),
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

  Widget _errorState() => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF1C9C9)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.error_outline,
                  color: Color(0xFFDC2626), size: 34),
              const SizedBox(height: 12),
              Text(_error ?? 'Profil admin tidak tersedia.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF111827), fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: _busy ? null : _logout,
                        child: const Text('Keluar'))),
                const SizedBox(width: 10),
                Expanded(
                    child: FilledButton(
                  onPressed: _load,
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7)),
                  child: const Text('Coba lagi'),
                )),
              ]),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
      );
    }
    if (_error != null || _profile == null) return _errorState();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final padding = screenWidth < 480
        ? 14.0
        : screenWidth < 800
            ? 20.0
            : screenWidth < 1200
                ? 24.0
                : 32.0;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ListView(
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
                        _hero(horizontal: false),
                        const SizedBox(height: 14),
                        _information(columns: 1),
                        const SizedBox(height: 14),
                        _session(horizontal: false),
                      ]);
                }
                if (available < 900) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _hero(horizontal: true),
                        const SizedBox(height: 16),
                        _information(columns: 2),
                        const SizedBox(height: 16),
                        _session(horizontal: available >= 600),
                      ]);
                }
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _hero(horizontal: true),
                      const SizedBox(height: 18),
                      _information(columns: 4),
                      const SizedBox(height: 18),
                      _session(horizontal: true),
                    ]);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
