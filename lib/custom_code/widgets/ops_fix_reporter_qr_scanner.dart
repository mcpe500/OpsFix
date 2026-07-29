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
import 'package:mobile_scanner/mobile_scanner.dart';
import '/custom_code/actions/index.dart' as actions;
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

class OpsFixReporterQrScanner extends StatefulWidget {
  const OpsFixReporterQrScanner({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OpsFixReporterQrScanner> createState() =>
      _OpsFixReporterQrScannerState();
}

class _OpsFixReporterQrScannerState extends State<OpsFixReporterQrScanner> {
  late final MobileScannerController _controller;
  final TextEditingController _codeController = TextEditingController();
  bool _processing = false;
  bool _cameraUnavailable = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Shared resolution path for both a scanned QR and a typed code, so the
  /// two entry points can never drift apart.
  ///
  /// [restartCamera] is false for manual entry: the camera may be
  /// unavailable, and restarting it there would throw.
  Future<void> _resolve(String value, {required bool restartCamera}) async {
    if (value.isEmpty) return;

    setState(() {
      _processing = true;
      _message = null;
    });

    try {
      final result = await actions.resolveOpsFixLocation(value);
      if (!mounted) return;
      if (result == 'ok' && FFAppState().currentLocationId.isNotEmpty) {
        context.goNamed(
          'reportIssuePage',
          extra: _opsFixReporterFade(),
          queryParameters: {
            'locationId': serializeParam(
              FFAppState().currentLocationId,
              ParamType.String,
            ),
          }.withoutNulls,
        );
        return;
      }
      setState(() {
        _processing = false;
        _message = result == 'not_found'
            ? OpsFixI18n.t(
                'Lokasi tidak ditemukan. Periksa kembali kode atau QR OpsFix.')
            : result == 'forbidden'
                ? OpsFixI18n.t(
                    'Lokasi ini tidak termasuk dalam akses site akun Anda.')
                : result == 'ambiguous'
                    ? OpsFixI18n.t(
                        'Kode lokasi digunakan di beberapa site. Pindai QR lokasi lengkap.')
                    : result == 'unauthenticated'
                        ? OpsFixI18n.t(
                            'Sesi Anda telah berakhir. Silakan masuk kembali.')
                        : OpsFixI18n.t(
                            'Kode tidak dikenali. Gunakan kode atau QR lokasi OpsFix.');
      });
      if (restartCamera && !_cameraUnavailable) await _controller.start();
    } catch (error) {
      debugPrint('Reporter location resolve failed: $error');
      if (!mounted) return;
      setState(() {
        _processing = false;
        _message = OpsFixI18n.t(
            'Belum dapat diproses. Periksa koneksi lalu coba lagi.');
      });
      if (restartCamera && !_cameraUnavailable) await _controller.start();
    }
  }

  Future<void> _detect(BarcodeCapture capture) async {
    if (_processing || capture.barcodes.isEmpty) return;
    final value = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim() ?? '')
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    if (value.isEmpty) return;
    await _controller.stop();
    await _resolve(value, restartCamera: true);
  }

  Future<void> _submitManualCode() async {
    if (_processing) return;
    final value = _codeController.text.trim();
    if (value.isEmpty) {
      setState(() =>
          _message = OpsFixI18n.t('Masukkan kode lokasi terlebih dahulu.'));
      return;
    }
    await _resolve(value, restartCamera: false);
  }

  Future<void> _retryCamera() async {
    setState(() {
      _cameraUnavailable = false;
      _message = null;
      _processing = false;
    });
    try {
      await _controller.start();
    } catch (_) {
      if (mounted) setState(() => _cameraUnavailable = true);
    }
  }

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.goNamed('homeUserPage', extra: _opsFixReporterFade());
    }
  }

  /// Manual code entry. Always rendered, so a reporter is never blocked by a
  /// camera that is missing, denied, or unsupported (notably on desktop
  /// browsers and any non-HTTPS origin).
  Widget _manualEntry({required bool emphasised}) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emphasised
                ? OpsFixI18n.t('Masukkan kode lokasi')
                : OpsFixI18n.t('atau masukkan kode lokasi'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: emphasised ? 15 : 12,
              fontWeight: emphasised ? FontWeight.w600 : FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (_) => _submitManualCode(),
                  decoration: InputDecoration(
                    hintText: OpsFixI18n.t('Contoh: LAB-A'),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFDDE2E7)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFDDE2E7)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _processing ? null : _submitManualCode,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                child: Text(OpsFixI18n.t('Buka')),
              ),
            ],
          ),
        ],
      );

  Widget _cameraFallback() => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFDDE2E7)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_outlined,
                  size: 52, color: Color(0xFF6C5CE7)),
              const SizedBox(height: 16),
              Text(
                OpsFixI18n.t('Kamera tidak dapat digunakan'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                OpsFixI18n.t(OpsFixI18n.t(
                    'Masukkan kode lokasi secara manual di bawah ini, atau izinkan akses kamera dan buka aplikasi melalui HTTPS lalu coba lagi.')),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, height: 1.45, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              _manualEntry(emphasised: true),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _retryCamera,
                  icon: const Icon(Icons.refresh),
                  label: Text(OpsFixI18n.t('Coba kamera lagi')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6C5CE7),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              TextButton(
                  onPressed: _back, child: Text(OpsFixI18n.t('Kembali'))),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: ColoredBox(
          color: const Color(0xFFF3F5F2),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _back,
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF111827)),
                      ),
                      Expanded(
                        child: Text(
                          OpsFixI18n.t('Scan QR lokasi'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      const OpsFixReporterHeaderActions(),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          OpsFixI18n.t(
                              'Arahkan kamera ke QR yang tersedia di lokasi fasilitas.'),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: _cameraUnavailable
                              ? _cameraFallback()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      MobileScanner(
                                        controller: _controller,
                                        fit: BoxFit.cover,
                                        onDetect: _detect,
                                        errorBuilder: (context, error) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (mounted &&
                                                !_cameraUnavailable) {
                                              setState(() =>
                                                  _cameraUnavailable = true);
                                            }
                                          });
                                          return const ColoredBox(
                                              color: Color(0xFF0B1426));
                                        },
                                      ),
                                      Center(
                                        child: Container(
                                          width: 238,
                                          height: 238,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_processing)
                                        const ColoredBox(
                                          color: Color(0x66000000),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                        if (!_cameraUnavailable) ...[
                          const SizedBox(height: 14),
                          _manualEntry(emphasised: false),
                        ],
                        const SizedBox(height: 14),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _message == null
                              ? Text(
                                  OpsFixI18n.t(
                                      'QR hanya digunakan untuk memilih lokasi laporan.'),
                                  key: ValueKey('hint'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF64748B)),
                                )
                              : Text(
                                  _message!,
                                  key: const ValueKey('message'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
