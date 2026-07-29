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
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

Future<void> openOpsFixAssetDetail(
  BuildContext context,
  int? unitIndex,
  String? locationId,
  String? siteId,
) async {
  final rows = await SupaFlow.client
      .from('maintenance_units')
      .select('id, location_id, unit_code')
      .eq('site_id', siteId ?? '')
      .eq('location_id', locationId ?? '')
      .eq('is_active', true)
      .order('code_sort')
      .range(unitIndex ?? 0, unitIndex ?? 0);
  if (rows.isEmpty) return;
  final row = rows.first;
  context.pushNamed(
    'AdminAssetDetailPage',
    queryParameters: {
      'unitId': serializeParam(row['id'], ParamType.String),
      'locationId': serializeParam(row['location_id'], ParamType.String),
      'assetCode': serializeParam(row['unit_code'], ParamType.String),
    }.withoutNulls,
    extra: _opsFixPageFade(),
  );
}
