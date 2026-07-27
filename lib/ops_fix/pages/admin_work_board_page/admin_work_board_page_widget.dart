import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_work_board_page_model.dart';
export 'admin_work_board_page_model.dart';

/// Manager work board ordered from live site ticket data.
class AdminWorkBoardPageWidget extends StatefulWidget {
  const AdminWorkBoardPageWidget({super.key});

  static String routeName = 'adminWorkBoardPage';
  static String routePath = '/admin/board';

  @override
  State<AdminWorkBoardPageWidget> createState() =>
      _AdminWorkBoardPageWidgetState();
}

class _AdminWorkBoardPageWidgetState extends State<AdminWorkBoardPageWidget> {
  late AdminWorkBoardPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminWorkBoardPageModel());

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
            child: custom_widgets.OpsFixResponsiveAdminWorkBoard(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
