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
import '/custom_code/widgets/ops_fix_responsive_unit_form.dart';
import '/custom_code/widgets/ops_fix_responsive_location_qr_panel.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OpsFixAdminLocationDetailContent extends StatefulWidget {
  const OpsFixAdminLocationDetailContent({
    super.key,
    this.width,
    this.height,
    required this.locationId,
  });

  final double? width;
  final double? height;
  final String locationId;

  @override
  State<OpsFixAdminLocationDetailContent> createState() =>
      OpsFixAdminLocationDetailContentState();
}

class OpsFixAdminLocationDetailContentState
    extends State<OpsFixAdminLocationDetailContent> {
  Map<String, dynamic>? _location;
  List<Map<String, dynamic>> _units = [];
  String _sitePublicUrl = '';
  String _qrUrl = '';
  bool _loading = true;
  bool _refreshing = false;
  String? _error;
  int _requestSerial = 0;

  String get _siteId => FFAppState().currentSiteId.trim();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> refresh() => _load(refreshing: true);

  Future<void> _load({bool refreshing = false}) async {
    if (refreshing && _refreshing) return;
    final siteId = _siteId;
    final locationId = widget.locationId.trim();
    final serial = ++_requestSerial;
    if (siteId.isEmpty || locationId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _error = 'Lokasi tidak valid atau situs aktif belum dipilih.';
      });
      return;
    }
    setState(() {
      if (refreshing) {
        _refreshing = true;
      } else {
        _loading = true;
      }
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        SupaFlow.client
            .from('locations')
            .select(
              'id,site_id,code,name,slug,location_type,building,floor,'
              'zone_code,description,is_active',
            )
            .eq('id', locationId)
            .eq('site_id', siteId)
            .eq('is_active', true)
            .maybeSingle(),
        SupaFlow.client
            .from('maintenance_units')
            .select(
              'id,site_id,location_id,unit_code,code_sort,name,category_code,'
              'position_label,component_options,criticality,condition,is_active',
            )
            .eq('location_id', locationId)
            .eq('site_id', siteId)
            .eq('is_active', true)
            .order('code_sort', ascending: true),
        actions.loadOpsFixSitePublicUrl(siteId),
        actions.loadOpsFixLocationQrUrl(locationId),
      ]);
      if (!mounted || serial != _requestSerial) return;
      final rawLocation = results[0];
      if (rawLocation == null) {
        setState(() {
          _loading = false;
          _refreshing = false;
          _location = null;
          _units = [];
          _error = 'Lokasi tidak ditemukan atau tidak dapat diakses.';
        });
        return;
      }
      setState(() {
        _location = Map<String, dynamic>.from(rawLocation as Map);
        _units = (results[1] as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _sitePublicUrl = results[2]?.toString() ?? '';
        _qrUrl = results[3]?.toString() ?? '';
        _loading = false;
        _refreshing = false;
      });
    } catch (_) {
      if (!mounted || serial != _requestSerial) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _error = 'Detail lokasi gagal dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  String _value(Map<String, dynamic>? row, String key) =>
      row?[key]?.toString().trim() ?? '';

  Future<bool?> _showAdaptive(
    Widget child, {
    required double dialogWidth,
  }) {
    final size = MediaQuery.sizeOf(context);
    if (size.width < 480) {
      return showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.92,
            ),
            child: child,
          ),
        ),
      );
    }
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
            maxHeight: size.height * 0.88,
          ),
          child: child,
        ),
      ),
    );
  }

  Future<void> openCreateForm() async {
    if (_siteId.isEmpty ||
        widget.locationId.trim().isEmpty ||
        _location == null) {
      _snack('Lokasi belum siap untuk menerima unit baru.', error: true);
      return;
    }
    final changed = await _showAdaptive(
      OpsFixResponsiveUnitForm(
        mode: 'create',
        siteId: _siteId,
        locationId: widget.locationId,
      ),
      dialogWidth: MediaQuery.sizeOf(context).width >= 1200 ? 820 : 720,
    );
    if (changed == true && mounted) {
      await _load();
      _snack('Unit berhasil ditambahkan.');
    }
  }

  Future<void> _openQr() async {
    if (_location == null) return;
    final changed = await _showAdaptive(
      OpsFixResponsiveLocationQrPanel(
        siteId: _siteId,
        locationId: widget.locationId,
        qrUrl: _qrUrl,
        sitePublicUrl: _sitePublicUrl,
      ),
      dialogWidth: 640,
    );
    if (changed == true && mounted) {
      await _load();
      _snack('URL publik tersimpan. QR lokasi telah diperbarui.');
    }
  }

  void _snack(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              error ? const Color(0xFFB91C1C) : const Color(0xFF111827),
        ),
      );
  }

  void _openUnit(Map<String, dynamic> unit) {
    final id = _value(unit, 'id');
    final code = _value(unit, 'unit_code');
    if (id.isEmpty) {
      _snack('Data aset tidak valid.', error: true);
      return;
    }
    context.pushNamed(
      'AdminAssetDetailPage',
      queryParameters: {
        'unitId': id,
        'locationId': widget.locationId,
        'assetCode': code,
      },
    );
  }

  String _typeLabel(String value) => switch (value) {
        'room' => 'Ruangan',
        'corridor' => 'Koridor',
        'toilet' => 'Toilet',
        'parking' => 'Parkir',
        'outdoor' => 'Luar ruang',
        _ => 'Lainnya',
      };

  String _conditionLabel(String value) => switch (value) {
        'operational' => 'Operasional',
        'needs_attention' => 'Perlu perhatian',
        'out_of_service' => 'Tidak beroperasi',
        'retired' => 'Dipensiunkan',
        _ => 'Status diperbarui',
      };

  String _criticalityLabel(String value) => switch (value) {
        'low' => 'Rendah',
        'medium' => 'Sedang',
        'high' => 'Tinggi',
        _ => 'Tidak diketahui',
      };

  Color _conditionColor(String value) => switch (value) {
        'operational' => const Color(0xFF047857),
        'needs_attention' => const Color(0xFFB45309),
        'out_of_service' => const Color(0xFFB91C1C),
        _ => const Color(0xFF64748B),
      };

  Widget _fact(IconData icon, String label, String value) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 15, color: const Color(0xFF64748B)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                value.isEmpty ? 'Belum diisi' : value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _identityPanel() {
    final name = _value(_location, 'name');
    final code = _value(_location, 'code');
    final description = _value(_location, 'description');
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1426),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x17081225),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF18243A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.location_city_outlined,
                  color: Color(0xFF99F6E4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? 'Lokasi tanpa nama' : name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      code.isEmpty ? '-' : code,
                      style: const TextStyle(
                        color: Color(0xFF99F6E4),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF17233D),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(
                    color: Color(0xFF6EE7B7),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 58,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                description.isEmpty
                    ? 'Belum ada deskripsi lokasi.'
                    : description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contextPanel() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _fact(
                  Icons.apartment_outlined,
                  'Gedung',
                  _value(_location, 'building'),
                ),
                const SizedBox(width: 8),
                _fact(
                  Icons.layers_outlined,
                  'Lantai',
                  _value(_location, 'floor'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _fact(
                  Icons.category_outlined,
                  'Tipe',
                  _typeLabel(_value(_location, 'location_type')),
                ),
                const SizedBox(width: 8),
                _fact(
                  Icons.map_outlined,
                  'Zona',
                  _value(_location, 'zone_code'),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_units.length} unit aktif',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _openQr,
                  icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                  label: const Text('QR lokasi'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6C5CE7),
                    side: const BorderSide(color: Color(0xFF6C5CE7)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _unitCard(Map<String, dynamic> unit, bool compact) {
    final condition = _value(unit, 'condition');
    final color = _conditionColor(condition);
    return SizedBox(
      height: compact ? 150 : 188,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openUnit(unit),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFDDE2E7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EDFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFF6C5CE7),
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _value(unit, 'unit_code'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _value(unit, 'name'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF6C5CE7),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _value(unit, 'position_label').isEmpty
                      ? 'Posisi belum diisi'
                      : _value(unit, 'position_label'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _value(unit, 'category_code').isEmpty
                            ? 'Tanpa kategori'
                            : _value(unit, 'category_code'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF334155),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!compact)
                      Text(
                        _criticalityLabel(_value(unit, 'criticality')),
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _conditionLabel(condition),
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _feedback(String title, String message, {bool retry = false}) =>
      Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 300),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off_outlined,
              color: Color(0xFF6C5CE7),
              size: 34,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
            if (retry) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba lagi'),
              ),
            ],
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final padding = screenWidth < 480
        ? 14.0
        : screenWidth < 800
            ? 20.0
            : screenWidth < 1200
                ? 24.0
                : 32.0;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(padding, 22, padding, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final available = constraints.maxWidth;
                  final columns = available >= 1080
                      ? 3
                      : available >= 680
                          ? 2
                          : 1;
                  const gap = 16.0;
                  final cardWidth = (available - (columns - 1) * gap) / columns;
                  final splitOverview = screenWidth >= 800;
                  if (_loading) {
                    return _feedback(
                      'Memuat lokasi…',
                      'Mengambil lokasi, unit, dan konfigurasi QR.',
                    );
                  }
                  if (_error != null) {
                    return _feedback(
                      'Detail lokasi belum tersedia',
                      _error!,
                      retry: true,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'ADMIN · ASSET REGISTRY',
                        style: TextStyle(
                          color: Color(0xFF6C5CE7),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Pilih unit untuk melihat detail aset.',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Unit aktif di lokasi ini siap dipantau dan dikelola.',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (splitOverview)
                        SizedBox(
                          height: 250,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(flex: 7, child: _identityPanel()),
                              const SizedBox(width: 16),
                              Expanded(flex: 5, child: _contextPanel()),
                            ],
                          ),
                        )
                      else ...[
                        SizedBox(height: 210, child: _identityPanel()),
                        const SizedBox(height: 14),
                        SizedBox(height: 245, child: _contextPanel()),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daftar unit',
                                  style: TextStyle(
                                    color: Color(0xFF111827),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Tekan unit untuk membuka detail aset.',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_refreshing)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_units.isEmpty)
                        _feedback(
                          'Belum ada unit aktif',
                          'Gunakan tombol Tambah unit untuk membuat aset '
                              'pertama pada lokasi ini.',
                        )
                      else
                        Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final unit in _units)
                              SizedBox(
                                width: cardWidth,
                                child: _unitCard(
                                  unit,
                                  columns == 1 && screenWidth < 680,
                                ),
                              ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
