import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ticket_badge_model.dart';
export 'ticket_badge_model.dart';

class TicketBadgeWidget extends StatefulWidget {
  const TicketBadgeWidget({
    super.key,
    Color? bgColor,
    String? label,
    Color? textColor,
  })  : this.bgColor = bgColor ?? const Color(0x1A6C5CE7),
        this.label = label ?? 'ASSIGNED',
        this.textColor = textColor ?? const Color(0xFF6C5CE7);

  final Color bgColor;
  final String label;
  final Color textColor;

  @override
  State<TicketBadgeWidget> createState() => _TicketBadgeWidgetState();
}

class _TicketBadgeWidgetState extends State<TicketBadgeWidget> {
  late TicketBadgeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TicketBadgeModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          widget!.bgColor,
          Color(0x1A6C5CE7),
        ),
        borderRadius: BorderRadius.circular(8.0),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
        child: Container(
          child: Text(
            valueOrDefault<String>(
              widget!.label,
              'ASSIGNED',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.figtree(
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: valueOrDefault<Color>(
                    widget!.textColor,
                    Color(0xFF6C5CE7),
                  ),
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  lineHeight: 1.4,
                ),
          ),
        ),
      ),
    );
  }
}
