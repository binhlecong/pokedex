import 'package:flutter/material.dart';

class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({
    Key? key,
    required this.buttonColor,
    required this.label,
    required this.openThisURL,
  }) : super(key: key);

  final MaterialStateProperty<Color> buttonColor;
  final String label;
  final VoidCallback openThisURL;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: openThisURL,
      child: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      style: ButtonStyle(
          backgroundColor: buttonColor,
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.only(left: 15, right: 15),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          )),
    );
  }
}
