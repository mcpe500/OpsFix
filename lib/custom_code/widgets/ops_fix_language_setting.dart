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
import '/flutter_flow/flutter_flow_util.dart';

/// Indonesian/English lookup shared by every OpsFix custom widget.
///
/// FlutterFlow's own localization handles FF-managed Text widgets. It cannot
/// reach custom Dart, which is where almost all of this app's copy lives, so
/// custom widgets route their user-visible strings through [t] / [tf].
///
/// The map is keyed by the Indonesian source string. That choice is
/// deliberate: an untranslated string falls through to the Indonesian original
/// instead of rendering blank, which is how FlutterFlow's own `getText`
/// behaves when a locale slot is empty.
class OpsFixI18n {
  const OpsFixI18n._();

  static const String defaultLanguage = 'id';

  /// The active language code (`'id'` or `'en'`).
  ///
  /// FlutterFlow's locale is the source of truth whenever a [BuildContext] is
  /// available. `FFAppState().appLanguage` mirrors it for the places that have
  /// no context — custom actions, and async callbacks that resolve after the
  /// element is gone.
  static String languageOf([BuildContext? context]) {
    if (context != null) {
      final localizations =
          Localizations.of<FFLocalizations>(context, FFLocalizations);
      final code = localizations?.languageCode.trim() ?? '';
      if (code.isNotEmpty) return code.split('_').first;
    }
    final mirrored = FFAppState().appLanguage.trim();
    return mirrored.isEmpty ? defaultLanguage : mirrored;
  }

  static bool isEnglish([BuildContext? context]) => languageOf(context) == 'en';

  /// Translates [source] — the Indonesian original — for the active language.
  static String t(String source, [BuildContext? context]) =>
      isEnglish(context) ? (_en[source] ?? source) : source;

  /// Like [t], but replaces the `{0}`, `{1}`, ... placeholders with [args].
  ///
  /// Used for strings that were Dart interpolations before translation, so the
  /// English word order can differ from the Indonesian.
  static String tf(String source, List<Object?> args, [BuildContext? context]) {
    var out = t(source, context);
    for (var i = 0; i < args.length; i++) {
      out = out.replaceAll('{$i}', args[i]?.toString() ?? '');
    }
    return out;
  }

  static const Map<String, String> _en = <String, String>{
    'Bahasa': 'Language',
    'Bahasa aplikasi': 'App language',
    'Pilih bahasa tampilan aplikasi.': 'Choose the app display language.',
  };
}

/// Compact `ID | EN` selector.
///
/// Writes both halves of the language state in one place:
///   * `setAppLanguage(...)` drives FlutterFlow's own locale, so every
///     FF-managed Text switches;
///   * `FFAppState().appLanguage` mirrors it so [OpsFixI18n] can resolve a
///     language without a BuildContext.
///
/// Intentionally self-sizing (`MainAxisSize.min`, no fixed height). The
/// previous language switcher was removed in prompts12 because it was inserted
/// as a fixed-height sibling above the logout footer and pushed it off-screen;
/// this control is designed to be dropped into a scrolling profile column
/// without displacing anything.
class OpsFixLanguageSetting extends StatefulWidget {
  const OpsFixLanguageSetting({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OpsFixLanguageSetting> createState() => _OpsFixLanguageSettingState();
}

class _OpsFixLanguageSettingState extends State<OpsFixLanguageSetting> {
  static const List<List<String>> _options = <List<String>>[
    <String>['id', 'ID', 'Bahasa Indonesia'],
    <String>['en', 'EN', 'English'],
  ];

  void _select(String code) {
    if (OpsFixI18n.languageOf(context) == code) return;
    FFAppState().update(() {
      FFAppState().appLanguage = code;
    });
    setAppLanguage(context, code);
  }

  @override
  Widget build(BuildContext context) {
    final active = OpsFixI18n.languageOf(context);
    return Container(
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              borderRadius: BorderRadius.circular(13),
            ),
            child:
                const Icon(Icons.language, color: Color(0xFF6C5CE7), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OpsFixI18n.t('Bahasa aplikasi', context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  OpsFixI18n.t('Pilih bahasa tampilan aplikasi.', context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F2),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in _options)
                  _segment(
                    code: option[0],
                    label: option[1],
                    tooltip: option[2],
                    selected: active == option[0],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _segment({
    required String code,
    required String label,
    required String tooltip,
    required bool selected,
  }) =>
      Tooltip(
        message: tooltip,
        child: Semantics(
          button: true,
          selected: selected,
          label: tooltip,
          child: InkWell(
            borderRadius: BorderRadius.circular(9),
            onTap: () => _select(code),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF6C5CE7) : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
}
