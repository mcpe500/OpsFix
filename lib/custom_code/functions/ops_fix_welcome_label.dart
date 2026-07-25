import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

/// Builds a safe personalized greeting from the authenticated user.
String? opsFixWelcomeLabel(
  String? name,
  String? email,
) {
  final display = (name ?? '').trim();
  final fallback = (email ?? '').split('@').first.trim();
  final value = display.isNotEmpty
      ? display
      : (fallback.isNotEmpty ? fallback : 'Pengguna');
  return 'Selamat datang, $value.';
}
