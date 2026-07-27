import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'technician_ticket_detail_page_widget.dart'
    show TechnicianTicketDetailPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TechnicianTicketDetailPageModel
    extends FlutterFlowModel<TechnicianTicketDetailPageWidget> {
  ///  Local state fields for this page.

  String? workNotes = '';

  String? ticketLoadState = 'invalid';

  List<TicketCardsVRow> liveTechnicianTicket = [];
  void addToLiveTechnicianTicket(TicketCardsVRow item) =>
      liveTechnicianTicket.add(item);
  void removeFromLiveTechnicianTicket(TicketCardsVRow item) =>
      liveTechnicianTicket.remove(item);
  void removeAtIndexFromLiveTechnicianTicket(int index) =>
      liveTechnicianTicket.removeAt(index);
  void insertAtIndexInLiveTechnicianTicket(int index, TicketCardsVRow item) =>
      liveTechnicianTicket.insert(index, item);
  void updateLiveTechnicianTicketAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveTechnicianTicket[index] = updateFn(liveTechnicianTicket[index]);

  List<TicketEventsRow> liveTechnicianEvents = [];
  void addToLiveTechnicianEvents(TicketEventsRow item) =>
      liveTechnicianEvents.add(item);
  void removeFromLiveTechnicianEvents(TicketEventsRow item) =>
      liveTechnicianEvents.remove(item);
  void removeAtIndexFromLiveTechnicianEvents(int index) =>
      liveTechnicianEvents.removeAt(index);
  void insertAtIndexInLiveTechnicianEvents(int index, TicketEventsRow item) =>
      liveTechnicianEvents.insert(index, item);
  void updateLiveTechnicianEventsAtIndex(
          int index, Function(TicketEventsRow) updateFn) =>
      liveTechnicianEvents[index] = updateFn(liveTechnicianEvents[index]);

  List<TicketDetailVRow> sourceTechnicianDetail = [];
  void addToSourceTechnicianDetail(TicketDetailVRow item) =>
      sourceTechnicianDetail.add(item);
  void removeFromSourceTechnicianDetail(TicketDetailVRow item) =>
      sourceTechnicianDetail.remove(item);
  void removeAtIndexFromSourceTechnicianDetail(int index) =>
      sourceTechnicianDetail.removeAt(index);
  void insertAtIndexInSourceTechnicianDetail(
          int index, TicketDetailVRow item) =>
      sourceTechnicianDetail.insert(index, item);
  void updateSourceTechnicianDetailAtIndex(
          int index, Function(TicketDetailVRow) updateFn) =>
      sourceTechnicianDetail[index] = updateFn(sourceTechnicianDetail[index]);

  List<TicketEventsRow> sourceTechnicianEvents = [];
  void addToSourceTechnicianEvents(TicketEventsRow item) =>
      sourceTechnicianEvents.add(item);
  void removeFromSourceTechnicianEvents(TicketEventsRow item) =>
      sourceTechnicianEvents.remove(item);
  void removeAtIndexFromSourceTechnicianEvents(int index) =>
      sourceTechnicianEvents.removeAt(index);
  void insertAtIndexInSourceTechnicianEvents(int index, TicketEventsRow item) =>
      sourceTechnicianEvents.insert(index, item);
  void updateSourceTechnicianEventsAtIndex(
          int index, Function(TicketEventsRow) updateFn) =>
      sourceTechnicianEvents[index] = updateFn(sourceTechnicianEvents[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
