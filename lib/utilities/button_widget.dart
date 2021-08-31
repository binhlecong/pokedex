import 'package:flutter/material.dart';

class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({
    Key? key,
    required this.label,
    required this.openThisURL,
  }) : super(key: key);

  final String label;
  final VoidCallback openThisURL;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: openThisURL,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).cardColor,
        padding: const EdgeInsets.only(left: 15, right: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }
}
