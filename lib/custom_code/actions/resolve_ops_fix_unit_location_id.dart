// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/supabase/supabase.dart';

Future<String> resolveOpsFixUnitLocationId(
  String? unitId,
  String? assetCode,
  String? siteId,
) async {
  try {
    dynamic query = SupaFlow.client
        .from('maintenance_units')
        .select('location_id')
        .eq('site_id', siteId ?? '');
    final safeUnitId = (unitId ?? '').trim();
    query = safeUnitId.isNotEmpty
        ? query.eq('id', safeUnitId)
        : query.eq('unit_code', assetCode ?? '');
    final row = await query.maybeSingle();
    return row?['location_id'] as String? ?? '';
  } catch (_) {
    return '';
  }
}
