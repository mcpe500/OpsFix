import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'register_page_widget.dart' show RegisterPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPageModel extends FlutterFlowModel<RegisterPageWidget> {
  ///  Local state fields for this page.

  String? name = '';

  String? email = '';

  String? password = '';

  String? confirmPassword = '';

  bool? acceptedTerms = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for NameField widget.
  FocusNode? nameFieldFocusNode;
  TextEditingController? nameFieldTextController;
  String? Function(BuildContext, String?)? nameFieldTextControllerValidator;
  // State field(s) for RegEmailField widget.
  FocusNode? regEmailFieldFocusNode;
  TextEditingController? regEmailFieldTextController;
  String? Function(BuildContext, String?)? regEmailFieldTextControllerValidator;
  // State field(s) for RegPasswordField widget.
  FocusNode? regPasswordFieldFocusNode;
  TextEditingController? regPasswordFieldTextController;
  late bool regPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      regPasswordFieldTextControllerValidator;
  // State field(s) for ConfirmPasswordField widget.
  FocusNode? confirmPasswordFieldFocusNode;
  TextEditingController? confirmPasswordFieldTextController;
  late bool confirmPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordFieldTextControllerValidator;
  // State field(s) for TermsCheckbox widget.
  bool? termsCheckboxValue;
  // Stores action output result for [Custom Action - registerOpsFixReporter] action in RegisterButton widget.
  String? registrationResult;

  @override
  void initState(BuildContext context) {
    regPasswordFieldVisibility = false;
    confirmPasswordFieldVisibility = false;
  }

  @override
  void dispose() {
    nameFieldFocusNode?.dispose();
    nameFieldTextController?.dispose();

    regEmailFieldFocusNode?.dispose();
    regEmailFieldTextController?.dispose();

    regPasswordFieldFocusNode?.dispose();
    regPasswordFieldTextController?.dispose();

    confirmPasswordFieldFocusNode?.dispose();
    confirmPasswordFieldTextController?.dispose();
  }
}
