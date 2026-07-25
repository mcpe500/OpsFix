import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_location_qr_sheet_model.dart';
export 'admin_location_qr_sheet_model.dart';

/// Location-level QR modal with public URL configuration and copy action.
class AdminLocationQrSheetWidget extends StatefulWidget {
  const AdminLocationQrSheetWidget({
    super.key,
    this.siteId,
    this.locationId,
    this.qrUrl,
  });

  final String? siteId;
  final String? locationId;
  final String? qrUrl;

  @override
  State<AdminLocationQrSheetWidget> createState() =>
      _AdminLocationQrSheetWidgetState();
}

class _AdminLocationQrSheetWidgetState
    extends State<AdminLocationQrSheetWidget> {
  late AdminLocationQrSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminLocationQrSheetModel());

    _model.adminSitePublicUrlFieldTextController ??= TextEditingController();
    _model.adminSitePublicUrlFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'QR lokasi',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    font: GoogleFonts.figtree(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleLarge.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
            ),
            Text(
              'Satu QR membuka seluruh lokasi dan daftar unitnya.',
              maxLines: 2,
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            if (widget!.qrUrl == '')
              Text(
                'Simpan URL publik HTTPS terlebih dahulu untuk membuat QR.',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).warning,
                ),
              ),
            if (!(widget!.qrUrl == ''))
              BarcodeWidget(
                data: widget!.qrUrl!,
                barcode: Barcode.qrCode(),
                width: 220.0,
                height: 220.0,
                errorBuilder: (_context, _error) => SizedBox(
                  width: 220.0,
                  height: 220.0,
                ),
                drawText: false,
              ),
            if (!(widget!.qrUrl == ''))
              Text(
                widget!.qrUrl!,
                maxLines: 2,
                style: TextStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            if (!(widget!.qrUrl == ''))
              FFButtonWidget(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: widget!.qrUrl!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tautan lokasi disalin.',
                        style: TextStyle(),
                      ),
                      duration: Duration(milliseconds: 4000),
                    ),
                  );
                },
                text: 'Salin tautan',
                options: FFButtonOptions(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: Colors.transparent,
                  textStyle: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            TextFormField(
              controller: _model.adminSitePublicUrlFieldTextController,
              focusNode: _model.adminSitePublicUrlFieldFocusNode,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'URL publik aplikasi (https://...)',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                filled: true,
              ),
              style: TextStyle(),
              maxLines: null,
              validator: _model.adminSitePublicUrlFieldTextControllerValidator
                  .asValidator(context),
            ),
            FFButtonWidget(
              onPressed: () async {
                _model.savePublicUrlCode = await actions.setOpsFixSitePublicUrl(
                  widget!.siteId,
                  _model.adminSitePublicUrlFieldTextController.text,
                );
                if (_model.savePublicUrlCode == 'updated') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'URL publik tersimpan. Buka QR kembali.',
                        style: TextStyle(),
                      ),
                      duration: Duration(milliseconds: 4000),
                    ),
                  );
                  context.pop();
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  }
                  context.pushNamed(
                    AdminAssetLocationDetailPageWidget.routeName,
                    queryParameters: {
                      'locationId': serializeParam(
                        widget!.locationId,
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                } else if (_model.savePublicUrlCode == 'invalid') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Gunakan URL HTTPS yang valid.',
                        style: TextStyle(),
                      ),
                      duration: Duration(milliseconds: 4000),
                    ),
                  );
                } else if (_model.savePublicUrlCode == 'access_denied') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Akses manajer ditolak.',
                        style: TextStyle(),
                      ),
                      duration: Duration(milliseconds: 4000),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'URL gagal disimpan. Periksa koneksi.',
                        style: TextStyle(),
                      ),
                      duration: Duration(milliseconds: 4000),
                    ),
                  );
                }

                safeSetState(() {});
              },
              text: 'Simpan URL publik',
              options: FFButtonOptions(
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: TextStyle(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ].divide(SizedBox(height: 14.0)),
        ),
      ),
    );
  }
}
