import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'technician_profile_page_widget.dart' show TechnicianProfilePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TechnicianProfilePageModel
    extends FlutterFlowModel<TechnicianProfilePageWidget> {
  ///  Local state fields for this page.

  List<UsersRow> sourceTechnicianProfile = [];
  void addToSourceTechnicianProfile(UsersRow item) =>
      sourceTechnicianProfile.add(item);
  void removeFromSourceTechnicianProfile(UsersRow item) =>
      sourceTechnicianProfile.remove(item);
  void removeAtIndexFromSourceTechnicianProfile(int index) =>
      sourceTechnicianProfile.removeAt(index);
  void insertAtIndexInSourceTechnicianProfile(int index, UsersRow item) =>
      sourceTechnicianProfile.insert(index, item);
  void updateSourceTechnicianProfileAtIndex(
          int index, Function(UsersRow) updateFn) =>
      sourceTechnicianProfile[index] = updateFn(sourceTechnicianProfile[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in TechnicianProfilePage widget.
  List<UsersRow>? sourceTechnicianProfileRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
