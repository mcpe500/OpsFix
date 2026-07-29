import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reporter_qr_scanner_page_model.dart';
export 'reporter_qr_scanner_page_model.dart';

/// Memindai QR lokasi OpsFix melalui kamera browser atau perangkat reporter.
class ReporterQrScannerPageWidget extends StatefulWidget {
  const ReporterQrScannerPageWidget({super.key});

  static String routeName = 'ReporterQrScannerPage';
  static String routePath = '/reporterQrScanner';

  @override
  State<ReporterQrScannerPageWidget> createState() =>
      _ReporterQrScannerPageWidgetState();
}

class _ReporterQrScannerPageWidgetState
    extends State<ReporterQrScannerPageWidget> {
  late ReporterQrScannerPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReporterQrScannerPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            child: custom_widgets.OpsFixResponsiveReporterQrShell(),
          ),
        ),
      ),
    );
  }
}
