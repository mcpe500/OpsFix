import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'technician_tasks_page_copy_widget.dart'
    show TechnicianTasksPageCopyWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TechnicianTasksPageCopyModel
    extends FlutterFlowModel<TechnicianTasksPageCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Chip widget.
  FormFieldController<List<String>>? chipValueController1;
  String? get chipValue1 => chipValueController1?.value?.firstOrNull;
  set chipValue1(String? val) =>
      chipValueController1?.value = val != null ? [val] : [];
  // State field(s) for Chip widget.
  FormFieldController<List<String>>? chipValueController2;
  String? get chipValue2 => chipValueController2?.value?.firstOrNull;
  set chipValue2(String? val) =>
      chipValueController2?.value = val != null ? [val] : [];
  // State field(s) for Chip widget.
  FormFieldController<List<String>>? chipValueController3;
  String? get chipValue3 => chipValueController3?.value?.firstOrNull;
  set chipValue3(String? val) =>
      chipValueController3?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
