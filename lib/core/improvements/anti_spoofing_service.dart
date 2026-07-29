import 'package:location/location.dart';

class AntiSpoofingService {
  static Future<bool> isLocationSecure(LocationData locationData) async {
    // Check if location is mocked / fake
    if (locationData.isMock != null && locationData.isMock == true) {
      return false; 
    }
    return true;
  }
}
