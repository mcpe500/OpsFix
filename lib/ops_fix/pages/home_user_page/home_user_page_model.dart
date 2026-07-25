import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'home_user_page_widget.dart' show HomeUserPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeUserPageModel extends FlutterFlowModel<HomeUserPageWidget> {
  ///  Local state fields for this page.

  List<MaintenanceUnitsRow> liveUnits = [];
  void addToLiveUnits(MaintenanceUnitsRow item) => liveUnits.add(item);
  void removeFromLiveUnits(MaintenanceUnitsRow item) => liveUnits.remove(item);
  void removeAtIndexFromLiveUnits(int index) => liveUnits.removeAt(index);
  void insertAtIndexInLiveUnits(int index, MaintenanceUnitsRow item) =>
      liveUnits.insert(index, item);
  void updateLiveUnitsAtIndex(
          int index, Function(MaintenanceUnitsRow) updateFn) =>
      liveUnits[index] = updateFn(liveUnits[index]);

  List<TicketCardsVRow> liveTickets = [];
  void addToLiveTickets(TicketCardsVRow item) => liveTickets.add(item);
  void removeFromLiveTickets(TicketCardsVRow item) => liveTickets.remove(item);
  void removeAtIndexFromLiveTickets(int index) => liveTickets.removeAt(index);
  void insertAtIndexInLiveTickets(int index, TicketCardsVRow item) =>
      liveTickets.insert(index, item);
  void updateLiveTicketsAtIndex(
          int index, Function(TicketCardsVRow) updateFn) =>
      liveTickets[index] = updateFn(liveTickets[index]);

  List<MaintenanceUnitsRow> sourceUnits = [];
  void addToSourceUnits(MaintenanceUnitsRow item) => sourceUnits.add(item);
  void removeFromSourceUnits(MaintenanceUnitsRow item) =>
      sourceUnits.remove(item);
  void removeAtIndexFromSourceUnits(int index) => sourceUnits.removeAt(index);
  void insertAtIndexInSourceUnits(int index, MaintenanceUnitsRow item) =>
      sourceUnits.insert(index, item);
  void updateSourceUnitsAtIndex(
          int index, Function(MaintenanceUnitsRow) updateFn) =>
      sourceUnits[index] = updateFn(sourceUnits[index]);

  List<ReporterSiteKpisVRow> sourceReporterKpis = [];
  void addToSourceReporterKpis(ReporterSiteKpisVRow item) =>
      sourceReporterKpis.add(item);
  void removeFromSourceReporterKpis(ReporterSiteKpisVRow item) =>
      sourceReporterKpis.remove(item);
  void removeAtIndexFromSourceReporterKpis(int index) =>
      sourceReporterKpis.removeAt(index);
  void insertAtIndexInSourceReporterKpis(
          int index, ReporterSiteKpisVRow item) =>
      sourceReporterKpis.insert(index, item);
  void updateSourceReporterKpisAtIndex(
          int index, Function(ReporterSiteKpisVRow) updateFn) =>
      sourceReporterKpis[index] = updateFn(sourceReporterKpis[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in homeUserPage widget.
  List<MaintenanceUnitsRow>? sourceHomeUnits;
  // Stores action output result for [Backend Call - Query Rows] action in homeUserPage widget.
  List<ReporterSiteKpisVRow>? sourceReporterKpiRows;
  var reporterLocationScan = '';
  // Stores action output result for [Custom Action - resolveOpsFixLocation] action in UserHomeScanButton widget.
  String? locationResolution;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
