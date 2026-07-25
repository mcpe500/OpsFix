import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'register_page_copy_widget.dart' show RegisterPageCopyWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPageCopyModel extends FlutterFlowModel<RegisterPageCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for txtNameRegister widget.
  FocusNode? txtNameRegisterFocusNode;
  TextEditingController? txtNameRegisterTextController;
  String? Function(BuildContext, String?)?
      txtNameRegisterTextControllerValidator;
  // State field(s) for txtEmailRegister widget.
  FocusNode? txtEmailRegisterFocusNode;
  TextEditingController? txtEmailRegisterTextController;
  String? Function(BuildContext, String?)?
      txtEmailRegisterTextControllerValidator;
  // State field(s) for txtPasswordRegister widget.
  FocusNode? txtPasswordRegisterFocusNode;
  TextEditingController? txtPasswordRegisterTextController;
  late bool txtPasswordRegisterVisibility;
  String? Function(BuildContext, String?)?
      txtPasswordRegisterTextControllerValidator;
  // State field(s) for txtCPasswordRegister widget.
  FocusNode? txtCPasswordRegisterFocusNode;
  TextEditingController? txtCPasswordRegisterTextController;
  late bool txtCPasswordRegisterVisibility;
  String? Function(BuildContext, String?)?
      txtCPasswordRegisterTextControllerValidator;

  @override
  void initState(BuildContext context) {
    txtPasswordRegisterVisibility = false;
    txtCPasswordRegisterVisibility = false;
  }

  @override
  void dispose() {
    txtNameRegisterFocusNode?.dispose();
    txtNameRegisterTextController?.dispose();

    txtEmailRegisterFocusNode?.dispose();
    txtEmailRegisterTextController?.dispose();

    txtPasswordRegisterFocusNode?.dispose();
    txtPasswordRegisterTextController?.dispose();

    txtCPasswordRegisterFocusNode?.dispose();
    txtCPasswordRegisterTextController?.dispose();
  }
}
