import 'package:flutter/material.dart';
import 'package:lobay/utilities/constants/app_enums.dart';

class AppClickWidget extends StatelessWidget {
  final Function? onTap;
  final ClickType? type;
  final Widget? child;

  const AppClickWidget(
      {super.key,
      required this.onTap,
      this.type = ClickType.inkWell,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return type == ClickType.inkWell
        ? InkWell(
            child: child,
            onTap: () {
              onTap!();
            },
          )
        : GestureDetector(
            child: child,
            onTap: () {
              onTap!();
            },
          );
  }
}
