import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteColorProvider = StateProvider<Color>((ref) {
  return Colors.purple;
});

final colorThemeProvider = StateProvider<ColorScheme>((ref) {
  return ColorScheme.fromSeed(seedColor: Colors.purple, brightness: Brightness.light);
});
