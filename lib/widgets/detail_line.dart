import 'package:flutter/material.dart';

class DetailLine extends StatelessWidget {
  const DetailLine({
    Key? key,
    required this.prop,
    this.value = '',
    required this.labelWidth,
    this.unit = '',
  }) : super(key: key);

  final String value;
  final String prop;
  final String unit;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: labelWidth,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              prop,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
