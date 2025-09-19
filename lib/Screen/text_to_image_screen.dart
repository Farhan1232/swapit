import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swapit/provider/TextToImageProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:io';

class TextToImageScreen extends StatefulWidget {
  const TextToImageScreen({Key? key}) : super(key: key);

  @override
  _TextToImageScreenState createState() => _TextToImageScreenState();
}

class _TextToImageScreenState extends State<TextToImageScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TextToImageProvider>(context);
    final _queryController = TextEditingController();

    // Function to download the image using path_provider and save in the Downloads folder
    void _downloadImage(Uint8List imageData) async {
      try {
        final directory = await getExternalStorageDirectory();
        final downloadsPath = Directory('${directory!.parent.path}/Downloads');
        if (!await downloadsPath.exists()) {
          await downloadsPath.create(recursive: true);
        }

        final fileName = 'generated_image_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${downloadsPath.path}/$fileName');

        // Write the image to the Downloads folder
        await file.writeAsBytes(imageData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to ${downloadsPath.path}/$fileName')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Text to Image'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text input field
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    hintText: 'Enter query text...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 15),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _queryController.clear();
                      },
                    ),
                  ),
                ),
              ),

              // Displaying image or loading state
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 300, // Adjust as needed
                  width: 300,
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.imageData != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(provider.imageData!),
                            )
                          : const Center(
                              child: Text(
                                'Enter Text and Click Generate',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                ),
              ),

              // Generate Button
              if (provider.imageData == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      String query = _queryController.text;
                      if (query.isNotEmpty) {
                        provider.generateImage(query);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Generate Image',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),

              // Download Button
              if (provider.imageData != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () => _downloadImage(provider.imageData!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Download Image',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
