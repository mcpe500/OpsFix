import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_location_form_sheet_model.dart';
export 'admin_location_form_sheet_model.dart';

/// Reusable manager modal for adding or editing a location.
class AdminLocationFormSheetWidget extends StatefulWidget {
  const AdminLocationFormSheetWidget({
    super.key,
    this.mode,
    this.siteId,
    this.locationId,
    this.recordIndex,
    this.code,
    this.recordName,
    this.locationType,
    this.building,
    this.floor,
    this.zoneCode,
    this.description,
    this.slug,
  });

  final String? mode;
  final String? siteId;
  final String? locationId;
  final int? recordIndex;
  final String? code;
  final String? recordName;
  final String? locationType;
  final String? building;
  final String? floor;
  final String? zoneCode;
  final String? description;
  final String? slug;

  @override
  State<AdminLocationFormSheetWidget> createState() =>
      _AdminLocationFormSheetWidgetState();
}

class _AdminLocationFormSheetWidgetState
    extends State<AdminLocationFormSheetWidget> {
  late AdminLocationFormSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminLocationFormSheetModel());

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
          building: widget!.building,
          categoryCode: '',
          code: widget!.code,
          codeSort: 0,
          condition: 'operational',
          criticality: 'medium',
          description: widget!.description,
          floor: widget!.floor,
          formKind: 'location',
          locationId: '',
          locationType: widget!.locationType,
          mode: widget!.mode,
          positionLabel: '',
          recordId: widget!.locationId,
          recordIndex: widget!.recordIndex,
          recordName: widget!.recordName,
          refreshAssetCode: '',
          refreshLocationId: '',
          refreshTarget: 'locations',
          refreshUnitId: '',
          siteId: widget!.siteId,
          slug: widget!.slug,
          zoneCode: widget!.zoneCode,
          componentOptions: '',
        ),
      ),
    );
  }
}
