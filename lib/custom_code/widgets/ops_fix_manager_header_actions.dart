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

import '/auth/supabase_auth/auth_util.dart';

class OpsFixManagerHeaderActions extends StatefulWidget {
  const OpsFixManagerHeaderActions({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<OpsFixManagerHeaderActions> createState() =>
      _OpsFixManagerHeaderActionsState();
}

class _OpsFixManagerHeaderActionsState
    extends State<OpsFixManagerHeaderActions> {
  String? _avatarUrl;

  bool get _profileActive =>
      GoRouterState.of(context).name == 'AdminProfilePage';

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    if (currentUserUid.isEmpty) return;
    try {
      final row = await SupaFlow.client
          .from('users')
          .select('avatar_url')
          .eq('id', currentUserUid)
          .maybeSingle();
      final value = row?['avatar_url']?.toString().trim() ?? '';
      if (mounted) setState(() => _avatarUrl = value.isEmpty ? null : value);
    } catch (_) {
      if (mounted) setState(() => _avatarUrl = null);
    }
  }

  Widget _fallback() => const ColoredBox(
        color: Color(0xFF6C5CE7),
        child: Center(
          child: Icon(Icons.person_outline, color: Colors.white, size: 24),
        ),
      );

  Future<void> _openProfile() async {
    if (_profileActive) return;
    await context.pushNamed('AdminProfilePage');
    await _loadAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'Buka notifikasi',
            child: IconButton(
              onPressed: () => context.pushNamed('NotificationsPage'),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF64748B),
              ),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF8FAFC),
                minimumSize: const Size(42, 42),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: _profileActive ? 'Profil admin' : 'Buka profil admin',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _profileActive ? null : _openProfile,
                customBorder: const CircleBorder(),
                child: SizedBox.square(
                  dimension: 42,
                  child: ClipOval(
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
          ),
        ],
      ),
    );
  }
}
