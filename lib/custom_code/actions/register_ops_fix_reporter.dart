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
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> registerOpsFixReporter(
  String displayName,
  String email,
  String password,
) async {
  final safeName = displayName.trim();
  final safeEmail = email.trim().toLowerCase();
  if (safeName.length < 2 || safeName.length > 100) {
    return 'invalid_name';
  }
  if (!safeEmail.contains('@')) {
    return 'invalid_email';
  }
  if (password.length < 8) {
    return 'weak_password';
  }

  try {
    final response = await SupaFlow.client.auth.signUp(
      email: safeEmail,
      password: password,
      data: {'display_name': safeName},
    );
    final user = response.user;
    if (user == null) {
      return 'auth_error';
    }

    // When email confirmation is enabled, Supabase can obscure an existing
    // account with a synthetic user that has no identities.
    if (user.identities?.isEmpty ?? false) {
      return 'email_exists';
    }

    // Registration should finish on the login page whether or not this
    // project's email-confirmation setting immediately creates a session.
    if (response.session != null) {
      await SupaFlow.client.auth.signOut();
    }
    return 'success';
  } on AuthException catch (error) {
    debugPrint(
      'OpsFix signup Auth failure: '
      'code=${error.code ?? 'unknown'}, '
      'status=${error.statusCode ?? 'unknown'}',
    );
    switch (error.code) {
      case 'email_exists':
      case 'user_already_exists':
        return 'email_exists';
      case 'email_address_invalid':
        return 'invalid_email';
      case 'email_address_not_authorized':
        return 'email_not_authorized';
      case 'email_provider_disabled':
        return 'email_provider_disabled';
      case 'weak_password':
        return 'weak_password';
      case 'signup_disabled':
        return 'signup_disabled';
      case 'over_email_send_rate_limit':
        return 'email_rate_limited';
      case 'over_request_rate_limit':
        return 'request_rate_limited';
      case 'unexpected_failure':
        return 'database_error';
    }

    final message = error.message.toLowerCase();
    if (message.contains('already registered') ||
        message.contains('already exists')) {
      return 'email_exists';
    }
    if (message.contains('database error')) {
      return 'database_error';
    }
    return 'auth_error';
  } catch (error) {
    debugPrint(
      'OpsFix signup client failure: ${error.runtimeType}',
    );
    return 'network_error';
  }
}
