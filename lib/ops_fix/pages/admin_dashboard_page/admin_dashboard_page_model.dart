import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'admin_dashboard_page_widget.dart' show AdminDashboardPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminDashboardPageModel
    extends FlutterFlowModel<AdminDashboardPageWidget> {
  ///  Local state fields for this page.

  List<ManagerSiteKpisVRow> liveManagerKpis = [];
  void addToLiveManagerKpis(ManagerSiteKpisVRow item) =>
      liveManagerKpis.add(item);
  void removeFromLiveManagerKpis(ManagerSiteKpisVRow item) =>
      liveManagerKpis.remove(item);
  void removeAtIndexFromLiveManagerKpis(int index) =>
      liveManagerKpis.removeAt(index);
  void insertAtIndexInLiveManagerKpis(int index, ManagerSiteKpisVRow item) =>
      liveManagerKpis.insert(index, item);
  void updateLiveManagerKpisAtIndex(
          int index, Function(ManagerSiteKpisVRow) updateFn) =>
      liveManagerKpis[index] = updateFn(liveManagerKpis[index]);

  List<TicketCardsVRow> liveManagerRecentTickets = [];
  void addToLiveManagerRecentTickets(TicketCardsVRow item) =>
      liveManagerRecentTickets.add(item);
  void removeFromLiveManagerRecentTickets(TicketCardsVRow item) =>
      liveManagerRecentTickets.remove(item);
  void removeAtIndexFromLiveManagerRecentTickets(int index) =>
      liveManagerRecentTickets.removeAt(index);
  void insertAtIndexInLiveManagerRecentTickets(
          int index, TicketCardsVRow item) =>
      liveManagerRecentTickets.insert(index, item);
  void updateLiveManagerRecentTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveManagerRecentTickets[index] =
          updateFn(liveManagerRecentTickets[index]);

  List<NotificationsRow> liveManagerNotifications = [];
  void addToLiveManagerNotifications(NotificationsRow item) =>
      liveManagerNotifications.add(item);
  void removeFromLiveManagerNotifications(NotificationsRow item) =>
      liveManagerNotifications.remove(item);
  void removeAtIndexFromLiveManagerNotifications(int index) =>
      liveManagerNotifications.removeAt(index);
  void insertAtIndexInLiveManagerNotifications(
          int index, NotificationsRow item) =>
      liveManagerNotifications.insert(index, item);
  void updateLiveManagerNotificationsAtIndex(
          int index, Function(NotificationsRow) updateFn) =>
      liveManagerNotifications[index] =
          updateFn(liveManagerNotifications[index]);

  List<ManagerSiteKpisVRow> sourceManagerKpis = [];
  void addToSourceManagerKpis(ManagerSiteKpisVRow item) =>
      sourceManagerKpis.add(item);
  void removeFromSourceManagerKpis(ManagerSiteKpisVRow item) =>
      sourceManagerKpis.remove(item);
  void removeAtIndexFromSourceManagerKpis(int index) =>
      sourceManagerKpis.removeAt(index);
  void insertAtIndexInSourceManagerKpis(int index, ManagerSiteKpisVRow item) =>
      sourceManagerKpis.insert(index, item);
  void updateSourceManagerKpisAtIndex(
          int index, Function(ManagerSiteKpisVRow) updateFn) =>
      sourceManagerKpis[index] = updateFn(sourceManagerKpis[index]);

  List<TicketCardsVRow> sourceManagerRecentTickets = [];
  void addToSourceManagerRecentTickets(TicketCardsVRow item) =>
      sourceManagerRecentTickets.add(item);
  void removeFromSourceManagerRecentTickets(TicketCardsVRow item) =>
      sourceManagerRecentTickets.remove(item);
  void removeAtIndexFromSourceManagerRecentTickets(int index) =>
      sourceManagerRecentTickets.removeAt(index);
  void insertAtIndexInSourceManagerRecentTickets(
          int index, TicketCardsVRow item) =>
      sourceManagerRecentTickets.insert(index, item);
  void updateSourceManagerRecentTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      sourceManagerRecentTickets[index] =
          updateFn(sourceManagerRecentTickets[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in adminDashboardPage widget.
  List<ManagerSiteKpisVRow>? sourceManagerKpiRows;
  // Stores action output result for [Backend Call - Query Rows] action in adminDashboardPage widget.
  List<TicketCardsVRow>? sourceManagerRecentRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
