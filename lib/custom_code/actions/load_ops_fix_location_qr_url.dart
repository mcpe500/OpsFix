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

Future<String> loadOpsFixLocationQrUrl(String? locationId) async {
  try {
    final location = await SupaFlow.client
        .from('locations')
        .select('site_id, slug')
        .eq('id', locationId ?? '')
        .eq('is_active', true)
        .maybeSingle();
    if (location == null) return '';
    final site = await SupaFlow.client
        .from('sites')
        .select('public_app_url')
        .eq('id', location['site_id'])
        .maybeSingle();
    final base = (site?['public_app_url'] as String? ?? '')
        .replaceAll(RegExp(r'/+$'), '');
    final slug = location['slug'] as String? ?? '';
    return base.isEmpty || slug.isEmpty ? '' : '$base/location/$slug';
  } catch (_) {
    return '';
  }
}
