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

class OpsFixManagerProfileNav extends StatelessWidget {
  const OpsFixManagerProfileNav({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final active = GoRouterState.of(context).name == 'AdminProfilePage';
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: active ? null : () => context.pushNamed('AdminProfilePage'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF13213A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF253451)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.admin_panel_settings_outlined,
                color: const Color(0xFF70E1CB),
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AKUN PENGELOLA',
                      style: TextStyle(
                        color: const Color(0xFF70E1CB),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Buka profil admin',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
