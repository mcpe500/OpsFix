import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'technician_ticket_detail_page_model.dart';
export 'technician_ticket_detail_page_model.dart';

/// Technician ticket workflow with start, proof upload, completion, and
/// timeline.
class TechnicianTicketDetailPageWidget extends StatefulWidget {
  const TechnicianTicketDetailPageWidget({
    super.key,
    String? ticketId,
  }) : this.ticketId = ticketId ?? '';

  /// Supabase ticket UUID; empty values render an invalid-ticket state.
  final String ticketId;

  static String routeName = 'technicianTicketDetailPage';
  static String routePath = '/technician/ticket';

  @override
  State<TechnicianTicketDetailPageWidget> createState() =>
      _TechnicianTicketDetailPageWidgetState();
}

class _TechnicianTicketDetailPageWidgetState
    extends State<TechnicianTicketDetailPageWidget> {
  late TechnicianTicketDetailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TechnicianTicketDetailPageModel());

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
            width: double.infinity,
            height: double.infinity,
            child: Container(
              child: custom_widgets.OpsFixResponsiveTechnicianTicketDetail(
                ticketId: widget!.ticketId,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
