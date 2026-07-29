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
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/ops_fix_language_setting.dart';

class OpsFixBulkQrExportPanel extends StatefulWidget {
  const OpsFixBulkQrExportPanel({
    super.key,
    this.width,
    this.height,
    required this.siteId,
    required this.locationsJson,
  });

  final double? width;
  final double? height;
  final String siteId;
  final String locationsJson;

  @override
  State<OpsFixBulkQrExportPanel> createState() =>
      _OpsFixBulkQrExportPanelState();
}

class _OpsFixBulkQrExportPanelState extends State<OpsFixBulkQrExportPanel> {
  late final TextEditingController _url;
  String _siteName = '';
  String _siteCode = '';
  String _layout = 'sheet_2x3';
  bool _loading = true;
  bool _busy = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void initState() {
    super.initState();
    _url = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSite());
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

  Future<void> _loadSite() async {
    try {
      final row = await SupaFlow.client
          .from('sites')
          .select('name,code,public_app_url')
          .eq('id', widget.siteId)
          .eq('is_active', true)
          .maybeSingle();
      if (!mounted) return;
      if (row == null) {
        setState(() {
          _loading = false;
          _message = OpsFixI18n.t('Situs aktif tidak dapat diakses.');
          _messageIsError = true;
        });
        return;
      }
      setState(() {
        _siteName = row['name']?.toString().trim() ?? '';
        _siteCode = row['code']?.toString().trim() ?? '';
        _url.text = _normalize(row['public_app_url']?.toString() ?? '');
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _message =
            OpsFixI18n.t('Konfigurasi QR gagal dimuat. Periksa koneksi.');
        _messageIsError = true;
      });
    }
  }

  void _setMessage(String message, {bool error = false}) {
    if (!mounted) return;
    setState(() {
      _message = message;
      _messageIsError = error;
    });
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
    final result =
        await actions.setOpsFixSitePublicUrl(widget.siteId, normalized);
    if (!mounted) return;
    setState(() => _busy = false);
    if (result == 'updated') {
      _url.text = normalized;
      _setMessage(OpsFixI18n.t('URL publik berhasil disimpan.'));
    } else {
      _setMessage(
        result == 'access_denied'
            ? OpsFixI18n.t('Akses manajer ditolak.')
            : result == 'invalid'
                ? OpsFixI18n.t('Gunakan URL HTTPS yang valid.')
                : OpsFixI18n.t('URL gagal disimpan. Periksa koneksi.'),
        error: true,
      );
    }
  }

  String _resultMessage(String code) => switch (code) {
        'saved' => OpsFixI18n.t('File QR berhasil disimpan.'),
        'printed' => OpsFixI18n.t('Dialog cetak telah dibuka.'),
        'cancelled' => OpsFixI18n.t('Ekspor dibatalkan.'),
        'invalid_url' => OpsFixI18n.t('Gunakan URL HTTPS yang valid.'),
        'empty' => OpsFixI18n.t('Data lokasi belum tersedia.'),
        'invalid_location' => OpsFixI18n.t(
            'Satu atau beberapa lokasi tidak memiliki kode QR yang valid.'),
        'generation_failed' => OpsFixI18n.t('QR gagal dibuat. Coba lagi.'),
        _ => OpsFixI18n.t('File gagal disimpan. Coba lagi.'),
      };

  Future<void> _export(String operation) async {
    if (_busy || _loading) return;
    final normalized = _normalize(_url.text);
    if (!_validUrl(normalized)) {
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
      _siteName,
      _siteCode,
      normalized,
      widget.locationsJson,
      _layout,
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

  Widget _layoutOption({
    required String value,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final selected = _layout == value;
    return InkWell(
      onTap: _busy ? null : () => setState(() => _layout = value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0EDFF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF6C5CE7) : const Color(0xFFDDE2E7),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected
                      ? const Color(0xFF6C5CE7)
                      : const Color(0xFF64748B),
                ),
                const Spacer(),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 20,
                  color: selected
                      ? const Color(0xFF6C5CE7)
                      : const Color(0xFF94A3B8),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      Icons.download_for_offline_outlined,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          OpsFixI18n.t('Unduh semua QR'),
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          OpsFixI18n.t(
                              'Siapkan QR lokasi aktif untuk dicetak.'),
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
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
                      if (_loading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(28),
                            child: CircularProgressIndicator(
                              color: Color(0xFF6C5CE7),
                            ),
                          ),
                        )
                      else ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFDDE2E7)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFF6C5CE7),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _siteName.isEmpty
                                      ? OpsFixI18n.t('Situs aktif')
                                      : _siteName,
                                  style: const TextStyle(
                                    color: Color(0xFF111827),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          OpsFixI18n.t('Pilih tata letak cetak'),
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (constraints.maxWidth < 520)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _layoutOption(
                                value: 'sheet_2x3',
                                icon: Icons.grid_view_outlined,
                                title: OpsFixI18n.t('6 kartu per lembar'),
                                description: OpsFixI18n.t(
                                    'Hemat kertas dan mudah dipotong.'),
                              ),
                              const SizedBox(height: 10),
                              _layoutOption(
                                value: 'poster_pages',
                                icon: Icons.article_outlined,
                                title: OpsFixI18n.t('1 poster per halaman'),
                                description: OpsFixI18n.t(
                                    'Siap ditempel dengan QR berukuran besar.'),
                              ),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _layoutOption(
                                  value: 'sheet_2x3',
                                  icon: Icons.grid_view_outlined,
                                  title: OpsFixI18n.t('6 kartu per lembar'),
                                  description: OpsFixI18n.t(
                                      'Hemat kertas dan mudah dipotong.'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _layoutOption(
                                  value: 'poster_pages',
                                  icon: Icons.article_outlined,
                                  title: OpsFixI18n.t('1 poster per halaman'),
                                  description: OpsFixI18n.t(
                                      'Siap ditempel dengan QR berukuran besar.'),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _url,
                          enabled: !_busy,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: OpsFixI18n.t(
                                'URL publik aplikasi (https://...)'),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              tooltip: OpsFixI18n.t('Simpan URL publik'),
                              onPressed: _busy ? null : _saveUrl,
                              icon: const Icon(Icons.save_outlined),
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
                        const SizedBox(height: 18),
                        if (constraints.maxWidth < 420)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              OutlinedButton.icon(
                                onPressed:
                                    _busy ? null : () => _export('print_pdf'),
                                icon: const Icon(Icons.print_outlined),
                                label: Text(OpsFixI18n.t('Cetak')),
                              ),
                              const SizedBox(height: 8),
                              FilledButton.icon(
                                onPressed: _busy
                                    ? null
                                    : () => _export('download_pdf'),
                                icon: _busy
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.download_rounded,
                                      ),
                                label: Text(OpsFixI18n.t('Unduh PDF')),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF6C5CE7),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed:
                                      _busy ? null : () => _export('print_pdf'),
                                  icon: const Icon(Icons.print_outlined),
                                  label: Text(OpsFixI18n.t('Cetak')),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: _busy
                                      ? null
                                      : () => _export('download_pdf'),
                                  icon: _busy
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.download_rounded),
                                  label: Text(OpsFixI18n.t('Unduh PDF')),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C5CE7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
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
