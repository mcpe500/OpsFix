// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

class OpsFixTechnicianIdentityLabel extends StatefulWidget {
  const OpsFixTechnicianIdentityLabel({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixTechnicianIdentityLabel> createState() =>
      _OpsFixTechnicianIdentityLabelState();
}

class _OpsFixTechnicianIdentityLabelState
    extends State<OpsFixTechnicianIdentityLabel> {
  String _name = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final row = await SupaFlow.client
          .from('users')
          .select('display_name')
          .eq('id', currentUserUid)
          .maybeSingle();
      if (mounted)
        setState(() => _name = row?['display_name']?.toString().trim() ?? '');
    } catch (error) {
      debugPrint('Technician identity load failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        child: Text(
          _name.isEmpty
              ? OpsFixI18n.t('TEKNISI')
              : 'TEKNISI · ${_name.toUpperCase()}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: .35,
            color: Color(0xFF64748B),
          ),
        ),
      );
}
