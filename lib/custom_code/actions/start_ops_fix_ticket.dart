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

Future<void> startOpsFixTicket(String ticketId) async {
  final current = await SupaFlow.client
      .from('tickets')
      .select('version,status')
      .eq('id', ticketId)
      .maybeSingle();
  if (current == null) {
    throw Exception('Ticket not found or access denied.');
  }
  final version = (current['version'] as num).toInt();
  final updated = await SupaFlow.client
      .from('tickets')
      .update({'status': 'in_progress', 'version': version + 1})
      .eq('id', ticketId)
      .eq('version', version)
      .select('id');
  if (updated.isEmpty) {
    throw Exception('Ticket changed. Refresh and try again.');
  }
}
