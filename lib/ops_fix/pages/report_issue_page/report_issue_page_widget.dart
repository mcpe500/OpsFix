import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'report_issue_page_model.dart';
export 'report_issue_page_model.dart';

/// Creates a Supabase ticket with validated issue data and secure evidence.
class ReportIssuePageWidget extends StatefulWidget {
  const ReportIssuePageWidget({
    super.key,
    String? unitId,
    String? locationId,
    String? unitCode,
  })  : this.unitId = unitId ?? '',
        this.locationId = locationId ?? '',
        this.unitCode = unitCode ?? '';

  /// Selected maintenance unit UUID.
  final String unitId;

  /// Selected location UUID.
  final String locationId;

  /// Selected unit code shown in the form.
  final String unitCode;

  static String routeName = 'reportIssuePage';
  static String routePath = '/report';

  @override
  State<ReportIssuePageWidget> createState() => _ReportIssuePageWidgetState();
}

class _ReportIssuePageWidgetState extends State<ReportIssuePageWidget> {
  late ReportIssuePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportIssuePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.sourceIssueTypeRows = await IssueTypesTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'is_active',
              true,
            )
            .order('sort_order', ascending: true),
      );
      _model.sourceIssueTypes =
          _model.sourceIssueTypeRows!.toList().cast<IssueTypesRow>();
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
            child: custom_widgets.OpsFixResponsiveReportIssue(
              locationId: widget!.locationId,
              unitCode: widget!.unitCode,
              unitId: widget!.unitId,
            ),
          ),
        ),
      ),
    );
  }
}
