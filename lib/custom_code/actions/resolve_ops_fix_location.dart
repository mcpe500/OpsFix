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

Future<String> resolveOpsFixLocation(String? rawInput) async {
  final user = SupaFlow.client.auth.currentUser;
  if (user == null) {
    return 'unauthenticated';
  }

  var candidate = (rawInput ?? '').trim();
  if (candidate.isEmpty || candidate == '-1') {
    return 'invalid';
  }

  final uri = Uri.tryParse(candidate);
  if (uri != null && uri.pathSegments.isNotEmpty) {
    final locationIndex = uri.pathSegments.indexOf('location');
    if (locationIndex >= 0 && locationIndex + 1 < uri.pathSegments.length) {
      candidate = uri.pathSegments[locationIndex + 1];
    } else if (uri.hasScheme) {
      candidate = uri.pathSegments.last;
    }
  }
  candidate =
      Uri.decodeComponent(candidate).replaceAll(RegExp(r'^/+|/+$'), '').trim();
  if (candidate.isEmpty) {
    return 'invalid';
  }

  Map<String, dynamic>? location;
  final slugRows = await SupaFlow.client
      .from('locations')
      .select('id, site_id, slug, code, name')
      .eq('is_active', true)
      .eq('slug', candidate.toLowerCase())
      .limit(2);
  if (slugRows.length == 1) {
    location = Map<String, dynamic>.from(slugRows.first);
  }

  if (location == null) {
    final currentSiteId = FFAppState().currentSiteId;
    final codeRows = currentSiteId.isEmpty
        ? await SupaFlow.client
            .from('locations')
            .select('id, site_id, slug, code, name')
            .eq('is_active', true)
            .ilike('code', candidate)
            .limit(2)
        : await SupaFlow.client
            .from('locations')
            .select('id, site_id, slug, code, name')
            .eq('is_active', true)
            .eq('site_id', currentSiteId)
            .ilike('code', candidate)
            .limit(2);
    if (codeRows.length == 1) {
      location = Map<String, dynamic>.from(codeRows.first);
    }
  }

  if (location == null) {
    FFAppState().update(() {
      FFAppState().currentLocationId = '';
      FFAppState().currentLocationSlug = '';
      FFAppState().currentLocationCode = '';
      FFAppState().currentLocationName = '';
    });
    return 'not_found';
  }

  FFAppState().update(() {
    FFAppState().currentSiteId = location!['site_id'] as String? ?? '';
    FFAppState().currentLocationId = location['id'] as String? ?? '';
    FFAppState().currentLocationSlug = location['slug'] as String? ?? '';
    FFAppState().currentLocationCode = location['code'] as String? ?? '';
    FFAppState().currentLocationName = location['name'] as String? ?? '';
    FFAppState().pendingLocationSlug = '';
  });
  return 'ok';
}
