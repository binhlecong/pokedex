import 'package:flutter/material.dart';

class SettingSection extends StatelessWidget {
  const SettingSection({
    Key? key,
    required this.title,
    this.settings = const [],
  }) : super(key: key);
  final String title;
  final List<Widget> settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: Theme.of(context).dividerColor,
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...settings,
        ],
      ),
    );
  }
}