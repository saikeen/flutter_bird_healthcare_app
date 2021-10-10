import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '/../views/bird_list_page/bird_list_page.dart';
import '/../views/record_list_page/record_list_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static List<Widget> _pageList = [
    RecordListPage(),
    BirdListPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);

    void _onItemTapped(int index) {
      selectedIndex.value = index;
    }

    return Scaffold(
      body: _pageList[selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: '愛鳥管理',
          ),
        ],
        currentIndex: selectedIndex.value,
        onTap: _onItemTapped,
      ),
    );
  }
}
