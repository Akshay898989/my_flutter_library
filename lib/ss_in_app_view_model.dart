import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ss_inapp_request_model.dart';
import 'ss_in_app_token_manager.dart';
import 'models.dart';
import 'ss_in_app_local_storage.dart';
const API_URL = 'https://8e46-dev-micro.surveysensum.com/inapp/api/v2/inapp';

class SSInAppViewModel {
  final SSInAppRequestModel requestModel;
  CustomTokenKey? tokenData;
  String fetchedToken = '';

  SSInAppViewModel(this.requestModel);

  String get baseUrl => 'https://${requestModel.subdomain}.surveysensum.com/inapp/api/v2/inapp';

  Future<void> getConfiguration(Function(bool) completion) async {
    final encodedToken = SSInAppTokenManager.instance.getEncodedToken();
    final url = Uri.parse('$baseUrl/token-data');

    final response = await http.get(
      url.replace(queryParameters: {'token': encodedToken.join(',')}), // Join encoded tokens
      headers: {'Content-Type': 'application/json;charset=utf-8'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final responseData = jsonDecode(response.body);
        final configResponse = SSInAppConfigurationResponse.fromJson(responseData);
        tokenData = getTokenEntry(configResponse);
        if (tokenData != null) {
          completion(checkIfUserNeedsToPerformSurvey());
        } else {
          completion(false);
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        completion(false); // Ensure completion is called even on error
      }
    } else {
      print('Failed to load configuration: ${response.statusCode}');
      completion(false);
    }
  }

  Future<void> loadSurvey(SSInAppRequestModel requestModel, Function(String) completion) async {
    final formData = FormData(contactInfo: requestModel.contactInfo, metadata: requestModel.metadata);
    final token = urlEncodedtoken([fetchedToken]);
    final apiUrl = Uri.parse('$baseUrl/contact-surveyLink?token=${token[0]}');

    final response = await http.post(
      apiUrl,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: formData.toString(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final responseData = jsonDecode(response.body);
        final surveyResponse = SSInAppSurveyResponse.fromJson(responseData);
        completion(surveyResponse.result);
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Failed to load survey: ${response.statusCode}');
    }
  }

  CustomTokenKey? getTokenEntry(SSInAppConfigurationResponse response) {
    for (final entry in response.result.entries) {
      final token = entry.key;
      final survey = entry.value;
      for (final rule in survey.inApp.target.rules) {
        if (rule.values.contains(requestModel.surveyId)) {
          fetchedToken = token;
          return survey;
        }
      }
    }
    return null;
  }

  bool isAnonymous() {
    final contactInfo = requestModel.contactInfo;
    if (contactInfo != null) {
      final email = contactInfo['email'] as String?;
      return email == null || email.isEmpty;
    }
    return true;
  }

  bool checkIfUserNeedsToPerformSurvey() {
    final status = SSInAppLocalStorage.instance.getSurveyStatus(fetchedToken);
    switch (status) {
      case SurveyPerformedStatus.notPerformed:
        return true;
      case SurveyPerformedStatus.declined:
      case SurveyPerformedStatus.performed:
        if (!isAnonymous() && status == SurveyPerformedStatus.performed) {
          return true;
        } else {
          // final repeatType = tokenData?.inApp.repeatSurvey.firstWhere(
          //         (type) => type.type == status,
          //     orElse: () => RepeatSurvey(type: SurveyPerformedStatus.notPerformed, status: RepeatSurveyStatus.off, repeatAfterDays: 0));
          // final repeatStatus = repeatType?.status;
          // if (repeatStatus == RepeatSurveyStatus.on) {
          //   return SSInAppLocalStorage.instance.hasSurveyTimePassed(fetchedToken, repeatType!.repeatAfterDays);
          // } else {
          //   return false;
          // }
          return true;
        }
      default:
        return true;
    }
  }
}
