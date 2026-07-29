import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reporter_location_tickets_page_model.dart';
export 'reporter_location_tickets_page_model.dart';

/// Lists privacy-safe active incidents for the reporter current location.
class ReporterLocationTicketsPageWidget extends StatefulWidget {
  const ReporterLocationTicketsPageWidget({
    super.key,
    this.locationId,
    this.ticketId,
  });

  final String? locationId;
  final String? ticketId;

  static String routeName = 'ReporterLocationTicketsPage';
  static String routePath = '/location-incidents';

  @override
  State<ReporterLocationTicketsPageWidget> createState() =>
      _ReporterLocationTicketsPageWidgetState();
}

class _ReporterLocationTicketsPageWidgetState
    extends State<ReporterLocationTicketsPageWidget> {
  late ReporterLocationTicketsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReporterLocationTicketsPageModel());

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
            child: custom_widgets.OpsFixResponsiveReporterLocationTickets(
              locationId: widget!.locationId,
              ticketId: widget!.ticketId,
            ),
          ),
        ),
      ),
    );
  }
}
