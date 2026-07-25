import '/components/ticket_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'my_tickets_page_copy_widget.dart' show MyTicketsPageCopyWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyTicketsPageCopyModel extends FlutterFlowModel<MyTicketsPageCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TicketCard.
  late TicketCardModel ticketCardModel1;
  // Model for TicketCard.
  late TicketCardModel ticketCardModel2;

  @override
  void initState(BuildContext context) {
    ticketCardModel1 = createModel(context, () => TicketCardModel());
    ticketCardModel2 = createModel(context, () => TicketCardModel());
  }

  @override
  void dispose() {
    ticketCardModel1.dispose();
    ticketCardModel2.dispose();
  }
}
