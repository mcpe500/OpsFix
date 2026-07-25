import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'location_entry_page_widget.dart' show LocationEntryPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LocationEntryPageModel extends FlutterFlowModel<LocationEntryPageWidget> {
  ///  Local state fields for this page.

  String? sourceLocationInput = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - resolveOpsFixSession] action in LocationEntryPage widget.
  String? sourceLocationEntryRole;
  // Stores action output result for [Custom Action - resolveOpsFixLocation] action in LocationEntryPage widget.
  String? sourceDeepLinkResolution;
  // State field(s) for SourceLocationInputField widget.
  FocusNode? sourceLocationInputFieldFocusNode;
  TextEditingController? sourceLocationInputFieldTextController;
  String? Function(BuildContext, String?)?
      sourceLocationInputFieldTextControllerValidator;
  // Stores action output result for [Custom Action - resolveOpsFixLocation] action in SourceResolveLocationButton widget.
  String? sourceManualResolution;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    sourceLocationInputFieldFocusNode?.dispose();
    sourceLocationInputFieldTextController?.dispose();
  }
}
