import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.sourceTechnicianDetailRows = await TicketDetailVTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'id',
              widget!.ticketId,
            )
            .eqOrNull(
              'assigned_technician_id',
              currentUserUid,
            )
            .eqOrNull(
              'site_id',
              FFAppState().currentSiteId,
            ),
      );
      _model.sourceTechnicianDetail =
          _model.sourceTechnicianDetailRows!.toList().cast<TicketDetailVRow>();
      safeSetState(() {});
      _model.sourceTechnicianEventRows = await TicketEventsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'ticket_id',
              widget!.ticketId,
            )
            .eqOrNull(
              'site_id',
              FFAppState().currentSiteId,
            )
            .order('created_at', ascending: true),
      );
      _model.sourceTechnicianEvents =
          _model.sourceTechnicianEventRows!.toList().cast<TicketEventsRow>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                iconTheme: IconThemeData(color: Color(0xFF111827)),
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderRadius: 22.0,
                  buttonSize: 40.0,
                  fillColor: Color(0xFFF8FAFC),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF111827),
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.goNamed(TechnicianTasksPageWidget.routeName);
                  },
                ),
                title: Text(
                  'Detail Pekerjaan',
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        font: GoogleFonts.figtree(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleLarge.fontStyle,
                      ),
                ),
                actions: [],
                centerTitle: true,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF3F5F2),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: custom_widgets.OpsFixTechnicianTicketOverview(
                        ticketId: widget!.ticketId,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Container(
                        child: custom_widgets.OpsFixTechnicianWorkStatusPanel(
                          ticketId: widget!.ticketId,
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 16.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
