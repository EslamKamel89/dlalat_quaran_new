import 'package:dlalat_quran/utils/colors.dart';
import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  final Widget childWidget;

  const SplashBackground({Key? key, required this.childWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              child: Image.asset(
                "assets/images/back_color.png",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                "assets/images/back_design.png",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )),
          childWidget,
        ],
      ),
    );
  }
}


class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}