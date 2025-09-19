import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swapit/provider/background_replacement_provider.dart';



class BackgroundReplacementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BackgroundProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Background'),
        ),
        body: Consumer<BackgroundProvider>(
          builder: (context, backgroundProvider, _) {
            return Column(
              children: [
                // 80% of the screen: Interactive image container
                Expanded(
                  flex: 8,
                  child: GestureDetector(
                    onTap: () async {
                      await backgroundProvider.pickImage();
                    },
                    onPanUpdate: (details) {
                      if (backgroundProvider.isPainting) {
                        RenderBox? box = context.findRenderObject() as RenderBox?;
                        Offset localPosition =
                            box!.globalToLocal(details.globalPosition);
                        backgroundProvider.addPaintPoint(localPosition);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Stack(
                        children: [
                          // Display selected image
                          backgroundProvider.imagePath.isNotEmpty
                              ? Image.file(
                                  File(backgroundProvider.imagePath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Center(child: Text('Tap to select an image')),

                          // Paint layer
                          CustomPaint(
                            size: Size.infinite,
                            painter: PaintingPainter(
                              points: backgroundProvider.paintPoints,
                            ),
                          ),

                          // Text overlays
                          ...backgroundProvider.textOverlays.map((text) {
                            return Positioned(
                              left: text.position.dx,
                              top: text.position.dy,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  backgroundProvider.updateTextPosition(
                                    text,
                                    details.delta,
                                  );
                                },
                                onTap: () {
                                  backgroundProvider.editTextOverlay(
                                    context,
                                    text,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  child: Text(
                                    text.text,
                                    style: TextStyle(
                                      color: text.color,
                                      fontSize: text.fontSize,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),

                // 20% of the screen: Action icons container
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Crop Icon
                        // IconButton(
                        //   icon: Icon(Icons.crop),
                        //   onPressed: () async {
                        //     if (backgroundProvider.imagePath.isNotEmpty) {
                        //       await backgroundProvider.cropImage(context);
                        //     } else {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //           content: Text('Please select an image first.'),
                        //         ),
                        //       );
                        //     }
                        //   },
                        // ),

                        // Add Text Icon
                        IconButton(
                          icon: Icon(Icons.text_fields),
                          onPressed: () {
                            backgroundProvider.addTextOverlay(context);
                          },
                        ),

                        // Paint Icon
                        IconButton(
                          icon: Icon(Icons.brush),
                          onPressed: () {
                            _promptEnablePaint(context, backgroundProvider);
                          },
                        ),

                        // Erase Icon (Clear all edits)
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            backgroundProvider.clearAllEdits();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Paint color selector (only visible in paint mode)
                if (backgroundProvider.isPainting)
                  Container(
                    height: 50,
                    color: Colors.grey[200],
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: backgroundProvider.paintColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            backgroundProvider.setPaintColor(color);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Prompt user to enable paint mode
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
}





