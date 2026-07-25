import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'update_password_page_widget.dart' show UpdatePasswordPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdatePasswordPageModel
    extends FlutterFlowModel<UpdatePasswordPageWidget> {
  ///  Local state fields for this page.

  String? password = '';

  String? confirmPassword = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for NewPasswordField widget.
  FocusNode? newPasswordFieldFocusNode;
  TextEditingController? newPasswordFieldTextController;
  late bool newPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      newPasswordFieldTextControllerValidator;
  // State field(s) for ConfirmNewPasswordField widget.
  FocusNode? confirmNewPasswordFieldFocusNode;
  TextEditingController? confirmNewPasswordFieldTextController;
  late bool confirmNewPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      confirmNewPasswordFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    newPasswordFieldVisibility = false;
    confirmNewPasswordFieldVisibility = false;
  }

  @override
  void dispose() {
    newPasswordFieldFocusNode?.dispose();
    newPasswordFieldTextController?.dispose();

    confirmNewPasswordFieldFocusNode?.dispose();
    confirmNewPasswordFieldTextController?.dispose();
  }
}
