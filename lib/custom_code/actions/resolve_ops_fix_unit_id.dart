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

Future<String> resolveOpsFixUnitId(
  String? unitId,
  String? assetCode,
  String? siteId,
) async {
  try {
    final safeUnitId = (unitId ?? '').trim();
    if (safeUnitId.isNotEmpty) return safeUnitId;
    final row = await SupaFlow.client
        .from('maintenance_units')
        .select('id')
        .eq('site_id', siteId ?? '')
        .eq('unit_code', assetCode ?? '')
        .maybeSingle();
    return row?['id'] as String? ?? '';
  } catch (_) {
    return '';
  }
}
