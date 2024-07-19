import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultValueProvider extends ChangeNotifier {
  int? _defaultvaluenumber;
  int? get defaultvaluenumber => _defaultvaluenumber;
  String? _saveddata1;
  String? get saveddata1 => _saveddata1;
  String? _saveddata2;
  String? get saveddata2 => _saveddata2;
  SharedPreferences? _prefs;

  DefaultValueProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _defaultvaluenumber = _prefs?.getInt('defaultvaluenumber') ?? 0; // Setting a default value of 0
    _saveddata1 = _prefs?.getString('saveddata1') ?? 'test'; // Setting an empty string as default
    _saveddata2 = _prefs?.getString('saveddata2') ?? 'test2'; // Setting an empty string as default
    notifyListeners();
  }
  Future<void> addingDataToProvider(int defaultvaluenumber, String saveddata1, String saveddata2) async {
    _defaultvaluenumber = defaultvaluenumber;
    _saveddata1 = saveddata1;
    _saveddata2 = saveddata2;
    await _prefs?.setInt('defaultvaluenumber', defaultvaluenumber);
    await _prefs?.setString('saveddata1', saveddata1);
    await _prefs?.setString('saveddata2', saveddata2);
    notifyListeners();
  }
}
