import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_unit_form_sheet_model.dart';
export 'admin_unit_form_sheet_model.dart';

/// Reusable manager modal for adding or editing a unit.
class AdminUnitFormSheetWidget extends StatefulWidget {
  const AdminUnitFormSheetWidget({
    super.key,
    this.mode,
    this.unitId,
    this.locationId,
    this.unitCode,
    this.codeSort,
    this.recordName,
    this.categoryCode,
    this.positionLabel,
    this.componentOptions,
    this.criticality,
    this.condition,
    this.refreshTarget,
  });

  final String? mode;
  final String? unitId;
  final String? locationId;
  final String? unitCode;
  final int? codeSort;
  final String? recordName;
  final String? categoryCode;
  final String? positionLabel;
  final String? componentOptions;
  final String? criticality;
  final String? condition;
  final String? refreshTarget;

  @override
  State<AdminUnitFormSheetWidget> createState() =>
      _AdminUnitFormSheetWidgetState();
}

class _AdminUnitFormSheetWidgetState extends State<AdminUnitFormSheetWidget> {
  late AdminUnitFormSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminUnitFormSheetModel());

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
          categoryCode: widget!.categoryCode,
          code: widget!.unitCode,
          codeSort: widget!.codeSort,
          componentOptions: widget!.componentOptions,
          condition: widget!.condition,
          criticality: widget!.criticality,
          description: '',
          floor: '',
          formKind: 'unit',
          locationId: widget!.locationId,
          locationType: 'room',
          mode: widget!.mode,
          positionLabel: widget!.positionLabel,
          recordId: widget!.unitId,
          recordIndex: 0,
          recordName: widget!.recordName,
          refreshAssetCode: widget!.unitCode,
          refreshLocationId: widget!.locationId,
          refreshTarget: widget!.refreshTarget,
          refreshUnitId: widget!.unitId,
          siteId: '',
          slug: '',
          zoneCode: '',
        ),
      ),
    );
  }
}
