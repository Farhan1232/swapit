import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyEnhancementProvider with ChangeNotifier {
  // State variables for sliders and feature options
  double _heightScale = 1.0;
  double _waistScale = 1.0;
  double _muscleTone = 1.0;

  double get heightScale => _heightScale;
  double get waistScale => _waistScale;
  double get muscleTone => _muscleTone;

  void updateHeightScale(double value) {
    _heightScale = value;
    notifyListeners();
  }

  void updateWaistScale(double value) {
    _waistScale = value;
    notifyListeners();
  }

  void updateMuscleTone(double value) {
    _muscleTone = value;
    notifyListeners();
  }
}