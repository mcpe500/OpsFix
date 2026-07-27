import 'package:flutter/material.dart';
import '/backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _pendingLocationSlug =
          prefs.getString('ff_pendingLocationSlug') ?? _pendingLocationSlug;
    });
    _safeInit(() {
      _currentSiteId = prefs.getString('ff_currentSiteId') ?? _currentSiteId;
    });
    _safeInit(() {
      _currentLocationId =
          prefs.getString('ff_currentLocationId') ?? _currentLocationId;
    });
    _safeInit(() {
      _currentLocationSlug =
          prefs.getString('ff_currentLocationSlug') ?? _currentLocationSlug;
    });
    _safeInit(() {
      _currentLocationCode =
          prefs.getString('ff_currentLocationCode') ?? _currentLocationCode;
    });
    _safeInit(() {
      _currentLocationName =
          prefs.getString('ff_currentLocationName') ?? _currentLocationName;
    });
    _safeInit(() {
      _currentLocationOwnerId = prefs.getString('ff_currentLocationOwnerId') ??
          _currentLocationOwnerId;
    });
    _safeInit(() {
      _appLanguage = prefs.getString('ff_appLanguage') ?? _appLanguage;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  /// QR/deep-link location slug retained across authentication.
  String _pendingLocationSlug = '';
  String get pendingLocationSlug => _pendingLocationSlug;
  set pendingLocationSlug(String value) {
    _pendingLocationSlug = value;
    prefs.setString('ff_pendingLocationSlug', value);
  }

  /// Role loaded from the current Supabase users row.
  String _currentUserRole = '';
  String get currentUserRole => _currentUserRole;
  set currentUserRole(String value) {
    _currentUserRole = value;
  }

  /// Persisted active reporter location context.
  String _currentSiteId = '';
  String get currentSiteId => _currentSiteId;
  set currentSiteId(String value) {
    _currentSiteId = value;
    prefs.setString('ff_currentSiteId', value);
  }

  /// Persisted active reporter location context.
  String _currentLocationId = '';
  String get currentLocationId => _currentLocationId;
  set currentLocationId(String value) {
    _currentLocationId = value;
    prefs.setString('ff_currentLocationId', value);
  }

  /// Persisted active reporter location context.
  String _currentLocationSlug = '';
  String get currentLocationSlug => _currentLocationSlug;
  set currentLocationSlug(String value) {
    _currentLocationSlug = value;
    prefs.setString('ff_currentLocationSlug', value);
  }

  /// Persisted active reporter location context.
  String _currentLocationCode = '';
  String get currentLocationCode => _currentLocationCode;
  set currentLocationCode(String value) {
    _currentLocationCode = value;
    prefs.setString('ff_currentLocationCode', value);
  }

  /// Persisted active reporter location context.
  String _currentLocationName = '';
  String get currentLocationName => _currentLocationName;
  set currentLocationName(String value) {
    _currentLocationName = value;
    prefs.setString('ff_currentLocationName', value);
  }

  /// UID that owns the persisted active location context.
  String _currentLocationOwnerId = '';
  String get currentLocationOwnerId => _currentLocationOwnerId;
  set currentLocationOwnerId(String value) {
    _currentLocationOwnerId = value;
    prefs.setString('ff_currentLocationOwnerId', value);
  }

  /// Active UI language code (id/en).
  ///
  /// Mirrors the FlutterFlow locale so custom Dart can resolve a language
  /// without a BuildContext.
  String _appLanguage = '';
  String get appLanguage => _appLanguage;
  set appLanguage(String value) {
    _appLanguage = value;
    prefs.setString('ff_appLanguage', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
