import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FaceSwapProvider with ChangeNotifier {
  XFile? image;
  XFile? targetImage;
  bool loading = false;
  String? swappedImageUrl;

  // Method to pick image
  Future<void> pickImage(ImageSource source, {bool isTarget = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      if (isTarget) {
        targetImage = pickedFile;
      } else {
        image = pickedFile;
      }
      notifyListeners();
    }
  }

  // Method to swap faces
  Future<void> swapFaces() async {
    if (image == null || targetImage == null) return;

    loading = true;
    swappedImageUrl = null;
    notifyListeners();

    try {
      // Call the Face++ API to swap faces
      var response = await swapFacesWithFacePlusPlus(image!.path, targetImage!.path);

      if (response.containsKey('error')) {
        print('Error swapping faces: ${response['responseBody']}');
      } else {
        swappedImageUrl = response['swapped_image_url'];
        print('Face swapped successfully. Image URL: $swappedImageUrl');
      }
    } catch (e) {
      print('Error swapping faces: $e');
    }

    loading = false;
    notifyListeners();
  }

  // Swap Faces with Face++ API
  Future<Map<String, dynamic>> swapFacesWithFacePlusPlus(String imagePath, String targetImagePath) async {
    String apiUrl = 'https://api-us.faceplusplus.com/facepp/v3/compare';
    String apiKey = 'LU4Lm0QC5I_'; // Replace with your actual Face++ API key
    String apiSecret = 'eVf50yPDZ42kRtgGHJ'; // Replace with your actual Face++ API secret

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['api_key'] = apiKey;
    request.fields['api_secret'] = apiSecret;

    request.files.add(await http.MultipartFile.fromPath('image_file1', imagePath));
    request.files.add(await http.MultipartFile.fromPath('image_file2', targetImagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      var result = await http.Response.fromStream(response);
      var jsonResponse = json.decode(result.body);
      print('Face comparison successful: ${jsonResponse}');
      return jsonResponse;
    } else {
      var result = await http.Response.fromStream(response);
      print('Failed to compare faces: ${response.statusCode}');
      print('Response body: ${result.body}');
      return {
        'error': 'Failed to compare faces',
        'statusCode': response.statusCode,
        'responseBody': result.body,
      };
    }
  }
}




