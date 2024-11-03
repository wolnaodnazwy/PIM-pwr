import 'package:flutter/material.dart';
import 'package:game/first_page/app_bar.dart';
import 'package:game/numer_generator.dart';
import 'drawer.dart';
import 'body.dart';

class GuessNumberScreen extends StatefulWidget {
  const GuessNumberScreen({super.key});
  @override
  State<GuessNumberScreen> createState() => _GuessNumberScreenState();
}

class _GuessNumberScreenState extends State<GuessNumberScreen> {
  String displayText = "0";
  int minRange = 1;
  int maxRange = 100;
  int selectedDifficulty = 1;
  int generatedNumber = 73;
  int remainingAttempts = 10;
  int initialAttempts = 10;

  final ScrollController _scrollController = ScrollController();
  final NumberGenerator _numberGenerator = NumberGenerator();

  Color upArrowColor = const Color(0xFFE8DEF8);
  Color downArrowColor = const Color(0xFFE8DEF8);

  void _onNumberPressed(String number) {
    setState(() {
      if (displayText == "0") {
        displayText = number;
      } else {
        displayText += number;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (displayText.isNotEmpty) {
        displayText = displayText.substring(0, displayText.length - 1);
      }
    });
  }

  void _generateAndShowNumber(int min, int max, int difficulty) {
    _numberGenerator.generate(min, max);
    generatedNumber = _numberGenerator.targetNumber;

    switch (difficulty) {
      case 1:
        initialAttempts = 10;
        break;
      case 2:
        initialAttempts = 6;
        break;
      case 3:
        initialAttempts = 2;
        break;
    }
    remainingAttempts = initialAttempts;
  }

  void updateSettings(int newMin, int newMax, int newDifficulty) {
    setState(() {
      minRange = newMin;
      maxRange = newMax;
      selectedDifficulty = newDifficulty;
    });
    _restartGame();
  }

  void _restartGame() {
    _generateAndShowNumber(minRange, maxRange, selectedDifficulty);
    setState(() {
      remainingAttempts = initialAttempts;
      displayText = "0";
      resetArrows();
    });
  }

  void resetArrows() {
    setState(() {
      upArrowColor = const Color(0xFFE8DEF8);
      downArrowColor = const Color(0xFFE8DEF8);
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFECE6F0),
          title: const Text(
            "Przegrałeś",
            style: TextStyle(
              color: Color(0xFF1D1B20),
            ),
          ),
          content: Text(
            "Ilość prób się skończyła\n\nOczekiwana liczba to: $generatedNumber",
            style: const TextStyle(
              color: Color(0xFF49454F),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
              child: Text(
                "Zagraj ponownie",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFECE6F0),
          title: const Text(
            "Wygrałeś!",
            style: TextStyle(
              color: Color(0xFF1D1B20),
            ),
          ),
          content: const Text(
            "Brawo, udało ci się zgadnąć liczbę",
            style: TextStyle(
              color: Color(0xFF49454F),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
              child: Text(
                "Zagraj ponownie",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRange() {
    final int? userNumber = int.tryParse(displayText);

    if (userNumber == generatedNumber) {
      _showWinDialog();
    } else {
      setState(() {
        if (userNumber! < generatedNumber) {
          upArrowColor = const Color(0xFF625B71);
          downArrowColor = const Color(0xFFE8DEF8);
        } else {
          upArrowColor = const Color(0xFFE8DEF8);
          downArrowColor = const Color(0xFF625B71);
        }
        if (remainingAttempts > 1) {
          remainingAttempts -= 1;
        } else {
          _showGameOverDialog();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        generatedNumber,
        _restartGame,
      ),
      drawer: drawer(
        context,
        minRange,
        maxRange,
        selectedDifficulty,
        updateSettings,
      ),
      body: body(
        upArrowColor,
        downArrowColor,
        _scrollController,
        displayText,
        remainingAttempts,
        _onNumberPressed,
        _onBackspacePressed,
        _showRange,
      ),
    );
  }
}
