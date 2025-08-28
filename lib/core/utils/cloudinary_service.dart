// core/utils/cloudinary_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class CloudinaryService {
  final String cloudName;
  final String uploadPreset;

  CloudinaryService({required this.cloudName, required this.uploadPreset});

  Future<String> uploadImage(String imagePath) async {
    try {
      final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
      
      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imagePath));
      
      // Send request
      final response = await request.send();
      
      // Check response status
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        
        if (jsonMap['secure_url'] != null) {
          return jsonMap['secure_url'] as String;
        } else if (jsonMap['url'] != null) {
          return jsonMap['url'] as String;
        } else {
          throw Exception('No image URL returned from Cloudinary');
        }
      } else {
        throw Exception('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Cloudinary upload error: $e');
      throw Exception('Failed to upload image to Cloudinary: $e');
    }
  }
}