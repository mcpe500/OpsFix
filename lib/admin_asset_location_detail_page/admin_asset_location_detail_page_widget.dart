import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_asset_location_detail_page_model.dart';
export 'admin_asset_location_detail_page_model.dart';

/// Shows a location summary and a manageable list of facility units for admin
/// users.
class AdminAssetLocationDetailPageWidget extends StatefulWidget {
  const AdminAssetLocationDetailPageWidget({
    super.key,
    String? locationId,
  }) : this.locationId = locationId ?? '';

  /// Supabase location UUID selected from the asset registry.
  final String locationId;

  static String routeName = 'AdminAssetLocationDetailPage';
  static String routePath = '/admin-asset-location-detail';

  @override
  State<AdminAssetLocationDetailPageWidget> createState() =>
      _AdminAssetLocationDetailPageWidgetState();
}

class _AdminAssetLocationDetailPageWidgetState
    extends State<AdminAssetLocationDetailPageWidget> {
  late AdminAssetLocationDetailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminAssetLocationDetailPageModel());

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
            child: custom_widgets.OpsFixResponsiveAdminLocationDetail(
              width: double.infinity,
              height: double.infinity,
              locationId: widget!.locationId,
            ),
          ),
        ),
      ),
    );
  }
}
