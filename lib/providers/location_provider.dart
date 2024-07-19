import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider extends ChangeNotifier {
  String? _savedLatitude;
  String? get latitude => _savedLatitude;

  String? _savedLongitude;
  String? get longitude => _savedLongitude;

  SharedPreferences? _prefs;

  LocationProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _savedLatitude = _prefs?.getString('latitude');
    _savedLongitude = _prefs?.getString('longitude');
    notifyListeners();
  }

  Future<void> addingDataToProvider(String latitude, String longitude) async {
    _savedLatitude = latitude;
    _savedLongitude = longitude;
    await _prefs?.setString('latitude', latitude);
    await _prefs?.setString('longitude', longitude);
    notifyListeners();
  }
}
