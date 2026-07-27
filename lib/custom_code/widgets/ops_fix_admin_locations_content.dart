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
import '/custom_code/widgets/ops_fix_responsive_location_form.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OpsFixAdminLocationsContent extends StatefulWidget {
  const OpsFixAdminLocationsContent({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<OpsFixAdminLocationsContent> createState() =>
      OpsFixAdminLocationsContentState();
}

class OpsFixAdminLocationsContentState
    extends State<OpsFixAdminLocationsContent> {
  static const _selectFields =
      'id,site_id,code,name,slug,location_type,building,floor,'
      'zone_code,description,is_active';

  List<Map<String, dynamic>> _locations = [];
  bool _loading = true;
  bool _refreshing = false;
  String? _error;
  String? _archivingId;
  int _requestSerial = 0;

  String get _siteId => FFAppState().currentSiteId.trim();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLocations());
  }

  Future<void> refresh() => _loadLocations(refreshing: true);

  Future<void> _loadLocations({bool refreshing = false}) async {
    if (refreshing && _refreshing) return;
    final siteId = _siteId;
    final serial = ++_requestSerial;
    if (siteId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _locations = [];
        _error = 'Situs aktif belum dipilih. Masuk ulang lalu coba lagi.';
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
      final dynamic response = await SupaFlow.client
          .from('locations')
          .select(_selectFields)
          .eq('site_id', siteId)
          .eq('is_active', true)
          .order('code', ascending: true);
      if (!mounted || serial != _requestSerial) return;
      final rows = (response as List)
          .map(
            (row) => Map<String, dynamic>.from(row as Map),
          )
          .toList();
      setState(() {
        _locations = rows;
        _loading = false;
        _refreshing = false;
      });
    } catch (_) {
      if (!mounted || serial != _requestSerial) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _error = 'Daftar lokasi gagal dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  void _showMessage(String message, {bool error = false}) {
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

  String _value(Map<String, dynamic> row, String key) =>
      row[key]?.toString().trim() ?? '';

  Future<void> _openLocationForm([
    Map<String, dynamic>? location,
  ]) async {
    final siteId = _siteId;
    if (siteId.isEmpty) {
      _showMessage('Situs aktif belum dipilih.', error: true);
      return;
    }
    final screen = MediaQuery.sizeOf(context);
    final isPhone = screen.width < 480;
    final form = OpsFixResponsiveLocationForm(
      mode: location == null ? 'create' : 'edit',
      siteId: siteId,
      locationId: location == null ? '' : _value(location, 'id'),
      code: location == null ? '' : _value(location, 'code'),
      locationName: location == null ? '' : _value(location, 'name'),
      locationType:
          location == null ? 'room' : _value(location, 'location_type'),
      building: location == null ? '' : _value(location, 'building'),
      floor: location == null ? '' : _value(location, 'floor'),
      zoneCode: location == null ? '' : _value(location, 'zone_code'),
      description: location == null ? '' : _value(location, 'description'),
      slug: location == null ? '' : _value(location, 'slug'),
    );

    bool? changed;
    if (isPhone) {
      changed = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) {
          final viewInsets = MediaQuery.viewInsetsOf(sheetContext);
          final size = MediaQuery.sizeOf(sheetContext);
          return Padding(
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.height * 0.92),
              child: form,
            ),
          );
        },
      );
    } else {
      changed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          final size = MediaQuery.sizeOf(dialogContext);
          final maxWidth = size.width >= 1200 ? 820.0 : 720.0;
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: size.height * 0.88,
              ),
              child: form,
            ),
          );
        },
      );
    }

    if (changed == true && mounted) {
      await _loadLocations();
      _showMessage(
        location == null
            ? 'Lokasi berhasil ditambahkan.'
            : 'Lokasi berhasil diperbarui.',
      );
    }
  }

  Future<void> _archiveLocation(Map<String, dynamic> location) async {
    final id = _value(location, 'id');
    if (id.isEmpty || _archivingId != null) return;
    final name = _value(location, 'name');
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Text('Arsipkan lokasi'),
            content: Text(
              '${name.isEmpty ? 'Lokasi ini' : name} dan unit aktifnya akan '
              'diarsipkan. Riwayat tiket dan pemeliharaan tetap tersimpan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB91C1C),
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Arsipkan'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed || !mounted) return;

    setState(() => _archivingId = id);
    String resultCode = 'network_error';
    try {
      final response = await SupaFlow.client.rpc(
        'archive_opsfix_location',
        params: {'p_location_id': id},
      );
      final result = Map<String, dynamic>.from(response as Map);
      resultCode = result['code']?.toString() ?? 'network_error';
    } catch (_) {
      resultCode = 'network_error';
    }
    if (!mounted) return;
    setState(() => _archivingId = null);

    switch (resultCode) {
      case 'archived':
        await _loadLocations();
        _showMessage('Lokasi berhasil diarsipkan.');
      case 'has_open_tickets':
        _showMessage(
          'Lokasi belum dapat diarsipkan karena masih memiliki tiket terbuka.',
          error: true,
        );
      case 'access_denied':
        _showMessage(
          'Anda tidak memiliki akses untuk mengarsipkan lokasi ini.',
          error: true,
        );
      default:
        _showMessage(
          'Lokasi gagal diarsipkan. Periksa koneksi lalu coba lagi.',
          error: true,
        );
    }
  }

  void _openDetail(Map<String, dynamic> location) {
    final id = _value(location, 'id');
    if (id.isEmpty) {
      _showMessage('Data lokasi tidak valid.', error: true);
      return;
    }
    FFAppState().currentLocationId = id;
    FFAppState().update(() {});
    context.pushNamed(
      'AdminAssetLocationDetailPage',
      queryParameters: {'locationId': id},
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

  IconData _typeIcon(String value) => switch (value) {
        'corridor' => Icons.view_week_outlined,
        'toilet' => Icons.wc_outlined,
        'parking' => Icons.local_parking_outlined,
        'outdoor' => Icons.park_outlined,
        _ => Icons.meeting_room_outlined,
      };

  Widget _fact(
    IconData icon,
    String label,
    String value,
  ) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
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
                style: TextStyle(
                  color: value.isEmpty
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF111827),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _locationCard(
    Map<String, dynamic> location, {
    required bool horizontal,
  }) {
    final id = _value(location, 'id');
    final code = _value(location, 'code');
    final name = _value(location, 'name');
    final type = _value(location, 'location_type');
    final building = _value(location, 'building');
    final floor = _value(location, 'floor');
    final zone = _value(location, 'zone_code');
    final description = _value(location, 'description');
    final archiving = _archivingId == id;

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EDFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _typeIcon(type),
            color: const Color(0xFF6C5CE7),
            size: 22,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? 'Lokasi tanpa nama' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                code.isEmpty ? '-' : code,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFE5F7F0),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'Aktif',
            style: TextStyle(
              color: Color(0xFF047857),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );

    final facts = Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fact(Icons.apartment_outlined, 'Gedung', building),
            const SizedBox(width: 8),
            _fact(Icons.layers_outlined, 'Lantai', floor),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fact(Icons.category_outlined, 'Tipe', _typeLabel(type)),
            const SizedBox(width: 8),
            _fact(Icons.map_outlined, 'Zona', zone),
          ],
        ),
      ],
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        facts,
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              description.isEmpty ? 'Belum ada deskripsi lokasi.' : description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: description.isEmpty
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );

    final actions = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: archiving ? null : () => _openLocationForm(location),
                icon: const Icon(Icons.edit_outlined, size: 17),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6C5CE7),
                  side: const BorderSide(color: Color(0xFFCFC7FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: archiving ? null : () => _archiveLocation(location),
                icon: archiving
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.archive_outlined, size: 17),
                label: const Text('Hapus'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFB91C1C),
                  side: const BorderSide(color: Color(0xFFFECACA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: archiving ? null : () => _openDetail(location),
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: const Text('Lihat lokasi & unit'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6C5CE7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE2E7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: horizontal
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: details),
                    const SizedBox(width: 16),
                    Expanded(flex: 4, child: actions),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                const SizedBox(height: 14),
                details,
                const SizedBox(height: 16),
                actions,
              ],
            ),
    );
  }

  Widget _feedback({
    required IconData icon,
    required String title,
    required String message,
    bool retry = false,
  }) =>
      Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 310),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE2E7)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFF6C5CE7), size: 28),
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
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B), height: 1.4),
            ),
            if (retry) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _loadLocations,
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
    final horizontalPadding = screenWidth < 480
        ? 14.0
        : screenWidth < 800
            ? 20.0
            : screenWidth < 1200
                ? 24.0
                : 32.0;
    final horizontalCard = screenWidth >= 480 && screenWidth < 680;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            22,
            horizontalPadding,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final columns = availableWidth >= 1080
                      ? 3
                      : availableWidth >= 680
                          ? 2
                          : 1;
                  const gap = 16.0;
                  final cardWidth =
                      (availableWidth - (columns - 1) * gap) / columns;

                  final titleBlock = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Kelola lokasi dan aset.',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Kelola lokasi operasional. Daftar unit tersedia '
                        'pada halaman detail setiap lokasi.',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  );

                  final addButton = FilledButton.icon(
                    onPressed: _loading ? null : () => _openLocationForm(),
                    icon: const Icon(Icons.add_location_alt_outlined, size: 19),
                    label: const Text('Tambah'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (availableWidth < 350)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleBlock,
                            const SizedBox(height: 14),
                            addButton,
                          ],
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: titleBlock),
                            const SizedBox(width: 14),
                            addButton,
                          ],
                        ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EDFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_locations.length} lokasi aktif',
                              style: const TextStyle(
                                color: Color(0xFF6C5CE7),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (_refreshing) ...[
                            const SizedBox(width: 10),
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (_loading)
                        _feedback(
                          icon: Icons.location_searching_outlined,
                          title: 'Memuat lokasi…',
                          message:
                              'Mengambil daftar lokasi aktif dari Supabase.',
                        )
                      else if (_error != null)
                        _feedback(
                          icon: Icons.cloud_off_outlined,
                          title: 'Lokasi belum dapat dimuat',
                          message: _error!,
                          retry: true,
                        )
                      else if (_locations.isEmpty)
                        _feedback(
                          icon: Icons.add_location_alt_outlined,
                          title: 'Belum ada lokasi aktif',
                          message: 'Gunakan tombol Tambah untuk membuat lokasi '
                              'operasional pertama pada situs ini.',
                        )
                      else
                        Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final location in _locations)
                              SizedBox(
                                width: cardWidth,
                                child: _locationCard(
                                  location,
                                  horizontal: horizontalCard && columns == 1,
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
