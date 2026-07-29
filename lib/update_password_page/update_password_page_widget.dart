import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'update_password_page_model.dart';
export 'update_password_page_model.dart';

/// Completes a Supabase password recovery session.
class UpdatePasswordPageWidget extends StatefulWidget {
  const UpdatePasswordPageWidget({super.key});

  static String routeName = 'UpdatePasswordPage';
  static String routePath = '/update-password';

  @override
  State<UpdatePasswordPageWidget> createState() =>
      _UpdatePasswordPageWidgetState();
}

class _UpdatePasswordPageWidgetState extends State<UpdatePasswordPageWidget> {
  late UpdatePasswordPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpdatePasswordPageModel());

    _model.newPasswordFieldTextController ??= TextEditingController();
    _model.newPasswordFieldFocusNode ??= FocusNode();

    _model.confirmNewPasswordFieldTextController ??= TextEditingController();
    _model.confirmNewPasswordFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                automaticallyImplyLeading: true,
                title: Text(
                  FFLocalizations.of(context).getText(
                    't1dfm82l' /* Update password */,
                  ),
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        font: GoogleFonts.figtree(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleLarge.fontStyle,
                      ),
                ),
                actions: [],
                centerTitle: true,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  FFLocalizations.of(context).getText(
                    'pbir1ssv' /* Choose a new password */,
                  ),
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.figtree(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontStyle,
                      ),
                ),
                TextFormField(
                  controller: _model.newPasswordFieldTextController,
                  focusNode: _model.newPasswordFieldFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.newPasswordFieldTextController',
                    Duration(milliseconds: 2000),
                    () async {
                      _model.password =
                          _model.newPasswordFieldTextController.text;
                      safeSetState(() {});
                    },
                  ),
                  obscureText: !_model.newPasswordFieldVisibility,
                  decoration: InputDecoration(
                    labelText: FFLocalizations.of(context).getText(
                      'io7h8q0c' /* New password */,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    filled: true,
                    suffixIcon: InkWell(
                      onTap: () async {
                        safeSetState(() => _model.newPasswordFieldVisibility =
                            !_model.newPasswordFieldVisibility);
                      },
                      focusNode: FocusNode(skipTraversal: true),
                      child: Icon(
                        _model.newPasswordFieldVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 22,
                      ),
                    ),
                  ),
                  style: TextStyle(),
                  validator: _model.newPasswordFieldTextControllerValidator
                      .asValidator(context),
                ),
                TextFormField(
                  controller: _model.confirmNewPasswordFieldTextController,
                  focusNode: _model.confirmNewPasswordFieldFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.confirmNewPasswordFieldTextController',
                    Duration(milliseconds: 2000),
                    () async {
                      _model.confirmPassword =
                          _model.confirmNewPasswordFieldTextController.text;
                      safeSetState(() {});
                    },
                  ),
                  obscureText: !_model.confirmNewPasswordFieldVisibility,
                  decoration: InputDecoration(
                    labelText: FFLocalizations.of(context).getText(
                      '6wc3rmoa' /* Confirm password */,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    filled: true,
                    suffixIcon: InkWell(
                      onTap: () async {
                        safeSetState(() =>
                            _model.confirmNewPasswordFieldVisibility =
                                !_model.confirmNewPasswordFieldVisibility);
                      },
                      focusNode: FocusNode(skipTraversal: true),
                      child: Icon(
                        _model.confirmNewPasswordFieldVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 22,
                      ),
                    ),
                  ),
                  style: TextStyle(),
                  validator: _model
                      .confirmNewPasswordFieldTextControllerValidator
                      .asValidator(context),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    await authManager.updatePassword(
                      newPassword: _model.newPasswordFieldTextController.text,
                      context: context,
                    );
                    safeSetState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          functions.opsFixLocalizedMessage(
                              'Password updated.',
                              'Password berhasil diperbarui.',
                              FFAppState().appLanguage)!,
                          style: TextStyle(),
                        ),
                        duration: Duration(milliseconds: 4000),
                      ),
                    );

                    context.goNamedAuth(
                      LaunchPageWidget.routeName,
                      context.mounted,
                      extra: <String, dynamic>{
                        '__transition_info__': TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 160),
                        ),
                      },
                    );
                  },
                  text: FFLocalizations.of(context).getText(
                    'hphz4vjx' /* Save new password */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
