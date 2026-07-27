import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/supabase/supabase.dart';

import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier, [Widget? entryPage]) =>
    GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? entryPage ?? LaunchPageWidget()
          : LoginPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? entryPage ?? LaunchPageWidget()
              : LoginPageWidget(),
        ),
        FFRoute(
          name: HomeUserPageCopyWidget.routeName,
          path: HomeUserPageCopyWidget.routePath,
          builder: (context, params) => HomeUserPageCopyWidget(),
        ),
        FFRoute(
          name: MyTicketsPageCopyWidget.routeName,
          path: MyTicketsPageCopyWidget.routePath,
          builder: (context, params) => MyTicketsPageCopyWidget(),
        ),
        FFRoute(
          name: RegisterPageCopyWidget.routeName,
          path: RegisterPageCopyWidget.routePath,
          builder: (context, params) => RegisterPageCopyWidget(),
        ),
        FFRoute(
          name: ReportIssuePageCopyWidget.routeName,
          path: ReportIssuePageCopyWidget.routePath,
          builder: (context, params) => ReportIssuePageCopyWidget(),
        ),
        FFRoute(
          name: TechnicianHistoryPageCopyWidget.routeName,
          path: TechnicianHistoryPageCopyWidget.routePath,
          builder: (context, params) => TechnicianHistoryPageCopyWidget(),
        ),
        FFRoute(
          name: TechnicianTasksPageCopyWidget.routeName,
          path: TechnicianTasksPageCopyWidget.routePath,
          builder: (context, params) => TechnicianTasksPageCopyWidget(),
        ),
        FFRoute(
          name: TechnicianTicketDetailPageCopyWidget.routeName,
          path: TechnicianTicketDetailPageCopyWidget.routePath,
          builder: (context, params) => TechnicianTicketDetailPageCopyWidget(),
        ),
        FFRoute(
          name: TicketDetailPageCopyWidget.routeName,
          path: TicketDetailPageCopyWidget.routePath,
          builder: (context, params) => TicketDetailPageCopyWidget(),
        ),
        FFRoute(
          name: LoginPageWidget.routeName,
          path: LoginPageWidget.routePath,
          builder: (context, params) => LoginPageWidget(),
        ),
        FFRoute(
          name: TicketDetailPageWidget.routeName,
          path: TicketDetailPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => TicketDetailPageWidget(
            ticketId: params.getParam(
              'ticketId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AdminWorkBoardPageWidget.routeName,
          path: AdminWorkBoardPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdminWorkBoardPageWidget(),
        ),
        FFRoute(
          name: LoginPageCopyWidget.routeName,
          path: LoginPageCopyWidget.routePath,
          builder: (context, params) => LoginPageCopyWidget(),
        ),
        FFRoute(
          name: UpdatePasswordPageWidget.routeName,
          path: UpdatePasswordPageWidget.routePath,
          builder: (context, params) => UpdatePasswordPageWidget(),
        ),
        FFRoute(
          name: AdminTicketsPageWidget.routeName,
          path: AdminTicketsPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdminTicketsPageWidget(),
        ),
        FFRoute(
          name: LocationEntryPageWidget.routeName,
          path: LocationEntryPageWidget.routePath,
          builder: (context, params) => LocationEntryPageWidget(
            slug: params.getParam(
              'slug',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AdminTicketDetailPageWidget.routeName,
          path: AdminTicketDetailPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdminTicketDetailPageWidget(
            ticketId: params.getParam(
              'ticketId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LaunchPageWidget.routeName,
          path: LaunchPageWidget.routePath,
          builder: (context, params) => LaunchPageWidget(),
        ),
        FFRoute(
          name: AdminProfilePageWidget.routeName,
          path: AdminProfilePageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdminProfilePageWidget(),
        ),
        FFRoute(
          name: ForgotPasswordPageWidget.routeName,
          path: ForgotPasswordPageWidget.routePath,
          builder: (context, params) => ForgotPasswordPageWidget(),
        ),
        FFRoute(
          name: AdminAssetsLocationsPageWidget.routeName,
          path: AdminAssetsLocationsPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdminAssetsLocationsPageWidget(),
        ),
        FFRoute(
          name: RegisterPageWidget.routeName,
          path: RegisterPageWidget.routePath,
          builder: (context, params) => RegisterPageWidget(),
        ),
        FFRoute(
          name: AdminDashboardPageWidget.routeName,
          path: AdminDashboardPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdminDashboardPageWidget(),
        ),
        FFRoute(
          name: ProfilePageWidget.routeName,
          path: ProfilePageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => ProfilePageWidget(),
        ),
        FFRoute(
          name: HomeUserPageWidget.routeName,
          path: HomeUserPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => HomeUserPageWidget(),
        ),
        FFRoute(
          name: TechnicianTasksPageWidget.routeName,
          path: TechnicianTasksPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => TechnicianTasksPageWidget(),
        ),
        FFRoute(
          name: ReportIssuePageWidget.routeName,
          path: ReportIssuePageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => ReportIssuePageWidget(
            unitId: params.getParam(
              'unitId',
              ParamType.String,
            ),
            locationId: params.getParam(
              'locationId',
              ParamType.String,
            ),
            unitCode: params.getParam(
              'unitCode',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: MyTicketsPageWidget.routeName,
          path: MyTicketsPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => MyTicketsPageWidget(),
        ),
        FFRoute(
          name: AdminActivityLogPageWidget.routeName,
          path: AdminActivityLogPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdminActivityLogPageWidget(),
        ),
        FFRoute(
          name: TechnicianTicketDetailPageWidget.routeName,
          path: TechnicianTicketDetailPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => TechnicianTicketDetailPageWidget(
            ticketId: params.getParam(
              'ticketId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: TechnicianHistoryPageWidget.routeName,
          path: TechnicianHistoryPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => TechnicianHistoryPageWidget(),
        ),
        FFRoute(
          name: AdminAssetLocationDetailPageWidget.routeName,
          path: AdminAssetLocationDetailPageWidget.routePath,
          builder: (context, params) => AdminAssetLocationDetailPageWidget(
            locationId: params.getParam(
              'locationId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AdminAssetDetailPageWidget.routeName,
          path: AdminAssetDetailPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdminAssetDetailPageWidget(
            assetCode: params.getParam(
              'assetCode',
              ParamType.String,
            ),
            unitId: params.getParam(
              'unitId',
              ParamType.String,
            ),
            locationId: params.getParam(
              'locationId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: TechnicianProfilePageWidget.routeName,
          path: TechnicianProfilePageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => TechnicianProfilePageWidget(),
        ),
        FFRoute(
          name: NotificationsPageWidget.routeName,
          path: NotificationsPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => NotificationsPageWidget(),
        ),
        FFRoute(
          name: ReporterQrScannerPageWidget.routeName,
          path: ReporterQrScannerPageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => ReporterQrScannerPageWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/login';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/OpsFix_Logo_New.png',
                    fit: BoxFit.contain,
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
