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
  if (user == null) return 'unauthenticated';

  var candidate = (rawInput ?? '').trim();
  if (candidate.isEmpty || candidate == '-1') return 'invalid';
  final uri = Uri.tryParse(candidate);
  if (uri != null && uri.pathSegments.isNotEmpty) {
    final index = uri.pathSegments.indexOf('location');
    if (index >= 0 && index + 1 < uri.pathSegments.length) {
      candidate = uri.pathSegments[index + 1];
    } else if (uri.hasScheme) {
      candidate = uri.pathSegments.last;
    }
  }
  candidate =
      Uri.decodeComponent(candidate).replaceAll(RegExp(r'^/+|/+$'), '').trim();
  if (candidate.isEmpty) return 'invalid';

  final scopeRows = await SupaFlow.client
      .from('user_site_scopes')
      .select('site_id')
      .eq('user_id', user.id);
  final allowedSites = (scopeRows as List)
      .map((row) => row['site_id']?.toString() ?? '')
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  if (allowedSites.isEmpty) return 'forbidden';

  Map<String, dynamic>? location;
  final slugRows = await SupaFlow.client
      .from('locations')
      .select('id,site_id,slug,code,name')
      .eq('is_active', true)
      .inFilter('site_id', allowedSites)
      .eq('slug', candidate.toLowerCase())
      .limit(2);
  if (slugRows.length == 1) {
    location = Map<String, dynamic>.from(slugRows.first);
  } else if (slugRows.length > 1) {
    return 'ambiguous';
  }

  if (location == null) {
    final currentSite = FFAppState().currentSiteId.trim();
    if (currentSite.isNotEmpty && allowedSites.contains(currentSite)) {
      final preferredRows = await SupaFlow.client
          .from('locations')
          .select('id,site_id,slug,code,name')
          .eq('is_active', true)
          .eq('site_id', currentSite)
          .ilike('code', candidate)
          .limit(2);
      if (preferredRows.length == 1) {
        location = Map<String, dynamic>.from(preferredRows.first);
      } else if (preferredRows.length > 1) {
        return 'ambiguous';
      }
    }
  }

  if (location == null) {
    final codeRows = await SupaFlow.client
        .from('locations')
        .select('id,site_id,slug,code,name')
        .eq('is_active', true)
        .inFilter('site_id', allowedSites)
        .ilike('code', candidate)
        .limit(2);
    if (codeRows.length == 1) {
      location = Map<String, dynamic>.from(codeRows.first);
    } else if (codeRows.length > 1) {
      return 'ambiguous';
    }
  }
  if (location == null) return 'not_found';

  FFAppState().update(() {
    FFAppState().currentSiteId = location!['site_id']?.toString() ?? '';
    FFAppState().currentLocationId = location['id']?.toString() ?? '';
    FFAppState().currentLocationSlug = location['slug']?.toString() ?? '';
    FFAppState().currentLocationCode = location['code']?.toString() ?? '';
    FFAppState().currentLocationName = location['name']?.toString() ?? '';
    FFAppState().currentLocationOwnerId = user.id;
    FFAppState().pendingLocationSlug = '';
  });
  return 'ok';
}
