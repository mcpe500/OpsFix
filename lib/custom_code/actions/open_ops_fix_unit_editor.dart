// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import '/custom_code/widgets/ops_fix_responsive_unit_form.dart';
import '/flutter_flow/flutter_flow_util.dart';

Future<String> openOpsFixUnitEditor(
  BuildContext context,
  String? siteId,
  String? unitId,
  String? locationId,
  String? unitCode,
) async {
  final safeSiteId = (siteId ?? '').trim();
  final safeUnitId = (unitId ?? '').trim();
  final safeLocationId = (locationId ?? '').trim();
  if (safeSiteId.isEmpty || safeUnitId.isEmpty || safeLocationId.isEmpty) {
    return 'invalid';
  }
  final size = MediaQuery.sizeOf(context);
  final form = OpsFixResponsiveUnitForm(
    mode: 'edit',
    siteId: safeSiteId,
    locationId: safeLocationId,
    unitId: safeUnitId,
    unitCode: unitCode ?? '',
  );
  bool? changed;
  if (size.width < 480) {
    changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.92,
          ),
          child: form,
        ),
      ),
    );
  } else {
    changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width >= 1200 ? 820 : 720,
            maxHeight: size.height * 0.88,
          ),
          child: form,
        ),
      ),
    );
  }
  if (changed != true || !context.mounted) return 'cancelled';
  context.pushReplacementNamed(
    'AdminAssetDetailPage',
    queryParameters: {
      'unitId': safeUnitId,
      'locationId': safeLocationId,
      'assetCode': unitCode ?? '',
    },
  );
  return 'updated';
}
