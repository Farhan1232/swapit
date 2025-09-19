import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swapit/provider/ThemeProvider.dart';


class AppearanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Appearance"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny, color: isDarkMode ? Colors.grey : Colors.amber),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            Icon(Icons.nightlight_round, color: isDarkMode ? Colors.blue : Colors.grey),
          ],
        ),
      ),
    );
  }
}
