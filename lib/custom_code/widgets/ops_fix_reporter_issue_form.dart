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
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OpsFixReporterIssueForm extends StatefulWidget {
  const OpsFixReporterIssueForm({
    super.key,
    this.width,
    this.height,
    this.locationId = '',
    this.unitId = '',
  });

  final double? width;
  final double? height;
  final String locationId;
  final String unitId;

  @override
  State<OpsFixReporterIssueForm> createState() =>
      _OpsFixReporterIssueFormState();
}

class _OpsFixReporterIssueFormState extends State<OpsFixReporterIssueForm> {
  final _description = TextEditingController();
  bool _loading = true;
  bool _busy = false;
  bool _duplicateConfirmed = false;
  String? _message;
  String _locationId = '';
  String _unitId = '';
  String _issueTypeId = '';
  String _issueCategoryId = '';
  PlatformFile? _photo;
  List<Map<String, dynamic>> _units = const [];
  List<Map<String, dynamic>> _issues = const [];

  @override
  void initState() {
    super.initState();
    _locationId = widget.locationId.trim().isNotEmpty
        ? widget.locationId.trim()
        : FFAppState().currentLocationId.trim();
    _unitId = widget.unitId.trim();
    _load();
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      if (_locationId.isEmpty && FFAppState().currentSiteId.isNotEmpty) {
        final locations = await SupaFlow.client
            .from('locations')
            .select('id')
            .eq('site_id', FFAppState().currentSiteId)
            .eq('is_active', true)
            .order('created_at', ascending: true)
            .limit(1);
        if (locations.isNotEmpty) {
          _locationId = locations.first['id']?.toString() ?? '';
        }
      }
      final results = await Future.wait([
        _locationId.isEmpty
            ? Future.value(<Map<String, dynamic>>[])
            : SupaFlow.client
                .from('maintenance_units')
                .select('id,unit_code,name')
                .eq('location_id', _locationId)
                .eq('is_active', true)
                .order('unit_code', ascending: true),
        SupaFlow.client
            .from('issue_types')
            .select('id,issue_category_id,label')
            .eq('is_active', true)
            .order('sort_order', ascending: true),
      ]);
      if (!mounted) return;
      setState(() {
        _units = (results[0] as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _issues = (results[1] as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        if (_unitId.isNotEmpty &&
            !_units.any((row) => row['id']?.toString() == _unitId)) {
          _unitId = '';
        }
        _loading = false;
      });
    } catch (error) {
      debugPrint('Reporter form load failed: $error');
      if (mounted) {
        setState(() {
          _loading = false;
          _message = 'Data formulir belum dapat dimuat. Coba lagi.';
        });
      }
    }
  }

  String _extension(PlatformFile file) {
    final explicit = (file.extension ?? '').toLowerCase();
    if (explicit.isNotEmpty) return explicit;
    final pieces = file.name.toLowerCase().split('.');
    return pieces.length > 1 ? pieces.last : '';
  }

  Future<void> _choosePhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.bytes == null || file.size > 5 * 1024 * 1024) {
      setState(
          () => _message = 'Gunakan foto JPG, PNG, atau WebP maksimal 5 MB.');
      return;
    }
    setState(() {
      _photo = file;
      _duplicateConfirmed = false;
      _message = 'Foto ${file.name} siap dikirim.';
    });
  }

  Future<Map<String, String>> _upload(PlatformFile file, String userId) async {
    final extension = _extension(file);
    final path =
        'users/$userId/${DateTime.now().microsecondsSinceEpoch}.$extension';
    final contentType = extension == 'png'
        ? 'image/png'
        : extension == 'webp'
            ? 'image/webp'
            : 'image/jpeg';
    await SupaFlow.client.storage.from('ticket-photos').uploadBinary(
          path,
          file.bytes!,
          fileOptions: FileOptions(contentType: contentType, upsert: false),
        );
    return {
      'path': path,
      'url': SupaFlow.client.storage.from('ticket-photos').getPublicUrl(path),
    };
  }

  Future<void> _submit() async {
    final user = SupaFlow.client.auth.currentUser;
    final description = _description.text.trim();
    if (user == null) {
      setState(() => _message = 'Sesi berakhir. Silakan masuk kembali.');
      return;
    }
    if (_locationId.isEmpty || _unitId.isEmpty) {
      setState(() => _message = 'Pilih perangkat yang akan dilaporkan.');
      return;
    }
    if (_issueTypeId.isEmpty || _issueCategoryId.isEmpty) {
      setState(() => _message = 'Pilih jenis gangguan terlebih dahulu.');
      return;
    }
    if (description.length < 5) {
      setState(() => _message = 'Jelaskan gejala minimal 5 karakter.');
      return;
    }
    if (_photo == null) {
      setState(() => _message = 'Tambahkan foto kondisi perangkat.');
      return;
    }

    if (!_duplicateConfirmed) {
      final duplicates = await SupaFlow.client
          .from('tickets')
          .select('ticket_code')
          .eq('reporter_id', user.id)
          .eq('location_id', _locationId)
          .eq('unit_id', _unitId)
          .eq('issue_type_id', _issueTypeId)
          .inFilter('status', const [
        'reported',
        'assigned',
        'in_progress',
        'pending_verification',
        'reopened'
      ]).limit(1);
      if (duplicates.isNotEmpty) {
        setState(() {
          _duplicateConfirmed = true;
          _message =
              'Tiket aktif ${duplicates.first['ticket_code']} serupa sudah ada. Tekan Kirim laporan lagi jika tetap ingin melanjutkan.';
        });
        return;
      }
    }

    setState(() {
      _busy = true;
      _message = 'Mengirim laporan…';
    });
    try {
      final upload = await _upload(_photo!, user.id);
      final created = await SupaFlow.client
          .from('tickets')
          .insert({
            'location_id': _locationId,
            'unit_id': _unitId,
            'issue_category_id': _issueCategoryId,
            'issue_type_id': _issueTypeId,
            'description': description,
            'before_photo_path': upload['path'],
            'before_photo_url': upload['url'],
          })
          .select('ticket_code')
          .single();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Laporan ${created['ticket_code']} berhasil dibuat.')),
      );
      context.goNamed('myTicketsPage');
    } catch (error) {
      debugPrint('Reporter ticket creation failed: $error');
      if (mounted) {
        setState(() {
          _busy = false;
          _message =
              'Laporan belum berhasil dikirim. Periksa data lalu coba lagi.';
        });
      }
    }
  }

  InputDecoration _fieldDecoration(String label, String hint) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDE2E7)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Buat laporan terstruktur',
              style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827))),
          const SizedBox(height: 4),
          const Text('Lengkapi informasi berikut agar laporan mudah diproses.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 18),
          const Text('Perangkat yang dilaporkan',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827))),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _unitId.isEmpty ? null : _unitId,
            isExpanded: true,
            decoration: _fieldDecoration(
                'Pilih perangkat', 'Pilih unit atau perangkat'),
            items: _units.map((unit) {
              final id = unit['id']?.toString() ?? '';
              final code = unit['unit_code']?.toString() ?? 'Unit';
              final label = unit['name']?.toString().trim() ?? '';
              return DropdownMenuItem(
                  value: id,
                  child: Text(label.isEmpty ? code : '$code · $label',
                      overflow: TextOverflow.ellipsis));
            }).toList(),
            onChanged:
                _busy ? null : (value) => setState(() => _unitId = value ?? ''),
          ),
          if (_units.isEmpty) ...[
            const SizedBox(height: 8),
            const Text('Belum ada perangkat aktif pada lokasi ini.',
                style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
          ],
          const SizedBox(height: 18),
          const Text('Pilih jenis gangguan',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827))),
          const SizedBox(height: 8),
          for (final issue in _issues) ...[
            Builder(builder: (context) {
              final id = issue['id']?.toString() ?? '';
              final selected = id == _issueTypeId;
              return InkWell(
                onTap: _busy
                    ? null
                    : () => setState(() {
                          _issueTypeId = id;
                          _issueCategoryId =
                              issue['issue_category_id']?.toString() ?? '';
                          _duplicateConfirmed = false;
                        }),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFF0EDFF)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: selected
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFFDDE2E7),
                        width: selected ? 2 : 1),
                  ),
                  child: Row(children: [
                    Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 20,
                        color: selected
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFF94A3B8)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(issue['label']?.toString() ?? 'Gangguan',
                            style: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: const Color(0xFF111827)))),
                  ]),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 10),
          const Text('Jelaskan gejalanya',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827))),
          const SizedBox(height: 8),
          TextField(
            controller: _description,
            minLines: 4,
            maxLines: 6,
            decoration: _fieldDecoration('Deskripsi masalah',
                'Contoh: tombol spasi tidak merespons saat digunakan.'),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _busy ? null : _choosePhoto,
            icon: Icon(_photo == null
                ? Icons.add_a_photo_outlined
                : Icons.check_circle_outline),
            label: Text(
                _photo == null
                    ? 'Pilih foto kondisi perangkat'
                    : 'Ganti foto · ${_photo!.name}',
                overflow: TextOverflow.ellipsis),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: const Color(0xFF6C5CE7),
                side: const BorderSide(color: Color(0xFF6C5CE7)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 8),
          const Text('Format JPG, PNG, atau WebP, maksimal 5 MB.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(_message!,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF475569))),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy ? null : _submit,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send_outlined),
            label: Text(_busy ? 'Mengirim…' : 'Kirim laporan'),
            style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: const Color(0xFF6C5CE7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
        ],
      ),
    );
  }
}
