import 'package:flutter/material.dart';

enum TabItem {
  home,
  settings,
}

const TabItemInfo = <TabItem, Map>{
  TabItem.home: {
    'icon': Icons.home_outlined,
    'label': 'ホーム',
    'routerName': '/home',
  },
  TabItem.settings: {
    'icon': Icons.list_alt_outlined,
    'label': '愛鳥管理',
    'routerName': '/bird_list',
  },
};
