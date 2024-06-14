import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_smarter/main.dart';

class DarkModeToggleSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch(
      value: themeProvider.themeMode == ThemeMode.dark,
      onChanged: (value) {
        themeProvider.toggleTheme();
        print('Dark mode toggled');
      },
    );
  }
}
