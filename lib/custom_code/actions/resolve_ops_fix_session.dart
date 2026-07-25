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
import '/flutter_flow/flutter_flow_util.dart';

Future<String> resolveOpsFixSession() async {
  final userId = SupaFlow.client.auth.currentUser?.id;
  if (userId == null || userId.isEmpty) {
    return '';
  }

  final profile = await SupaFlow.client
      .from('users')
      .select('role, is_active')
      .eq('id', userId)
      .maybeSingle();
  if (profile == null || profile['is_active'] != true) {
    return '';
  }

  final scopes = await SupaFlow.client
      .from('user_site_scopes')
      .select('site_id, is_default')
      .eq('user_id', userId)
      .order('is_default', ascending: false)
      .limit(1);

  final role = profile['role']?.toString() ?? '';
  final siteId =
      scopes.isEmpty ? '' : scopes.first['site_id']?.toString() ?? '';

  Map<String, dynamic>? defaultLocation;
  if (siteId.isNotEmpty) {
    final locations = await SupaFlow.client
        .from('locations')
        .select('id, site_id, slug, code, name')
        .eq('site_id', siteId)
        .eq('is_active', true)
        .order('created_at', ascending: true)
        .limit(1);
    if (locations.isNotEmpty) {
      defaultLocation = Map<String, dynamic>.from(locations.first);
    }
  }

  FFAppState().update(() {
    FFAppState().currentUserRole = role;
    FFAppState().currentSiteId = siteId;
    FFAppState().currentLocationId = defaultLocation?['id']?.toString() ?? '';
    FFAppState().currentLocationSlug =
        defaultLocation?['slug']?.toString() ?? '';
    FFAppState().currentLocationCode =
        defaultLocation?['code']?.toString() ?? '';
    FFAppState().currentLocationName =
        defaultLocation?['name']?.toString() ?? '';
  });
  return role;
}
