import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'admin_location_qr_sheet_widget.dart' show AdminLocationQrSheetWidget;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminLocationQrSheetModel
    extends FlutterFlowModel<AdminLocationQrSheetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for AdminSitePublicUrlField widget.
  FocusNode? adminSitePublicUrlFieldFocusNode;
  TextEditingController? adminSitePublicUrlFieldTextController;
  String? Function(BuildContext, String?)?
      adminSitePublicUrlFieldTextControllerValidator;
  // Stores action output result for [Custom Action - setOpsFixSitePublicUrl] action in AdminSavePublicUrlButton widget.
  String? savePublicUrlCode;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    adminSitePublicUrlFieldFocusNode?.dispose();
    adminSitePublicUrlFieldTextController?.dispose();
  }
}
