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
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';

class OpsFixResponsiveRegister extends StatefulWidget {
  const OpsFixResponsiveRegister({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixResponsiveRegister> createState() =>
      _OpsFixResponsiveRegisterState();
}

class _OpsFixResponsiveRegisterState extends State<OpsFixResponsiveRegister> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _passwordVisible = false;
  bool _confirmVisible = false;
  bool _acceptedTerms = false;
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  String _resultMessage(String result) => switch (result) {
        'invalid_name' => 'Nama harus terdiri dari 2 sampai 100 karakter.',
        'invalid_email' => 'Masukkan alamat email yang valid.',
        'weak_password' => 'Gunakan password dengan minimal 8 karakter.',
        'email_exists' =>
          'Email tersebut sudah terdaftar. Silakan masuk atau reset password.',
        'email_not_authorized' =>
          'Email tersebut belum dapat menerima email dari OpsFix. Hubungi administrator.',
        'email_provider_disabled' =>
          'Pendaftaran menggunakan email dan password sedang dinonaktifkan.',
        'email_rate_limited' =>
          'Batas pengiriman email tercapai. Tunggu beberapa saat lalu coba lagi.',
        'request_rate_limited' =>
          'Terlalu banyak percobaan pendaftaran. Tunggu beberapa menit lalu coba lagi.',
        'signup_disabled' => 'Pendaftaran akun sedang tidak tersedia.',
        'database_error' =>
          'Akun belum dapat disiapkan. Hubungi administrator OpsFix.',
        'network_error' =>
          'Tidak dapat terhubung ke server. Periksa koneksi lalu coba lagi.',
        _ => 'Pendaftaran gagal. Periksa data Anda lalu coba lagi.',
      };

  Future<void> _submit() async {
    if (_submitting) return;
    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    if (name.length < 2) {
      _message('Masukkan nama lengkap Anda.');
      _nameFocus.requestFocus();
      return;
    }
    if (!email.contains('@')) {
      _message('Masukkan alamat email yang valid.');
      _emailFocus.requestFocus();
      return;
    }
    if (password.length < 8) {
      _message('Password minimal terdiri dari 8 karakter.');
      _passwordFocus.requestFocus();
      return;
    }
    if (password != _confirm.text) {
      _message('Konfirmasi password tidak cocok.');
      _confirmFocus.requestFocus();
      return;
    }
    if (!_acceptedTerms) {
      _message(
          'Setujui Kebijakan Privasi dan Ketentuan Penggunaan untuk melanjutkan.');
      return;
    }
    setState(() => _submitting = true);
    final result = await actions.registerOpsFixReporter(name, email, password);
    if (!mounted) return;
    if (result == 'success') {
      _message('Akun berhasil dibuat. Silakan masuk.');
      context.goNamed('LoginPage');
      return;
    }
    setState(() => _submitting = false);
    _message(_resultMessage(result));
  }

  InputDecoration _decoration(String label, {Widget? suffix}) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF667085), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF7F7F8),
        suffixIcon: suffix,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  Widget _logo() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Color(0xFF6C5CE7), shape: BoxShape.circle),
            child: const Text('O',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 8),
          const Text('OpsFix',
              style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 22,
                  fontWeight: FontWeight.w600)),
        ],
      );

  Widget _heading({bool desktop = false}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Buat akun baru',
              style: TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 7),
          Text('Daftar untuk melaporkan fasilitas.',
              style: TextStyle(
                  color: const Color(0xFF111827),
                  fontSize: desktop ? 29 : 23,
                  height: 1.2,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          const Text(
              'Isi data dasar. Akses portal mengikuti peran dan lokasi organisasi.',
              style: TextStyle(
                  color: Color(0xFF667085), fontSize: 14, height: 1.4)),
        ],
      );

  Widget _form() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            focusNode: _nameFocus,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            onSubmitted: (_) => _emailFocus.requestFocus(),
            decoration: _decoration('Nama lengkap'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            onSubmitted: (_) => _passwordFocus.requestFocus(),
            decoration: _decoration('Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            focusNode: _passwordFocus,
            obscureText: !_passwordVisible,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            onSubmitted: (_) => _confirmFocus.requestFocus(),
            decoration: _decoration('Password',
                suffix: IconButton(
                  tooltip: _passwordVisible
                      ? 'Sembunyikan password'
                      : 'Tampilkan password',
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                  icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF98A2B3)),
                )),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirm,
            focusNode: _confirmFocus,
            obscureText: !_confirmVisible,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            onSubmitted: (_) => _submit(),
            decoration: _decoration('Konfirmasi password',
                suffix: IconButton(
                  tooltip: _confirmVisible
                      ? 'Sembunyikan password'
                      : 'Tampilkan password',
                  onPressed: () =>
                      setState(() => _confirmVisible = !_confirmVisible),
                  icon: Icon(
                      _confirmVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF98A2B3)),
                )),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
                color: const Color(0xFFF3F5F2),
                borderRadius: BorderRadius.circular(12)),
            child: const Text(
                'Minimal 8 karakter · satu huruf kapital · satu angka · konfirmasi cocok',
                style: TextStyle(
                    color: Color(0xFF52637D), fontSize: 11, height: 1.35)),
          ),
        ],
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
        child: _form(),
      );

  Widget _actions() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(
                        _acceptedTerms
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 22,
                        color: _acceptedTerms
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFF98A2B3)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                      child: Text(
                          'Saya menyetujui Kebijakan Privasi dan Ketentuan Penggunaan.',
                          style: TextStyle(
                              color: Color(0xFF344054),
                              fontSize: 13,
                              height: 1.4))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Buat akun',
                      style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sudah punya akun?',
                  style: TextStyle(color: Color(0xFF667085), fontSize: 12)),
              TextButton(
                onPressed: () => context.goNamed('LoginPage'),
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 5)),
                child: const Text('Masuk di sini',
                    style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 12)),
              ),
            ],
          ),
        ],
      );

  Widget _registerContent(
          {required double maxWidth,
          bool showLogo = true,
          bool desktop = false}) =>
      Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showLogo) ...[_logo(), const SizedBox(height: 24)],
              _heading(desktop: desktop),
              const SizedBox(height: 20),
              _formCard(),
              const SizedBox(height: 16),
              _actions(),
            ],
          ),
        ),
      );

  Widget _benefit(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 17, color: const Color(0xFF8B7CF6)),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFFD8E0EF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ]),
      );

  Widget _brandPanel() => Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF081225), Color(0xFF15213C)])),
        child: Stack(children: [
          Positioned(
              top: -120,
              right: -110,
              child: Container(
                  width: 330,
                  height: 330,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x126C5CE7)))),
          Positioned(
              bottom: -150,
              left: -120,
              child: Container(
                  width: 360,
                  height: 360,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x0D35D0BA)))),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 470),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(children: [
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
                                      spreadRadius: 3)
                                ]),
                            child: const Text('O',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700))),
                        const SizedBox(width: 16),
                        const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('OpsFix',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(height: 2),
                              Text('Facility care, made traceable.',
                                  style: TextStyle(
                                      color: Color(0xFFAAB6CC), fontSize: 12))
                            ]),
                      ]),
                      const SizedBox(height: 64),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                              color: const Color(0x1A35D0BA),
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: const Color(0x3335D0BA))),
                          child: const Text('PORTAL OPERASIONAL FASILITAS',
                              style: TextStyle(
                                  color: Color(0xFF70E1CB),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7))),
                      const SizedBox(height: 20),
                      const Text('Fasilitas terjaga.\nPekerjaan terlacak.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              height: 1.12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.8)),
                      const SizedBox(height: 18),
                      const Text(
                          'Satu ruang kerja untuk melaporkan gangguan, mengatur penugasan, dan memastikan setiap perbaikan selesai dengan bukti.',
                          style: TextStyle(
                              color: Color(0xFFC5CEE0),
                              fontSize: 16,
                              height: 1.55)),
                      const SizedBox(height: 30),
                      Wrap(spacing: 10, runSpacing: 10, children: [
                        _benefit(
                            Icons.qr_code_scanner, 'Laporan berbasis lokasi'),
                        _benefit(
                            Icons.track_changes_outlined, 'Status real-time'),
                        _benefit(
                            Icons.verified_user_outlined, 'Aktivitas tercatat')
                      ]),
                      const SizedBox(height: 46),
                      const Row(children: [
                        Icon(Icons.lock_outline,
                            size: 16, color: Color(0xFF8491A8)),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text('Akses aman sesuai peran pengguna.',
                                style: TextStyle(
                                    color: Color(0xFF8491A8), fontSize: 12)))
                      ]),
                    ]),
              ),
            ),
          ),
        ]),
      );

  Widget _mobile() => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _registerContent(maxWidth: 560),
      );

  Widget _tablet() => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 44),
        child: _registerContent(maxWidth: 600),
      );

  Widget _desktop() => Row(children: [
        Expanded(flex: 44, child: _brandPanel()),
        Expanded(
          flex: 56,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 36),
            child:
                _registerContent(maxWidth: 520, showLogo: false, desktop: true),
          ),
        ),
      ]);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: ColoredBox(
          color: const Color(0xFFF3F5F2),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth < 480) return _mobile();
              if (constraints.maxWidth < 1200) return _tablet();
              return _desktop();
            }),
          ),
        ),
      );
}
