import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_assets_locations_page_model.dart';
export 'admin_assets_locations_page_model.dart';

/// Manager asset inventory filtered by current site.
class AdminAssetsLocationsPageWidget extends StatefulWidget {
  const AdminAssetsLocationsPageWidget({super.key});

  static String routeName = 'adminAssetsLocationsPage';
  static String routePath = '/admin/assets';

  @override
  State<AdminAssetsLocationsPageWidget> createState() =>
      _AdminAssetsLocationsPageWidgetState();
}

class _AdminAssetsLocationsPageWidgetState
    extends State<AdminAssetsLocationsPageWidget> {
  late AdminAssetsLocationsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminAssetsLocationsPageModel());

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
            child: custom_widgets.OpsFixResponsiveAdminLocations(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
