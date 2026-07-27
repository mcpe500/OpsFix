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
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/ops_fix_responsive_maintenance_note_form.dart';

class OpsFixAdminAssetDetailContent extends StatefulWidget {
  const OpsFixAdminAssetDetailContent({
    super.key,
    this.width,
    this.height,
    required this.unitId,
    required this.locationId,
    required this.assetCode,
  });

  final double? width;
  final double? height;
  final String unitId;
  final String locationId;
  final String assetCode;

  @override
  State<OpsFixAdminAssetDetailContent> createState() =>
      OpsFixAdminAssetDetailContentState();
}

class OpsFixAdminAssetDetailContentState
    extends State<OpsFixAdminAssetDetailContent> {
  bool _loading = true;
  bool _refreshing = false;
  bool _archiving = false;
  String? _error;
  Map<String, dynamic>? _unit;
  List<Map<String, dynamic>> _notes = const [];

  String get _siteId => FFAppState().currentSiteId.trim();
  String get _resolvedUnitId => _unit?['id']?.toString() ?? '';
  String get _resolvedLocationId =>
      _unit?['location_id']?.toString() ?? widget.locationId.trim();
  String get _unitCode =>
      _unit?['unit_code']?.toString() ?? widget.assetCode.trim();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool showSpinner = true}) async {
    if (!mounted) return;
    final siteId = _siteId;
    final requestedUnitId = widget.unitId.trim();
    final assetCode = widget.assetCode.trim();
    if (siteId.isEmpty || (requestedUnitId.isEmpty && assetCode.isEmpty)) {
      setState(() {
        _loading = false;
        _refreshing = false;
        _unit = null;
        _notes = const [];
        _error = 'Aset tidak valid atau situs aktif belum dipilih.';
      });
      return;
    }
    setState(() {
      if (showSpinner) _loading = true;
      _refreshing = !showSpinner;
      _error = null;
    });
    try {
      dynamic query = SupaFlow.client
          .from('maintenance_units')
          .select(
            'id,site_id,location_id,unit_code,code_sort,name,category_code,'
            'position_label,component_options,criticality,condition,is_active,'
            'updated_at',
          )
          .eq('site_id', siteId);
      query = requestedUnitId.isNotEmpty
          ? query.eq('id', requestedUnitId)
          : query.eq('unit_code', assetCode);
      final rawUnit = await query.maybeSingle();
      if (rawUnit == null) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _refreshing = false;
          _unit = null;
          _notes = const [];
          _error = 'Aset tidak ditemukan atau tidak dapat diakses.';
        });
        return;
      }
      final unit = Map<String, dynamic>.from(rawUnit as Map);
      final resolvedUnitId = unit['id']?.toString() ?? '';
      final rawNotes = await SupaFlow.client
          .from('maintenance_note_cards_v')
          .select(
            'id,site_id,location_id,unit_id,author_name,note_type,note,'
            'performed_at,created_at',
          )
          .eq('unit_id', resolvedUnitId)
          .eq('site_id', siteId)
          .order('performed_at', ascending: true);
      if (!mounted) return;
      setState(() {
        _unit = unit;
        _notes = (rawNotes as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList(growable: false);
        _loading = false;
        _refreshing = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _error = 'Data aset gagal dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  void backToLocation() {
    final locationId = _resolvedLocationId;
    if (locationId.isEmpty) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      return;
    }
    context.pushNamed(
      'AdminAssetLocationDetailPage',
      queryParameters: {'locationId': locationId},
    );
  }

  String _conditionLabel(String value) => switch (value) {
        'operational' => 'Operasional',
        'needs_attention' => 'Perlu perhatian',
        'out_of_service' => 'Tidak beroperasi',
        'retired' => 'Dipensiunkan',
        _ => value.trim().isEmpty ? 'Tidak diketahui' : value,
      };

  String _criticalityLabel(String value) => switch (value) {
        'low' => 'Rendah',
        'medium' => 'Sedang',
        'high' => 'Tinggi',
        _ => value.trim().isEmpty ? 'Tidak diketahui' : value,
      };

  String _noteTypeLabel(String value) => switch (value) {
        'inspection' => 'Inspeksi',
        'preventive' => 'Preventif',
        'corrective' => 'Korektif',
        'other' => 'Lainnya',
        _ => 'Catatan',
      };

  Color _noteTypeColor(String value) => switch (value) {
        'inspection' => const Color(0xFF2563EB),
        'preventive' => const Color(0xFF059669),
        'corrective' => const Color(0xFFD97706),
        _ => const Color(0xFF64748B),
      };

  String _formatDate(dynamic raw) {
    final parsed = DateTime.tryParse(raw?.toString() ?? '');
    if (parsed == null) return '-';
    final local = parsed.toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} · '
        '${two(local.hour)}:${two(local.minute)}';
  }

  String _safe(dynamic value, {String fallback = '-'}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  Future<void> _openNoteForm() async {
    if (_resolvedUnitId.isEmpty) return;
    final size = MediaQuery.sizeOf(context);
    final phone = size.width < 480;
    bool? changed;
    if (phone) {
      changed = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => Padding(
          padding: MediaQuery.viewInsetsOf(sheetContext),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.92,
            ),
            child: OpsFixResponsiveMaintenanceNoteForm(
              unitId: _resolvedUnitId,
            ),
          ),
        ),
      );
    } else {
      changed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 28,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width >= 1200 ? 680 : 620,
              maxHeight: size.height * 0.88,
            ),
            child: OpsFixResponsiveMaintenanceNoteForm(
              unitId: _resolvedUnitId,
            ),
          ),
        ),
      );
    }
    if (changed == true && mounted) {
      await _load(showSpinner: false);
    }
  }

  Future<void> _editAsset() async {
    if (_resolvedUnitId.isEmpty || _resolvedLocationId.isEmpty) return;
    await actions.openOpsFixUnitEditor(
      context,
      _siteId,
      _resolvedUnitId,
      _resolvedLocationId,
      _unitCode,
    );
  }

  void _snackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _archiveConfirmationContent(BuildContext overlayContext) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDE2E7)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.archive_outlined,
                      color: Color(0xFFB91C1C),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Arsipkan aset?',
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_safe(_unit?['unit_code'])} · '
                          '${_safe(_unit?['name'])}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(overlayContext, false),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFED7AA)),
                ),
                child: const Text(
                  'Aset akan dinonaktifkan. Tiket dan catatan lama tetap '
                  'tersimpan. Aset dengan tiket terbuka tidak dapat '
                  'diarsipkan.',
                  style: TextStyle(
                    color: Color(0xFF9A3412),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(overlayContext, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF475569),
                        side: const BorderSide(color: Color(0xFFDDE2E7)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(overlayContext, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFB91C1C),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.archive_outlined, size: 18),
                      label: const Text('Arsipkan aset'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Future<bool> _confirmArchive() async {
    final size = MediaQuery.sizeOf(context);
    if (size.width < 480) {
      return await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (sheetContext) => Padding(
              padding: MediaQuery.viewInsetsOf(sheetContext),
              child: SafeArea(
                top: false,
                child: _archiveConfirmationContent(sheetContext),
              ),
            ),
          ) ??
          false;
    }
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: _archiveConfirmationContent(dialogContext),
            ),
          ),
        ) ??
        false;
  }

  Future<void> _archiveAsset() async {
    if (_resolvedUnitId.isEmpty || _archiving) return;
    final confirmed = await _confirmArchive();
    if (!confirmed || !mounted) return;
    setState(() => _archiving = true);
    String code = 'network_error';
    try {
      final response = await SupaFlow.client.rpc(
        'archive_opsfix_unit',
        params: {'p_unit_id': _resolvedUnitId},
      );
      final result = Map<String, dynamic>.from(response as Map);
      code = result['code']?.toString() ?? 'network_error';
    } catch (_) {
      code = 'network_error';
    }
    if (!mounted) return;
    setState(() => _archiving = false);
    if (code == 'archived') {
      _snackbar('Aset berhasil diarsipkan.');
      context.pushReplacementNamed(
        'AdminAssetLocationDetailPage',
        queryParameters: {'locationId': _resolvedLocationId},
      );
      return;
    }
    _snackbar(
      switch (code) {
        'has_open_tickets' =>
          'Aset belum dapat diarsipkan karena masih memiliki tiket terbuka.',
        'access_denied' =>
          'Anda tidak memiliki akses manajer untuk mengarsipkan aset ini.',
        _ => 'Aset gagal diarsipkan. Periksa koneksi lalu coba lagi.',
      },
    );
  }

  Widget _surface({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(18),
    Color color = Colors.white,
    Color borderColor = const Color(0xFFDDE2E7),
  }) =>
      Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D0F172A),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: child,
      );

  Widget _hero() {
    final unit = _unit!;
    final condition = _safe(unit['condition'], fallback: 'unknown');
    final active = unit['is_active'] == true;
    return _surface(
      color: const Color(0xFF0B1426),
      borderColor: const Color(0xFF1E293B),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.desktop_windows_outlined,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF143A32)
                      : const Color(0xFF3F2530),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _conditionLabel(condition),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: active
                        ? const Color(0xFF6EE7B7)
                        : const Color(0xFFFDA4AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            _safe(unit['unit_code']),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _safe(unit['name']),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF94A3B8),
                size: 19,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _safe(unit['position_label'],
                      fallback: 'Posisi belum ditentukan'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fact(String label, String value, IconData icon) => Container(
        height: 76,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8ECF1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 15, color: const Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Expanded(
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _factGrid(List<Widget> facts) => LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 520 ? 2 : 1;
          const gap = 10.0;
          final cellWidth = columns == 2
              ? (constraints.maxWidth - gap) / 2
              : constraints.maxWidth;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: facts
                .map((fact) => SizedBox(width: cellWidth, child: fact))
                .toList(),
          );
        },
      );

  Widget _informationCard() {
    final unit = _unit!;
    final rawComponents = unit['component_options'];
    final components = rawComponents is List
        ? rawComponents.map((value) => value.toString()).join(', ')
        : _safe(rawComponents);
    return _surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi aset',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _factGrid([
            _fact(
              'Kategori',
              _safe(unit['category_code']),
              Icons.category_outlined,
            ),
            _fact(
              'Kondisi',
              _conditionLabel(_safe(unit['condition'], fallback: 'unknown')),
              Icons.health_and_safety_outlined,
            ),
            _fact(
              'Kritikalitas',
              _criticalityLabel(
                _safe(unit['criticality'], fallback: 'unknown'),
              ),
              Icons.priority_high,
            ),
            _fact(
              'Posisi',
              _safe(unit['position_label']),
              Icons.place_outlined,
            ),
            _fact(
              'Kode unit',
              _safe(unit['unit_code']),
              Icons.tag,
            ),
            _fact(
              'Komponen',
              components.isEmpty ? '-' : components,
              Icons.memory_outlined,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _systemCard() {
    final unit = _unit!;
    final active = unit['is_active'] == true;
    return _surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status sistem',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _factGrid([
            _fact(
              'Status aset',
              active ? 'Aset aktif' : 'Aset diarsipkan',
              active ? Icons.check_circle_outline : Icons.archive_outlined,
            ),
            _fact(
              'Lokasi induk',
              'QR tersedia pada lokasi',
              Icons.qr_code_2,
            ),
            _fact(
              'Diperbarui',
              _formatDate(unit['updated_at']),
              Icons.update,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _actionPanel(double availableWidth) {
    final stack = availableWidth < 400;
    final edit = OutlinedButton.icon(
      onPressed: _editAsset,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6C5CE7),
        side: const BorderSide(color: Color(0xFF6C5CE7)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.edit_outlined, size: 18),
      label: const Text('Edit aset'),
    );
    final archive = OutlinedButton.icon(
      onPressed: _archiving ? null : _archiveAsset,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFDC2626),
        side: const BorderSide(color: Color(0xFFFCA5A5)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: _archiving
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFDC2626),
              ),
            )
          : const Icon(Icons.archive_outlined, size: 18),
      label: Text(_archiving ? 'Mengarsipkan…' : 'Hapus'),
    );
    return _surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tindakan aset',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Perbarui informasi atau arsipkan aset dengan aman.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(height: 14),
          if (stack) ...[
            edit,
            const SizedBox(height: 10),
            archive,
          ] else
            Row(
              children: [
                Expanded(child: edit),
                const SizedBox(width: 10),
                Expanded(child: archive),
              ],
            ),
        ],
      ),
    );
  }

  Widget _noteTypeBadge(String type) {
    final color = _noteTypeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _noteTypeLabel(type),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _compactNoteCard(Map<String, dynamic> note) {
    final type = _safe(note['note_type'], fallback: 'other');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(child: _noteTypeBadge(type)),
              const Spacer(),
              Flexible(
                child: Text(
                  _formatDate(note['performed_at']),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _safe(note['note']),
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 15,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  _safe(note['author_name'], fallback: 'Manajer'),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _noteTableHeader() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EDFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 112,
              child: Text(
                'Jenis',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Catatan',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 150,
              child: Text(
                'Oleh',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 158,
              child: Text(
                'Waktu',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _noteTableRow(Map<String, dynamic> note) {
    final type = _safe(note['note_type'], fallback: 'other');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8ECF1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 112,
              child: Align(
                alignment: Alignment.topLeft,
                child: _noteTypeBadge(type),
              )),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _safe(note['note']),
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 150,
            child: Text(
              _safe(note['author_name'], fallback: 'Manajer'),
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 158,
            child: Text(
              _formatDate(note['performed_at']),
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _maintenanceCard(double availableWidth) => _surface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pemeliharaan aset',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Riwayat append-only untuk unit ini.',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: _openNoteForm,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah catatan'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_notes.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8ECF1)),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.history_toggle_off,
                      size: 34,
                      color: Color(0xFF94A3B8),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Belum ada catatan pemeliharaan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else if (availableWidth >= 900) ...[
              _noteTableHeader(),
              const SizedBox(height: 8),
              for (var index = 0; index < _notes.length; index++) ...[
                _noteTableRow(_notes[index]),
                if (index < _notes.length - 1) const SizedBox(height: 8),
              ],
            ] else
              for (var index = 0; index < _notes.length; index++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: index < _notes.length - 1 ? 10 : 0,
                  ),
                  child: _compactNoteCard(_notes[index]),
                ),
          ],
        ),
      );

  Widget _singleColumn(double available) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _hero(),
          const SizedBox(height: 14),
          _actionPanel(available),
          const SizedBox(height: 14),
          _informationCard(),
          const SizedBox(height: 14),
          _systemCard(),
          const SizedBox(height: 14),
          _maintenanceCard(available),
        ],
      );

  Widget _wideLayout(double available) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Independent columns avoid row-height gaps when card content differs.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _hero(),
                    const SizedBox(height: 16),
                    _systemCard(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _informationCard(),
                    const SizedBox(height: 16),
                    _actionPanel(available * 7 / 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _maintenanceCard(available),
        ],
      );

  Widget _feedback({
    required IconData icon,
    required String title,
    required String message,
    bool retry = false,
  }) =>
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: _surface(
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EDFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: const Color(0xFF6C5CE7)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                  if (retry) ...[
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _load,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba lagi'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
      );
    }
    if (_unit == null) {
      return _feedback(
        icon: Icons.inventory_2_outlined,
        title: 'Aset tidak tersedia',
        message: _error ?? 'Aset tidak ditemukan atau tidak dapat diakses.',
        retry: true,
      );
    }
    if (_error != null) {
      return _feedback(
        icon: Icons.cloud_off_outlined,
        title: 'Data gagal dimuat',
        message: _error!,
        retry: true,
      );
    }
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 480
        ? 14.0
        : screenWidth < 800
            ? 20.0
            : screenWidth < 1200
                ? 24.0
                : 32.0;
    return RefreshIndicator(
      onRefresh: () => _load(showSpinner: false),
      color: const Color(0xFF6C5CE7),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          20,
          horizontalPadding,
          28,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final available = constraints.maxWidth;
                final content = available >= 680
                    ? _wideLayout(available)
                    : _singleColumn(available);
                return Stack(
                  children: [
                    content,
                    if (_refreshing)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF6C5CE7),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
