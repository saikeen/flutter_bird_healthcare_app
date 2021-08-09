import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:flutter/material.dart';

import 'package:BirdHealthcare/components/pages/root_page.dart';
import 'package:BirdHealthcare/components/pages/dammy_page.dart';
import 'package:BirdHealthcare/components/pages/record_list_page.dart';
import 'package:BirdHealthcare/components/pages/record_registration_page.dart';
import 'package:BirdHealthcare/components/pages/bird_list_page.dart';
import 'package:BirdHealthcare/components/pages/bird_registration_page.dart';
import 'package:BirdHealthcare/components/pages/bird_edit_page.dart';
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
    '/bird_list': (context) => BirdListPage(title: '愛鳥管理'),
  };
}
