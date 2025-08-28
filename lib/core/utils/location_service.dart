// core/utils/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Silakan aktifkan GPS Anda.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        
        // Format alamat
        String address = '';
        if (placemark.street != null && placemark.street!.isNotEmpty) {
          address += '${placemark.street}, ';
        }
        if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
          address += '${placemark.subLocality}, ';
        }
        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          address += '${placemark.locality}, ';
        }
        if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
          address += '${placemark.administrativeArea}, ';
        }
        if (placemark.country != null && placemark.country!.isNotEmpty) {
          address += placemark.country!;
        }
        
        return address.isNotEmpty ? address : 'Lokasi tidak diketahui';
      }
      return 'Lokasi tidak diketahui';
    } catch (e) {
      print('Error getting address: $e');
      return 'Tidak dapat mendapatkan alamat';
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}