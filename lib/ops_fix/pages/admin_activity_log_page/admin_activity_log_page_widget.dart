import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_activity_log_page_model.dart';
export 'admin_activity_log_page_model.dart';

/// Manager activity log backed by immutable ticket events.
class AdminActivityLogPageWidget extends StatefulWidget {
  const AdminActivityLogPageWidget({super.key});

  static String routeName = 'adminActivityLogPage';
  static String routePath = '/admin/activity';

  @override
  State<AdminActivityLogPageWidget> createState() =>
      _AdminActivityLogPageWidgetState();
}

class _AdminActivityLogPageWidgetState
    extends State<AdminActivityLogPageWidget> {
  late AdminActivityLogPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminActivityLogPageModel());

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
            child: custom_widgets.OpsFixResponsiveAdminActivityLog(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
