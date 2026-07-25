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

  /// Current site scope selected for operational queries.
  String _currentSiteId = '';
  String get currentSiteId => _currentSiteId;
  set currentSiteId(String value) {
    _currentSiteId = value;
  }

  /// Database-resolved active location UUID for the session.
  String _currentLocationId = '';
  String get currentLocationId => _currentLocationId;
  set currentLocationId(String value) {
    _currentLocationId = value;
  }

  /// Database-resolved active location slug for the session.
  String _currentLocationSlug = '';
  String get currentLocationSlug => _currentLocationSlug;
  set currentLocationSlug(String value) {
    _currentLocationSlug = value;
  }

  /// Database-resolved active location code for the session.
  String _currentLocationCode = '';
  String get currentLocationCode => _currentLocationCode;
  set currentLocationCode(String value) {
    _currentLocationCode = value;
  }

  /// Database-resolved active location name for the session.
  String _currentLocationName = '';
  String get currentLocationName => _currentLocationName;
  set currentLocationName(String value) {
    _currentLocationName = value;
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
