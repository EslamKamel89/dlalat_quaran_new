import 'package:dlalat_quran/utils/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;

  const PrimaryButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius == 0 ? 10 : borderRadius)))),
    );
  }
}
