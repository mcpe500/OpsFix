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

Future<void> verifyOpsFixCompletion(
  String ticketId,
  String? attemptId,
  String decision,
  String comment,
) async {
  final safeAttemptId = (attemptId ?? '').trim();
  if (ticketId.isEmpty || safeAttemptId.isEmpty) {
    throw Exception('A valid ticket and completion attempt are required.');
  }
  final response = await SupaFlow.client.functions.invoke(
    'verify-completion',
    body: {
      'ticket_id': ticketId,
      'attempt_id': safeAttemptId,
      'decision': decision,
      'comment': comment,
    },
  );
  if (response.status >= 400) {
    throw Exception('Verification failed: ${response.data}');
  }
}
