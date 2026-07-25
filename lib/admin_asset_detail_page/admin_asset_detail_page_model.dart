import '/backend/supabase/supabase.dart';
import '/components/admin_maintenance_note_sheet_widget.dart';
import '/components/admin_unit_form_sheet_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'admin_asset_detail_page_widget.dart' show AdminAssetDetailPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminAssetDetailPageModel
    extends FlutterFlowModel<AdminAssetDetailPageWidget> {
  ///  Local state fields for this page.

  List<MaintenanceUnitsRow> sourceAssetDetail = [];
  void addToSourceAssetDetail(MaintenanceUnitsRow item) =>
      sourceAssetDetail.add(item);
  void removeFromSourceAssetDetail(MaintenanceUnitsRow item) =>
      sourceAssetDetail.remove(item);
  void removeAtIndexFromSourceAssetDetail(int index) =>
      sourceAssetDetail.removeAt(index);
  void insertAtIndexInSourceAssetDetail(int index, MaintenanceUnitsRow item) =>
      sourceAssetDetail.insert(index, item);
  void updateSourceAssetDetailAtIndex(
          int index, Function(MaintenanceUnitsRow) updateFn) =>
      sourceAssetDetail[index] = updateFn(sourceAssetDetail[index]);

  String? resolvedUnitId = '';

  String? resolvedLocationId = '';

  List<MaintenanceNoteCardsVRow> maintenanceNoteRows = [];
  void addToMaintenanceNoteRows(MaintenanceNoteCardsVRow item) =>
      maintenanceNoteRows.add(item);
  void removeFromMaintenanceNoteRows(MaintenanceNoteCardsVRow item) =>
      maintenanceNoteRows.remove(item);
  void removeAtIndexFromMaintenanceNoteRows(int index) =>
      maintenanceNoteRows.removeAt(index);
  void insertAtIndexInMaintenanceNoteRows(
          int index, MaintenanceNoteCardsVRow item) =>
      maintenanceNoteRows.insert(index, item);
  void updateMaintenanceNoteRowsAtIndex(
          int index, Function(MaintenanceNoteCardsVRow) updateFn) =>
      maintenanceNoteRows[index] = updateFn(maintenanceNoteRows[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - resolveOpsFixUnitId] action in AdminAssetDetailPage widget.
  String? resolvedAssetUnitId;
  // Stores action output result for [Custom Action - resolveOpsFixUnitLocationId] action in AdminAssetDetailPage widget.
  String? resolvedAssetLocationId;
  // Stores action output result for [Backend Call - Query Rows] action in AdminAssetDetailPage widget.
  List<MaintenanceUnitsRow>? stableAssetDetailRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminAssetDetailPage widget.
  List<MaintenanceNoteCardsVRow>? assetMaintenanceNoteRows;
  // Stores action output result for [Custom Action - archiveOpsFixManagerRecord] action in AdminAssetDeleteButton widget.
  String? managerArchiveUnitResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
