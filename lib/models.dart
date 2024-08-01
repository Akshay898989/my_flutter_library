import 'dart:convert';

class SSInAppSurveyResponse {
  final double statusCode;
  final String result;
  final String? etag;
  final List<String> errors;
  final String message;
  final String? corelationId;

  SSInAppSurveyResponse({
    required this.statusCode,
    required this.result,
    this.etag,
    required this.errors,
    required this.message,
    this.corelationId,
  });

  factory SSInAppSurveyResponse.fromJson(Map<String, dynamic> json) {
    return SSInAppSurveyResponse(
      statusCode: json['statusCode'].toDouble(),
      result: json['result'],
      etag: json['etag'],
      errors: List<String>.from(json['errors']),
      message: json['message'],
      corelationId: json['corelationId'],
    );
  }
}

class SSInAppConfigurationResponse {
  final int statusCode;
  final Map<String, CustomTokenKey> result;
  final String? etag;
  final List<String> errors;
  final String message;
  final String? corelationID;

  SSInAppConfigurationResponse({
    required this.statusCode,
    required this.result,
    this.etag,
    required this.errors,
    required this.message,
    this.corelationID,
  });

  factory SSInAppConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return SSInAppConfigurationResponse(
      statusCode: json['statusCode'],
      result: (json['result'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, CustomTokenKey.fromJson(value)),
      ),
      etag: json['etag'],
      errors: List<String>.from(json['errors']),
      message: json['message'],
      corelationID: json['corelationID'],
    );
  }
}

class CustomTokenKey {
  final InApp inApp;
  final ResponseLimit responseLimit;

  CustomTokenKey({
    required this.inApp,
    required this.responseLimit,
  });

  factory CustomTokenKey.fromJson(Map<String, dynamic> json) {
    return CustomTokenKey(
      inApp: InApp.fromJson(json['inApp']),
      responseLimit: ResponseLimit.fromJson(json['responseLimit']),
    );
  }
}

class InApp {
  final String? sidebarText;
  final String sidebarColour;
  final int delayTime;
  final Target target;
  final InAppLayout layout;
  final int position;
  final String campID;
  final PopupSize popupSize;
  final int launchType;
  final List<RepeatSurvey> repeatSurvey;
  final bool autoCloseSurvey;
  final String surveyGUID;
  final String id;

  InApp({
    this.sidebarText,
    required this.sidebarColour,
    required this.delayTime,
    required this.target,
    required this.layout,
    required this.position,
    required this.campID,
    required this.popupSize,
    required this.launchType,
    required this.repeatSurvey,
    required this.autoCloseSurvey,
    required this.surveyGUID,
    required this.id,
  });

  factory InApp.fromJson(Map<String, dynamic> json) {
    return InApp(
      sidebarText: json['sidebarText'],
      sidebarColour: json['sidebarColour'],
      delayTime: json['delayTime'],
      target: Target.fromJson(json['target']),
      layout: InAppLayoutExtension.fromJson(json['layout']),
      position: json['position'],
      campID: json['campID'],
      popupSize: PopupSize.fromJson(json['popupSize']),
      launchType: json['launchType'],
      repeatSurvey: (json['repeatSurvey'] as List).map((e) => RepeatSurvey.fromJson(e)).toList(),
      autoCloseSurvey: json['autoCloseSurvey'],
      surveyGUID: json['surveyGUID'],
      id: json['id'],
    );
  }
}

class Target {
  final int type;
  final List<Rule> rules;
  final String? condition;
  final String? field;
  final String? targetOperator;
  final List<String> values;

  Target({
    required this.type,
    required this.rules,
    this.condition,
    this.field,
    this.targetOperator,
    required this.values,
  });

  factory Target.fromJson(Map<String, dynamic> json) {
    return Target(
      type: json['type'],
      rules: (json['rules'] as List).map((e) => Rule.fromJson(e)).toList(),
      condition: json['condition'],
      field: json['field'],
      targetOperator: json['targetOperator'],
      values: List<String>.from(json['values']),
    );
  }
}

class Rule {
  final int type;
  final List<String> values; // Ensure this matches the type used in your code

  Rule({
    required this.type,
    required this.values,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      type: json['type'],
      values: List<String>.from(json['values']),
    );
  }
}


class FormData {
  final Map<String, dynamic>? contactInfo;  // Ensure this is Map<String, dynamic>?
  final Map<String, dynamic>? metadata;  // Ensure this is Map<String, dynamic>?

  FormData({
    this.contactInfo,
    this.metadata,
  });

  @override
  String toString() {
    final data = {
      'contactInfo': contactInfo,
      'metadata': metadata,
    };
    return Uri(queryParameters: data.map((key, value) => MapEntry(key, jsonEncode(value)))).query;
  }
}

class PopupSize {
  final int width;
  final int height;
  final int unit;

  PopupSize({
    required this.width,
    required this.height,
    required this.unit,
  });

  factory PopupSize.fromJson(Map<String, dynamic> json) {
    return PopupSize(
      width: json['width'],
      height: json['height'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'unit': unit,
    };
  }
}

enum InAppLayout {
  fullScreen,
  popup,
  embedInView,
}

extension InAppLayoutExtension on InAppLayout {
  int get value {
    switch (this) {
      case InAppLayout.fullScreen:
        return 1;
      case InAppLayout.popup:
        return 2;
      case InAppLayout.embedInView:
        return 4;
    }
  }

  static InAppLayout fromJson(int value) {
    switch (value) {
      case 1:
        return InAppLayout.fullScreen;
      case 2:
        return InAppLayout.popup;
      case 4:
        return InAppLayout.embedInView;
      default:
        throw ArgumentError('Invalid InAppLayout value: $value');
    }
  }
}

class ResponseLimit {
  final int maxResponses;
  final int responseIntervalDays;

  ResponseLimit({
    required this.maxResponses,
    required this.responseIntervalDays,
  });

  factory ResponseLimit.fromJson(Map<String, dynamic> json) {
    return ResponseLimit(
      maxResponses: json['maxResponses'] as int,
      responseIntervalDays: json['responseIntervalDays'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxResponses': maxResponses,
      'responseIntervalDays': responseIntervalDays,
    };
  }
}


class RepeatSurvey {
  final RepeatSurveyStatus type;
  final RepeatSurveyStatus status;
  final int repeatAfterDays;

  RepeatSurvey({
    required this.type,
    required this.status,
    required this.repeatAfterDays,
  });

  factory RepeatSurvey.fromJson(Map<String, dynamic> json) {
    return RepeatSurvey(
      type: RepeatSurveyStatus.values[json['type']],
      status: RepeatSurveyStatus.values[json['status']],
      repeatAfterDays: json['repeatAfterDays'],
    );
  }
}

enum RepeatSurveyStatus { on, off }

List<String> urlEncodedtoken(List<String> tokens) {
  // Implement URL encoding for tokens
  return tokens.map((token) => Uri.encodeComponent(token)).toList();
}
