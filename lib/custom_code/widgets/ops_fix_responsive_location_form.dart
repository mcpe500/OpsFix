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

class OpsFixResponsiveLocationForm extends StatefulWidget {
  const OpsFixResponsiveLocationForm({
    super.key,
    this.width,
    this.height,
    required this.mode,
    required this.siteId,
    this.locationId = '',
    this.code = '',
    this.locationName = '',
    this.locationType = 'room',
    this.building = '',
    this.floor = '',
    this.zoneCode = '',
    this.description = '',
    this.slug = '',
  });

  final double? width;
  final double? height;
  final String mode;
  final String siteId;
  final String locationId;
  final String code;
  final String locationName;
  final String locationType;
  final String building;
  final String floor;
  final String zoneCode;
  final String description;
  final String slug;

  @override
  State<OpsFixResponsiveLocationForm> createState() =>
      _OpsFixResponsiveLocationFormState();
}

class _OpsFixResponsiveLocationFormState
    extends State<OpsFixResponsiveLocationForm> {
  late final TextEditingController _code;
  late final TextEditingController _name;
  late final TextEditingController _building;
  late final TextEditingController _floor;
  late final TextEditingController _zone;
  late final TextEditingController _description;
  late String _locationType;
  late String _slug;
  bool _loadingRecord = false;
  bool _busy = false;
  String? _message;

  bool get _isEdit => widget.mode == 'edit';
  bool get _enabled => !_busy && !_loadingRecord;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.code);
    _name = TextEditingController(text: widget.locationName);
    _building = TextEditingController(text: widget.building);
    _floor = TextEditingController(text: widget.floor);
    _zone = TextEditingController(text: widget.zoneCode);
    _description = TextEditingController(text: widget.description);
    _locationType = _validType(widget.locationType);
    _slug = widget.slug;
    if (_isEdit) {
      _loadCurrentLocation();
    }
  }

  String _validType(String value) => const {
        'room',
        'corridor',
        'toilet',
        'parking',
        'outdoor',
        'other',
      }.contains(value)
          ? value
          : 'room';

  Future<void> _loadCurrentLocation() async {
    if (widget.locationId.trim().isEmpty || widget.siteId.trim().isEmpty) {
      setState(() => _message = 'Lokasi tidak dapat dimuat.');
      return;
    }
    setState(() => _loadingRecord = true);
    try {
      final row = await SupaFlow.client
          .from('locations')
          .select(
            'id,site_id,code,name,slug,location_type,building,floor,'
            'zone_code,description,is_active',
          )
          .eq('id', widget.locationId)
          .eq('site_id', widget.siteId)
          .eq('is_active', true)
          .maybeSingle();
      if (!mounted) return;
      if (row == null) {
        setState(() {
          _loadingRecord = false;
          _message = 'Lokasi tidak ditemukan atau tidak dapat diakses.';
        });
        return;
      }
      _code.text = row['code']?.toString() ?? '';
      _name.text = row['name']?.toString() ?? '';
      _building.text = row['building']?.toString() ?? '';
      _floor.text = row['floor']?.toString() ?? '';
      _zone.text = row['zone_code']?.toString() ?? '';
      _description.text = row['description']?.toString() ?? '';
      setState(() {
        _locationType = _validType(
          row['location_type']?.toString() ?? 'room',
        );
        _slug = row['slug']?.toString() ?? widget.slug;
        _loadingRecord = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingRecord = false;
        _message = 'Data lokasi gagal dimuat. Coba lagi.';
      });
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _building.dispose();
    _floor.dispose();
    _zone.dispose();
    _description.dispose();
    super.dispose();
  }

  String get _slugPreview => _code.text
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');

  String _messageFor(String code) => switch (code) {
        'duplicate_code' => 'Kode sudah digunakan pada situs ini.',
        'duplicate_slug' => 'Slug QR sudah digunakan. Gunakan kode lain.',
        'access_denied' => 'Anda tidak memiliki akses manajer untuk data ini.',
        'invalid' => 'Periksa kembali nilai formulir.',
        'network_error' =>
          'Koneksi gagal. Form tetap terbuka untuk dicoba lagi.',
        _ => 'Operasi tidak dapat diselesaikan.',
      };

  Future<void> _save() async {
    if (!_enabled) return;
    final code = _code.text.trim();
    final name = _name.text.trim();
    if (widget.siteId.trim().isEmpty ||
        code.isEmpty ||
        name.length < 2 ||
        (_isEdit && widget.locationId.trim().isEmpty)) {
      setState(() => _message = _messageFor('invalid'));
      return;
    }

    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final params = <String, dynamic>{
        'p_code': code,
        'p_name': name,
        'p_location_type': _locationType,
        'p_building': _building.text.trim(),
        'p_floor': _floor.text.trim(),
        'p_zone_code': _zone.text.trim(),
        'p_description': _description.text.trim(),
      };
      dynamic response;
      if (_isEdit) {
        params['p_location_id'] = widget.locationId;
        response = await SupaFlow.client.rpc(
          'update_opsfix_location',
          params: params,
        );
      } else {
        params['p_site_id'] = widget.siteId;
        response = await SupaFlow.client.rpc(
          'create_opsfix_location',
          params: params,
        );
      }

      final result = Map<String, dynamic>.from(response as Map);
      final resultCode = result['code']?.toString() ?? 'network_error';
      if (result['ok'] != true) {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _message = _messageFor(resultCode);
        });
        return;
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = _messageFor('network_error');
      });
    }
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B)),
        filled: true,
        fillColor: _enabled ? Colors.white : const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE3EC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE3EC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 1.5),
        ),
      );

  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) =>
      TextField(
        controller: controller,
        enabled: _enabled,
        maxLines: maxLines,
        textInputAction:
            maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
        decoration: _decoration(label),
        onChanged: label == 'Kode lokasi' ? (_) => setState(() {}) : null,
      );

  Widget _typeField() => DropdownButtonFormField<String>(
        value: _locationType,
        isExpanded: true,
        decoration: _decoration('Tipe lokasi'),
        items: const {
          'room': 'Ruangan',
          'corridor': 'Koridor',
          'toilet': 'Toilet',
          'parking': 'Parkir',
          'outdoor': 'Luar ruang',
          'other': 'Lainnya',
        }
            .entries
            .map(
              (entry) => DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        onChanged: _enabled
            ? (value) => setState(
                  () => _locationType = value ?? 'room',
                )
            : null,
      );

  Widget _fieldRow(
    bool wide,
    Widget first,
    Widget second,
  ) {
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [first, const SizedBox(height: 14), second],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: 14),
        Expanded(child: second),
      ],
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 600;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    wide ? 26 : 18,
                    wide ? 22 : 16,
                    wide ? 18 : 10,
                    14,
                  ),
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
                          Icons.location_on_outlined,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEdit ? 'Edit lokasi' : 'Tambah lokasi',
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isEdit
                                  ? 'Perbarui informasi lokasi operasional.'
                                  : 'Daftarkan lokasi operasional baru.',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tutup',
                        onPressed: _busy
                            ? null
                            : () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                if (_loadingRecord)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    color: Color(0xFF6C5CE7),
                  )
                else
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(wide ? 26 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _fieldRow(
                          wide,
                          _textField(_code, 'Kode lokasi'),
                          _typeField(),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.qr_code_2_rounded,
                                size: 18,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _isEdit
                                      ? 'Slug QR tetap: '
                                          '${_slug.isEmpty ? '-' : _slug}'
                                      : 'Slug QR: '
                                          '${_slugPreview.isEmpty ? '-' : _slugPreview}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _textField(_name, 'Nama lokasi'),
                        const SizedBox(height: 14),
                        _fieldRow(
                          wide,
                          _textField(_building, 'Gedung'),
                          _textField(_floor, 'Lantai'),
                        ),
                        const SizedBox(height: 14),
                        _textField(
                          _zone,
                          'Zona (kosong = kode lokasi)',
                        ),
                        const SizedBox(height: 14),
                        _textField(
                          _description,
                          'Deskripsi',
                          maxLines: 4,
                        ),
                        if (_message != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFFECACA),
                              ),
                            ),
                            child: Text(
                              _message!,
                              style: const TextStyle(
                                color: Color(0xFFB91C1C),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    wide ? 26 : 18,
                    14,
                    wide ? 26 : 18,
                    16,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: wide ? 190 : double.infinity,
                      height: 46,
                      child: FilledButton.icon(
                        onPressed: _enabled ? _save : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                            : const Icon(Icons.save_outlined, size: 19),
                        label: Text(
                          _busy ? 'Menyimpan…' : 'Simpan lokasi',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
