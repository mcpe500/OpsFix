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

Future<void> submitOpsFixCompletion(
  String ticketId,
  String note,
  String proofUrl,
) async {
  final response = await SupaFlow.client.functions.invoke(
    'submit-completion',
    body: {
      'ticket_id': ticketId,
      'note': note.trim(),
      'proof_url': proofUrl,
      'checklist': <dynamic>[],
    },
  );
  if (response.status >= 400) {
    throw Exception('Completion submission failed: ${response.data}');
  }
}
