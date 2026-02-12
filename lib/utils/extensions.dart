import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NumberFormatter on num {
  String toThousands() {
    final NumberFormat formatter = NumberFormat.decimalPattern('fr');
    return formatter.format(this);
  }

  static int randomInt(int minimum, int maximum) {
    int mini = min(maximum, minimum);
    int maxi = max(maximum, minimum);
    return minimum + Random().nextInt(maxi - mini);
  }

  static double randomDouble(num maximum, [num minimum = 0.0]) {
    double mini = min(maximum, minimum).toDouble();
    double maxi = max(maximum, minimum).toDouble();
    double value = mini + Random().nextDouble() * (maxi - mini);
    return double.parse(value.toStringAsFixed(2));
  }
}

int randomInt(int minimum, int maximum) => minimum + Random().nextInt(maximum - minimum);
double randomDouble(num minimum, num maximum) => minimum + (maximum - minimum) * Random().nextDouble();
bool randomBool() => Random().nextBool();

extension ColorX on Color {
  Color transform(bool reverse) {
    return reverse ? Color.from(red: (255 - r) / 255, green: (255 - g) / 255, blue: (255 - b) / 255, alpha: a) : this;
  }

  Color _darker(int value) {
    return Color.fromARGB((a * 255).round(), (r * 255 - value).clamp(0, 255).toInt(), (g * 255 - value).clamp(0, 255).toInt(), (b * 255 - value).clamp(0, 255).toInt());
  }

  Color _lighter(int value) {
    return Color.fromARGB((a * 255).round(), (r * 255 + value).clamp(0, 255).toInt(), (g * 255 + value).clamp(0, 255).toInt(), (b * 255 + value).clamp(0, 255).toInt());
  }

  Color contrast(int value, bool dark) {
    return dark ? _lighter(value) : _darker(value);
  }

  String colorToHex({bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
            '${(r * 255).floor().toRadixString(16).padLeft(2, '0')}'
            '${(g * 255).floor().toRadixString(16).padLeft(2, '0')}'
            '${(b * 255).floor().toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }
}
