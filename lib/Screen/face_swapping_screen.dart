import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swapit/provider/face_swap_provider.dart';

class FaceSwappingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Swapping'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Consumer<FaceSwapProvider>(  // Watch for changes in the provider
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Row for Original and Target Image Containers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Original Image Container
                      Column(
                        children: [
                          provider.image == null
                              ? Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image, size: 80, color: Colors.grey),
                                )
                              : Image.file(
                                  File(provider.image!.path),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(height: 10),
                          // Pick Original Image
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.camera_alt, size: 30),
                                onPressed: () {
                                  provider.pickImage(ImageSource.camera);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.photo, size: 30),
                                onPressed: () {
                                  provider.pickImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 20), // Space between the two containers

                      // Target Image Container
                      Column(
                        children: [
                          provider.targetImage == null
                              ? Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image, size: 80, color: Colors.grey),
                                )
                              : Image.file(
                                  File(provider.targetImage!.path),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(height: 10),
                          // Pick Target Image
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.camera_alt, size: 30),
                                onPressed: () {
                                  provider.pickImage(ImageSource.camera, isTarget: true);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.photo, size: 30),
                                onPressed: () {
                                  provider.pickImage(ImageSource.gallery, isTarget: true);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Swap Faces Button
                  ElevatedButton(
                    onPressed: () async {
                      await provider.swapFaces();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Face Swapped!')),
                      );
                    },
                    child: Text('Swap Faces'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Show the loading indicator if loading is true
                  if (provider.loading)
                    Center(child: CircularProgressIndicator())
                  else if (provider.swappedImageUrl != null)
                    // Show the swapped image when available
                    Image.network(
                      provider.swappedImageUrl!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  else
                    // Default placeholder
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Swapped Image will appear here',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
