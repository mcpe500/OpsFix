import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_profile_page_model.dart';
export 'admin_profile_page_model.dart';

/// Shows the authenticated OpsFix administrator profile and secure logout
/// action.
class AdminProfilePageWidget extends StatefulWidget {
  const AdminProfilePageWidget({super.key});

  static String routeName = 'AdminProfilePage';
  static String routePath = '/adminProfilePage';

  @override
  State<AdminProfilePageWidget> createState() => _AdminProfilePageWidgetState();
}

class _AdminProfilePageWidgetState extends State<AdminProfilePageWidget> {
  late AdminProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminProfilePageModel());

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
            child: custom_widgets.OpsFixResponsiveAdminProfile(),
          ),
        ),
      ),
    );
  }
}
