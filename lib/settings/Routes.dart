import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:flutter/material.dart';

import 'package:BirdHealthcare/pages/RootPage.dart';
import 'package:BirdHealthcare/pages/DammyPage.dart';
import 'package:BirdHealthcare/pages/RecordListPage.dart';
import 'package:BirdHealthcare/pages/RecordRegistrationPage.dart';
import 'package:BirdHealthcare/pages/BirdListPage.dart';
import 'package:BirdHealthcare/pages/BirdRegistrationPage.dart';
import 'package:BirdHealthcare/pages/BirdEditPage.dart';
class Routes {
  static final RouteFactory onGenerateRoute = (RouteSettings settings) {
    final ScreenArguments arg = settings.arguments;

    if (settings.name == '/fullscreen') {
      return MaterialPageRoute(
        builder: (context) => DammyPage(
          title: 'fullscreen',
          arguments: arg,
        ),
        fullscreenDialog: arg.fullscreenDialog,
      );
    } else if (settings.name == '/record_registration') {
      return MaterialPageRoute(
        builder: (context) => RecordRegistrationPage(
          title: '記録登録',
          arguments: arg,
        ),
        fullscreenDialog: arg.fullscreenDialog,
      );
    } else if (settings.name == '/bird_registration') {
      return MaterialPageRoute(
        builder: (context) => BirdRegistrationPage(
          title: '愛鳥登録',
          arguments: arg,
        ),
        fullscreenDialog: arg.fullscreenDialog,
      );
    } else if (settings.name == '/bird_edit') {
      return MaterialPageRoute(
        builder: (context) => BirdEditPage(
          title: '愛鳥編集',
          arguments: arg,
        ),
        fullscreenDialog: arg.fullscreenDialog,
      );
    } else if (Routes.routes.keys.contains(settings.name)) {
      return MaterialPageRoute(
        builder: routes[settings.name],
      );
    } else {
      throw Exception('invalid route');
    }
  };

  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => RootPage(),
    '/home': (context) => RecordListPage(title: 'ホーム'),
    '/settings': (context) => BirdListPage(title: '愛鳥管理'),
  };
}
