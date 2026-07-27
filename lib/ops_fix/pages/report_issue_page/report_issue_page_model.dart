import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'report_issue_page_widget.dart' show ReportIssuePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReportIssuePageModel extends FlutterFlowModel<ReportIssuePageWidget> {
  ///  Local state fields for this page.

  String? description = '';

  String? contact = '';

  String? accessNotes = '';

  List<IssueTypesRow> liveIssueTypes = [];
  void addToLiveIssueTypes(IssueTypesRow item) => liveIssueTypes.add(item);
  void removeFromLiveIssueTypes(IssueTypesRow item) =>
      liveIssueTypes.remove(item);
  void removeAtIndexFromLiveIssueTypes(int index) =>
      liveIssueTypes.removeAt(index);
  void insertAtIndexInLiveIssueTypes(int index, IssueTypesRow item) =>
      liveIssueTypes.insert(index, item);
  void updateLiveIssueTypesAtIndex(
          int index, Function(IssueTypesRow) updateFn) =>
      liveIssueTypes[index] = updateFn(liveIssueTypes[index]);

  List<TicketCardsVRow> duplicateTickets = [];
  void addToDuplicateTickets(TicketCardsVRow item) =>
      duplicateTickets.add(item);
  void removeFromDuplicateTickets(TicketCardsVRow item) =>
      duplicateTickets.remove(item);
  void removeAtIndexFromDuplicateTickets(int index) =>
      duplicateTickets.removeAt(index);
  void insertAtIndexInDuplicateTickets(int index, TicketCardsVRow item) =>
      duplicateTickets.insert(index, item);
  void updateDuplicateTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      duplicateTickets[index] = updateFn(duplicateTickets[index]);

  String? selectedIssueTypeId = '';

  String? selectedIssueCategoryId = '';

  List<IssueTypesRow> sourceIssueTypes = [];
  void addToSourceIssueTypes(IssueTypesRow item) => sourceIssueTypes.add(item);
  void removeFromSourceIssueTypes(IssueTypesRow item) =>
      sourceIssueTypes.remove(item);
  void removeAtIndexFromSourceIssueTypes(int index) =>
      sourceIssueTypes.removeAt(index);
  void insertAtIndexInSourceIssueTypes(int index, IssueTypesRow item) =>
      sourceIssueTypes.insert(index, item);
  void updateSourceIssueTypesAtIndex(
          int index, Function(IssueTypesRow) updateFn) =>
      sourceIssueTypes[index] = updateFn(sourceIssueTypes[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in reportIssuePage widget.
  List<IssueTypesRow>? sourceIssueTypeRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
