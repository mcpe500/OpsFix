import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ticket_detail_page_model.dart';
export 'ticket_detail_page_model.dart';

/// Reporter ticket detail, verification attempts, and immutable event
/// timeline.
class TicketDetailPageWidget extends StatefulWidget {
  const TicketDetailPageWidget({
    super.key,
    String? ticketId,
  }) : this.ticketId = ticketId ?? '';

  /// Supabase ticket UUID; empty values render an invalid-ticket state.
  final String ticketId;

  static String routeName = 'ticketDetailPage';
  static String routePath = '/ticket';

  @override
  State<TicketDetailPageWidget> createState() => _TicketDetailPageWidgetState();
}

class _TicketDetailPageWidgetState extends State<TicketDetailPageWidget> {
  late TicketDetailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TicketDetailPageModel());

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
        backgroundColor: Color(0xFFF3F5F2),
        body: Container(
          child: custom_widgets.OpsFixResponsiveReporterTicketDetail(
            ticketId: widget!.ticketId,
          ),
        ),
      ),
    );
  }
}
