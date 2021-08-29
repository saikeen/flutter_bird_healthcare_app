import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'components/pages/bird_list_page.dart';
import 'components/pages/record_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomePage(),
    );
  }
}

class HomePage extends HookConsumerWidget {
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
