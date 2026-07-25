import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'technician_ticket_detail_page_copy_widget.dart'
    show TechnicianTicketDetailPageCopyWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TechnicianTicketDetailPageCopyModel
    extends FlutterFlowModel<TechnicianTicketDetailPageCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TechnicianNoteField widget.
  FocusNode? technicianNoteFieldFocusNode;
  TextEditingController? technicianNoteFieldTextController;
  String? Function(BuildContext, String?)?
      technicianNoteFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    technicianNoteFieldFocusNode?.dispose();
    technicianNoteFieldTextController?.dispose();
  }
}
