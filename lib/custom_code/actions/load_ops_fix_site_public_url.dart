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

Future<String> loadOpsFixSitePublicUrl(String? siteId) async {
  try {
    final row = await SupaFlow.client
        .from('sites')
        .select('public_app_url')
        .eq('id', siteId ?? '')
        .maybeSingle();
    return row?['public_app_url'] as String? ?? '';
  } catch (_) {
    return '';
  }
}
