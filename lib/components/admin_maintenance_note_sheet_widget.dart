import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_maintenance_note_sheet_model.dart';
export 'admin_maintenance_note_sheet_model.dart';

/// Reusable manager modal for append-only unit maintenance notes.
class AdminMaintenanceNoteSheetWidget extends StatefulWidget {
  const AdminMaintenanceNoteSheetWidget({
    super.key,
    this.unitId,
    this.locationId,
    this.assetCode,
  });

  final String? unitId;
  final String? locationId;
  final String? assetCode;

  @override
  State<AdminMaintenanceNoteSheetWidget> createState() =>
      _AdminMaintenanceNoteSheetWidgetState();
}

class _AdminMaintenanceNoteSheetWidgetState
    extends State<AdminMaintenanceNoteSheetWidget> {
  late AdminMaintenanceNoteSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminMaintenanceNoteSheetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
        child: custom_widgets.OpsFixManagerRecordForm(
          building: '',
          categoryCode: '',
          code: '',
          codeSort: 0,
          condition: 'operational',
          criticality: 'medium',
          description: '',
          floor: '',
          formKind: 'note',
          locationId: '',
          locationType: 'room',
          mode: 'create',
          positionLabel: '',
          recordId: widget!.unitId,
          recordIndex: 0,
          recordName: '',
          refreshAssetCode: widget!.assetCode,
          refreshLocationId: widget!.locationId,
          refreshTarget: 'asset_detail',
          refreshUnitId: widget!.unitId,
          siteId: '',
          slug: '',
          zoneCode: '',
          componentOptions: '',
        ),
      ),
    );
  }
}
