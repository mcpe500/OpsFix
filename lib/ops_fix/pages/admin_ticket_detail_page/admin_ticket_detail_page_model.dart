import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'admin_ticket_detail_page_widget.dart' show AdminTicketDetailPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminTicketDetailPageModel
    extends FlutterFlowModel<AdminTicketDetailPageWidget> {
  ///  Local state fields for this page.

  String? ticketLoadState = 'invalid';

  List<TicketCardsVRow> liveAdminTicket = [];
  void addToLiveAdminTicket(TicketCardsVRow item) => liveAdminTicket.add(item);
  void removeFromLiveAdminTicket(TicketCardsVRow item) =>
      liveAdminTicket.remove(item);
  void removeAtIndexFromLiveAdminTicket(int index) =>
      liveAdminTicket.removeAt(index);
  void insertAtIndexInLiveAdminTicket(int index, TicketCardsVRow item) =>
      liveAdminTicket.insert(index, item);
  void updateLiveAdminTicketAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveAdminTicket[index] = updateFn(liveAdminTicket[index]);

  List<TicketEventsRow> liveAdminTicketEvents = [];
  void addToLiveAdminTicketEvents(TicketEventsRow item) =>
      liveAdminTicketEvents.add(item);
  void removeFromLiveAdminTicketEvents(TicketEventsRow item) =>
      liveAdminTicketEvents.remove(item);
  void removeAtIndexFromLiveAdminTicketEvents(int index) =>
      liveAdminTicketEvents.removeAt(index);
  void insertAtIndexInLiveAdminTicketEvents(int index, TicketEventsRow item) =>
      liveAdminTicketEvents.insert(index, item);
  void updateLiveAdminTicketEventsAtIndex(
          int index, Function(TicketEventsRow) updateFn) =>
      liveAdminTicketEvents[index] = updateFn(liveAdminTicketEvents[index]);

  List<UsersRow> liveSiteTechnicians = [];
  void addToLiveSiteTechnicians(UsersRow item) => liveSiteTechnicians.add(item);
  void removeFromLiveSiteTechnicians(UsersRow item) =>
      liveSiteTechnicians.remove(item);
  void removeAtIndexFromLiveSiteTechnicians(int index) =>
      liveSiteTechnicians.removeAt(index);
  void insertAtIndexInLiveSiteTechnicians(int index, UsersRow item) =>
      liveSiteTechnicians.insert(index, item);
  void updateLiveSiteTechniciansAtIndex(
          int index, Function(UsersRow) updateFn) =>
      liveSiteTechnicians[index] = updateFn(liveSiteTechnicians[index]);

  List<TicketDetailVRow> sourceManagerDetail = [];
  void addToSourceManagerDetail(TicketDetailVRow item) =>
      sourceManagerDetail.add(item);
  void removeFromSourceManagerDetail(TicketDetailVRow item) =>
      sourceManagerDetail.remove(item);
  void removeAtIndexFromSourceManagerDetail(int index) =>
      sourceManagerDetail.removeAt(index);
  void insertAtIndexInSourceManagerDetail(int index, TicketDetailVRow item) =>
      sourceManagerDetail.insert(index, item);
  void updateSourceManagerDetailAtIndex(
          int index, Function(TicketDetailVRow) updateFn) =>
      sourceManagerDetail[index] = updateFn(sourceManagerDetail[index]);

  List<TicketEventsRow> sourceManagerDetailEvents = [];
  void addToSourceManagerDetailEvents(TicketEventsRow item) =>
      sourceManagerDetailEvents.add(item);
  void removeFromSourceManagerDetailEvents(TicketEventsRow item) =>
      sourceManagerDetailEvents.remove(item);
  void removeAtIndexFromSourceManagerDetailEvents(int index) =>
      sourceManagerDetailEvents.removeAt(index);
  void insertAtIndexInSourceManagerDetailEvents(
          int index, TicketEventsRow item) =>
      sourceManagerDetailEvents.insert(index, item);
  void updateSourceManagerDetailEventsAtIndex(
          int index, Function(TicketEventsRow) updateFn) =>
      sourceManagerDetailEvents[index] =
          updateFn(sourceManagerDetailEvents[index]);

  List<AssignmentRulesRow> sourceManagerAssignmentRules = [];
  void addToSourceManagerAssignmentRules(AssignmentRulesRow item) =>
      sourceManagerAssignmentRules.add(item);
  void removeFromSourceManagerAssignmentRules(AssignmentRulesRow item) =>
      sourceManagerAssignmentRules.remove(item);
  void removeAtIndexFromSourceManagerAssignmentRules(int index) =>
      sourceManagerAssignmentRules.removeAt(index);
  void insertAtIndexInSourceManagerAssignmentRules(
          int index, AssignmentRulesRow item) =>
      sourceManagerAssignmentRules.insert(index, item);
  void updateSourceManagerAssignmentRulesAtIndex(
          int index, Function(AssignmentRulesRow) updateFn) =>
      sourceManagerAssignmentRules[index] =
          updateFn(sourceManagerAssignmentRules[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in adminTicketDetailPage widget.
  List<TicketDetailVRow>? sourceManagerDetailRows;
  // Stores action output result for [Backend Call - Query Rows] action in adminTicketDetailPage widget.
  List<TicketEventsRow>? sourceManagerDetailEventRows;
  // Stores action output result for [Backend Call - Query Rows] action in adminTicketDetailPage widget.
  List<AssignmentRulesRow>? sourceManagerAssignmentRuleRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
