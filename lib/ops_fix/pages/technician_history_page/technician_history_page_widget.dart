import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'technician_history_page_model.dart';
export 'technician_history_page_model.dart';

/// Completed technician work queried from Supabase.
class TechnicianHistoryPageWidget extends StatefulWidget {
  const TechnicianHistoryPageWidget({super.key});

  static String routeName = 'technicianHistoryPage';
  static String routePath = '/technician/history';

  @override
  State<TechnicianHistoryPageWidget> createState() =>
      _TechnicianHistoryPageWidgetState();
}

class _TechnicianHistoryPageWidgetState
    extends State<TechnicianHistoryPageWidget> {
  late TechnicianHistoryPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TechnicianHistoryPageModel());

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
            child: custom_widgets.OpsFixResponsiveTechnicianHistory(),
          ),
        ),
      ),
    );
  }
}
