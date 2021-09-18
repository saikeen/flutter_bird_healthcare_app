import 'package:BirdHealthcare/views/record_list_page/circle_avatar_button.dart';
import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/models/bird_list_model.dart';
import 'package:BirdHealthcare/providers/select_bird_provider.dart';
import "package:flutter/material.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CircleAbatarListViewStyle {
  const CircleAbatarListViewStyle({
    this.height,
  });

  final int? height;
}

class StylableCircleAbatarListView extends HookConsumerWidget {
  const StylableCircleAbatarListView({
    Key? key,
    this.style = const CircleAbatarListViewStyle(),
    this.data,
  }) : super(key: key);

  final CircleAbatarListViewStyle style;
  final BirdListModel? data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60.0,
      child: Consumer(builder: (context, watch, child) {
        final List<Bird>? birds = data!.birds;

        if (birds == null) {
          return CircularProgressIndicator();
        }

        final List<Widget> widgets = birds
            .map((bird) => StylableCircleAbatarButton(
                  style: CircleAbatarButtonStyle(
                      backgroundColor: Colors.grey.shade200, size: 60),
                  text: bird.name,
                  imageUrl: bird.imageUrl,
                  onPressed: () {
                    ref.watch(selectBirdProvider).setData(bird.id, bird.name);
                  },
                ))
            .toList();

        return ListView(
          scrollDirection: Axis.horizontal,
          children: widgets,
        );
      }),
    );
  }
}
