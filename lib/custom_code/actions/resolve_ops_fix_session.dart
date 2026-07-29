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
  final user = SupaFlow.client.auth.currentUser;
  if (user == null || user.id.isEmpty) return '';

  final profile = await SupaFlow.client
      .from('users')
      .select('role,is_active')
      .eq('id', user.id)
      .maybeSingle();
  if (profile == null || profile['is_active'] != true) return '';

  final scopeRows = await SupaFlow.client
      .from('user_site_scopes')
      .select('site_id,is_default')
      .eq('user_id', user.id)
      .order('is_default', ascending: false);
  final scopes = (scopeRows as List)
      .map((row) => Map<String, dynamic>.from(row as Map))
      .where((row) => (row['site_id']?.toString() ?? '').isNotEmpty)
      .toList();
  final allowedSites =
      scopes.map((row) => row['site_id'].toString()).toSet().toList();
  final defaultSite = allowedSites.isEmpty ? '' : allowedSites.first;
  final role = profile['role']?.toString().trim().toLowerCase() ?? '';
  final isReporter = role == 'reporter' || role == 'user';
  Map<String, dynamic>? selected;

  Future<Map<String, dynamic>?> activeLocation(String id) async {
    if (id.isEmpty || allowedSites.isEmpty) return null;
    final row = await SupaFlow.client
        .from('locations')
        .select('id,site_id,slug,code,name')
        .eq('id', id)
        .eq('is_active', true)
        .inFilter('site_id', allowedSites)
        .maybeSingle();
    return row == null ? null : Map<String, dynamic>.from(row);
  }

  if (isReporter &&
      FFAppState().currentLocationOwnerId == user.id &&
      FFAppState().currentLocationId.trim().isNotEmpty) {
    selected = await activeLocation(FFAppState().currentLocationId.trim());
  }

  if (isReporter && selected == null && allowedSites.isNotEmpty) {
    for (final siteId in allowedSites) {
      final raw = await SupaFlow.client.rpc(
        'list_opsfix_reporter_tickets',
        params: {'p_site_id': siteId, 'p_limit': 1, 'p_offset': 0},
      );
      final response =
          raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
      final incidents = response['incidents'] is List
          ? response['incidents'] as List
          : const <dynamic>[];
      if (incidents.isNotEmpty) {
        final incident = Map<String, dynamic>.from(incidents.first as Map);
        selected =
            await activeLocation(incident['location_id']?.toString() ?? '');
        if (selected != null) break;
      }
    }
  }

  if (selected == null && defaultSite.isNotEmpty) {
    final rows = await SupaFlow.client
        .from('locations')
        .select('id,site_id,slug,code,name')
        .eq('site_id', defaultSite)
        .eq('is_active', true)
        .order('created_at', ascending: true)
        .limit(1);
    if (rows.isNotEmpty) selected = Map<String, dynamic>.from(rows.first);
  }

  FFAppState().update(() {
    FFAppState().currentUserRole = role;
    FFAppState().currentSiteId =
        selected?['site_id']?.toString() ?? defaultSite;
    FFAppState().currentLocationId = selected?['id']?.toString() ?? '';
    FFAppState().currentLocationSlug = selected?['slug']?.toString() ?? '';
    FFAppState().currentLocationCode = selected?['code']?.toString() ?? '';
    FFAppState().currentLocationName = selected?['name']?.toString() ?? '';
    FFAppState().currentLocationOwnerId = user.id;
  });
  return role;
}
