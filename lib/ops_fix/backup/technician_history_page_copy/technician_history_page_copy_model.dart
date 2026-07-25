import '/components/metric_card4_widget.dart';
import '/components/ticket_badge_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'technician_history_page_copy_widget.dart'
    show TechnicianHistoryPageCopyWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class TechnicianHistoryPageCopyModel
    extends FlutterFlowModel<TechnicianHistoryPageCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MetricCard.
  late MetricCard4Model metricCardModel1;
  // Model for MetricCard.
  late MetricCard4Model metricCardModel2;
  // Model for MetricCard.
  late MetricCard4Model metricCardModel3;
  // Model for MetricCard.
  late MetricCard4Model metricCardModel4;
  // Model for TicketBadge.
  late TicketBadgeModel ticketBadgeModel1;
  // Model for TicketBadge.
  late TicketBadgeModel ticketBadgeModel2;
  // Model for TicketBadge.
  late TicketBadgeModel ticketBadgeModel3;
  // Model for TicketBadge.
  late TicketBadgeModel ticketBadgeModel4;
  // Model for TicketBadge.
  late TicketBadgeModel ticketBadgeModel5;

  @override
  void initState(BuildContext context) {
    metricCardModel1 = createModel(context, () => MetricCard4Model());
    metricCardModel2 = createModel(context, () => MetricCard4Model());
    metricCardModel3 = createModel(context, () => MetricCard4Model());
    metricCardModel4 = createModel(context, () => MetricCard4Model());
    ticketBadgeModel1 = createModel(context, () => TicketBadgeModel());
    ticketBadgeModel2 = createModel(context, () => TicketBadgeModel());
    ticketBadgeModel3 = createModel(context, () => TicketBadgeModel());
    ticketBadgeModel4 = createModel(context, () => TicketBadgeModel());
    ticketBadgeModel5 = createModel(context, () => TicketBadgeModel());
  }

  @override
  void dispose() {
    metricCardModel1.dispose();
    metricCardModel2.dispose();
    metricCardModel3.dispose();
    metricCardModel4.dispose();
    ticketBadgeModel1.dispose();
    ticketBadgeModel2.dispose();
    ticketBadgeModel3.dispose();
    ticketBadgeModel4.dispose();
    ticketBadgeModel5.dispose();
  }
}
