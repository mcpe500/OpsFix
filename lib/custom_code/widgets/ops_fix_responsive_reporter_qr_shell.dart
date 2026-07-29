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

class OpsFixResponsiveReporterQrShell extends StatelessWidget {
  const OpsFixResponsiveReporterQrShell({
    super.key,
    this.width,
    this.height,
  });
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1200;
    final content = const Expanded(child: OpsFixReporterQrScanner());
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: const Color(0xFFF3F5F2),
        child: SafeArea(
          child: desktop
              ? Row(children: [
                  const OpsFixReporterSidebar(),
                  Expanded(child: Column(children: [content])),
                ])
              : Column(children: [
                  content,
                  const OpsFixReporterBottomNav(),
                ]),
        ),
      ),
    );
  }
}
