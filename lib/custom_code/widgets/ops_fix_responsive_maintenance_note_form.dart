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
import '/custom_code/widgets/ops_fix_language_setting.dart';

class OpsFixResponsiveMaintenanceNoteForm extends StatefulWidget {
  const OpsFixResponsiveMaintenanceNoteForm({
    super.key,
    this.width,
    this.height,
    required this.unitId,
  });

  final double? width;
  final double? height;
  final String unitId;

  @override
  State<OpsFixResponsiveMaintenanceNoteForm> createState() =>
      _OpsFixResponsiveMaintenanceNoteFormState();
}

class _OpsFixResponsiveMaintenanceNoteFormState
    extends State<OpsFixResponsiveMaintenanceNoteForm> {
  late final TextEditingController _performedAt;
  late final TextEditingController _note;
  String _noteType = 'inspection';
  bool _busy = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _performedAt = TextEditingController(
      text:
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
    );
    _note = TextEditingController();
  }

  @override
  void dispose() {
    _performedAt.dispose();
    _note.dispose();
    super.dispose();
  }

  String _messageFor(String code) => switch (code) {
        'invalid' => OpsFixI18n.t(
            'Periksa jenis, waktu, dan isi catatan. Catatan minimal 3 karakter.'),
        'access_denied' =>
          OpsFixI18n.t('Anda tidak memiliki akses manajer untuk aset ini.'),
        'network_error' =>
          OpsFixI18n.t('Koneksi gagal. Form tetap terbuka untuk dicoba lagi.'),
        _ => OpsFixI18n.t('Catatan pemeliharaan tidak dapat disimpan.'),
      };

  Future<void> _save() async {
    if (_busy) return;
    final unitId = widget.unitId.trim();
    final note = _note.text.trim();
    final performed = DateTime.tryParse(
      _performedAt.text.trim().replaceFirst(' ', 'T'),
    );
    if (unitId.isEmpty ||
        note.length < 3 ||
        note.length > 2000 ||
        performed == null) {
      setState(() => _message = _messageFor('invalid'));
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final response = await SupaFlow.client.rpc(
        'create_opsfix_maintenance_note',
        params: {
          'p_unit_id': unitId,
          'p_note_type': _noteType,
          'p_note': note,
          'p_performed_at': performed.toUtc().toIso8601String(),
        },
      );
      final result = Map<String, dynamic>.from(response as Map);
      final code = result['code']?.toString() ?? 'network_error';
      if (result['ok'] != true || code != 'created') {
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
        fillColor: _busy ? const Color(0xFFF8FAFC) : Colors.white,
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

  Widget _typeField() => DropdownButtonFormField<String>(
        initialValue: _noteType,
        isExpanded: true,
        decoration: _decoration(OpsFixI18n.t('Jenis catatan')),
        items: {
          'inspection': OpsFixI18n.t('Inspeksi'),
          'preventive': OpsFixI18n.t('Preventif'),
          'corrective': OpsFixI18n.t('Korektif'),
          'other': OpsFixI18n.t('Lainnya'),
        }
            .entries
            .map(
              (entry) => DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        onChanged: _busy
            ? null
            : (value) {
                if (value != null) setState(() => _noteType = value);
              },
      );

  Widget _timeField() => TextField(
        controller: _performedAt,
        enabled: !_busy,
        keyboardType: TextInputType.datetime,
        decoration:
            _decoration(OpsFixI18n.t('Waktu pelaksanaan (YYYY-MM-DD HH:mm)')),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 560;
              final metadata = wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _typeField()),
                        const SizedBox(width: 14),
                        Expanded(child: _timeField()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _typeField(),
                        const SizedBox(height: 14),
                        _timeField(),
                      ],
                    );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EDFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.build_circle_outlined,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              OpsFixI18n.t('Tambah catatan pemeliharaan'),
                              style: TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              OpsFixI18n.t(
                                  'Catatan tersimpan permanen pada riwayat aset.'),
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed:
                            _busy ? null : () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  metadata,
                  const SizedBox(height: 14),
                  TextField(
                    controller: _note,
                    enabled: !_busy,
                    minLines: 4,
                    maxLines: 7,
                    maxLength: 2000,
                    decoration:
                        _decoration(OpsFixI18n.t('Catatan pemeliharaan')),
                  ),
                  if (_message != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Text(
                        _message!,
                        style: const TextStyle(
                          color: Color(0xFFB42318),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed:
                            _busy ? null : () => Navigator.of(context).pop(),
                        child: Text(OpsFixI18n.t('Batal')),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        onPressed: _busy ? null : _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: _busy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined, size: 19),
                        label: Text(_busy
                            ? OpsFixI18n.t('Menyimpan…')
                            : OpsFixI18n.t('Simpan catatan')),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
