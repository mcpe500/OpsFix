import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_asset_detail_page_model.dart';
export 'admin_asset_detail_page_model.dart';

/// Displays detailed identity, condition, maintenance, and ticket information
/// for one managed asset.
class AdminAssetDetailPageWidget extends StatefulWidget {
  const AdminAssetDetailPageWidget({
    super.key,
    this.assetCode,
    String? unitId,
    String? locationId,
  })  : this.unitId = unitId ?? '',
        this.locationId = locationId ?? '';

  final String? assetCode;

  /// Stable maintenance unit UUID.
  final String unitId;

  /// Parent location UUID used for deterministic back routing.
  final String locationId;

  static String routeName = 'AdminAssetDetailPage';
  static String routePath = '/admin-asset-detail';

  @override
  State<AdminAssetDetailPageWidget> createState() =>
      _AdminAssetDetailPageWidgetState();
}

class _AdminAssetDetailPageWidgetState
    extends State<AdminAssetDetailPageWidget> {
  late AdminAssetDetailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminAssetDetailPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.OpsFixResponsiveAdminAssetDetail(
              width: double.infinity,
              height: double.infinity,
              assetCode: widget!.assetCode,
              locationId: widget!.locationId,
              unitId: widget!.unitId,
            ),
          ),
        ),
      ),
    );
  }
}
