import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double radius;
  final double iconSize;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.radius = 10,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white30),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.all(8),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
