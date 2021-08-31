import 'package:flutter/material.dart';
import 'package:pokedex/widgets/setting_section.dart';
import 'package:pokedex/widgets/settings/brightness_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const [
          SettingSection(
            title: 'Appearance',
            settings: [
              BrightnessSwitch(),
            ],
          ),
        ],
      ),
    );
  }
}
