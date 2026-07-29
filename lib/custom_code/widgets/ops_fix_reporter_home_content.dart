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
import '/auth/supabase_auth/auth_util.dart';
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

class OpsFixReporterHomeContent extends StatefulWidget {
  const OpsFixReporterHomeContent({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixReporterHomeContent> createState() =>
      _OpsFixReporterHomeContentState();
}

class _OpsFixReporterHomeContentState extends State<OpsFixReporterHomeContent> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _kpi;
  List<Map<String, dynamic>> _units = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted)
      setState(() {
        _loading = true;
        _error = null;
      });
    try {
      final locationId = FFAppState().currentLocationId.trim();
      final siteId = FFAppState().currentSiteId.trim();
      final futures = await Future.wait<dynamic>([
        locationId.isEmpty
            ? Future.value(<dynamic>[])
            : SupaFlow.client
                .from('maintenance_units')
                .select('id,unit_code,name,position_label')
                .eq('location_id', locationId)
                .eq('is_active', true)
                .order('code_sort', ascending: true),
        currentUserUid.isEmpty || siteId.isEmpty
            ? Future.value(<String, dynamic>{})
            : SupaFlow.client.rpc(
                'get_opsfix_reporter_kpis',
                params: {'p_site_id': siteId},
              ),
      ]);
      final unitRows = futures[0] as List;
      final kpiResult = futures[1] is Map
          ? Map<String, dynamic>.from(futures[1] as Map)
          : <String, dynamic>{};
      if (!mounted) return;
      setState(() {
        _units = unitRows
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _kpi = kpiResult['ok'] == true ? kpiResult : null;
        _loading = false;
      });
    } catch (error) {
      debugPrint('Reporter home load failed: $error');
      if (mounted)
        setState(() {
          _loading = false;
          _error = OpsFixI18n.t(
              'Dashboard belum dapat dimuat. Tarik ke bawah untuk mencoba lagi.');
        });
    }
  }

  String _text(Map<String, dynamic>? row, String key, [String fallback = '']) {
    final value = row?[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  int _count(String key) {
    final raw = _kpi?[key];
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  String _status(String raw) => switch (raw) {
        'reported' => OpsFixI18n.t('Dilaporkan'),
        'assigned' => OpsFixI18n.t('Teknisi ditetapkan'),
        'in_progress' => OpsFixI18n.t('Sedang dikerjakan'),
        'pending_verification' => OpsFixI18n.t('Menunggu verifikasi'),
        'fixed' => OpsFixI18n.t('Selesai'),
        'closed' => OpsFixI18n.t('Ditutup'),
        'reopened' => OpsFixI18n.t('Dibuka kembali'),
        _ => OpsFixI18n.t('Status diperbarui'),
      };

  void _report({String? unitId, String? unitCode}) {
    context.pushNamed(
      'reportIssuePage',
      extra: _opsFixReporterFade(),
      queryParameters: {
        'locationId':
            serializeParam(FFAppState().currentLocationId, ParamType.String),
        if (unitId != null) 'unitId': serializeParam(unitId, ParamType.String),
        if (unitCode != null)
          'unitCode': serializeParam(unitCode, ParamType.String),
      }.withoutNulls,
    );
  }

  Widget _hero() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: const Color(0xFF081225),
            borderRadius: BorderRadius.circular(24)),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(OpsFixI18n.t('PORTAL PENGGUNA'),
              style: TextStyle(
                  color: Color(0xFF35D0BA),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Text(OpsFixI18n.t('Selamat datang di OpsFix'),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(
              OpsFixI18n.t(
                  'Laporkan gangguan fasilitas dan pantau progres berdasarkan data Anda.'),
              style: TextStyle(
                  color: Color(0xFFD8E0EF), fontSize: 13, height: 1.35)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFF3159E8),
                borderRadius: BorderRadius.circular(15)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(OpsFixI18n.t('Lokasi aktif'),
                  style: TextStyle(
                      color: Color(0xFFDCE6FF),
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              Text(
                  FFAppState().currentLocationName.trim().isEmpty
                      ? OpsFixI18n.t('Lokasi belum dipilih')
                      : FFAppState().currentLocationName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(
                  FFAppState().currentLocationCode.trim().isEmpty
                      ? OpsFixI18n.t('Pilih lokasi untuk membuat laporan')
                      : FFAppState().currentLocationCode,
                  style:
                      const TextStyle(color: Color(0xFFE8EDFF), fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: FilledButton(
                    onPressed: _report,
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9))),
                    child: Text(OpsFixI18n.t('Buat laporan')))),
            const SizedBox(width: 10),
            Expanded(
                child: OutlinedButton(
                    onPressed: () => context.pushNamed('ReporterQrScannerPage',
                        extra: _opsFixReporterFade()),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8B7CF6),
                        side: const BorderSide(color: Color(0xFF6C5CE7)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9))),
                    child: Text(OpsFixI18n.t('Scan / kode')))),
          ]),
        ]),
      );

  Widget _metric(IconData icon, Color color, int value, String label) =>
      Expanded(
        child: Container(
          height: 108,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFDDE2E7))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 12),
            Text('$value',
                style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 23,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
          ]),
        ),
      );

  Widget _summary() {
    final latestId = _text(_kpi, 'latest_ticket_id');
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        _metric(Icons.confirmation_number_outlined, const Color(0xFF6C5CE7),
            _count('active_tickets'), OpsFixI18n.t('Tiket aktif')),
        const SizedBox(width: 9),
        _metric(Icons.engineering_outlined, const Color(0xFFF59E0B),
            _count('in_progress_tickets'), OpsFixI18n.t('Ditangani')),
        const SizedBox(width: 9),
        _metric(Icons.check_circle_outline, const Color(0xFF10B981),
            _count('completed_tickets'), OpsFixI18n.t('Selesai')),
      ]),
      const SizedBox(height: 14),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDDE2E7))),
        child: latestId.isEmpty
            ? Column(children: [
                Icon(Icons.inbox_outlined, size: 34, color: Color(0xFF94A3B8)),
                SizedBox(height: 10),
                Text(OpsFixI18n.t('Belum ada tiket'),
                    style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 5),
                Text(
                    OpsFixI18n.t(
                        'Tiket terbaru akan muncul setelah Anda mengirim laporan pertama.'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF64748B), fontSize: 12, height: 1.4)),
              ])
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(OpsFixI18n.t('Tiket terbaru'),
                    style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 19,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(_text(_kpi, 'latest_ticket_code', OpsFixI18n.t('Tiket')),
                    style: const TextStyle(
                        color: Color(0xFF6C5CE7),
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(
                    _text(_kpi, 'latest_ticket_title',
                        OpsFixI18n.t('Laporan fasilitas')),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 17,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Text(_status(_text(_kpi, 'latest_ticket_status')),
                    style: const TextStyle(
                        color: Color(0xFF64748B), fontSize: 12)),
                const SizedBox(height: 11),
                OutlinedButton(
                    onPressed: () => context.goNamed('myTicketsPage',
                        extra: _opsFixReporterFade()),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6C5CE7),
                        side: const BorderSide(color: Color(0xFF6C5CE7))),
                    child: Text(OpsFixI18n.t('Lihat tiket saya'))),
              ]),
      ),
    ]);
  }

  Widget _guide() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDDE2E7))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(OpsFixI18n.t('Cara laporan diproses'),
              style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          Text(
              <String>[
                OpsFixI18n.t('1. Pilih perangkat yang bermasalah'),
                OpsFixI18n.t('2. Jelaskan gangguan dan sertakan foto'),
                OpsFixI18n.t('3. Pantau status hingga perbaikan selesai'),
              ].join('\n'),
              style: TextStyle(
                  color: Color(0xFF64748B), fontSize: 12, height: 1.65)),
        ]),
      );

  Widget _unitCard(Map<String, dynamic> unit) => OutlinedButton(
        onPressed: () => _report(
          unitId: _text(unit, 'id'),
          unitCode: _text(unit, 'unit_code'),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6C5CE7),
          side: const BorderSide(color: Color(0xFFB8AEFF)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          alignment: Alignment.centerLeft,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(children: [
          const Icon(Icons.desktop_windows_outlined, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(_text(unit, 'unit_code', OpsFixI18n.t('Perangkat')),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                if (_text(unit, 'name').isNotEmpty)
                  Text(_text(unit, 'name'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 11)),
              ])),
          const Icon(Icons.chevron_right, size: 18),
        ]),
      );

  Widget _devices(int columns) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(OpsFixI18n.t('Perangkat lokasi'),
              style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFDDE2E7))),
            child: _units.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 22, horizontal: 12),
                    child: Column(children: [
                      Icon(Icons.devices_other_outlined,
                          size: 34, color: Color(0xFF94A3B8)),
                      SizedBox(height: 10),
                      Text(OpsFixI18n.t('Belum ada perangkat di lokasi ini'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 5),
                      Text(
                          OpsFixI18n.t(
                              'Perangkat akan ditampilkan setelah pengelola menambahkannya ke lokasi aktif.'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              height: 1.4)),
                    ]),
                  )
                : LayoutBuilder(builder: (context, constraints) {
                    const gap = 9.0;
                    final cardWidth = columns <= 1
                        ? constraints.maxWidth
                        : (constraints.maxWidth - gap * (columns - 1)) /
                            columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: _units
                          .map((unit) => SizedBox(
                              width: cardWidth, child: _unitCard(unit)))
                          .toList(),
                    );
                  }),
          ),
        ],
      );

  Widget _loadedLayout(double screenWidth) {
    final desktop = screenWidth >= 1200;
    final tablet = screenWidth >= 480 && !desktop;
    final deviceColumns = desktop
        ? 3
        : tablet
            ? 2
            : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (desktop)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 7, child: _hero()),
            const SizedBox(width: 18),
            Expanded(flex: 5, child: _summary()),
          ])
        else ...[
          _hero(),
          const SizedBox(height: 16),
          _summary(),
        ],
        const SizedBox(height: 18),
        OpsFixReporterIncidentPreview(
          locationId: FFAppState().currentLocationId,
        ),
        const SizedBox(height: 18),
        if (tablet)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 4, child: _guide()),
            const SizedBox(width: 16),
            Expanded(flex: 6, child: _devices(deviceColumns)),
          ])
        else ...[
          _guide(),
          const SizedBox(height: 18),
          _devices(deviceColumns),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxWidth = screenWidth >= 1200
        ? 1280.0
        : screenWidth >= 480
            ? 960.0
            : double.infinity;
    final horizontal = screenWidth >= 1200
        ? 24.0
        : screenWidth >= 480
            ? 20.0
            : 14.0;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics()),
          padding: EdgeInsets.fromLTRB(horizontal, 18, horizontal, 28),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: _loading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(child: CircularProgressIndicator()))
                    : _error != null
                        ? Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F2),
                                borderRadius: BorderRadius.circular(16)),
                            child: Text(_error!,
                                textAlign: TextAlign.center,
                                style:
                                    const TextStyle(color: Color(0xFFBE123C))))
                        : _loadedLayout(screenWidth),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
