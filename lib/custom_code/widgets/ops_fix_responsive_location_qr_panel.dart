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

import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/ops_fix_language_setting.dart';

class OpsFixResponsiveLocationQrPanel extends StatefulWidget {
  const OpsFixResponsiveLocationQrPanel({
    super.key,
    this.width,
    this.height,
    required this.siteId,
    required this.locationId,
    required this.locationName,
    required this.locationCode,
    required this.locationSlug,
    required this.qrUrl,
    required this.sitePublicUrl,
  });

  final double? width;
  final double? height;
  final String siteId;
  final String locationId;
  final String locationName;
  final String locationCode;
  final String locationSlug;
  final String qrUrl;
  final String sitePublicUrl;

  @override
  State<OpsFixResponsiveLocationQrPanel> createState() =>
      _OpsFixResponsiveLocationQrPanelState();
}

class _OpsFixResponsiveLocationQrPanelState
    extends State<OpsFixResponsiveLocationQrPanel> {
  late final TextEditingController _url;
  late String _publicUrl;
  bool _busy = false;
  bool _savedUrl = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void initState() {
    super.initState();
    _publicUrl = _normalize(widget.sitePublicUrl);
    _url = TextEditingController(text: _publicUrl);
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  String _normalize(String value) =>
      value.trim().replaceAll(RegExp(r'/+$'), '');

  bool _validUrl(String value) {
    final uri = Uri.tryParse(_normalize(value));
    return uri != null &&
        uri.scheme.toLowerCase() == 'https' &&
        uri.host.trim().isNotEmpty &&
        !uri.hasQuery &&
        !uri.hasFragment;
  }

  String get _effectiveQr {
    if (_publicUrl.isNotEmpty && widget.locationSlug.trim().isNotEmpty) {
      return '$_publicUrl/location/${widget.locationSlug.trim()}';
    }
    return widget.qrUrl.trim();
  }

  String get _locationsJson => jsonEncode([
        {
          'id': widget.locationId,
          'code': widget.locationCode,
          'name': widget.locationName,
          'slug': widget.locationSlug,
        },
      ]);

  void _setMessage(String value, {bool error = false}) {
    if (!mounted) return;
    setState(() {
      _message = value;
      _messageIsError = error;
    });
  }

  Future<void> _copy() async {
    if (_effectiveQr.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _effectiveQr));
    _setMessage(OpsFixI18n.t('Tautan lokasi disalin.'));
  }

  Future<void> _saveUrl() async {
    if (_busy) return;
    final normalized = _normalize(_url.text);
    if (!_validUrl(normalized)) {
      _setMessage(OpsFixI18n.t('Gunakan URL HTTPS yang valid.'), error: true);
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    final code = await actions.setOpsFixSitePublicUrl(
      widget.siteId,
      normalized,
    );
    if (!mounted) return;
    if (code == 'updated') {
      setState(() {
        _busy = false;
        _savedUrl = true;
        _publicUrl = normalized;
        _url.text = normalized;
        _message =
            OpsFixI18n.t('URL publik tersimpan. QR lokasi telah diperbarui.');
        _messageIsError = false;
      });
      return;
    }
    setState(() {
      _busy = false;
      _message = code == 'invalid'
          ? OpsFixI18n.t('Gunakan URL HTTPS yang valid.')
          : code == 'access_denied'
              ? OpsFixI18n.t('Akses manajer ditolak.')
              : OpsFixI18n.t('URL gagal disimpan. Periksa koneksi.');
      _messageIsError = true;
    });
  }

  String _resultMessage(String code) => switch (code) {
        'saved' => OpsFixI18n.t('File QR berhasil disimpan.'),
        'printed' => OpsFixI18n.t('Dialog cetak telah dibuka.'),
        'cancelled' => OpsFixI18n.t('Ekspor dibatalkan.'),
        'invalid_url' => OpsFixI18n.t('Gunakan URL HTTPS yang valid.'),
        'empty' => OpsFixI18n.t('Data lokasi belum tersedia.'),
        'invalid_location' => OpsFixI18n.t('Data lokasi tidak valid.'),
        'generation_failed' => OpsFixI18n.t('QR gagal dibuat. Coba lagi.'),
        _ => OpsFixI18n.t('File gagal disimpan. Coba lagi.'),
      };

  Future<void> _export(String operation) async {
    if (_busy) return;
    if (!_validUrl(_publicUrl)) {
      _setMessage(
        OpsFixI18n.t('Simpan URL publik HTTPS sebelum mengekspor QR.'),
        error: true,
      );
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    final result = await actions.exportOpsFixLocationQrs(
      '',
      '',
      _publicUrl,
      _locationsJson,
      'single_poster',
      operation,
      OpsFixI18n.languageOf(context),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    _setMessage(
      _resultMessage(result),
      error: !const {'saved', 'printed', 'cancelled'}.contains(result),
    );
  }

  Widget _exportButtons(double availableWidth) {
    final buttons = <Widget>[
      OutlinedButton.icon(
        onPressed: _busy ? null : () => _export('download_png'),
        icon: const Icon(Icons.image_outlined, size: 18),
        label: Text(OpsFixI18n.t('Unduh PNG')),
      ),
      OutlinedButton.icon(
        onPressed: _busy ? null : () => _export('download_pdf'),
        icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
        label: Text(OpsFixI18n.t('Unduh PDF')),
      ),
      FilledButton.icon(
        onPressed: _busy ? null : () => _export('print_pdf'),
        icon: const Icon(Icons.print_outlined, size: 18),
        label: Text(OpsFixI18n.t('Cetak')),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF6C5CE7),
        ),
      ),
    ];
    if (availableWidth < 520) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < buttons.length; i++) ...[
            buttons[i],
            if (i < buttons.length - 1) const SizedBox(height: 8),
          ],
        ],
      );
    }
    return Row(
      children: [
        for (var i = 0; i < buttons.length; i++) ...[
          Expanded(child: buttons[i]),
          if (i < buttons.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasQr = _effectiveQr.isNotEmpty;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 10, 14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EDFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          OpsFixI18n.t('QR lokasi'),
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          OpsFixI18n.t(
                              'Pratinjau, unduh, atau cetak QR lokasi ini.'),
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _busy
                        ? null
                        : () => Navigator.of(context).pop(_savedUrl),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (hasQr) ...[
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFDDE2E7)),
                            ),
                            child: BarcodeWidget(
                              data: _effectiveQr,
                              barcode: Barcode.qrCode(
                                errorCorrectLevel:
                                    BarcodeQRCorrectionLevel.high,
                              ),
                              width: 210,
                              height: 210,
                              drawText: false,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.locationName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          widget.locationCode,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF6C5CE7),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _effectiveQr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _copy,
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          label: Text(OpsFixI18n.t('Salin tautan')),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6C5CE7),
                            side: const BorderSide(color: Color(0xFF6C5CE7)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _exportButtons(constraints.maxWidth),
                        const SizedBox(height: 18),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFED7AA)),
                          ),
                          child: Text(
                            OpsFixI18n.t(
                                'Simpan URL publik HTTPS terlebih dahulu untuk membuat QR.'),
                            style: const TextStyle(color: Color(0xFF9A3412)),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      TextField(
                        controller: _url,
                        enabled: !_busy,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText:
                              OpsFixI18n.t('URL publik aplikasi (https://...)'),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF6C5CE7),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      if (_message != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _message!,
                          style: TextStyle(
                            color: _messageIsError
                                ? const Color(0xFFB91C1C)
                                : const Color(0xFF047857),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: _busy ? null : _saveUrl,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                        ),
                        icon: _busy
                            ? const SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          _busy
                              ? OpsFixI18n.t('Menyiapkan file…')
                              : OpsFixI18n.t('Simpan URL publik'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
