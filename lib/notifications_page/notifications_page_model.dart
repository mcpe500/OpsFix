import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'notifications_page_widget.dart' show NotificationsPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationsPageModel extends FlutterFlowModel<NotificationsPageWidget> {
  ///  Local state fields for this page.

  List<NotificationsRow> notificationRows = [];
  void addToNotificationRows(NotificationsRow item) =>
      notificationRows.add(item);
  void removeFromNotificationRows(NotificationsRow item) =>
      notificationRows.remove(item);
  void removeAtIndexFromNotificationRows(int index) =>
      notificationRows.removeAt(index);
  void insertAtIndexInNotificationRows(int index, NotificationsRow item) =>
      notificationRows.insert(index, item);
  void updateNotificationRowsAtIndex(
          int index, Function(NotificationsRow) updateFn) =>
      notificationRows[index] = updateFn(notificationRows[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in NotificationsPage widget.
  List<NotificationsRow>? loadedNotifications;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
