import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/theme/color_theme_provider.dart';

class SetThemePage extends ConsumerStatefulWidget {
  const SetThemePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetThemePageState();
}

class _SetThemePageState extends ConsumerState<SetThemePage> {
  bool _darkMode = false;
  Color pickerColor = Colors.purple;
  Color currentColor = Colors.purple;

  @override
  void initState() {
    super.initState();
    final setColor = ref.read(favoriteColorProvider);
    pickerColor = setColor;
    currentColor = setColor;
    final brightValue = ref.read(colorThemeProvider).brightness;
    _darkMode = brightValue == Brightness.dark ? true : false;
  }

  void _changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  _showColorDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: _changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                ref.read(colorThemeProvider.notifier).update((state) => ColorScheme.fromSeed(seedColor: currentColor, brightness: state.brightness));
                ref.read(favoriteColorProvider.notifier).update((state) => currentColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CheckboxListTile(
              title: const Text('select for dark mode'),
              value: _darkMode,
              onChanged: (val) {
                setState(() {
                  _darkMode = val!;
                });
                Brightness brightness = val! ? Brightness.dark : Brightness.light;
                ref.read(colorThemeProvider.notifier).update((state) => state.copyWith(brightness: brightness));
              }),
          const SizedBox(
            height: 30,
          ),
          const Text("press the colorful box below to choose your color"),
          InkWell(
            onTap: _showColorDialogue,
            child: ColoredBox(
              color: currentColor,
              child: const SizedBox(
                height: 140,
                width: 350,
              ),
            ),
          ),
          ElevatedButton(onPressed: _saveSettings, child: const Text('save these settings'))
        ],
      ),
    );
  }

  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", _darkMode);
    prefs.setInt("color", currentColor.value);
  }
}
