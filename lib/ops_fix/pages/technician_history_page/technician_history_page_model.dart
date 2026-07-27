import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'technician_history_page_widget.dart' show TechnicianHistoryPageWidget;
import 'package:flutter/material.dart';
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
