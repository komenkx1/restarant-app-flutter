import 'package:flutter/material.dart';
import 'package:restaurant_app/theme/custom_theme.dart';

class HeaderComponent extends StatelessWidget {
  const HeaderComponent(
      {Key? key,
      required this.headerText,
      required this.subHeaderText,
      this.onPressed,
      this.isButtonActive = false,
      this.icon})
      : super(key: key);

  final String headerText;
  final String subHeaderText;
  final Function()? onPressed;
  final bool isButtonActive;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(headerText, style: CustomTheme.headerTextStyle),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: isButtonActive
                  ? IconButton(
                      onPressed: () => onPressed!(),
                      icon: Icon(icon ?? Icons.settings))
                  : Container()),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(subHeaderText, style: CustomTheme.subHeaderTextStyle),
      ),
    ]);
  }
}
