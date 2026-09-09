import 'package:flutter/material.dart';

class FooterTextWithIcon extends StatelessWidget {
   FooterTextWithIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
