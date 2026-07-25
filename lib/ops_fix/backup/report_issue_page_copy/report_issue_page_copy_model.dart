import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'report_issue_page_copy_widget.dart' show ReportIssuePageCopyWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReportIssuePageCopyModel
    extends FlutterFlowModel<ReportIssuePageCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for SearchUnitField widget.
  FocusNode? searchUnitFieldFocusNode;
  TextEditingController? searchUnitFieldTextController;
  String? Function(BuildContext, String?)?
      searchUnitFieldTextControllerValidator;
  // State field(s) for SelectUnitDropdown widget.
  String? selectUnitDropdownValue;
  FormFieldController<String>? selectUnitDropdownValueController;
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
  // State field(s) for Chip widget.
  FormFieldController<List<String>>? chipValueController4;
  String? get chipValue4 => chipValueController4?.value?.firstOrNull;
  set chipValue4(String? val) =>
      chipValueController4?.value = val != null ? [val] : [];
  // State field(s) for CategoryDropdown widget.
  String? categoryDropdownValue;
  FormFieldController<String>? categoryDropdownValueController;
  // State field(s) for IssueTypeDropdown widget.
  String? issueTypeDropdownValue;
  FormFieldController<String>? issueTypeDropdownValueController;
  // State field(s) for DescriptionField widget.
  FocusNode? descriptionFieldFocusNode;
  TextEditingController? descriptionFieldTextController;
  String? Function(BuildContext, String?)?
      descriptionFieldTextControllerValidator;
  // State field(s) for ImpactDropdown widget.
  String? impactDropdownValue;
  FormFieldController<String>? impactDropdownValueController;
  // State field(s) for IncidentTimeField widget.
  FocusNode? incidentTimeFieldFocusNode;
  TextEditingController? incidentTimeFieldTextController;
  String? Function(BuildContext, String?)?
      incidentTimeFieldTextControllerValidator;
  // State field(s) for OptionalContactField widget.
  FocusNode? optionalContactFieldFocusNode;
  TextEditingController? optionalContactFieldTextController;
  String? Function(BuildContext, String?)?
      optionalContactFieldTextControllerValidator;
  // State field(s) for AccessNotesField widget.
  FocusNode? accessNotesFieldFocusNode;
  TextEditingController? accessNotesFieldTextController;
  String? Function(BuildContext, String?)?
      accessNotesFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchUnitFieldFocusNode?.dispose();
    searchUnitFieldTextController?.dispose();

    descriptionFieldFocusNode?.dispose();
    descriptionFieldTextController?.dispose();

    incidentTimeFieldFocusNode?.dispose();
    incidentTimeFieldTextController?.dispose();

    optionalContactFieldFocusNode?.dispose();
    optionalContactFieldTextController?.dispose();

    accessNotesFieldFocusNode?.dispose();
    accessNotesFieldTextController?.dispose();
  }
}
