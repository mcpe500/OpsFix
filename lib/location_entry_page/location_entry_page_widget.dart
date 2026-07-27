import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'location_entry_page_model.dart';
export 'location_entry_page_model.dart';

/// Captures a QR location slug and preserves it through sign-in.
class LocationEntryPageWidget extends StatefulWidget {
  const LocationEntryPageWidget({
    super.key,
    this.slug,
  });

  final String? slug;

  static String routeName = 'LocationEntryPage';
  static String routePath = '/location/:slug';

  @override
  State<LocationEntryPageWidget> createState() =>
      _LocationEntryPageWidgetState();
}

class _LocationEntryPageWidgetState extends State<LocationEntryPageWidget> {
  late LocationEntryPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LocationEntryPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().pendingLocationSlug = widget!.slug!;
      safeSetState(() {});
      _model.locationEntryRole = await actions.resolveOpsFixSession();
      _model.locationEntryResolution = await actions.resolveOpsFixLocation(
        widget!.slug,
      );
      if (_model.locationEntryResolution == 'ok') {
        if (_model.locationEntryRole == 'manager') {
          context.goNamed(AdminDashboardPageWidget.routeName);
        } else {
          if (_model.locationEntryRole == 'technician') {
            context.goNamed(TechnicianTasksPageWidget.routeName);
          } else {
            context.goNamed(
              ReportIssuePageWidget.routeName,
              queryParameters: {
                'locationId': serializeParam(
                  FFAppState().currentLocationId,
                  ParamType.String,
                ),
              }.withoutNulls,
            );
          }
        }
      } else {
        if (_model.locationEntryResolution == 'unauthenticated') {
          context.goNamed(LoginPageWidget.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lokasi dari QR tidak ditemukan. Pastikan tautan berasal dari OpsFix.',
                style: TextStyle(),
              ),
              duration: Duration(milliseconds: 4000),
            ),
          );
        }
      }
    });

    _model.sourceLocationInputFieldTextController ??= TextEditingController();
    _model.sourceLocationInputFieldFocusNode ??= FocusNode();

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
                    '1prjy5yo' /* OpsFix Location */,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 56.0,
                ),
                Text(
                  FFLocalizations.of(context).getText(
                    '4vp2c9em' /* Pilih lokasi OpsFix */,
                  ),
                  textAlign: TextAlign.center,
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
                  controller: _model.sourceLocationInputFieldTextController,
                  focusNode: _model.sourceLocationInputFieldFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.sourceLocationInputFieldTextController',
                    Duration(milliseconds: 2000),
                    () async {
                      _model.sourceLocationInput =
                          _model.sourceLocationInputFieldTextController.text;
                      safeSetState(() {});
                    },
                  ),
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: FFLocalizations.of(context).getText(
                      '02atrcmy' /* Kode, slug, atau URL lokasi */,
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
                  ),
                  style: TextStyle(),
                  maxLines: null,
                  validator: _model
                      .sourceLocationInputFieldTextControllerValidator
                      .asValidator(context),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    _model.sourceManualResolution =
                        await actions.resolveOpsFixLocation(
                      _model.sourceLocationInput,
                    );
                    if (_model.sourceManualResolution == 'ok') {
                      if (FFAppState().currentUserRole == 'manager') {
                        context.goNamed(AdminDashboardPageWidget.routeName);
                      } else if (FFAppState().currentUserRole == 'technician') {
                        context.goNamed(TechnicianTasksPageWidget.routeName);
                      } else {
                        context.goNamed(HomeUserPageWidget.routeName);
                      }
                    } else if (_model.sourceManualResolution ==
                        'unauthenticated') {
                      FFAppState().pendingLocationSlug =
                          _model.sourceLocationInput!;
                      safeSetState(() {});

                      context.pushNamed(LoginPageWidget.routeName);
                    } else if (_model.sourceManualResolution == 'invalid') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Masukkan kode atau URL lokasi yang valid.',
                            style: TextStyle(),
                          ),
                          duration: Duration(milliseconds: 4000),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Lokasi tidak ditemukan.',
                            style: TextStyle(),
                          ),
                          duration: Duration(milliseconds: 4000),
                        ),
                      );
                    }

                    safeSetState(() {});
                  },
                  text: FFLocalizations.of(context).getText(
                    '3ngcjyqd' /* Gunakan lokasi */,
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
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed(LoginPageWidget.routeName);
                  },
                  text: FFLocalizations.of(context).getText(
                    'hfkt0x32' /* Masuk terlebih dahulu */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.transparent,
                    textStyle: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                Text(
                  FFLocalizations.of(context).getText(
                    'vpubcim7' /* Pemindaian QR dan input manual... */,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.figtree(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodySmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
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
