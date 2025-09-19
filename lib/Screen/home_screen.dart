import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images from the gallery
import 'dart:io'; // For handling file operations

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> sliderImages = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
  ];

  File? _profileImage; // To store the selected profile image

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path); // Update the profile image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SwapIt Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header with Profile Picture
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: _pickImage, // Call the image picker function
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) // Show selected image
                          : AssetImage('assets/default_profile.png') as ImageProvider, // Default image
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Appearance Section
            ListTile(
              leading: Icon(Icons.palette, color: Colors.purple),
              title: Text('Appearance'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/appearance-screen');
              },
            ),
            // Premium Appearance Section
            ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Premium Appearance'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/premium-appearance');
              },
            ),
            // About Section
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/about');
              },
            ),
            // Logout Section
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Perform logout actions (e.g., clear user session)
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Image Slider
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: sliderImages.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  sliderImages[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          // Grid Navigation
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildGridTile(
                  context,
                  'Text-to-Image',
                  Icons.text_fields,
                  '/text-to-image',
                ),
                _buildGridTile(
                  context,
                  'Face Swapping',
                  Icons.face,
                  '/face-swapping',
                ),
                _buildGridTile(
                  context,
                  'Body Enhancement',
                  Icons.fitness_center,
                  '/body-enhancement',
                ),
                _buildGridTile(
                  context,
                  'Background Replacement',
                  Icons.photo,
                  '/background-replacement',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}