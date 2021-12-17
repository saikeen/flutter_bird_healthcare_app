import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Button {
  dynamic data;
  dynamic icon;
  MaterialColor backgroundColor;
  Button(this.data, this.icon, this.backgroundColor);
}

const int ADD_BUTTON_INDEX = 0;

class SelectButtonList extends HookConsumerWidget {
  final void Function(dynamic selectedIndex, dynamic selectedData) handleChange;
  final dynamic selectedData;
  final List<dynamic> dataList;
  final dynamic selectButtonIcon;
  SelectButtonList(this.selectedData, this.dataList, this.handleChange,
      this.selectButtonIcon);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Button> selectButtonObjects = dataList
        .map((data) => Button(data, selectButtonIcon, Colors.orange))
        .toList();
    final List<Button> buttonObjects = [
      Button(null, FaIcon(FontAwesomeIcons.plus), Colors.grey),
      ...selectButtonObjects
    ];

    final List<Widget> widgets = buttonObjects
        .map(
          (obj) => Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: obj.data?.id != null &&
                              obj.data?.id == selectedData?.id
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
                      backgroundImage: (obj.data?.imageUrl ?? '').isNotEmpty
                          ? NetworkImage(obj.data?.imageUrl ?? '')
                          : null,
                      child: IconButton(
                        icon: obj.icon,
                        color: (obj.data?.imageUrl ?? '').isNotEmpty
                            ? Colors.transparent
                            : Colors.white,
                        onPressed: () => {
                          handleChange(buttonObjects.indexOf(obj), obj.data)
                        },
                      ),
                    ),
                  )),
              Text(obj.data?.name ?? ''),
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
