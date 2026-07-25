import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'admin_work_board_page_widget.dart' show AdminWorkBoardPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminWorkBoardPageModel
    extends FlutterFlowModel<AdminWorkBoardPageWidget> {
  ///  Local state fields for this page.

  List<TicketCardsVRow> liveBoardTickets = [];
  void addToLiveBoardTickets(TicketCardsVRow item) =>
      liveBoardTickets.add(item);
  void removeFromLiveBoardTickets(TicketCardsVRow item) =>
      liveBoardTickets.remove(item);
  void removeAtIndexFromLiveBoardTickets(int index) =>
      liveBoardTickets.removeAt(index);
  void insertAtIndexInLiveBoardTickets(int index, TicketCardsVRow item) =>
      liveBoardTickets.insert(index, item);
  void updateLiveBoardTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveBoardTickets[index] = updateFn(liveBoardTickets[index]);

  List<TicketCardsVRow> sourceBoardTickets = [];
  void addToSourceBoardTickets(TicketCardsVRow item) =>
      sourceBoardTickets.add(item);
  void removeFromSourceBoardTickets(TicketCardsVRow item) =>
      sourceBoardTickets.remove(item);
  void removeAtIndexFromSourceBoardTickets(int index) =>
      sourceBoardTickets.removeAt(index);
  void insertAtIndexInSourceBoardTickets(int index, TicketCardsVRow item) =>
      sourceBoardTickets.insert(index, item);
  void updateSourceBoardTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      sourceBoardTickets[index] = updateFn(sourceBoardTickets[index]);

  List<TicketCardsVRow> reportedBoardTickets = [];
  void addToReportedBoardTickets(TicketCardsVRow item) =>
      reportedBoardTickets.add(item);
  void removeFromReportedBoardTickets(TicketCardsVRow item) =>
      reportedBoardTickets.remove(item);
  void removeAtIndexFromReportedBoardTickets(int index) =>
      reportedBoardTickets.removeAt(index);
  void insertAtIndexInReportedBoardTickets(int index, TicketCardsVRow item) =>
      reportedBoardTickets.insert(index, item);
  void updateReportedBoardTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      reportedBoardTickets[index] = updateFn(reportedBoardTickets[index]);

  List<TicketCardsVRow> assignedBoardTickets = [];
  void addToAssignedBoardTickets(TicketCardsVRow item) =>
      assignedBoardTickets.add(item);
  void removeFromAssignedBoardTickets(TicketCardsVRow item) =>
      assignedBoardTickets.remove(item);
  void removeAtIndexFromAssignedBoardTickets(int index) =>
      assignedBoardTickets.removeAt(index);
  void insertAtIndexInAssignedBoardTickets(int index, TicketCardsVRow item) =>
      assignedBoardTickets.insert(index, item);
  void updateAssignedBoardTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      assignedBoardTickets[index] = updateFn(assignedBoardTickets[index]);

  List<TicketCardsVRow> progressBoardTickets = [];
  void addToProgressBoardTickets(TicketCardsVRow item) =>
      progressBoardTickets.add(item);
  void removeFromProgressBoardTickets(TicketCardsVRow item) =>
      progressBoardTickets.remove(item);
  void removeAtIndexFromProgressBoardTickets(int index) =>
      progressBoardTickets.removeAt(index);
  void insertAtIndexInProgressBoardTickets(int index, TicketCardsVRow item) =>
      progressBoardTickets.insert(index, item);
  void updateProgressBoardTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      progressBoardTickets[index] = updateFn(progressBoardTickets[index]);

  List<TicketCardsVRow> verificationBoardTickets = [];
  void addToVerificationBoardTickets(TicketCardsVRow item) =>
      verificationBoardTickets.add(item);
  void removeFromVerificationBoardTickets(TicketCardsVRow item) =>
      verificationBoardTickets.remove(item);
  void removeAtIndexFromVerificationBoardTickets(int index) =>
      verificationBoardTickets.removeAt(index);
  void insertAtIndexInVerificationBoardTickets(
          int index, TicketCardsVRow item) =>
      verificationBoardTickets.insert(index, item);
  void updateVerificationBoardTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      verificationBoardTickets[index] =
          updateFn(verificationBoardTickets[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in adminWorkBoardPage widget.
  List<TicketCardsVRow>? loadReportedRows;
  // Stores action output result for [Backend Call - Query Rows] action in adminWorkBoardPage widget.
  List<TicketCardsVRow>? loadAssignedRows;
  // Stores action output result for [Backend Call - Query Rows] action in adminWorkBoardPage widget.
  List<TicketCardsVRow>? loadProgressRows;
  // Stores action output result for [Backend Call - Query Rows] action in adminWorkBoardPage widget.
  List<TicketCardsVRow>? loadVerificationRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminWorkBoardRefreshButton widget.
  List<TicketCardsVRow>? refreshReportedRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminWorkBoardRefreshButton widget.
  List<TicketCardsVRow>? refreshAssignedRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminWorkBoardRefreshButton widget.
  List<TicketCardsVRow>? refreshProgressRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminWorkBoardRefreshButton widget.
  List<TicketCardsVRow>? refreshVerificationRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
