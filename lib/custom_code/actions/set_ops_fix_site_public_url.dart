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

Future<String> setOpsFixSitePublicUrl(
  String? siteId,
  String? publicAppUrl,
) async {
  try {
    final response = await SupaFlow.client.rpc(
      'set_opsfix_site_public_url',
      params: {
        'p_site_id': siteId ?? '',
        'p_public_app_url': publicAppUrl ?? '',
      },
    );
    final result = Map<String, dynamic>.from(response as Map);
    return result['code'] as String? ?? 'network_error';
  } catch (_) {
    return 'network_error';
  }
}
