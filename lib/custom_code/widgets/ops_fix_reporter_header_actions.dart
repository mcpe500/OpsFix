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
import '/custom_code/widgets/ops_fix_language_setting.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

Map<String, dynamic> _reporterHeaderFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixReporterHeaderActions extends StatefulWidget {
  const OpsFixReporterHeaderActions({
    super.key,
    this.width,
    this.height,
    this.profileActive = false,
    this.showBell = true,
  });
  final double? width;
  final double? height;
  final bool profileActive;
  final bool showBell;

  @override
  State<OpsFixReporterHeaderActions> createState() =>
      _OpsFixReporterHeaderActionsState();
}

class _OpsFixReporterHeaderActionsState
    extends State<OpsFixReporterHeaderActions> {
  String? _avatarUrl;
  String _initial = 'O';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (currentUserUid.isEmpty) return;
    try {
      final row = await SupaFlow.client
          .from('users')
          .select('display_name,avatar_url')
          .eq('id', currentUserUid)
          .maybeSingle();
      if (!mounted) return;
      final name = row?['display_name']?.toString().trim() ?? '';
      final avatar = row?['avatar_url']?.toString().trim() ?? '';
      setState(() {
        _initial = name.isEmpty ? 'O' : name.characters.first.toUpperCase();
        _avatarUrl = avatar.isEmpty ? null : avatar;
      });
    } catch (error) {
      debugPrint('Reporter header profile load failed: ${error.runtimeType}');
    }
  }

  Future<void> _openProfile() async {
    if (widget.profileActive) return;
    await context.pushNamed('ProfilePage', extra: _reporterHeaderFade());
    if (mounted) await _load();
  }

  Widget _fallback() => ColoredBox(
        color: const Color(0xFFF0EDFF),
        child: Center(
          child: Text(
            _initial,
            style: const TextStyle(
              color: Color(0xFF6C5CE7),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height ?? 44,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (widget.showBell) ...[
            const OpsFixNotificationBell(),
            const SizedBox(width: 8),
          ],
          Tooltip(
            message: OpsFixI18n.t('Profil Pengguna'),
            child: Material(
              color: Colors.transparent,
              shape: CircleBorder(
                side: BorderSide(
                  color: widget.profileActive
                      ? const Color(0xFF6C5CE7)
                      : const Color(0xFFDDE2E7),
                  width: widget.profileActive ? 2 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: widget.profileActive ? null : _openProfile,
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: _avatarUrl == null
                      ? _fallback()
                      : Image.network(
                          _avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallback(),
                        ),
                ),
              ),
            ),
          ),
        ]),
      );
}
