import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'my_tickets_page_model.dart';
export 'my_tickets_page_model.dart';

/// Reporter ticket history queried from Supabase for the authenticated user
/// and site.
class MyTicketsPageWidget extends StatefulWidget {
  const MyTicketsPageWidget({super.key});

  static String routeName = 'myTicketsPage';
  static String routePath = '/tickets';

  @override
  State<MyTicketsPageWidget> createState() => _MyTicketsPageWidgetState();
}

class _MyTicketsPageWidgetState extends State<MyTicketsPageWidget> {
  late MyTicketsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyTicketsPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.sourceReporterTicketRows = await TicketCardsVTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'reporter_id',
              currentUserUid,
            )
            .eqOrNull(
              'site_id',
              FFAppState().currentSiteId,
            )
            .order('updated_at'),
      );
      _model.sourceReporterTickets =
          _model.sourceReporterTicketRows!.toList().cast<TicketCardsVRow>();
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
        backgroundColor: Color(0xFFF3F5F2),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            child: custom_widgets.OpsFixResponsiveMyTickets(),
          ),
        ),
      ),
    );
  }
}
