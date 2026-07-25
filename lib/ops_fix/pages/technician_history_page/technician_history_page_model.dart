import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'technician_history_page_widget.dart' show TechnicianHistoryPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TechnicianHistoryPageModel
    extends FlutterFlowModel<TechnicianHistoryPageWidget> {
  ///  Local state fields for this page.

  List<TicketCardsVRow> liveTechnicianHistory = [];
  void addToLiveTechnicianHistory(TicketCardsVRow item) =>
      liveTechnicianHistory.add(item);
  void removeFromLiveTechnicianHistory(TicketCardsVRow item) =>
      liveTechnicianHistory.remove(item);
  void removeAtIndexFromLiveTechnicianHistory(int index) =>
      liveTechnicianHistory.removeAt(index);
  void insertAtIndexInLiveTechnicianHistory(int index, TicketCardsVRow item) =>
      liveTechnicianHistory.insert(index, item);
  void updateLiveTechnicianHistoryAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveTechnicianHistory[index] = updateFn(liveTechnicianHistory[index]);

  List<TicketCardsVRow> sourceTechnicianHistory = [];
  void addToSourceTechnicianHistory(TicketCardsVRow item) =>
      sourceTechnicianHistory.add(item);
  void removeFromSourceTechnicianHistory(TicketCardsVRow item) =>
      sourceTechnicianHistory.remove(item);
  void removeAtIndexFromSourceTechnicianHistory(int index) =>
      sourceTechnicianHistory.removeAt(index);
  void insertAtIndexInSourceTechnicianHistory(
          int index, TicketCardsVRow item) =>
      sourceTechnicianHistory.insert(index, item);
  void updateSourceTechnicianHistoryAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      sourceTechnicianHistory[index] = updateFn(sourceTechnicianHistory[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in technicianHistoryPage widget.
  List<TicketCardsVRow>? sourceTechnicianHistoryRows;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
