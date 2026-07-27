import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePageWidget> {
  ///  Local state fields for this page.

  List<UsersRow> sourceProfileRows = [];
  void addToSourceProfileRows(UsersRow item) => sourceProfileRows.add(item);
  void removeFromSourceProfileRows(UsersRow item) =>
      sourceProfileRows.remove(item);
  void removeAtIndexFromSourceProfileRows(int index) =>
      sourceProfileRows.removeAt(index);
  void insertAtIndexInSourceProfileRows(int index, UsersRow item) =>
      sourceProfileRows.insert(index, item);
  void updateSourceProfileRowsAtIndex(int index, Function(UsersRow) updateFn) =>
      sourceProfileRows[index] = updateFn(sourceProfileRows[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in ProfilePage widget.
  List<UsersRow>? sourceProfileQueryRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
