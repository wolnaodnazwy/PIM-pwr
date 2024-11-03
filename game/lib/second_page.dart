import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final int? minRange;
  final int? maxRange;
  final int selectedDifficulty;
  final void Function(int min, int max, int difficulty) onSave;

  const SettingsScreen({
    super.key,
    required this.onSave,
    this.minRange,
    this.maxRange,
    required this.selectedDifficulty,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _minController;
  late TextEditingController _maxController;
  late int selectedDifficulty;
  final int maxAllowedValue = 100000000;

  @override
  void initState() {
    super.initState();
    _minController =
        TextEditingController(text: widget.minRange?.toString() ?? '');
    _maxController =
        TextEditingController(text: widget.maxRange?.toString() ?? '');
    selectedDifficulty = widget.selectedDifficulty;
  }

  void _saveSettings() {
    final minText = _minController.text;
    final maxText = _maxController.text;

    if (minText.isNotEmpty && maxText.isNotEmpty) {
      final int? min = int.tryParse(minText);
      final int? max = int.tryParse(maxText);

      if (min != null && max != null && min < max && max <= maxAllowedValue) {
        widget.onSave(min, max, selectedDifficulty);
        Navigator.pop(context);
      } 
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150,
            padding: const EdgeInsets.only(top: 80),
            child: const Text(
              "Ustawienia",
              style: TextStyle(
                color: Color(0xFF625B71),
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: Color(0xFFEADDFF),
          ),
          const Text(
            "Wybór zakresu",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4F378A),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Maksymalna liczba to $maxAllowedValue",
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4F378A),
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: Color(0xFFEADDFF),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(48, 16, 48, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Od",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF625B71),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _minController,
                        
                        decoration: InputDecoration(
                          
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Do",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF625B71),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _maxController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            // borderSide: const BorderSide(
                            //   color: Color(0xFFCAC4D0),
                            // )
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: Color(0xFFEADDFF),
          ),
          const Text(
            "Poziom trudności",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4F378A),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: Color(0xFFEADDFF),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: [
                RadioListTile(
                  title: Text(
                    "Łatwy",
                    style: TextStyle(
                      color: selectedDifficulty == 1
                          ? const Color(0xFF625B71)
                          : const Color(0xFF79747E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "Liczba prób: 10",
                    style: TextStyle(
                      color: Color(0xFF79747E),
                    ),
                  ),
                  value: 1,
                  groupValue: selectedDifficulty,
                  onChanged: (value) {
                    setState(() {
                      selectedDifficulty = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: Text(
                    "Średni",
                    style: TextStyle(
                      color: selectedDifficulty == 2
                          ? const Color(0xFF625B71)
                          : const Color(0xFF79747E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "Liczba prób: 6",
                    style: TextStyle(
                      color: Color(0xFF79747E),
                    ),
                  ),
                  value: 2,
                  groupValue: selectedDifficulty,
                  onChanged: (value) {
                    setState(() {
                      selectedDifficulty = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: Text(
                    "Trudny",
                    style: TextStyle(
                      color: selectedDifficulty == 3
                          ? const Color(0xFF625B71)
                          : const Color(0xFF79747E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "Liczba prób: 2",
                    style: TextStyle(
                      color: Color(0xFF79747E),
                    ),
                  ),
                  value: 3,
                  groupValue: selectedDifficulty,
                  onChanged: (value) {
                    setState(() {
                      selectedDifficulty = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8DEF8), // Background color
                foregroundColor: const Color(0xFF4F378A), // Kolor tekstu i ikony
              ),
              child: const Text("Zapisz ustawienia"),
            ),
          ),
        ],
      ),
    );
  }
}
