import 'dart:convert';

class SSInAppRequestModel {
  final String token;
  final Map<String, dynamic>? contactInfo;  // Updated to Map<String, dynamic>?
  final Map<String, dynamic>? metadata;  // Updated to Map<String, dynamic>?
  final String surveyId;
  final String subdomain;

  SSInAppRequestModel({
    required this.token,
    this.contactInfo,  // Updated to accept Map<String, dynamic>?
    this.metadata,  // Updated to accept Map<String, dynamic>?
    required this.subdomain,
    required this.surveyId,
  });

  factory SSInAppRequestModel.fromJson(Map<String, dynamic> json) {
    return SSInAppRequestModel(
      token: json['token'] as String,
      contactInfo: json['contactInfo'] as Map<String, dynamic>?,  // Ensure correct type
      metadata: json['metadata'] as Map<String, dynamic>?,  // Ensure correct type
      subdomain: json['subdomain'] as String,
      surveyId: json['surveyId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'contactInfo': contactInfo,  // Ensure correct type
      'metadata': metadata,  // Ensure correct type
      'subdomain': subdomain,
      'surveyId': surveyId,
    };
  }
}
