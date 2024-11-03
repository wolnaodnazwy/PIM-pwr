// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

AppBar appBar(
  BuildContext context,
  int? generatedNumber,
  VoidCallback _restartGame,
) {
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings_outlined),
              color: Colors.white,
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: "Zmień ustawienia gry",
            ),
          ),
        ),
        const Spacer(),
        const Text(
          "Zgadnij liczbę",
          style: TextStyle(
            color: Color(0xFF4F378A),
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.flag_outlined),
            color: Colors.white,
            tooltip: 'Poddaj się',
            onPressed: () {
              _dialogBuilder(context, generatedNumber, _restartGame);
            },
          ),
        ),
      ],
    ),
  );
}

Future<dynamic> _dialogBuilder(
  BuildContext context,
  int? generatedNumber,
  VoidCallback _restartGame,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFECE6F0),
        title: const Text(
          "Poddać się",
          style: TextStyle(
            color: Color(0xFF1D1B20),
          ),
        ),
        content: const Text(
          "Czy na pewno chcesz się poddać? \n\nTej czynności nie da się cofnąć.",
          style: TextStyle(
            color: Color(0xFF49454F),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop();
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
                      "Oczekiwana liczba to: $generatedNumber",
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
            },
            child: Text(
              "Tak",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Nie",
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
