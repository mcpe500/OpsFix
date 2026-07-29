// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class _OpsFixQrLocation {
  const _OpsFixQrLocation({
    required this.code,
    required this.name,
    required this.slug,
  });

  final String code;
  final String name;
  final String slug;

  String url(String baseUrl) => '$baseUrl/location/$slug';
}

String _safeName(String value, {String fallback = 'location'}) {
  final cleaned = value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return cleaned.isEmpty ? fallback : cleaned;
}

List<_OpsFixQrLocation>? _decodeLocations(String source) {
  try {
    final decoded = jsonDecode(source);
    if (decoded is! List || decoded.isEmpty) return null;
    final locations = <_OpsFixQrLocation>[];
    for (final value in decoded) {
      if (value is! Map) return null;
      final row = Map<String, dynamic>.from(value);
      final code = row['code']?.toString().trim() ?? '';
      final name = row['name']?.toString().trim() ?? '';
      final slug = row['slug']?.toString().trim() ?? '';
      if (code.isEmpty ||
          name.isEmpty ||
          slug.isEmpty ||
          !RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(slug)) {
        return null;
      }
      locations.add(_OpsFixQrLocation(code: code, name: name, slug: slug));
    }
    locations.sort((a, b) => a.code.compareTo(b.code));
    return locations;
  } catch (_) {
    return null;
  }
}

String? _normalizeBaseUrl(String value) {
  final normalized = value.trim().replaceAll(RegExp(r'/+$'), '');
  final uri = Uri.tryParse(normalized);
  if (uri == null ||
      uri.scheme.toLowerCase() != 'https' ||
      uri.host.trim().isEmpty ||
      uri.hasQuery ||
      uri.hasFragment) {
    return null;
  }
  return normalized;
}

pw.Widget _qr(String data, double size) => pw.Container(
      width: size,
      height: size,
      padding: const pw.EdgeInsets.all(8),
      color: PdfColors.white,
      child: pw.BarcodeWidget(
        data: data,
        barcode: pw.Barcode.qrCode(
          errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high,
        ),
        drawText: false,
        color: PdfColors.black,
        backgroundColor: PdfColors.white,
      ),
    );

pw.Widget _brand() => pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 22,
          height: 22,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#6C5CE7'),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          ),
          child: pw.Text(
            'O',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(width: 7),
        pw.Text(
          'OpsFix',
          style: pw.TextStyle(
            color: PdfColor.fromHex('#111827'),
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );

String _instruction(String languageCode) => languageCode == 'en'
    ? 'Scan to report an issue at this location'
    : 'Pindai untuk melaporkan gangguan di lokasi ini';

pw.Widget _posterBody(
  _OpsFixQrLocation location,
  String baseUrl,
  String siteName,
  String languageCode, {
  required double qrSize,
  bool square = false,
}) {
  final subtitle = siteName.trim().isEmpty ? 'OpsFix' : siteName.trim();
  return pw.Container(
    decoration: pw.BoxDecoration(
      color: PdfColors.white,
      border: pw.Border.all(color: PdfColor.fromHex('#DDE2E7'), width: 1),
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),
    ),
    padding: pw.EdgeInsets.all(square ? 14 : 28),
    child: pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        _brand(),
        pw.SizedBox(height: square ? 8 : 20),
        pw.Text(
          subtitle,
          textAlign: pw.TextAlign.center,
          maxLines: 1,
          style: pw.TextStyle(
            color: PdfColor.fromHex('#64748B'),
            fontSize: square ? 10 : 13,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          location.name,
          textAlign: pw.TextAlign.center,
          maxLines: 2,
          style: pw.TextStyle(
            color: PdfColor.fromHex('#111827'),
            fontSize: square ? 18 : 27,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#F0EDFF'),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
          ),
          child: pw.Text(
            location.code,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#6C5CE7'),
              fontSize: square ? 11 : 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: square ? 8 : 22),
        _qr(location.url(baseUrl), qrSize),
        pw.SizedBox(height: square ? 8 : 20),
        pw.Text(
          _instruction(languageCode),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: PdfColor.fromHex('#111827'),
            fontSize: square ? 11 : 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          location.url(baseUrl),
          textAlign: pw.TextAlign.center,
          maxLines: 2,
          style: pw.TextStyle(
            color: PdfColor.fromHex('#64748B'),
            fontSize: square ? 8 : 10,
          ),
        ),
      ],
    ),
  );
}

pw.Widget _sheetCard(
  _OpsFixQrLocation location,
  String baseUrl,
  String languageCode,
) =>
    pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(
          color: PdfColor.fromHex('#CBD5E1'),
          width: 0.7,
        ),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          _brand(),
          pw.SizedBox(height: 5),
          pw.Text(
            location.name,
            maxLines: 1,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#111827'),
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            location.code,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#6C5CE7'),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          _qr(location.url(baseUrl), 42 * PdfPageFormat.mm),
          pw.SizedBox(height: 4),
          pw.Text(
            _instruction(languageCode),
            maxLines: 2,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#475569'),
              fontSize: 7.5,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            location.url(baseUrl),
            maxLines: 2,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#64748B'),
              fontSize: 6,
            ),
          ),
        ],
      ),
    );

pw.Widget _sheetSlot(
  _OpsFixQrLocation? location,
  String baseUrl,
  String languageCode,
) =>
    pw.Expanded(
      child: location == null
          ? pw.SizedBox()
          : _sheetCard(location, baseUrl, languageCode),
    );

Future<Uint8List> _buildDocument({
  required List<_OpsFixQrLocation> locations,
  required String baseUrl,
  required String siteName,
  required String layout,
  required String languageCode,
}) async {
  final document = pw.Document(
    title: 'OpsFix location QR codes',
    author: 'OpsFix',
    creator: 'OpsFix',
  );
  if (layout == 'single_square') {
    final square = PdfPageFormat(
      152.4 * PdfPageFormat.mm,
      152.4 * PdfPageFormat.mm,
      marginAll: 0,
    );
    document.addPage(
      pw.Page(
        pageFormat: square,
        build: (_) => pw.Center(
          child: pw.SizedBox(
            width: 140 * PdfPageFormat.mm,
            height: 140 * PdfPageFormat.mm,
            child: _posterBody(
              locations.first,
              baseUrl,
              siteName,
              languageCode,
              qrSize: 68 * PdfPageFormat.mm,
              square: true,
            ),
          ),
        ),
      ),
    );
    return document.save();
  }

  if (layout == 'sheet_2x3') {
    for (var start = 0; start < locations.length; start += 6) {
      final pageRows = locations.skip(start).take(6).toList();
      _OpsFixQrLocation? at(int index) =>
          index < pageRows.length ? pageRows[index] : null;
      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(10 * PdfPageFormat.mm),
          build: (_) => pw.Column(
            children: [
              for (var row = 0; row < 3; row++) ...[
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      _sheetSlot(at(row * 2), baseUrl, languageCode),
                      pw.SizedBox(width: 6 * PdfPageFormat.mm),
                      _sheetSlot(at(row * 2 + 1), baseUrl, languageCode),
                    ],
                  ),
                ),
                if (row < 2) pw.SizedBox(height: 6 * PdfPageFormat.mm),
              ],
            ],
          ),
        ),
      );
    }
    return document.save();
  }

  for (final location in locations) {
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18 * PdfPageFormat.mm),
        build: (_) => pw.Center(
          child: pw.SizedBox(
            width: 170 * PdfPageFormat.mm,
            height: 250 * PdfPageFormat.mm,
            child: _posterBody(
              location,
              baseUrl,
              siteName,
              languageCode,
              qrSize: 112 * PdfPageFormat.mm,
            ),
          ),
        ),
      ),
    );
  }
  return document.save();
}

Future<String> exportOpsFixLocationQrs(
  String siteName,
  String siteCode,
  String publicAppUrl,
  String locationsJson,
  String layout,
  String operation,
  String languageCode,
) async {
  final baseUrl = _normalizeBaseUrl(publicAppUrl);
  if (baseUrl == null) return 'invalid_url';
  final locations = _decodeLocations(locationsJson);
  if (locations == null) return 'invalid_location';
  if (locations.isEmpty) return 'empty';
  if (!const {'single_poster', 'sheet_2x3', 'poster_pages'}.contains(layout)) {
    return 'generation_failed';
  }
  if (!const {'download_pdf', 'download_png', 'print_pdf'}
      .contains(operation)) {
    return 'generation_failed';
  }
  if (operation == 'download_png' && locations.length != 1) {
    return 'generation_failed';
  }

  final language = languageCode == 'en' ? 'en' : 'id';
  Uint8List bytes;
  try {
    bytes = await _buildDocument(
      locations: locations,
      baseUrl: baseUrl,
      siteName: siteName,
      layout: operation == 'download_png' ? 'single_square' : layout,
      languageCode: language,
    );
  } catch (_) {
    return 'generation_failed';
  }

  final date = DateTime.now().toIso8601String().split('T').first;
  final locationCode = _safeName(locations.first.code);
  final safeSiteCode = _safeName(siteCode, fallback: 'site');
  final stem = operation == 'download_png'
      ? 'opsfix-location-qr-$locationCode'
      : layout == 'single_poster'
          ? 'opsfix-location-qr-poster-$locationCode'
          : layout == 'sheet_2x3'
              ? 'opsfix-location-qrs-6-per-page-$safeSiteCode-$date'
              : 'opsfix-location-qrs-posters-$safeSiteCode-$date';

  try {
    if (operation == 'print_pdf') {
      final opened = await Printing.layoutPdf(
        name: '$stem.pdf',
        format: PdfPageFormat.a4,
        onLayout: (_) async => bytes,
      );
      return opened ? 'printed' : 'cancelled';
    }
    if (operation == 'download_pdf') {
      await FileSaver.instance.saveFile(
        name: stem,
        bytes: bytes,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );
      return 'saved';
    }

    Uint8List? pngBytes;
    await for (final page
        in Printing.raster(bytes, pages: const [0], dpi: 300)) {
      pngBytes = await page.toPng();
      break;
    }
    if (pngBytes == null || pngBytes.isEmpty) return 'generation_failed';
    await FileSaver.instance.saveFile(
      name: stem,
      bytes: pngBytes,
      fileExtension: 'png',
      mimeType: MimeType.custom,
      customMimeType: 'image/png',
    );
    return 'saved';
  } catch (_) {
    return 'save_failed';
  }
}
