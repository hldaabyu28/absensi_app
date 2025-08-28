// core/utils/camera_service.dart
import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> takePicture() async {
    try {
      return await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 50,
      );
    } catch (e) {
      throw Exception('Failed to take picture: $e');
    }
  }
}
