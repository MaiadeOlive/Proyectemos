import 'package:flutter/material.dart';

import '../../../commons/styles.dart';

class CardButton extends StatelessWidget {
  final String text;
  final double cardWidth;
  final double cardHeight;
  final String namedRoute;
  final Color backgroundColor;
  final IconData icon;
  final Color shadowColor;
  final double iconSize;

  const CardButton({
    Key? key,
    required this.text,
    required this.cardWidth,
    required this.cardHeight,
    required this.namedRoute,
    required this.backgroundColor,
    required this.icon,
    required this.shadowColor,
    required this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight,
      width: cardWidth,
      child: ElevatedButton.icon(
        icon: CircleAvatar(
          radius: 28,
          backgroundColor: backgroundColor,
          child: Icon(
            icon,
            size: iconSize,
            color: ThemeColors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 1,
          onPrimary: shadowColor,
          primary: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle: ThemeText.paragraph16GrayNormal,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(namedRoute);
        },
        label: Row(
          children: [
            const SizedBox(
              width: 25,
            ),
            Text(
              text,
              style: ThemeText.paragraph16GrayNormal,
            ),
          ],
        ),
      ),
    );
  }
}
