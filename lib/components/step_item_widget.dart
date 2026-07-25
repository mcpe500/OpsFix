import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'step_item_model.dart';
export 'step_item_model.dart';

class StepItemWidget extends StatefulWidget {
  const StepItemWidget({
    super.key,
    bool? active,
    String? step,
    String? label,
  })  : this.active = active ?? true,
        this.step = step ?? '1',
        this.label = label ?? 'Target';

  final bool active;
  final String step;
  final String label;

  @override
  State<StepItemWidget> createState() => _StepItemWidgetState();
}

class _StepItemWidgetState extends State<StepItemWidget> {
  late StepItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StepItemModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: valueOrDefault<Color>(
              valueOrDefault<bool>(
                widget!.active,
                true,
              )
                  ? Color(0xFF6C5CE7)
                  : FlutterFlowTheme.of(context).secondaryBackground,
              Color(0xFF6C5CE7),
            ),
            borderRadius: BorderRadius.circular(9999.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: valueOrDefault<Color>(
                valueOrDefault<bool>(
                  widget!.active,
                  true,
                )
                    ? Color(0xFF6C5CE7)
                    : FlutterFlowTheme.of(context).alternate,
                Color(0xFF6C5CE7),
              ),
              width: 1.0,
            ),
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Text(
            valueOrDefault<String>(
              '${widget!.step}',
              '1',
            ),
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.figtree(
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  color: valueOrDefault<Color>(
                    valueOrDefault<bool>(
                      widget!.active,
                      true,
                    )
                        ? Colors.white
                        : FlutterFlowTheme.of(context).secondaryText,
                    Colors.white,
                  ),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  lineHeight: 1.4,
                ),
          ),
        ),
        Text(
          valueOrDefault<String>(
            widget!.label,
            'Target',
          ),
          style: FlutterFlowTheme.of(context).labelSmall.override(
                font: GoogleFonts.figtree(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                ),
                color: valueOrDefault<Color>(
                  valueOrDefault<bool>(
                    widget!.active,
                    true,
                  )
                      ? FlutterFlowTheme.of(context).primaryText
                      : FlutterFlowTheme.of(context).secondaryText,
                  FlutterFlowTheme.of(context).primaryText,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                lineHeight: 1.4,
              ),
        ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}
