import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'technician_profile_page_model.dart';
export 'technician_profile_page_model.dart';

/// Shows the signed-in technician identity, work summary, and secure logout
/// action.
class TechnicianProfilePageWidget extends StatefulWidget {
  const TechnicianProfilePageWidget({super.key});

  static String routeName = 'TechnicianProfilePage';
  static String routePath = '/technician-profile';

  @override
  State<TechnicianProfilePageWidget> createState() =>
      _TechnicianProfilePageWidgetState();
}

class _TechnicianProfilePageWidgetState
    extends State<TechnicianProfilePageWidget> {
  late TechnicianProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TechnicianProfilePageModel());

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
              child: custom_widgets.OpsFixResponsiveTechnicianProfile(),
            ),
          ),
        ),
      ),
    );
  }
}
