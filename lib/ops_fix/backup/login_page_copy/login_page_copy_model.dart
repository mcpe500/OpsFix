import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'login_page_copy_widget.dart' show LoginPageCopyWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPageCopyModel extends FlutterFlowModel<LoginPageCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for txtEmailLogin widget.
  FocusNode? txtEmailLoginFocusNode;
  TextEditingController? txtEmailLoginTextController;
  String? Function(BuildContext, String?)? txtEmailLoginTextControllerValidator;
  // State field(s) for txtPasswordLogin widget.
  FocusNode? txtPasswordLoginFocusNode;
  TextEditingController? txtPasswordLoginTextController;
  late bool txtPasswordLoginVisibility;
  String? Function(BuildContext, String?)?
      txtPasswordLoginTextControllerValidator;

  @override
  void initState(BuildContext context) {
    txtPasswordLoginVisibility = false;
  }

  @override
  void dispose() {
    txtEmailLoginFocusNode?.dispose();
    txtEmailLoginTextController?.dispose();

    txtPasswordLoginFocusNode?.dispose();
    txtPasswordLoginTextController?.dispose();
  }
}
