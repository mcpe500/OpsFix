import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'admin_tickets_page_widget.dart' show AdminTicketsPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminTicketsPageModel extends FlutterFlowModel<AdminTicketsPageWidget> {
  ///  Local state fields for this page.

  String? searchQuery = '';

  String? filter = 'all';

  List<TicketCardsVRow> liveManagerTicketRows = [];
  void addToLiveManagerTicketRows(TicketCardsVRow item) =>
      liveManagerTicketRows.add(item);
  void removeFromLiveManagerTicketRows(TicketCardsVRow item) =>
      liveManagerTicketRows.remove(item);
  void removeAtIndexFromLiveManagerTicketRows(int index) =>
      liveManagerTicketRows.removeAt(index);
  void insertAtIndexInLiveManagerTicketRows(int index, TicketCardsVRow item) =>
      liveManagerTicketRows.insert(index, item);
  void updateLiveManagerTicketRowsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveManagerTicketRows[index] = updateFn(liveManagerTicketRows[index]);

  List<TicketCardsVRow> sourceManagerTickets = [];
  void addToSourceManagerTickets(TicketCardsVRow item) =>
      sourceManagerTickets.add(item);
  void removeFromSourceManagerTickets(TicketCardsVRow item) =>
      sourceManagerTickets.remove(item);
  void removeAtIndexFromSourceManagerTickets(int index) =>
      sourceManagerTickets.removeAt(index);
  void insertAtIndexInSourceManagerTickets(int index, TicketCardsVRow item) =>
      sourceManagerTickets.insert(index, item);
  void updateSourceManagerTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      sourceManagerTickets[index] = updateFn(sourceManagerTickets[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in adminTicketsPage widget.
  List<TicketCardsVRow>? sourceManagerTicketRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminAllTicketsFilter widget.
  List<TicketCardsVRow>? allTicketRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminReportedTicketsFilter widget.
  List<TicketCardsVRow>? reportedTicketRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminAssignedTicketsFilter widget.
  List<TicketCardsVRow>? assignedTicketRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminProgressTicketsFilter widget.
  List<TicketCardsVRow>? progressTicketRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
