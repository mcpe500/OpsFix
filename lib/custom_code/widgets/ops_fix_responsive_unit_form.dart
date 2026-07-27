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

class OpsFixResponsiveUnitForm extends StatefulWidget {
  const OpsFixResponsiveUnitForm({
    super.key,
    this.width,
    this.height,
    required this.mode,
    required this.siteId,
    required this.locationId,
    this.unitId = '',
    this.unitCode = '',
    this.codeSort = 0,
    this.recordName = '',
    this.categoryCode = '',
    this.positionLabel = '',
    this.componentOptions = '',
    this.criticality = 'medium',
    this.condition = 'operational',
  });

  final double? width;
  final double? height;
  final String mode;
  final String siteId;
  final String locationId;
  final String unitId;
  final String unitCode;
  final int codeSort;
  final String recordName;
  final String categoryCode;
  final String positionLabel;
  final String componentOptions;
  final String criticality;
  final String condition;

  @override
  State<OpsFixResponsiveUnitForm> createState() =>
      _OpsFixResponsiveUnitFormState();
}

class _OpsFixResponsiveUnitFormState extends State<OpsFixResponsiveUnitForm> {
  late final TextEditingController _code;
  late final TextEditingController _sort;
  late final TextEditingController _name;
  late final TextEditingController _category;
  late final TextEditingController _position;
  late final TextEditingController _components;
  late String _criticality;
  late String _condition;
  bool _loadingRecord = false;
  bool _busy = false;
  String? _message;

  bool get _isEdit => widget.mode == 'edit';
  bool get _enabled => !_busy && !_loadingRecord;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.unitCode);
    _sort = TextEditingController(text: widget.codeSort.toString());
    _name = TextEditingController(text: widget.recordName);
    _category = TextEditingController(text: widget.categoryCode);
    _position = TextEditingController(text: widget.positionLabel);
    _components = TextEditingController(text: widget.componentOptions);
    _criticality = _validCriticality(widget.criticality);
    _condition = _validCondition(widget.condition);
    if (_isEdit) _loadUnit();
  }

  String _validCriticality(String value) =>
      const {'low', 'medium', 'high'}.contains(value) ? value : 'medium';

  String _validCondition(String value) => const {
        'operational',
        'needs_attention',
        'out_of_service',
        'retired',
      }.contains(value)
          ? value
          : 'operational';

  Future<void> _loadUnit() async {
    if (widget.siteId.trim().isEmpty ||
        widget.locationId.trim().isEmpty ||
        widget.unitId.trim().isEmpty) {
      setState(() => _message = 'Aset tidak dapat dimuat.');
      return;
    }
    setState(() => _loadingRecord = true);
    try {
      final row = await SupaFlow.client
          .from('maintenance_units')
          .select(
            'id,site_id,location_id,unit_code,code_sort,name,category_code,'
            'position_label,component_options,criticality,condition,is_active',
          )
          .eq('id', widget.unitId)
          .eq('site_id', widget.siteId)
          .eq('location_id', widget.locationId)
          .eq('is_active', true)
          .maybeSingle();
      if (!mounted) return;
      if (row == null) {
        setState(() {
          _loadingRecord = false;
          _message = 'Aset tidak ditemukan atau tidak dapat diakses.';
        });
        return;
      }
      _code.text = row['unit_code']?.toString() ?? '';
      _sort.text = (row['code_sort'] as num?)?.toInt().toString() ?? '0';
      _name.text = row['name']?.toString() ?? '';
      _category.text = row['category_code']?.toString() ?? '';
      _position.text = row['position_label']?.toString() ?? '';
      _components.text = (row['component_options'] as List?)
              ?.map((value) => value.toString())
              .join(', ') ??
          '';
      setState(() {
        _criticality =
            _validCriticality(row['criticality']?.toString() ?? 'medium');
        _condition =
            _validCondition(row['condition']?.toString() ?? 'operational');
        _loadingRecord = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingRecord = false;
        _message = 'Data aset gagal dimuat. Coba lagi.';
      });
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _sort.dispose();
    _name.dispose();
    _category.dispose();
    _position.dispose();
    _components.dispose();
    super.dispose();
  }

  String _messageFor(String code) => switch (code) {
        'duplicate_code' => 'Kode unit sudah digunakan pada lokasi ini.',
        'access_denied' => 'Anda tidak memiliki akses manajer untuk aset ini.',
        'invalid' => 'Periksa kembali nilai formulir.',
        'network_error' =>
          'Koneksi gagal. Form tetap terbuka untuk dicoba lagi.',
        _ => 'Operasi tidak dapat diselesaikan.',
      };

  Future<void> _save() async {
    if (!_enabled) return;
    final sort = int.tryParse(_sort.text.trim());
    if (widget.siteId.trim().isEmpty ||
        widget.locationId.trim().isEmpty ||
        (_isEdit && widget.unitId.trim().isEmpty) ||
        _code.text.trim().isEmpty ||
        _name.text.trim().isEmpty ||
        _category.text.trim().isEmpty ||
        sort == null ||
        sort < 0) {
      setState(() => _message = _messageFor('invalid'));
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final params = <String, dynamic>{
        'p_unit_code': _code.text.trim(),
        'p_code_sort': sort,
        'p_name': _name.text.trim(),
        'p_category_code': _category.text.trim(),
        'p_position_label': _position.text.trim(),
        'p_component_options': _components.text
            .split(',')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList(),
        'p_criticality': _criticality,
        'p_condition': _condition,
      };
      dynamic response;
      if (_isEdit) {
        params['p_unit_id'] = widget.unitId;
        response =
            await SupaFlow.client.rpc('update_opsfix_unit', params: params);
      } else {
        params['p_location_id'] = widget.locationId;
        response =
            await SupaFlow.client.rpc('create_opsfix_unit', params: params);
      }
      final result = Map<String, dynamic>.from(response as Map);
      final code = result['code']?.toString() ?? 'network_error';
      if (result['ok'] != true) {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _message = _messageFor(code);
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
          borderSide: const BorderSide(color: Color(0xFFDDE2E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE2E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 1.5),
        ),
      );

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) =>
      TextField(
        controller: controller,
        enabled: _enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: _decoration(label),
      );

  Widget _row(bool wide, Widget first, Widget second) {
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

  Widget _dropdown({
    required String value,
    required String label,
    required Map<String, String> options,
    required ValueChanged<String> onChanged,
  }) =>
      DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: _decoration(label),
        items: options.entries
            .map(
              (entry) => DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        onChanged: _enabled
            ? (next) {
                if (next != null) onChanged(next);
              }
            : null,
      );

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
                          Icons.inventory_2_outlined,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEdit ? 'Edit aset' : 'Tambah unit/aset',
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isEdit
                                  ? 'Perbarui informasi aset pada lokasi ini.'
                                  : 'Daftarkan unit baru pada lokasi ini.',
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
                        _row(
                          wide,
                          _field(_code, 'Kode unit/aset'),
                          _field(
                            _sort,
                            'Urutan',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _field(_name, 'Nama unit/aset'),
                        const SizedBox(height: 14),
                        _row(
                          wide,
                          _field(_category, 'Kategori'),
                          _field(_position, 'Posisi'),
                        ),
                        const SizedBox(height: 14),
                        _row(
                          wide,
                          _dropdown(
                            value: _criticality,
                            label: 'Kritikalitas',
                            options: const {
                              'low': 'Rendah',
                              'medium': 'Sedang',
                              'high': 'Tinggi',
                            },
                            onChanged: (value) =>
                                setState(() => _criticality = value),
                          ),
                          _dropdown(
                            value: _condition,
                            label: 'Kondisi',
                            options: const {
                              'operational': 'Operasional',
                              'needs_attention': 'Perlu perhatian',
                              'out_of_service': 'Tidak beroperasi',
                              'retired': 'Dipensiunkan',
                            },
                            onChanged: (value) =>
                                setState(() => _condition = value),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _field(
                          _components,
                          'Komponen (pisahkan dengan koma)',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFDDE2E7)),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.qr_code_2_rounded,
                                color: Color(0xFF64748B),
                                size: 19,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'QR tersedia pada lokasi induk, bukan per unit.',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_message != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFFECACA)),
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
                          _busy ? 'Menyimpan…' : 'Simpan aset',
                          style: const TextStyle(fontWeight: FontWeight.w700),
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
