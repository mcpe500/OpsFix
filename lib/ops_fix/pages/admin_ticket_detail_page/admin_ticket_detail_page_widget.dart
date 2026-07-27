import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_ticket_detail_page_model.dart';
export 'admin_ticket_detail_page_model.dart';

/// Manager ticket detail with site-scoped assignment and event timeline.
class AdminTicketDetailPageWidget extends StatefulWidget {
  const AdminTicketDetailPageWidget({
    super.key,
    String? ticketId,
  }) : this.ticketId = ticketId ?? '';

  /// Supabase ticket UUID; empty values render an invalid-ticket state.
  final String ticketId;

  static String routeName = 'adminTicketDetailPage';
  static String routePath = '/admin/ticket';

  @override
  State<AdminTicketDetailPageWidget> createState() =>
      _AdminTicketDetailPageWidgetState();
}

class _AdminTicketDetailPageWidgetState
    extends State<AdminTicketDetailPageWidget> {
  late AdminTicketDetailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminTicketDetailPageModel());

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
            child: custom_widgets.OpsFixResponsiveAdminTicketDetail(
              width: double.infinity,
              height: double.infinity,
              ticketId: widget!.ticketId,
            ),
          ),
        ),
      ),
    );
  }
}
