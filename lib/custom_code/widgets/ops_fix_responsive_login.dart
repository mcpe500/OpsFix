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
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixResponsiveLogin extends StatefulWidget {
  const OpsFixResponsiveLogin({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixResponsiveLogin> createState() => _OpsFixResponsiveLoginState();
}

class _OpsFixResponsiveLoginState extends State<OpsFixResponsiveLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _passwordVisible = false;
  bool _remember = false;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(OpsFixI18n.t('Email dan password wajib diisi.'))),
      );
      return;
    }
    setState(() => _submitting = true);
    GoRouter.of(context).prepareAuthEvent();
    final user = await authManager.signInWithEmail(context, email, password);
    if (!mounted) return;
    if (user == null) {
      setState(() => _submitting = false);
      return;
    }
    context.goNamedAuth(
      'LaunchPage',
      context.mounted,
      extra: _opsFixPageFade(),
    );
  }

  Widget _logo({bool large = false, bool light = false}) {
    final foreground = light ? Colors.white : const Color(0xFF111827);
    final secondary = light ? const Color(0xFFD8E0EF) : const Color(0xFF667085);
    final size = large ? 72.0 : 56.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7),
            shape: BoxShape.circle,
            border: light ? Border.all(color: Colors.white24, width: 1) : null,
          ),
          child: Text('O',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: large ? 30 : 24,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
        Text('OpsFix',
            style: TextStyle(
                color: foreground,
                fontSize: large ? 30 : 22,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(OpsFixI18n.t('Facility care, made traceable.'),
            style: TextStyle(color: secondary, fontSize: 12)),
      ],
    );
  }

  Widget _heading({bool desktop = false}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(OpsFixI18n.t('Portal OpsFix'),
              style: TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 7),
          Text(OpsFixI18n.t('Masuk ke akunmu.'),
              style: TextStyle(
                  color: const Color(0xFF111827),
                  fontSize: desktop ? 30 : 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          Text(
              OpsFixI18n.t(
                  'Gunakan akun yang telah terdaftar untuk membuka portal sesuai peranmu.'),
              style: TextStyle(
                  color: Color(0xFF667085), fontSize: 14, height: 1.4)),
        ],
      );

  InputDecoration _decoration(String label, {Widget? suffix}) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF667085), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF7F7F8),
        suffixIcon: suffix,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 1.5)),
      );

  Widget _formCard() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A111827), blurRadius: 18, offset: Offset(0, 6))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onSubmitted: (_) => _passwordFocus.requestFocus(),
              decoration: _decoration(OpsFixI18n.t('Email')),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: !_passwordVisible,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _submit(),
              decoration: _decoration(
                OpsFixI18n.t('Password'),
                suffix: IconButton(
                  tooltip: _passwordVisible
                      ? OpsFixI18n.t('Sembunyikan password')
                      : OpsFixI18n.t('Tampilkan password'),
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                  icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF98A2B3)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _remember = !_remember),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [
                      Icon(
                          _remember
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 20,
                          color: _remember
                              ? const Color(0xFF6C5CE7)
                              : const Color(0xFF98A2B3)),
                      const SizedBox(width: 8),
                      Text(OpsFixI18n.t('Ingat saya'),
                          style: TextStyle(
                              color: Color(0xFF667085), fontSize: 12)),
                    ]),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.pushNamed(
                    'forgotPasswordPage',
                    extra: _opsFixPageFade(),
                  ),
                  child: Text(OpsFixI18n.t('Lupa password?'),
                      style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9))),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(OpsFixI18n.t('Masuk'),
                        style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );

  Widget _registerLink() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(OpsFixI18n.t('Belum punya akun?'),
              style: TextStyle(color: Color(0xFF667085), fontSize: 12)),
          TextButton(
            onPressed: () => context.pushNamed(
              'RegisterPage',
              extra: _opsFixPageFade(),
            ),
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 5)),
            child: Text(OpsFixI18n.t('Daftar sekarang'),
                style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 12)),
          ),
        ],
      );

  Widget _mobile() => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 700),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logo(),
              const SizedBox(height: 24),
              Align(alignment: Alignment.centerLeft, child: _heading()),
              const SizedBox(height: 24),
              _formCard(),
              const SizedBox(height: 16),
              _registerLink(),
            ],
          ),
        ),
      );

  Widget _tablet() => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _logo(),
                const SizedBox(height: 30),
                Align(alignment: Alignment.centerLeft, child: _heading()),
                const SizedBox(height: 22),
                _formCard(),
                const SizedBox(height: 14),
                _registerLink(),
              ],
            ),
          ),
        ),
      );

  Widget _desktop() => Row(
        children: [
          Expanded(
            flex: 44,
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF081225), Color(0xFF15213C)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -120,
                    right: -110,
                    child: Container(
                      width: 330,
                      height: 330,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x126C5CE7),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -150,
                    left: -120,
                    child: Container(
                      width: 360,
                      height: 360,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x0D35D0BA),
                      ),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 64, vertical: 48),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 470),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 62,
                                  height: 62,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C5CE7),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white24),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color(0x336C5CE7),
                                          blurRadius: 28,
                                          spreadRadius: 3),
                                    ],
                                  ),
                                  child: const Text('O',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('OpsFix',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700)),
                                    SizedBox(height: 2),
                                    Text(
                                        OpsFixI18n.t(
                                            'Facility care, made traceable.'),
                                        style: TextStyle(
                                            color: Color(0xFFAAB6CC),
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 64),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0x1A35D0BA),
                                borderRadius: BorderRadius.circular(18),
                                border:
                                    Border.all(color: const Color(0x3335D0BA)),
                              ),
                              child: Text(
                                  OpsFixI18n.t('PORTAL OPERASIONAL FASILITAS'),
                                  style: TextStyle(
                                      color: Color(0xFF70E1CB),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.7)),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              <String>[
                                OpsFixI18n.t('Fasilitas terjaga.'),
                                OpsFixI18n.t('Pekerjaan terlacak.'),
                              ].join('\n'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  height: 1.12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.8),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              OpsFixI18n.t(
                                  'Satu ruang kerja untuk melaporkan gangguan, mengatur penugasan, dan memastikan setiap perbaikan selesai dengan bukti.'),
                              style: TextStyle(
                                  color: Color(0xFFC5CEE0),
                                  fontSize: 16,
                                  height: 1.55),
                            ),
                            const SizedBox(height: 30),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _benefitChip(Icons.qr_code_scanner,
                                    OpsFixI18n.t('Laporan berbasis lokasi')),
                                _benefitChip(Icons.track_changes_outlined,
                                    OpsFixI18n.t('Status real-time')),
                                _benefitChip(Icons.verified_user_outlined,
                                    OpsFixI18n.t('Aktivitas tercatat')),
                              ],
                            ),
                            const SizedBox(height: 46),
                            Row(
                              children: [
                                Icon(Icons.lock_outline,
                                    size: 16, color: Color(0xFF8491A8)),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                        OpsFixI18n.t(
                                            'Akses aman sesuai peran pengguna.'),
                                        style: TextStyle(
                                            color: Color(0xFF8491A8),
                                            fontSize: 12))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 56,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _heading(desktop: true),
                      const SizedBox(height: 26),
                      _formCard(),
                      const SizedBox(height: 14),
                      _registerLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _benefitChip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: const Color(0xFF8B7CF6)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFFD8E0EF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: ColoredBox(
          color: const Color(0xFFF3F5F2),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 480) return _mobile();
                if (constraints.maxWidth < 1200) return _tablet();
                return _desktop();
              },
            ),
          ),
        ),
      );
}
