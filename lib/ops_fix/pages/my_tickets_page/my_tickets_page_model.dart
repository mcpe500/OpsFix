import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'my_tickets_page_widget.dart' show MyTicketsPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyTicketsPageModel extends FlutterFlowModel<MyTicketsPageWidget> {
  ///  Local state fields for this page.

  List<TicketCardsVRow> liveTicketRows = [];
  void addToLiveTicketRows(TicketCardsVRow item) => liveTicketRows.add(item);
  void removeFromLiveTicketRows(TicketCardsVRow item) =>
      liveTicketRows.remove(item);
  void removeAtIndexFromLiveTicketRows(int index) =>
      liveTicketRows.removeAt(index);
  void insertAtIndexInLiveTicketRows(int index, TicketCardsVRow item) =>
      liveTicketRows.insert(index, item);
  void updateLiveTicketRowsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveTicketRows[index] = updateFn(liveTicketRows[index]);

  List<TicketCardsVRow> sourceReporterTickets = [];
  void addToSourceReporterTickets(TicketCardsVRow item) =>
      sourceReporterTickets.add(item);
  void removeFromSourceReporterTickets(TicketCardsVRow item) =>
      sourceReporterTickets.remove(item);
  void removeAtIndexFromSourceReporterTickets(int index) =>
      sourceReporterTickets.removeAt(index);
  void insertAtIndexInSourceReporterTickets(int index, TicketCardsVRow item) =>
      sourceReporterTickets.insert(index, item);
  void updateSourceReporterTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      sourceReporterTickets[index] = updateFn(sourceReporterTickets[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in myTicketsPage widget.
  List<TicketCardsVRow>? sourceReporterTicketRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
