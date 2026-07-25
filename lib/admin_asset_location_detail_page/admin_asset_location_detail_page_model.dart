import '/backend/supabase/supabase.dart';
import '/components/admin_location_qr_sheet_widget.dart';
import '/components/admin_unit_form_sheet_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'admin_asset_location_detail_page_widget.dart'
    show AdminAssetLocationDetailPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminAssetLocationDetailPageModel
    extends FlutterFlowModel<AdminAssetLocationDetailPageWidget> {
  ///  Local state fields for this page.

  List<LocationsRow> sourceSiteLocations = [];
  void addToSourceSiteLocations(LocationsRow item) =>
      sourceSiteLocations.add(item);
  void removeFromSourceSiteLocations(LocationsRow item) =>
      sourceSiteLocations.remove(item);
  void removeAtIndexFromSourceSiteLocations(int index) =>
      sourceSiteLocations.removeAt(index);
  void insertAtIndexInSourceSiteLocations(int index, LocationsRow item) =>
      sourceSiteLocations.insert(index, item);
  void updateSourceSiteLocationsAtIndex(
          int index, Function(LocationsRow) updateFn) =>
      sourceSiteLocations[index] = updateFn(sourceSiteLocations[index]);

  List<MaintenanceUnitsRow> sourceLocationUnits = [];
  void addToSourceLocationUnits(MaintenanceUnitsRow item) =>
      sourceLocationUnits.add(item);
  void removeFromSourceLocationUnits(MaintenanceUnitsRow item) =>
      sourceLocationUnits.remove(item);
  void removeAtIndexFromSourceLocationUnits(int index) =>
      sourceLocationUnits.removeAt(index);
  void insertAtIndexInSourceLocationUnits(
          int index, MaintenanceUnitsRow item) =>
      sourceLocationUnits.insert(index, item);
  void updateSourceLocationUnitsAtIndex(
          int index, Function(MaintenanceUnitsRow) updateFn) =>
      sourceLocationUnits[index] = updateFn(sourceLocationUnits[index]);

  String? sitePublicAppUrl = '';

  String? locationQrUrl = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in AdminAssetLocationDetailPage widget.
  List<LocationsRow>? selectedManagerLocationRows;
  // Stores action output result for [Backend Call - Query Rows] action in AdminAssetLocationDetailPage widget.
  List<MaintenanceUnitsRow>? managerLocationUnitRows;
  // Stores action output result for [Custom Action - loadOpsFixSitePublicUrl] action in AdminAssetLocationDetailPage widget.
  String? loadedSitePublicUrl;
  // Stores action output result for [Custom Action - loadOpsFixLocationQrUrl] action in AdminAssetLocationDetailPage widget.
  String? loadedLocationQrUrl;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
