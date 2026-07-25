import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'technician_tasks_page_widget.dart' show TechnicianTasksPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TechnicianTasksPageModel
    extends FlutterFlowModel<TechnicianTasksPageWidget> {
  ///  Local state fields for this page.

  List<TicketCardsVRow> liveAssignedTickets = [];
  void addToLiveAssignedTickets(TicketCardsVRow item) =>
      liveAssignedTickets.add(item);
  void removeFromLiveAssignedTickets(TicketCardsVRow item) =>
      liveAssignedTickets.remove(item);
  void removeAtIndexFromLiveAssignedTickets(int index) =>
      liveAssignedTickets.removeAt(index);
  void insertAtIndexInLiveAssignedTickets(int index, TicketCardsVRow item) =>
      liveAssignedTickets.insert(index, item);
  void updateLiveAssignedTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveAssignedTickets[index] = updateFn(liveAssignedTickets[index]);

  List<NotificationsRow> liveTechNotifications = [];
  void addToLiveTechNotifications(NotificationsRow item) =>
      liveTechNotifications.add(item);
  void removeFromLiveTechNotifications(NotificationsRow item) =>
      liveTechNotifications.remove(item);
  void removeAtIndexFromLiveTechNotifications(int index) =>
      liveTechNotifications.removeAt(index);
  void insertAtIndexInLiveTechNotifications(int index, NotificationsRow item) =>
      liveTechNotifications.insert(index, item);
  void updateLiveTechNotificationsAtIndex(
          int index, Function(NotificationsRow) updateFn) =>
      liveTechNotifications[index] = updateFn(liveTechNotifications[index]);

  List<TicketCardsVRow> sourceAssignedTickets = [];
  void addToSourceAssignedTickets(TicketCardsVRow item) =>
      sourceAssignedTickets.add(item);
  void removeFromSourceAssignedTickets(TicketCardsVRow item) =>
      sourceAssignedTickets.remove(item);
  void removeAtIndexFromSourceAssignedTickets(int index) =>
      sourceAssignedTickets.removeAt(index);
  void insertAtIndexInSourceAssignedTickets(int index, TicketCardsVRow item) =>
      sourceAssignedTickets.insert(index, item);
  void updateSourceAssignedTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      sourceAssignedTickets[index] = updateFn(sourceAssignedTickets[index]);

  List<TechnicianSiteKpisVRow> sourceTechnicianKpis = [];
  void addToSourceTechnicianKpis(TechnicianSiteKpisVRow item) =>
      sourceTechnicianKpis.add(item);
  void removeFromSourceTechnicianKpis(TechnicianSiteKpisVRow item) =>
      sourceTechnicianKpis.remove(item);
  void removeAtIndexFromSourceTechnicianKpis(int index) =>
      sourceTechnicianKpis.removeAt(index);
  void insertAtIndexInSourceTechnicianKpis(
          int index, TechnicianSiteKpisVRow item) =>
      sourceTechnicianKpis.insert(index, item);
  void updateSourceTechnicianKpisAtIndex(
          int index, Function(TechnicianSiteKpisVRow) updateFn) =>
      sourceTechnicianKpis[index] = updateFn(sourceTechnicianKpis[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in technicianTasksPage widget.
  List<TicketCardsVRow>? sourceAssignedTicketRows;
  // Stores action output result for [Backend Call - Query Rows] action in technicianTasksPage widget.
  List<TechnicianSiteKpisVRow>? sourceTechnicianKpiRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
