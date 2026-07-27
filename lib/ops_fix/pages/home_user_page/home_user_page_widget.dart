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
import 'home_user_page_model.dart';
export 'home_user_page_model.dart';

/// Reporter portal with database KPIs, resolved location, and scoped
/// maintenance units.
class HomeUserPageWidget extends StatefulWidget {
  const HomeUserPageWidget({super.key});

  static String routeName = 'homeUserPage';
  static String routePath = '/home';

  @override
  State<HomeUserPageWidget> createState() => _HomeUserPageWidgetState();
}

class _HomeUserPageWidgetState extends State<HomeUserPageWidget> {
  late HomeUserPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeUserPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.sourceHomeUnits = await MaintenanceUnitsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'location_id',
              FFAppState().currentLocationId,
            )
            .eqOrNull(
              'is_active',
              true,
            )
            .order('code_sort', ascending: true),
      );
      _model.sourceUnits =
          _model.sourceHomeUnits!.toList().cast<MaintenanceUnitsRow>();
      safeSetState(() {});
      _model.sourceReporterKpiRows = await ReporterSiteKpisVTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'reporter_id',
              currentUserUid,
            )
            .eqOrNull(
              'site_id',
              FFAppState().currentSiteId,
            ),
      );
      _model.sourceReporterKpis =
          _model.sourceReporterKpiRows!.toList().cast<ReporterSiteKpisVRow>();
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
            child: custom_widgets.OpsFixResponsiveReporterHome(),
          ),
        ),
      ),
    );
  }
}
