import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'admin_activity_log_page_widget.dart' show AdminActivityLogPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminActivityLogPageModel
    extends FlutterFlowModel<AdminActivityLogPageWidget> {
  ///  Local state fields for this page.

  List<TicketEventsRow> liveAdminActivity = [];
  void addToLiveAdminActivity(TicketEventsRow item) =>
      liveAdminActivity.add(item);
  void removeFromLiveAdminActivity(TicketEventsRow item) =>
      liveAdminActivity.remove(item);
  void removeAtIndexFromLiveAdminActivity(int index) =>
      liveAdminActivity.removeAt(index);
  void insertAtIndexInLiveAdminActivity(int index, TicketEventsRow item) =>
      liveAdminActivity.insert(index, item);
  void updateLiveAdminActivityAtIndex(
          int index, Function(TicketEventsRow) updateFn) =>
      liveAdminActivity[index] = updateFn(liveAdminActivity[index]);

  List<TicketEventsRow> sourceManagerEvents = [];
  void addToSourceManagerEvents(TicketEventsRow item) =>
      sourceManagerEvents.add(item);
  void removeFromSourceManagerEvents(TicketEventsRow item) =>
      sourceManagerEvents.remove(item);
  void removeAtIndexFromSourceManagerEvents(int index) =>
      sourceManagerEvents.removeAt(index);
  void insertAtIndexInSourceManagerEvents(int index, TicketEventsRow item) =>
      sourceManagerEvents.insert(index, item);
  void updateSourceManagerEventsAtIndex(
          int index, Function(TicketEventsRow) updateFn) =>
      sourceManagerEvents[index] = updateFn(sourceManagerEvents[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in adminActivityLogPage widget.
  List<TicketEventsRow>? loadedAuditEvents;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
