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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/backend/supabase/supabase.dart';
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
  int _desktopStep = 0;
  int _duplicateRequest = 0;
  bool _checkingDuplicate = false;
  Map<String, dynamic>? _duplicateIncident;
  // Retained only for the legacy private issue-grid helper, which is not
  // mounted by the active responsive form.
  bool _duplicateConfirmed = false;
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
          _message =
              OpsFixI18n.t('Data formulir belum dapat dimuat. Coba lagi.');
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
      setState(() => _message =
          OpsFixI18n.t('Gunakan foto JPG, PNG, atau WebP maksimal 5 MB.'));
      return;
    }
    setState(() {
      _photo = file;
      _duplicateIncident = null;
      _message = OpsFixI18n.tf('Foto {0} siap dikirim.', [file.name]);
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
    if (user == null) {
      setState(() =>
          _message = OpsFixI18n.t('Sesi berakhir. Silakan masuk kembali.'));
      return;
    }
    if (!_stepOneReady) {
      setState(() => _message = OpsFixI18n.t(
          'Pilih perangkat dan jenis gangguan sebelum melanjutkan.'));
      return;
    }
    final duplicate = await _checkDuplicate(required: true);
    if (!mounted || duplicate != null) return;
    final description = _description.text.trim();
    if (description.length < 5) {
      setState(
          () => _message = OpsFixI18n.t('Jelaskan gejala minimal 5 karakter.'));
      return;
    }
    if (_photo == null) {
      setState(
          () => _message = OpsFixI18n.t('Tambahkan foto kondisi perangkat.'));
      return;
    }

    String? uploadedPath;
    setState(() {
      _busy = true;
      _message = OpsFixI18n.t('Mengirim laporan…');
    });
    try {
      final upload = await _upload(_photo!, user.id);
      uploadedPath = upload['path'];
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
            content: Text(OpsFixI18n.tf(
                OpsFixI18n.t('Laporan {0} berhasil dibuat.'),
                [created['ticket_code']]))),
      );
      context.goNamed('myTicketsPage', extra: _opsFixReporterFade());
    } on PostgrestException catch (error) {
      await _cleanupUpload(uploadedPath);
      if (error.code == '23505') {
        final winner = await _checkDuplicate(required: true);
        if (mounted) {
          setState(() {
            _busy = false;
            if (winner != null) {
              _desktopStep = 0;
              _message = OpsFixI18n.t(
                  'Laporan serupa baru saja dibuat. Anda dapat menandai diri sebagai terdampak.');
            }
          });
        }
      } else {
        debugPrint('Reporter insert failed: ${error.code}');
        if (mounted) {
          setState(() {
            _busy = false;
            _message = OpsFixI18n.t(
                'Laporan belum berhasil dikirim. Periksa data lalu coba lagi.');
          });
        }
      }
    } catch (error) {
      await _cleanupUpload(uploadedPath);
      debugPrint('Reporter ticket creation failed: ${error.runtimeType}');
      if (mounted) {
        setState(() {
          _busy = false;
          _message = OpsFixI18n.t(
              'Laporan belum berhasil dikirim. Periksa koneksi lalu coba lagi.');
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
                          child: Text(
                              issue['label']?.toString() ??
                                  OpsFixI18n.t('Gangguan'),
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
    // Issue-type labels come out of Supabase in English, and this table exists
    // to render them in Indonesian. In English the source value is already
    // correct, so the lookup is skipped rather than translated twice.
    //
    // The table stays `const` deliberately: it is keyed by a database value, so
    // it must not be routed through OpsFixI18n.
    if (OpsFixI18n.isEnglish(context)) return raw;
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
    if (unit == null) return OpsFixI18n.t('Belum dipilih');
    final code = unit['unit_code']?.toString() ?? OpsFixI18n.t('Unit');
    final name = unit['name']?.toString().trim() ?? '';
    return name.isEmpty ? code : '$code · $name';
  }

  String get _issueLabel => _selectedIssue == null
      ? OpsFixI18n.t('Belum dipilih')
      : _localizedIssue(
          _selectedIssue!['label']?.toString() ?? OpsFixI18n.t('Gangguan'));

  bool get _stepOneReady =>
      _unitId.isNotEmpty &&
      _issueTypeId.isNotEmpty &&
      _issueCategoryId.isNotEmpty;
  bool get _stepTwoReady =>
      _description.text.trim().length >= 5 && _photo != null;

  void _resetDuplicate() {
    _duplicateRequest++;
    _checkingDuplicate = false;
    _duplicateIncident = null;
  }

  Map<String, dynamic> _jsonMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  Future<Map<String, dynamic>?> _checkDuplicate({bool required = false}) async {
    if (_locationId.isEmpty || _unitId.isEmpty || _issueTypeId.isEmpty) {
      if (mounted) setState(_resetDuplicate);
      return null;
    }
    final request = ++_duplicateRequest;
    if (mounted) setState(() => _checkingDuplicate = true);
    try {
      final raw = await SupaFlow.client.rpc(
        'find_opsfix_open_duplicate',
        params: {
          'p_location_id': _locationId,
          'p_unit_id': _unitId,
          'p_issue_type_id': _issueTypeId,
          'p_component_key': null,
        },
      );
      if (!mounted || request != _duplicateRequest) return null;
      final result = _jsonMap(raw);
      final incident =
          result['code'] == 'found' ? _jsonMap(result['incident']) : null;
      setState(() {
        _checkingDuplicate = false;
        _duplicateIncident = incident?.isEmpty == true ? null : incident;
        if (required && result['ok'] != true) {
          _message = OpsFixI18n.t(
              'Pemeriksaan gangguan belum berhasil. Periksa koneksi lalu coba lagi.');
        }
      });
      return _duplicateIncident;
    } catch (error) {
      debugPrint('Duplicate lookup failed: ${error.runtimeType}');
      if (mounted && request == _duplicateRequest) {
        setState(() {
          _checkingDuplicate = false;
          if (required) {
            _message = OpsFixI18n.t(
                'Pemeriksaan gangguan belum berhasil. Periksa koneksi lalu coba lagi.');
          }
        });
      }
      return null;
    }
  }

  Future<void> _joinDuplicate() async {
    final incident = _duplicateIncident;
    final ticketId = incident?['ticket_id']?.toString() ?? '';
    if (_busy || ticketId.isEmpty) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = _jsonMap(await SupaFlow.client.rpc(
        'join_opsfix_affected_ticket',
        params: {'p_ticket_id': ticketId},
      ));
      final updated = _jsonMap(result['incident']);
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (updated.isNotEmpty) _duplicateIncident = updated;
        _message = switch (result['code']?.toString()) {
          'joined' =>
            OpsFixI18n.t('Anda ditambahkan sebagai pengguna yang terdampak.'),
          'already_joined' => OpsFixI18n.t(
              'Anda sudah menandai diri sebagai pengguna yang terdampak.'),
          'own_ticket' =>
            OpsFixI18n.t('Anda adalah pelapor awal gangguan ini.'),
          'ticket_closed' => OpsFixI18n.t(
              'Gangguan ini sudah ditutup. Periksa kembali pilihan Anda.'),
          _ =>
            OpsFixI18n.t('Belum dapat menandai terdampak. Silakan coba lagi.'),
        };
      });
    } catch (error) {
      debugPrint('Join affected incident failed: ${error.runtimeType}');
      if (mounted) {
        setState(() {
          _busy = false;
          _message = OpsFixI18n.t(
              'Belum dapat menandai terdampak. Periksa koneksi lalu coba lagi.');
        });
      }
    }
  }

  void _openDuplicate() {
    final incident = _duplicateIncident;
    final ticketId = incident?['ticket_id']?.toString() ?? '';
    if (ticketId.isEmpty) return;
    if (incident?['relationship']?.toString() == 'owner') {
      context.pushNamed(
        'ticketDetailPage',
        extra: _opsFixReporterFade(),
        queryParameters: {
          'ticketId': serializeParam(ticketId, ParamType.String),
        }.withoutNulls,
      );
      return;
    }
    context.pushNamed(
      'ReporterLocationTicketsPage',
      extra: _opsFixReporterFade(),
      queryParameters: {
        'locationId': serializeParam(_locationId, ParamType.String),
        'ticketId': serializeParam(ticketId, ParamType.String),
      }.withoutNulls,
    );
  }

  Future<void> _cleanupUpload(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      await SupaFlow.client.storage.from('ticket-photos').remove([path]);
    } catch (error) {
      debugPrint(
          'Unreferenced report upload cleanup failed: ${error.runtimeType}');
    }
  }

  String _incidentStatus(String value) => switch (value) {
        'reported' => OpsFixI18n.t('Baru dilaporkan'),
        'assigned' => OpsFixI18n.t('Teknisi ditetapkan'),
        'in_progress' => OpsFixI18n.t('Sedang dikerjakan'),
        'pending_verification' => OpsFixI18n.t('Menunggu verifikasi'),
        'reopened' => OpsFixI18n.t('Dibuka kembali'),
        _ => OpsFixI18n.t('Gangguan aktif'),
      };

  Widget _incidentCard() {
    final incident = _duplicateIncident;
    if (incident == null) return const SizedBox.shrink();
    final relationship = incident['relationship']?.toString() ?? 'none';
    final affected =
        int.tryParse(incident['affected_count']?.toString() ?? '') ?? 1;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8B7CF6)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Icon(Icons.groups_outlined, color: Color(0xFF6C5CE7)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              OpsFixI18n.t('Gangguan ini sudah dilaporkan'),
              style: const TextStyle(
                color: Color(0xFF111827),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            incident['ticket_code']?.toString() ?? OpsFixI18n.t('Tiket'),
            style: const TextStyle(
              color: Color(0xFF5B4CE3),
              fontWeight: FontWeight.w700,
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text(incident['target_label']?.toString() ?? _unitLabel,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(incident['issue_type']?.toString() ?? _issueLabel,
            style: const TextStyle(color: Color(0xFF64748B))),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          Chip(
              label:
                  Text(_incidentStatus(incident['status']?.toString() ?? ''))),
          Chip(label: Text(OpsFixI18n.tf('{0} orang terdampak', [affected]))),
        ]),
        const SizedBox(height: 12),
        if (relationship == 'owner')
          Text(OpsFixI18n.t('Anda sudah melaporkan gangguan ini.'),
              style: const TextStyle(color: Color(0xFF475569)))
        else if (relationship == 'supporter')
          Text(OpsFixI18n.t('Anda sudah menandai terdampak.'),
              style: const TextStyle(color: Color(0xFF475569))),
        const SizedBox(height: 10),
        Row(children: [
          if (relationship == 'none') ...[
            Expanded(
              child: FilledButton.icon(
                onPressed: _busy ? null : _joinDuplicate,
                icon: const Icon(Icons.group_add_outlined),
                label: Text(OpsFixI18n.t('Saya juga terdampak')),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: OutlinedButton(
              onPressed: _openDuplicate,
              child: Text(relationship == 'owner'
                  ? OpsFixI18n.t('Buka tiket')
                  : OpsFixI18n.t('Buka gangguan')),
            ),
          ),
        ]),
      ]),
    );
  }

  Future<void> _nextStep() async {
    if (_desktopStep == 0 && !_stepOneReady) {
      setState(() => _message = OpsFixI18n.t(
          'Pilih perangkat dan jenis gangguan sebelum melanjutkan.'));
      return;
    }
    if (_desktopStep == 0) {
      final duplicate = await _checkDuplicate(required: true);
      if (!mounted || duplicate != null || _checkingDuplicate) return;
    }
    if (_desktopStep == 1 && !_stepTwoReady) {
      setState(() => _message = OpsFixI18n.t(
          'Jelaskan gejala minimal 5 karakter dan tambahkan foto kondisi perangkat.'));
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
          Text(OpsFixI18n.t('Perangkat yang dilaporkan'),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _unitId.isEmpty ? null : _unitId,
            isExpanded: true,
            decoration: _fieldDecoration(OpsFixI18n.t('Pilih perangkat'),
                OpsFixI18n.t('Pilih unit atau perangkat')),
            items: _units.map((unit) {
              final id = unit['id']?.toString() ?? '';
              final code =
                  unit['unit_code']?.toString() ?? OpsFixI18n.t('Unit');
              final name = unit['name']?.toString().trim() ?? '';
              return DropdownMenuItem(
                value: id,
                child: Text(name.isEmpty ? code : '$code · $name',
                    overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: _busy
                ? null
                : (value) {
                    setState(() {
                      _unitId = value ?? '';
                      _resetDuplicate();
                    });
                    unawaited(_checkDuplicate());
                  },
          ),
          if (_units.isEmpty) ...[
            const SizedBox(height: 8),
            Text(OpsFixI18n.t('Belum ada perangkat aktif pada lokasi ini.'),
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
                      : () {
                          setState(() {
                            _issueTypeId = id;
                            _issueCategoryId =
                                issue['issue_category_id']?.toString() ?? '';
                            _resetDuplicate();
                          });
                          unawaited(_checkDuplicate());
                        },
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
                          _localizedIssue(issue['label']?.toString() ??
                              OpsFixI18n.t('Gangguan')),
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
          Text(OpsFixI18n.t('Jelaskan gejalanya'),
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
            decoration: _fieldDecoration(
                OpsFixI18n.t('Deskripsi masalah'),
                OpsFixI18n.t(
                    'Contoh: tombol spasi tidak merespons saat digunakan.')),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _busy ? null : _choosePhoto,
            icon: Icon(_photo == null
                ? Icons.add_a_photo_outlined
                : Icons.check_circle_outline),
            label: Text(
              _photo == null
                  ? OpsFixI18n.t('Pilih foto kondisi perangkat')
                  : OpsFixI18n.tf('Ganti foto · {0}', [_photo!.name]),
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
          Text(OpsFixI18n.t('Format JPG, PNG, atau WebP, maksimal 5 MB.'),
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
                  OpsFixI18n.t('Lokasi'),
                  FFAppState().currentLocationName.trim().isEmpty
                      ? OpsFixI18n.t('Lokasi laporan')
                      : FFAppState().currentLocationName),
              _summaryRow(OpsFixI18n.t('Perangkat'), _unitLabel),
              _summaryRow(OpsFixI18n.t('Gangguan'), _issueLabel),
              _summaryRow(OpsFixI18n.t('Deskripsi'), _description.text.trim()),
              _summaryRow(OpsFixI18n.t('Foto'),
                  _photo?.name ?? OpsFixI18n.t('Belum dipilih')),
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
                    OpsFixI18n.tf(
                        OpsFixI18n.t(
                            'Tiket {0} dengan perangkat dan gangguan serupa masih aktif. Periksa tiket tersebut atau pilih “Kirim laporan” bila ini masalah berbeda.'),
                        [_duplicateTicketCode]),
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
                    Text(OpsFixI18n.t('Progres laporan'),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(OpsFixI18n.t('Lengkapi tiga langkah berikut.'),
                        style:
                            TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    const SizedBox(height: 18),
                    _stepIndicator(
                        0,
                        OpsFixI18n.t('Perangkat & gangguan'),
                        _stepOneReady
                            ? OpsFixI18n.t('Pilihan sudah lengkap')
                            : OpsFixI18n.t('Tentukan masalah')),
                    const SizedBox(height: 5),
                    _stepIndicator(
                        1,
                        OpsFixI18n.t('Detail & bukti'),
                        _stepTwoReady
                            ? OpsFixI18n.t('Bukti sudah lengkap')
                            : OpsFixI18n.t('Jelaskan kondisi')),
                    const SizedBox(height: 5),
                    _stepIndicator(2, OpsFixI18n.t('Tinjau & kirim'),
                        OpsFixI18n.t('Pastikan laporan benar')),
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
                    Text(OpsFixI18n.t('LOKASI LAPORAN'),
                        style: TextStyle(
                            color: Color(0xFF35D0BA),
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 7),
                    Text(
                      FFAppState().currentLocationName.trim().isEmpty
                          ? OpsFixI18n.t('Lokasi belum dipilih')
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
                    _sectionTitle(
                        OpsFixI18n.t('Perangkat dan jenis gangguan'),
                        OpsFixI18n.t(
                            'Pilih objek laporan dan masalah yang paling sesuai.')),
                    const SizedBox(height: 22),
                    _devicePicker(),
                    const SizedBox(height: 20),
                    Text(OpsFixI18n.t('Pilih jenis gangguan'),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 9),
                    _localizedIssueGrid(),
                    if (_checkingDuplicate)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: LinearProgressIndicator(),
                      ),
                    if (_duplicateIncident != null) _incidentCard(),
                  ] else if (_desktopStep == 1) ...[
                    _sectionTitle(
                        OpsFixI18n.t('Detail dan bukti kondisi'),
                        OpsFixI18n.t(
                            'Jelaskan gejala yang terlihat dan lampirkan foto terbaru.')),
                    const SizedBox(height: 22),
                    _detailsAndPhoto(),
                  ] else ...[
                    _sectionTitle(
                        OpsFixI18n.t('Tinjau laporan'),
                        OpsFixI18n.t(
                            'Pastikan informasi berikut sudah benar sebelum dikirim.')),
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
                          child: Text(OpsFixI18n.t('Kembali')),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: _desktopStep > 0 ? 2 : 1,
                      child: FilledButton.icon(
                        onPressed: _busy ||
                                _checkingDuplicate ||
                                _duplicateIncident != null
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
                            ? OpsFixI18n.t('Mengirim…')
                            : _desktopStep < 2
                                ? OpsFixI18n.t('Lanjutkan')
                                : OpsFixI18n.t('Kirim laporan')),
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
            _sectionTitle(
                OpsFixI18n.t('Buat laporan terstruktur'),
                OpsFixI18n.t(
                    'Lengkapi informasi berikut agar laporan mudah diproses.')),
            const SizedBox(height: 18),
            _devicePicker(),
            const SizedBox(height: 18),
            Text(OpsFixI18n.t('Pilih jenis gangguan'),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _localizedIssueGrid(),
            if (_checkingDuplicate)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(),
              ),
            if (_duplicateIncident != null)
              _incidentCard()
            else ...[
              const SizedBox(height: 18),
              _detailsAndPhoto(),
            ],
            _messagePanel(),
            if (_duplicateIncident == null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _busy || _checkingDuplicate ? null : _submit,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.send_outlined),
                label: Text(_busy
                    ? OpsFixI18n.t('Mengirim…')
                    : OpsFixI18n.t('Kirim laporan')),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: const Color(0xFF6C5CE7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
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
