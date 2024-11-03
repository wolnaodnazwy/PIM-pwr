// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:game/second_page.dart';

SizedBox drawer(
  BuildContext context,
  int minRange,
  int maxRange,
  int selectedDifficulty,
  Function(int, int, int) updateSettings 
) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.1,
    child: Drawer(
      child: SettingsScreen(
        minRange: minRange,
        maxRange: maxRange,
        selectedDifficulty: selectedDifficulty,
        onSave: (int newMin, int newMax, int newDifficulty) {
          if (newMin != minRange ||
              newMax != maxRange ||
              newDifficulty != selectedDifficulty) {
            updateSettings(newMin, newMax, newDifficulty);
          }
        },
      ),
    ),
  );
}
