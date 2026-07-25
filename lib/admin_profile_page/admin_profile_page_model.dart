import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'admin_profile_page_widget.dart' show AdminProfilePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminProfilePageModel extends FlutterFlowModel<AdminProfilePageWidget> {
  ///  Local state fields for this page.

  List<UsersRow> sourceAdminProfile = [];
  void addToSourceAdminProfile(UsersRow item) => sourceAdminProfile.add(item);
  void removeFromSourceAdminProfile(UsersRow item) =>
      sourceAdminProfile.remove(item);
  void removeAtIndexFromSourceAdminProfile(int index) =>
      sourceAdminProfile.removeAt(index);
  void insertAtIndexInSourceAdminProfile(int index, UsersRow item) =>
      sourceAdminProfile.insert(index, item);
  void updateSourceAdminProfileAtIndex(
          int index, Function(UsersRow) updateFn) =>
      sourceAdminProfile[index] = updateFn(sourceAdminProfile[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in AdminProfilePage widget.
  List<UsersRow>? sourceAdminProfileRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
