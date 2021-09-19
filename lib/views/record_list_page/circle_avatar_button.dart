import "package:flutter/material.dart";

class CircleAbatarButtonStyle {
  const CircleAbatarButtonStyle({
    this.margin,
    this.backgroundColor,
    this.size,
  });

  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? size;
}

class StylableCircleAbatarButton extends StatelessWidget {
  const StylableCircleAbatarButton({
    required this.onPressed,
    Key? key,
    this.style = const CircleAbatarButtonStyle(),
    this.text,
    this.imageUrl,
  }) : super(key: key);

  final CircleAbatarButtonStyle style;
  final VoidCallback? onPressed;
  final String? text;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) => Container(
      margin: style.margin,
      child: Stack(children: [
        if (imageUrl == null)
          CircleAvatar(
            radius: style.size! / 2,
            child: Text(text!,
                style: TextStyle(fontSize: style.size! / 6),
                overflow: TextOverflow.ellipsis),
            backgroundColor: style.backgroundColor,
          ),
        if (imageUrl != null)
          CircleAvatar(
            radius: style.size! / 2,
            backgroundImage: NetworkImage(imageUrl!),
            backgroundColor: style.backgroundColor,
          ),
        Positioned(
          width: style.size,
          height: style.size,
          child: RawMaterialButton(
            onPressed: onPressed,
            shape: CircleBorder(),
          ),
        ),
      ]));
}
