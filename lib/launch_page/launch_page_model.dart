import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'launch_page_widget.dart' show LaunchPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LaunchPageModel extends FlutterFlowModel<LaunchPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - resolveOpsFixSession] action in LaunchPage widget.
  String? launchRole;
  // Stores action output result for [Custom Action - resolveOpsFixLocation] action in LaunchPage widget.
  String? launchLocationResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
