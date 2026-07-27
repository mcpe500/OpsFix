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

Map<String, dynamic> _opsFixReporterFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

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
  int _desktopStep = 0;
  String? _duplicateTicketCode;
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
      _duplicateTicketCode = null;
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

  Future<void> _rememberActiveLocation(String ownerId) async {
    final row = await SupaFlow.client
        .from('locations')
        .select('id,site_id,slug,code,name')
        .eq('id', _locationId)
        .eq('is_active', true)
        .maybeSingle();
    if (row == null) return;
    FFAppState().update(() {
      FFAppState().currentSiteId = row['site_id']?.toString() ?? '';
      FFAppState().currentLocationId = row['id']?.toString() ?? '';
      FFAppState().currentLocationSlug = row['slug']?.toString() ?? '';
      FFAppState().currentLocationCode = row['code']?.toString() ?? '';
      FFAppState().currentLocationName = row['name']?.toString() ?? '';
      FFAppState().currentLocationOwnerId = ownerId;
    });
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
          _duplicateTicketCode = duplicates.first['ticket_code']?.toString();
          _message =
              'Tiket serupa masih aktif. Tinjau peringatan sebelum melanjutkan.';
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
      await _rememberActiveLocation(user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Laporan ${created['ticket_code']} berhasil dibuat.')),
      );
      context.goNamed('myTicketsPage', extra: _opsFixReporterFade());
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

  Widget _issueGrid() => LayoutBuilder(
        builder: (context, constraints) {
          final columns = MediaQuery.sizeOf(context).width >= 700 ? 2 : 1;
          const gap = 8.0;
          final itemWidth = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - gap) / 2;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: _issues.map((issue) {
              final id = issue['id']?.toString() ?? '';
              final selected = id == _issueTypeId;
              return SizedBox(
                width: itemWidth,
                child: InkWell(
                  onTap: _busy
                      ? null
                      : () => setState(() {
                            _issueTypeId = id;
                            _issueCategoryId =
                                issue['issue_category_id']?.toString() ?? '';
                            _duplicateConfirmed = false;
                            _duplicateTicketCode = null;
                            _duplicateTicketCode = null;
                            _duplicateTicketCode = null;
                          }),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: const Color(0xFF111827)))),
                    ]),
                  ),
                ),
              );
            }).toList(),
          );
        },
      );

  String _localizedIssue(String raw) {
    const labels = <String, String>{
      'Computer will not power on': 'Komputer tidak dapat menyala',
      'No network connection': 'Tidak ada koneksi jaringan',
      'Cannot sign in': 'Tidak dapat masuk ke akun',
      'Power outlet problem': 'Masalah pada stopkontak',
      'Furniture damage': 'Kerusakan furnitur',
      'Room-level problem': 'Masalah pada ruangan',
      'Display problem': 'Masalah pada layar',
      'Application error': 'Aplikasi mengalami gangguan',
      'Slow or unstable network': 'Jaringan lambat atau tidak stabil',
      'Keyboard or mouse problem': 'Masalah keyboard atau mouse',
    };
    return labels[raw] ?? raw;
  }

  Map<String, dynamic>? get _selectedUnit {
    for (final unit in _units) {
      if (unit['id']?.toString() == _unitId) return unit;
    }
    return null;
  }

  Map<String, dynamic>? get _selectedIssue {
    for (final issue in _issues) {
      if (issue['id']?.toString() == _issueTypeId) return issue;
    }
    return null;
  }

  String get _unitLabel {
    final unit = _selectedUnit;
    if (unit == null) return 'Belum dipilih';
    final code = unit['unit_code']?.toString() ?? 'Unit';
    final name = unit['name']?.toString().trim() ?? '';
    return name.isEmpty ? code : '$code · $name';
  }

  String get _issueLabel => _selectedIssue == null
      ? 'Belum dipilih'
      : _localizedIssue(_selectedIssue!['label']?.toString() ?? 'Gangguan');

  bool get _stepOneReady =>
      _unitId.isNotEmpty &&
      _issueTypeId.isNotEmpty &&
      _issueCategoryId.isNotEmpty;
  bool get _stepTwoReady =>
      _description.text.trim().length >= 5 && _photo != null;

  void _resetDuplicate() {
    _duplicateConfirmed = false;
    _duplicateTicketCode = null;
  }

  void _nextStep() {
    if (_desktopStep == 0 && !_stepOneReady) {
      setState(() =>
          _message = 'Pilih perangkat dan jenis gangguan sebelum melanjutkan.');
      return;
    }
    if (_desktopStep == 1 && !_stepTwoReady) {
      setState(() => _message =
          'Jelaskan gejala minimal 5 karakter dan tambahkan foto kondisi perangkat.');
      return;
    }
    setState(() {
      _message = null;
      _desktopStep = (_desktopStep + 1).clamp(0, 2).toInt();
    });
  }

  Widget _sectionTitle(String title, String subtitle) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827))),
          const SizedBox(height: 5),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF64748B), height: 1.4)),
        ],
      );

  Widget _devicePicker() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Perangkat yang dilaporkan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _unitId.isEmpty ? null : _unitId,
            isExpanded: true,
            decoration: _fieldDecoration(
                'Pilih perangkat', 'Pilih unit atau perangkat'),
            items: _units.map((unit) {
              final id = unit['id']?.toString() ?? '';
              final code = unit['unit_code']?.toString() ?? 'Unit';
              final name = unit['name']?.toString().trim() ?? '';
              return DropdownMenuItem(
                value: id,
                child: Text(name.isEmpty ? code : '$code · $name',
                    overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: _busy
                ? null
                : (value) => setState(() {
                      _unitId = value ?? '';
                      _resetDuplicate();
                    }),
          ),
          if (_units.isEmpty) ...[
            const SizedBox(height: 8),
            const Text('Belum ada perangkat aktif pada lokasi ini.',
                style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
          ],
        ],
      );

  Widget _localizedIssueGrid() => LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 560 ? 2 : 1;
          const gap = 10.0;
          final itemWidth = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - gap) / 2;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: _issues.map((issue) {
              final id = issue['id']?.toString() ?? '';
              final selected = id == _issueTypeId;
              return SizedBox(
                width: itemWidth,
                child: InkWell(
                  onTap: _busy
                      ? null
                      : () => setState(() {
                            _issueTypeId = id;
                            _issueCategoryId =
                                issue['issue_category_id']?.toString() ?? '';
                            _resetDuplicate();
                          }),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFF0EDFF)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFFDDE2E7),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(children: [
                      Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 20,
                        color: selected
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _localizedIssue(
                              issue['label']?.toString() ?? 'Gangguan'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w500,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            }).toList(),
          );
        },
      );

  Widget _detailsAndPhoto() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Jelaskan gejalanya',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _description,
            minLines: 5,
            maxLines: 8,
            onChanged: (_) => setState(() {
              _resetDuplicate();
              _message = null;
            }),
            decoration: _fieldDecoration('Deskripsi masalah',
                'Contoh: tombol spasi tidak merespons saat digunakan.'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _busy ? null : _choosePhoto,
            icon: Icon(_photo == null
                ? Icons.add_a_photo_outlined
                : Icons.check_circle_outline),
            label: Text(
              _photo == null
                  ? 'Pilih foto kondisi perangkat'
                  : 'Ganti foto · ${_photo!.name}',
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: const Color(0xFF6C5CE7),
              side: const BorderSide(color: Color(0xFF6C5CE7)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 7),
          const Text('Format JPG, PNG, atau WebP, maksimal 5 MB.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      );

  Widget _summaryRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 115,
              child: Text(label,
                  style:
                      const TextStyle(color: Color(0xFF64748B), fontSize: 13))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _review() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFDDE2E7)),
            ),
            child: Column(children: [
              _summaryRow(
                  'Lokasi',
                  FFAppState().currentLocationName.trim().isEmpty
                      ? 'Lokasi laporan'
                      : FFAppState().currentLocationName),
              _summaryRow('Perangkat', _unitLabel),
              _summaryRow('Gangguan', _issueLabel),
              _summaryRow('Deskripsi', _description.text.trim()),
              _summaryRow('Foto', _photo?.name ?? 'Belum dipilih'),
            ]),
          ),
          if (_duplicateTicketCode != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFD97706)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tiket $_duplicateTicketCode dengan perangkat dan gangguan serupa masih aktif. Periksa tiket tersebut atau pilih “Tetap kirim” bila ini masalah berbeda.',
                    style: const TextStyle(
                        color: Color(0xFF92400E), fontSize: 13, height: 1.4),
                  ),
                ),
              ]),
            ),
          ],
        ],
      );

  Widget _messagePanel() {
    if (_message == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(_message!,
          style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
    );
  }

  Widget _stepIndicator(int index, String title, String subtitle) {
    final active = _desktopStep == index;
    final complete = _desktopStep > index;
    final color =
        active || complete ? const Color(0xFF6C5CE7) : const Color(0xFFCBD5E1);
    return InkWell(
      onTap: index < _desktopStep && !_busy
          ? () => setState(() {
                _desktopStep = index;
                _message = null;
              })
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF0EDFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: complete
                ? const Icon(Icons.check, size: 17, color: Colors.white)
                : Text('${index + 1}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: active
                            ? const Color(0xFF5B4CE3)
                            : const Color(0xFF111827),
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _desktopWizard() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 330,
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFDDE2E7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Progres laporan',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    const Text('Lengkapi tiga langkah berikut.',
                        style:
                            TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    const SizedBox(height: 18),
                    _stepIndicator(
                        0,
                        'Perangkat & gangguan',
                        _stepOneReady
                            ? 'Pilihan sudah lengkap'
                            : 'Tentukan masalah'),
                    const SizedBox(height: 5),
                    _stepIndicator(
                        1,
                        'Detail & bukti',
                        _stepTwoReady
                            ? 'Bukti sudah lengkap'
                            : 'Jelaskan kondisi'),
                    const SizedBox(height: 5),
                    _stepIndicator(
                        2, 'Tinjau & kirim', 'Pastikan laporan benar'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF081225),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LOKASI LAPORAN',
                        style: TextStyle(
                            color: Color(0xFF35D0BA),
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 7),
                    Text(
                      FFAppState().currentLocationName.trim().isEmpty
                          ? 'Lokasi belum dipilih'
                          : FFAppState().currentLocationName,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    if (_unitId.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(_unitLabel,
                          style: const TextStyle(
                              color: Color(0xFFD8E0EF), fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 720),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDDE2E7)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_desktopStep == 0) ...[
                    _sectionTitle('Perangkat dan jenis gangguan',
                        'Pilih objek laporan dan masalah yang paling sesuai.'),
                    const SizedBox(height: 22),
                    _devicePicker(),
                    const SizedBox(height: 20),
                    const Text('Pilih jenis gangguan',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 9),
                    _localizedIssueGrid(),
                  ] else if (_desktopStep == 1) ...[
                    _sectionTitle('Detail dan bukti kondisi',
                        'Jelaskan gejala yang terlihat dan lampirkan foto terbaru.'),
                    const SizedBox(height: 22),
                    _detailsAndPhoto(),
                  ] else ...[
                    _sectionTitle('Tinjau laporan',
                        'Pastikan informasi berikut sudah benar sebelum dikirim.'),
                    const SizedBox(height: 20),
                    _review(),
                  ],
                  _messagePanel(),
                  const SizedBox(height: 22),
                  Row(children: [
                    if (_desktopStep > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _busy
                              ? null
                              : () => setState(() {
                                    _desktopStep--;
                                    _message = null;
                                  }),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            foregroundColor: const Color(0xFF5B4CE3),
                            side: const BorderSide(color: Color(0xFF6C5CE7)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Kembali'),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: _desktopStep > 0 ? 2 : 1,
                      child: FilledButton.icon(
                        onPressed: _busy
                            ? null
                            : _desktopStep < 2
                                ? _nextStep
                                : _submit,
                        icon: _busy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Icon(_desktopStep < 2
                                ? Icons.arrow_forward
                                : Icons.send_outlined),
                        label: Text(_busy
                            ? 'Mengirim…'
                            : _desktopStep < 2
                                ? 'Lanjutkan'
                                : _duplicateTicketCode == null
                                    ? 'Kirim laporan'
                                    : 'Tetap kirim'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFF6C5CE7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _singlePageForm() => Container(
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
            _sectionTitle('Buat laporan terstruktur',
                'Lengkapi informasi berikut agar laporan mudah diproses.'),
            const SizedBox(height: 18),
            _devicePicker(),
            const SizedBox(height: 18),
            const Text('Pilih jenis gangguan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _localizedIssueGrid(),
            const SizedBox(height: 18),
            _detailsAndPhoto(),
            _messagePanel(),
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
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    return desktop ? _desktopWizard() : _singlePageForm();
  }
}
