// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

Padding body(
  Color upArrowColor,
  Color downArrowColor,
  ScrollController _scrollController,
  String displayText,
  int remainingAttempts,
  Function(String) _onNumberPressed,
  VoidCallback _onBackspacePressed,
  VoidCallback _showRange,
) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: LayoutBuilder(
      builder: (context, constraints) {
        double buttonSize = (constraints.maxWidth - 72) / 3;
        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF79747E),
                      width: 1,
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_drop_up,
                        color: upArrowColor,
                        size: 64,
                      ),
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          displayText.isEmpty ? "0" : displayText,
                          style: const TextStyle(
                              fontSize: 56, color: Color(0xFF625B71)),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: downArrowColor,
                        size: 64,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color(0xFFEADDFF),
            ),
            Text(
              "Liczba pozostałych prób: $remainingAttempts",
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF4F378A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Color(0xFFEADDFF),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 32,
              runSpacing: 16,
              children: [
                for (var i = 1; i <= 9; i++)
                  Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () => _onNumberPressed(i.toString()),
                        child: Text(
                          '$i',
                          style: TextStyle(
                            fontSize: buttonSize / 1.6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF79747E),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: const Color(0xFF625B71),
                      size: buttonSize / 2.5,
                    ),
                    onPressed: _onBackspacePressed,
                    highlightColor: const Color(0xFF79747E),
                  ),
                ),
                Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () => _onNumberPressed("0"),
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontSize: buttonSize / 1.6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF79747E),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: const Color(0xFF625B71),
                      size: buttonSize / 2.5,
                    ),
                    highlightColor: const Color(0xFF79747E),
                    onPressed: _showRange,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
