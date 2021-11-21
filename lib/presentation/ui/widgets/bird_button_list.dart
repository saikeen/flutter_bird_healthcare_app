import 'package:BirdHealthcare/core/domain/bird.dart';
import 'package:BirdHealthcare/presentation/models/bird_list_model.dart';
import 'package:BirdHealthcare/presentation/models/select_bird_model.dart';
import 'package:BirdHealthcare/presentation/providers/bird_provider.dart';
import 'package:BirdHealthcare/presentation/providers/record_provider.dart';
import 'package:BirdHealthcare/presentation/ui/screens/add_bird_screen.dart';
import "package:flutter/material.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Button {
  Bird? bird;
  FaIcon icon;
  MaterialColor backgroundColor;
  Button(this.bird, this.icon, this.backgroundColor);
}

const int ADD_BUTTON_INDEX = 0;
const int FIRST_SELECTABLE_INDEX = 1;

class BirdButtonList extends HookConsumerWidget {
  BirdButtonList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _birdListProvider = ref.watch(birdListProvider);
    final _selectBirdProvider = ref.watch(selectBirdProvider);

    final List<Button> addButtonObjects = List.generate(
        1, (index) => Button(null, FaIcon(FontAwesomeIcons.plus), Colors.grey));
    final List<Button> birdButtonObjects = _birdListProvider.birds
        .map((bird) =>
            Button(bird, FaIcon(FontAwesomeIcons.dove), Colors.orange))
        .toList();
    final List<Button> buttonObjects = [
      ...addButtonObjects,
      ...birdButtonObjects
    ];

    final List<Widget> widgets = buttonObjects
        .map(
          (obj) => Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: obj.bird?.id != null &&
                              obj.bird?.id == _selectBirdProvider.bird?.id
                          ? obj.backgroundColor
                          : Colors.white,
                      shape: BoxShape.circle),
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    padding: EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: obj.backgroundColor,
                      backgroundImage: (obj.bird?.imageUrl ?? '').isNotEmpty
                          ? NetworkImage(obj.bird?.imageUrl ?? '')
                          : null,
                      child: IconButton(
                        icon: obj.icon,
                        color: (obj.bird?.imageUrl ?? '').isNotEmpty
                            ? Colors.transparent
                            : Colors.white,
                        onPressed: () => {
                          if (buttonObjects.indexOf(obj) == ADD_BUTTON_INDEX)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddBirdScreen(),
                                  fullscreenDialog: true,
                                ),
                              )
                            }
                          else
                            {_selectBirdProvider.setBird(obj.bird)}
                        },
                      ),
                    ),
                  )),
              Text(obj.bird?.name ?? ''),
            ],
          ),
        )
        .toList();

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widgets,
      ),
    );
  }
}
