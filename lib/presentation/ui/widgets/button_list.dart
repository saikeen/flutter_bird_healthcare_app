import 'package:BirdHealthcare/presentation/ui/screens/add_bird_screen.dart';
import "package:flutter/material.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Button {
  IconData icon;
  MaterialColor backgroundColor;
  Button(this.icon, this.backgroundColor);
}

const int ADD_BUTTON_INDEX = 0;
const int FIRST_SELECTABLE_INDEX = 1;

class ButtonList extends HookConsumerWidget {
  final selectedIndex = useState(FIRST_SELECTABLE_INDEX);

  void _onButtonTapped(BuildContext context, int index) {
    if (index == ADD_BUTTON_INDEX) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddBirdScreen(),
          fullscreenDialog: true,
        ),
      );
      return null;
    }

    selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addButtonObjects =
        List.generate(1, (index) => Button(Icons.add, Colors.grey));
    final itemButtonObjects = [
      Button(Icons.monitor_weight, Colors.lightGreen),
      Button(Icons.restaurant, Colors.green),
      Button(Icons.water, Colors.teal),
      Button(Icons.medication, Colors.cyan),
      Button(Icons.wc, Colors.lightBlue),
      Button(Icons.mood, Colors.blue),
      Button(Icons.directions_run, Colors.indigo),
      Button(Icons.favorite, Colors.purple),
    ];
    final buttonObjects = [...addButtonObjects, ...itemButtonObjects];

    final List<Widget> widgets = buttonObjects
        .map(
          (obj) => _iconButton(context, buttonObjects.indexOf(obj), obj.icon,
              obj.backgroundColor),
        )
        .toList();

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widgets,
      ),
    );
  }

  Widget _iconButton(context, index, icon, backgroundColor) {
    return Container(
        decoration: BoxDecoration(
            color:
                index == selectedIndex.value ? backgroundColor : Colors.white,
            shape: BoxShape.circle),
        padding: EdgeInsets.all(3.0),
        child: Container(
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            padding: EdgeInsets.all(3.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: backgroundColor,
              child: IconButton(
                icon: Icon(icon),
                color: Colors.white,
                onPressed: () => {_onButtonTapped(context, index)},
              ),
            )));
  }
}
