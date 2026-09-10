import 'package:flutter/material.dart';
import 'package:social_media_app/utils/colors.dart';


class CustomButtom extends StatelessWidget {
  const CustomButtom(
      {super.key,
        this.color,
        this.radius,
        this.child,
        this.label,
        required this.onPressed});

  final Color? color;
  final double? radius;
  final Widget? child;
  final String? label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsetsDirectional.all(10),
      minWidth: MediaQuery.of(context).size.width,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10))),
      color: color ?? AppColors.primary,
      onPressed: onPressed,
      child: child ??
          Text(
            label ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
    );
  }
}
