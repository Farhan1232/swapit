import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

  // Prompt to enable paint mode
  Future<void> _promptEnablePaint(
      BuildContext context, BackgroundProvider provider) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Enable Paint Mode'),
          content: Text('Do you want to enable paint mode?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      provider.togglePaintMode(context);
    }
  }


// BackgroundProvider
class BackgroundProvider with ChangeNotifier {
  String _imagePath = '';
  String get imagePath => _imagePath;

  // Paint-related properties
  bool isPainting = false;
  List<PaintPoint> paintPoints = [];
  List<Color> paintColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.brown,
  ];
  Color selectedPaintColor = Colors.red;

  // Text-related properties
  List<TextOverlay> textOverlays = [];

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imagePath = pickedFile.path;
      notifyListeners();
    }
  }

  Future<void> cropImage(BuildContext context) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _imagePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    if (croppedFile != null) {
      _imagePath = croppedFile.path;
      notifyListeners();
    }
  }

  void togglePaintMode(BuildContext context) {
    isPainting = !isPainting;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isPainting ? 'Paint mode enabled' : 'Paint mode disabled')),
    );
    notifyListeners();
  }

  void addPaintPoint(Offset point) {
    paintPoints.add(PaintPoint(point, selectedPaintColor));
    notifyListeners();
  }

  void setPaintColor(Color color) {
    selectedPaintColor = color;
    notifyListeners();
  }

  void addTextOverlay(BuildContext context) {
    textOverlays.add(TextOverlay('New Text', Offset(50, 50), Colors.black, 16));
    notifyListeners();
  }

  void updateTextPosition(TextOverlay text, Offset delta) {
    text.position = text.position + delta;
    notifyListeners();
  }

  void clearAllEdits() {
    paintPoints.clear();
    textOverlays.clear();
    notifyListeners();
  }

  Future<void> editTextOverlay(BuildContext context, TextOverlay overlay) async {
    final textController = TextEditingController(text: overlay.text);
    final newText = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Edit Text'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(labelText: 'Enter text'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(textController.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newText != null && newText.isNotEmpty) {
      overlay.text = newText;
      notifyListeners();
    }
  }
}

// Helper Classes
class PaintPoint {
  final Offset offset;
  final Color color;

  PaintPoint(this.offset, this.color);
}

class TextOverlay {
  String text;
  Offset position;
  Color color;
  double fontSize;

  TextOverlay(this.text, this.position, this.color, this.fontSize);
}

// Custom Painter for Paint Layer
class PaintingPainter extends CustomPainter {
  final List<PaintPoint> points;

  PaintingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      final paint = Paint()
        ..color = point.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0;

      canvas.drawCircle(point.offset, 5.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}







