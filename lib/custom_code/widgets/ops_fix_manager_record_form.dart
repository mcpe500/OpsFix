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
import '/backend/supabase/supabase.dart';

class OpsFixManagerRecordForm extends StatefulWidget {
  const OpsFixManagerRecordForm({
    super.key,
    this.width,
    this.height,
    required this.formKind,
    required this.mode,
    required this.siteId,
    required this.recordId,
    required this.recordIndex,
    required this.locationId,
    required this.code,
    required this.recordName,
    required this.locationType,
    required this.building,
    required this.floor,
    required this.zoneCode,
    required this.description,
    required this.slug,
    required this.codeSort,
    required this.categoryCode,
    required this.positionLabel,
    this.componentOptions = '',
    required this.criticality,
    required this.condition,
    required this.refreshTarget,
    required this.refreshLocationId,
    required this.refreshUnitId,
    required this.refreshAssetCode,
  });

  final double? width;
  final double? height;
  final String? formKind;
  final String? mode;
  final String? siteId;
  final String? recordId;
  final int? recordIndex;
  final String? locationId;
  final String? code;
  final String? recordName;
  final String? locationType;
  final String? building;
  final String? floor;
  final String? zoneCode;
  final String? description;
  final String? slug;
  final int? codeSort;
  final String? categoryCode;
  final String? positionLabel;
  final String? componentOptions;
  final String? criticality;
  final String? condition;
  final String? refreshTarget;
  final String? refreshLocationId;
  final String? refreshUnitId;
  final String? refreshAssetCode;

  @override
  State<OpsFixManagerRecordForm> createState() =>
      _OpsFixManagerRecordFormState();
}

class _OpsFixManagerRecordFormState extends State<OpsFixManagerRecordForm> {
  late final TextEditingController _code;
  late final TextEditingController _name;
  late final TextEditingController _building;
  late final TextEditingController _floor;
  late final TextEditingController _zone;
  late final TextEditingController _description;
  late final TextEditingController _sort;
  late final TextEditingController _category;
  late final TextEditingController _position;
  late final TextEditingController _components;
  late final TextEditingController _note;
  late final TextEditingController _performedAt;
  late String _locationType;
  late String _criticality;
  late String _condition;
  String _noteType = 'inspection';
  bool _busy = false;
  String? _message;
  late String _resolvedRecordId;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.code);
    _name = TextEditingController(text: widget.recordName);
    _building = TextEditingController(text: widget.building);
    _floor = TextEditingController(text: widget.floor);
    _zone = TextEditingController(text: widget.zoneCode);
    _description = TextEditingController(text: widget.description);
    _sort = TextEditingController(text: (widget.codeSort ?? 0).toString());
    _category = TextEditingController(text: widget.categoryCode);
    _position = TextEditingController(text: widget.positionLabel);
    _components = TextEditingController(text: widget.componentOptions ?? '');
    _note = TextEditingController();
    final now = DateTime.now();
    _performedAt = TextEditingController(
      text: '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}',
    );
    _locationType = const {
      'room',
      'corridor',
      'toilet',
      'parking',
      'outdoor',
      'other'
    }.contains(widget.locationType)
        ? widget.locationType!
        : 'room';
    _criticality = const {'low', 'medium', 'high'}.contains(widget.criticality)
        ? widget.criticality!
        : 'medium';
    _condition = const {
      'operational',
      'needs_attention',
      'out_of_service',
      'retired'
    }.contains(widget.condition)
        ? widget.condition!
        : 'operational';
    _resolvedRecordId = widget.recordId ?? '';
    if (widget.formKind == 'location' && widget.mode == 'edit') {
      _loadLocation();
    } else if (widget.formKind == 'unit' && widget.mode == 'edit') {
      _loadUnit();
    }
  }

  Future<void> _loadLocation() async {
    try {
      final rows = await SupaFlow.client
          .from('locations')
          .select()
          .eq('site_id', widget.siteId ?? '')
          .eq('is_active', true)
          .order('code')
          .range(widget.recordIndex ?? 0, widget.recordIndex ?? 0);
      if (rows.isEmpty || !mounted) return;
      final row = rows.first;
      _resolvedRecordId = row['id'] as String? ?? '';
      _code.text = row['code'] as String? ?? '';
      _name.text = row['name'] as String? ?? '';
      _building.text = row['building'] as String? ?? '';
      _floor.text = row['floor'] as String? ?? '';
      _zone.text = row['zone_code'] as String? ?? '';
      _description.text = row['description'] as String? ?? '';
      final type = row['location_type'] as String? ?? 'room';
      setState(() => _locationType = type);
    } catch (_) {
      if (mounted) {
        setState(() => _message = 'Data lokasi gagal dimuat.');
      }
    }
  }

  Future<void> _loadUnit() async {
    try {
      final row = await SupaFlow.client
          .from('maintenance_units')
          .select()
          .eq('id', _resolvedRecordId)
          .maybeSingle();
      if (row == null || !mounted) return;
      _code.text = row['unit_code'] as String? ?? '';
      _sort.text = (row['code_sort'] as int? ?? 0).toString();
      _name.text = row['name'] as String? ?? '';
      _category.text = row['category_code'] as String? ?? '';
      _position.text = row['position_label'] as String? ?? '';
      final values = (row['component_options'] as List?)
              ?.map((value) => value.toString())
              .toList() ??
          const <String>[];
      _components.text = values.join(', ');
      setState(() {
        _criticality = row['criticality'] as String? ?? 'medium';
        _condition = row['condition'] as String? ?? 'operational';
      });
    } catch (_) {
      if (mounted) {
        setState(() => _message = 'Data aset gagal dimuat.');
      }
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _code,
      _name,
      _building,
      _floor,
      _zone,
      _description,
      _sort,
      _category,
      _position,
      _components,
      _note,
      _performedAt,
    ]) {
      controller.dispose();
    }
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
    if (_busy) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      dynamic response;
      if (widget.formKind == 'location') {
        if (_code.text.trim().isEmpty || _name.text.trim().length < 2) {
          throw const FormatException('invalid');
        }
        final params = <String, dynamic>{
          'p_code': _code.text,
          'p_name': _name.text,
          'p_location_type': _locationType,
          'p_building': _building.text,
          'p_floor': _floor.text,
          'p_zone_code': _zone.text,
          'p_description': _description.text,
        };
        if (widget.mode == 'create') {
          params['p_site_id'] = widget.siteId ?? '';
          response = await SupaFlow.client
              .rpc('create_opsfix_location', params: params);
        } else {
          params['p_location_id'] = _resolvedRecordId;
          response = await SupaFlow.client
              .rpc('update_opsfix_location', params: params);
        }
      } else if (widget.formKind == 'unit') {
        final sort = int.tryParse(_sort.text.trim());
        if (_code.text.trim().isEmpty ||
            _name.text.trim().isEmpty ||
            _category.text.trim().isEmpty ||
            sort == null ||
            sort < 0) {
          throw const FormatException('invalid');
        }
        final params = <String, dynamic>{
          'p_unit_code': _code.text,
          'p_code_sort': sort,
          'p_name': _name.text,
          'p_category_code': _category.text,
          'p_position_label': _position.text,
          'p_component_options': _components.text
              .split(',')
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .toList(),
          'p_criticality': _criticality,
          'p_condition': _condition,
        };
        if (widget.mode == 'create') {
          params['p_location_id'] = widget.locationId ?? '';
          response =
              await SupaFlow.client.rpc('create_opsfix_unit', params: params);
        } else {
          params['p_unit_id'] = _resolvedRecordId;
          response =
              await SupaFlow.client.rpc('update_opsfix_unit', params: params);
        }
      } else {
        final performed = DateTime.tryParse(
          _performedAt.text.trim().replaceFirst(' ', 'T'),
        );
        if (_note.text.trim().length < 3 || performed == null) {
          throw const FormatException('invalid');
        }
        response = await SupaFlow.client.rpc(
          'create_opsfix_maintenance_note',
          params: {
            'p_unit_id': _resolvedRecordId,
            'p_note_type': _noteType,
            'p_note': _note.text,
            'p_performed_at': performed.toUtc().toIso8601String(),
          },
        );
      }
      final result = Map<String, dynamic>.from(response as Map);
      final code = result['code'] as String? ?? 'network_error';
      if (result['ok'] != true) {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _message = _messageFor(code);
        });
        return;
      }
      final router = GoRouter.of(context);
      Navigator.of(context).pop();
      if (widget.refreshTarget == 'locations') {
        router.pushReplacementNamed('adminAssetsLocationsPage');
      } else if (widget.refreshTarget == 'location_detail') {
        router.pushReplacementNamed(
          'AdminAssetLocationDetailPage',
          queryParameters: {'locationId': widget.refreshLocationId ?? ''},
        );
      } else {
        router.pushReplacementNamed(
          'AdminAssetDetailPage',
          queryParameters: {
            'unitId': widget.refreshUnitId ?? '',
            'locationId': widget.refreshLocationId ?? '',
            'assetCode': widget.refreshAssetCode ?? '',
          },
        );
      }
    } on FormatException {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = _messageFor('invalid');
      });
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
      );

  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) =>
      TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: _decoration(label),
        onChanged: (_) => setState(() {}),
      );

  Widget _formColumn(List<Widget> fields) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < fields.length; index++) ...[
            fields[index],
            if (index < fields.length - 1) const SizedBox(height: 14),
          ],
        ],
      );

  Widget _locationFields() => _formColumn(
        [
          _textField(_code, 'Kode lokasi'),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.mode == 'create'
                  ? 'Slug QR: ${_slugPreview.isEmpty ? '-' : _slugPreview}'
                  : 'Slug QR tetap: ${widget.slug}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          _textField(_name, 'Nama lokasi'),
          DropdownButtonFormField<String>(
            value: _locationType,
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
                .map((entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ))
                .toList(),
            onChanged: _busy
                ? null
                : (value) => setState(() => _locationType = value ?? 'room'),
          ),
          _textField(_building, 'Gedung'),
          _textField(_floor, 'Lantai'),
          _textField(_zone, 'Zona (kosong = kode lokasi)'),
          _textField(_description, 'Deskripsi', maxLines: 3),
        ],
      );

  Widget _unitFields() => _formColumn(
        [
          _textField(_code, 'Kode unit/aset'),
          _textField(
            _sort,
            'Urutan',
            keyboardType: TextInputType.number,
          ),
          _textField(_name, 'Nama unit/aset'),
          _textField(_category, 'Kategori'),
          _textField(_position, 'Posisi'),
          _textField(_components, 'Komponen (pisahkan dengan koma)',
              maxLines: 2),
          DropdownButtonFormField<String>(
            value: _criticality,
            decoration: _decoration('Kritikalitas'),
            items: const ['low', 'medium', 'high']
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: _busy
                ? null
                : (value) => setState(() => _criticality = value ?? 'medium'),
          ),
          DropdownButtonFormField<String>(
            value: _condition,
            decoration: _decoration('Kondisi'),
            items: const [
              'operational',
              'needs_attention',
              'out_of_service',
              'retired',
            ]
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: _busy
                ? null
                : (value) =>
                    setState(() => _condition = value ?? 'operational'),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('QR hanya tersedia untuk lokasi induk.'),
          ),
        ],
      );

  Widget _noteFields() => _formColumn(
        [
          DropdownButtonFormField<String>(
            value: _noteType,
            decoration: _decoration('Jenis catatan'),
            items: const {
              'inspection': 'Inspeksi',
              'preventive': 'Preventif',
              'corrective': 'Korektif',
              'other': 'Lainnya',
            }
                .entries
                .map((entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ))
                .toList(),
            onChanged: _busy
                ? null
                : (value) => setState(() => _noteType = value ?? 'inspection'),
          ),
          _textField(_performedAt, 'Waktu pelaksanaan (YYYY-MM-DD HH:mm)'),
          _textField(_note, 'Catatan pemeliharaan', maxLines: 5),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final title = widget.formKind == 'location'
        ? (widget.mode == 'create' ? 'Tambah lokasi' : 'Edit lokasi')
        : widget.formKind == 'unit'
            ? (widget.mode == 'create' ? 'Tambah unit/aset' : 'Edit aset')
            : 'Tambah catatan pemeliharaan';
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: _busy ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (widget.formKind == 'location') _locationFields(),
              if (widget.formKind == 'unit') _unitFields(),
              if (widget.formKind == 'note') _noteFields(),
              if (_message != null) ...[
                const SizedBox(height: 12),
                Text(
                  _message!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _busy ? null : _save,
                icon: _busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_busy ? 'Menyimpan…' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
