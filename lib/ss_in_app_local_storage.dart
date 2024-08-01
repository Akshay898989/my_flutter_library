import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum SurveyPerformedStatus { notPerformed, declined, performed }

class SSInAppLocalStorage {
  static final SSInAppLocalStorage instance = SSInAppLocalStorage._internal();
  SharedPreferences? _prefs;

  SSInAppLocalStorage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Map<String, SurveyPerformedStatus> get surveyPerformedStatus {
    final statusJson = _prefs?.getString('surveyPerformedStatus') ?? '{}';
    final Map<String, dynamic> statusMap = jsonDecode(statusJson);

    return statusMap.map((key, value) {
      return MapEntry(key, SurveyPerformedStatus.values[value as int]);
    });
  }

  set surveyPerformedStatus(Map<String, SurveyPerformedStatus> value) {
    final Map<String, int> intMap = value.map((key, status) => MapEntry(key, status.index));
    _prefs?.setString('surveyPerformedStatus', jsonEncode(intMap));
  }

  Map<String, DateTime> get surveyPerformTime {
    final timeJson = _prefs?.getString('surveyPerformTime') ?? '{}';
    final Map<String, String> timeMap = Map<String, String>.from(jsonDecode(timeJson));

    return timeMap.map((key, value) {
      return MapEntry(key, DateTime.parse(value));
    });
  }

  set surveyPerformTime(Map<String, DateTime> value) {
    final Map<String, String> stringMap = value.map((key, dateTime) => MapEntry(key, dateTime.toIso8601String()));
    _prefs?.setString('surveyPerformTime', jsonEncode(stringMap));
  }

  int? getSurveyStatus(String key) {
    return surveyPerformedStatus[key]?.index;
  }

  bool hasSurveyTimePassed(String token, int days) {
    final storedTime = surveyPerformTime[token];
    if (storedTime == null) {
      return true;
    }
    final currentTime = DateTime.now();
    final difference = currentTime.difference(storedTime).inDays;
    return difference > days;
  }
}
