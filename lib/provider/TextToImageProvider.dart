import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

class TextToImageProvider with ChangeNotifier {
  final StabilityAI _ai = StabilityAI();
  final String apiKey = 'sk-LmLJDncphhQ1KHTBl0ai309j0QmTEgsgsz1NwNU1HISAUp30'; // Replace with your API key
  final ImageAIStyle imageAIStyle = ImageAIStyle.digitalPainting;

  bool _isLoading = false;
  Uint8List? _imageData;

  bool get isLoading => _isLoading;
  Uint8List? get imageData => _imageData;

  Future<void> generateImage(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _imageData = await _ai.generateImage(
        apiKey: apiKey,
        imageAIStyle: imageAIStyle,
        prompt: query,
      );
    } catch (e) {
      _imageData = null;
      if (kDebugMode) {
        print('Error: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}

