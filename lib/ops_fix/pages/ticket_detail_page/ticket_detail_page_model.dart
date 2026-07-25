import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'ticket_detail_page_widget.dart' show TicketDetailPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TicketDetailPageModel extends FlutterFlowModel<TicketDetailPageWidget> {
  ///  Local state fields for this page.

  String? ticketLoadState = 'invalid';

  List<TicketCardsVRow> liveTicketDetail = [];
  void addToLiveTicketDetail(TicketCardsVRow item) =>
      liveTicketDetail.add(item);
  void removeFromLiveTicketDetail(TicketCardsVRow item) =>
      liveTicketDetail.remove(item);
  void removeAtIndexFromLiveTicketDetail(int index) =>
      liveTicketDetail.removeAt(index);
  void insertAtIndexInLiveTicketDetail(int index, TicketCardsVRow item) =>
      liveTicketDetail.insert(index, item);
  void updateLiveTicketDetailAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveTicketDetail[index] = updateFn(liveTicketDetail[index]);

  List<TicketEventsRow> liveTicketEvents = [];
  void addToLiveTicketEvents(TicketEventsRow item) =>
      liveTicketEvents.add(item);
  void removeFromLiveTicketEvents(TicketEventsRow item) =>
      liveTicketEvents.remove(item);
  void removeAtIndexFromLiveTicketEvents(int index) =>
      liveTicketEvents.removeAt(index);
  void insertAtIndexInLiveTicketEvents(int index, TicketEventsRow item) =>
      liveTicketEvents.insert(index, item);
  void updateLiveTicketEventsAtIndex(
          int index, Function(TicketEventsRow) updateFn) =>
      liveTicketEvents[index] = updateFn(liveTicketEvents[index]);

  List<CompletionAttemptsRow> liveCompletionAttempts = [];
  void addToLiveCompletionAttempts(CompletionAttemptsRow item) =>
      liveCompletionAttempts.add(item);
  void removeFromLiveCompletionAttempts(CompletionAttemptsRow item) =>
      liveCompletionAttempts.remove(item);
  void removeAtIndexFromLiveCompletionAttempts(int index) =>
      liveCompletionAttempts.removeAt(index);
  void insertAtIndexInLiveCompletionAttempts(
          int index, CompletionAttemptsRow item) =>
      liveCompletionAttempts.insert(index, item);
  void updateLiveCompletionAttemptsAtIndex(
          int index, Function(CompletionAttemptsRow) updateFn) =>
      liveCompletionAttempts[index] = updateFn(liveCompletionAttempts[index]);

  List<TicketDetailVRow> sourceTicketDetail = [];
  void addToSourceTicketDetail(TicketDetailVRow item) =>
      sourceTicketDetail.add(item);
  void removeFromSourceTicketDetail(TicketDetailVRow item) =>
      sourceTicketDetail.remove(item);
  void removeAtIndexFromSourceTicketDetail(int index) =>
      sourceTicketDetail.removeAt(index);
  void insertAtIndexInSourceTicketDetail(int index, TicketDetailVRow item) =>
      sourceTicketDetail.insert(index, item);
  void updateSourceTicketDetailAtIndex(
          int index, Function(TicketDetailVRow) updateFn) =>
      sourceTicketDetail[index] = updateFn(sourceTicketDetail[index]);

  List<TicketEventsRow> sourceTicketEvents = [];
  void addToSourceTicketEvents(TicketEventsRow item) =>
      sourceTicketEvents.add(item);
  void removeFromSourceTicketEvents(TicketEventsRow item) =>
      sourceTicketEvents.remove(item);
  void removeAtIndexFromSourceTicketEvents(int index) =>
      sourceTicketEvents.removeAt(index);
  void insertAtIndexInSourceTicketEvents(int index, TicketEventsRow item) =>
      sourceTicketEvents.insert(index, item);
  void updateSourceTicketEventsAtIndex(
          int index, Function(TicketEventsRow) updateFn) =>
      sourceTicketEvents[index] = updateFn(sourceTicketEvents[index]);

  List<CompletionAttemptsRow> sourceCompletionAttempts = [];
  void addToSourceCompletionAttempts(CompletionAttemptsRow item) =>
      sourceCompletionAttempts.add(item);
  void removeFromSourceCompletionAttempts(CompletionAttemptsRow item) =>
      sourceCompletionAttempts.remove(item);
  void removeAtIndexFromSourceCompletionAttempts(int index) =>
      sourceCompletionAttempts.removeAt(index);
  void insertAtIndexInSourceCompletionAttempts(
          int index, CompletionAttemptsRow item) =>
      sourceCompletionAttempts.insert(index, item);
  void updateSourceCompletionAttemptsAtIndex(
          int index, Function(CompletionAttemptsRow) updateFn) =>
      sourceCompletionAttempts[index] =
          updateFn(sourceCompletionAttempts[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in ticketDetailPage widget.
  List<TicketDetailVRow>? sourceReporterDetailRows;
  // Stores action output result for [Backend Call - Query Rows] action in ticketDetailPage widget.
  List<TicketEventsRow>? sourceReporterEventRows;
  // Stores action output result for [Backend Call - Query Rows] action in ticketDetailPage widget.
  List<CompletionAttemptsRow>? sourceReporterAttemptRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
