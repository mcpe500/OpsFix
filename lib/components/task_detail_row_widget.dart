import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'task_detail_row_model.dart';
export 'task_detail_row_model.dart';

class TaskDetailRowWidget extends StatefulWidget {
  const TaskDetailRowWidget({
    super.key,
    this.icon,
    String? text,
  }) : this.text = text ?? 'Pelapor: Nadia';

  final Widget? icon;
  final String text;

  @override
  State<TaskDetailRowWidget> createState() => _TaskDetailRowWidgetState();
}

class _TaskDetailRowWidgetState extends State<TaskDetailRowWidget> {
  late TaskDetailRowModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TaskDetailRowModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget!.icon!,
        Text(
          valueOrDefault<String>(
            widget!.text,
            'Pelapor: Nadia',
          ),
          style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.figtree(
                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                lineHeight: 1.4,
              ),
        ),
      ].divide(SizedBox(width: 8.0)),
    );
  }
}
