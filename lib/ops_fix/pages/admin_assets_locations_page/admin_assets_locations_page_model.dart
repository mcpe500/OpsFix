import '/backend/supabase/supabase.dart';
import '/components/admin_location_form_sheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'admin_assets_locations_page_widget.dart'
    show AdminAssetsLocationsPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminAssetsLocationsPageModel
    extends FlutterFlowModel<AdminAssetsLocationsPageWidget> {
  ///  Local state fields for this page.

  List<LocationsRow> liveAdminLocations = [];
  void addToLiveAdminLocations(LocationsRow item) =>
      liveAdminLocations.add(item);
  void removeFromLiveAdminLocations(LocationsRow item) =>
      liveAdminLocations.remove(item);
  void removeAtIndexFromLiveAdminLocations(int index) =>
      liveAdminLocations.removeAt(index);
  void insertAtIndexInLiveAdminLocations(int index, LocationsRow item) =>
      liveAdminLocations.insert(index, item);
  void updateLiveAdminLocationsAtIndex(
          int index, Function(LocationsRow) updateFn) =>
      liveAdminLocations[index] = updateFn(liveAdminLocations[index]);

  List<MaintenanceUnitsRow> liveAdminUnits = [];
  void addToLiveAdminUnits(MaintenanceUnitsRow item) =>
      liveAdminUnits.add(item);
  void removeFromLiveAdminUnits(MaintenanceUnitsRow item) =>
      liveAdminUnits.remove(item);
  void removeAtIndexFromLiveAdminUnits(int index) =>
      liveAdminUnits.removeAt(index);
  void insertAtIndexInLiveAdminUnits(int index, MaintenanceUnitsRow item) =>
      liveAdminUnits.insert(index, item);
  void updateLiveAdminUnitsAtIndex(
          int index, Function(MaintenanceUnitsRow) updateFn) =>
      liveAdminUnits[index] = updateFn(liveAdminUnits[index]);

  List<MaintenanceUnitsRow> sourceManagerUnits = [];
  void addToSourceManagerUnits(MaintenanceUnitsRow item) =>
      sourceManagerUnits.add(item);
  void removeFromSourceManagerUnits(MaintenanceUnitsRow item) =>
      sourceManagerUnits.remove(item);
  void removeAtIndexFromSourceManagerUnits(int index) =>
      sourceManagerUnits.removeAt(index);
  void insertAtIndexInSourceManagerUnits(int index, MaintenanceUnitsRow item) =>
      sourceManagerUnits.insert(index, item);
  void updateSourceManagerUnitsAtIndex(
          int index, Function(MaintenanceUnitsRow) updateFn) =>
      sourceManagerUnits[index] = updateFn(sourceManagerUnits[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in adminAssetsLocationsPage widget.
  List<LocationsRow>? managerLocationRows;
  // Stores action output result for [Custom Action - archiveOpsFixManagerRecord] action in AdminDeleteLocationButton widget.
  String? managerArchiveLocationResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
