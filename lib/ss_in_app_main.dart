import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ss_inapp_request_model.dart';
class SSInAppView extends StatefulWidget {
  final SSInAppRequestModel requestModel;

  SSInAppView({required this.requestModel});

  @override
  _SSInAppViewState createState() => _SSInAppViewState();
}

class _SSInAppViewState extends State<SSInAppView> {
  late WebViewController _webViewController;
  String? _urlString;
  bool _isLoading = true;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _getConfiguration();
  }

  Future<void> _getConfiguration() async {
    // Fetch configuration
    // Mocked response
    final showSurvey = true; // Replace with actual logic
    final surveyLink = 'https://8e46-dev-micro.surveysensum.com/inapp/api/v2/inapp/contact-surveyLink?token=WnSCQOWgwc3O8xf2SQUkyUb5TSIzKQBaOR5rPlbxoGVMHbOsgF2EOPa1VD4obDb%2BEUboOtDO4jJ9czohw5MroQ%3D%3D'; // Replace with actual URL

    if (showSurvey) {
      setState(() {
        _urlString = surveyLink;
        _isFullScreen = true; // Set based on your requirement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isFullScreen ? Colors.transparent : Colors.white,
      body: Stack(
        children: [
          if (_urlString != null)
            WebView(
              initialUrl: _urlString,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (_) {
                setState(() {
                  _isLoading = false;
                });
              },
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_urlString != null && !_isFullScreen)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _handleClose();
                },
              ),
            ),
        ],
      ),
    );
  }

  void _handleClose() {
    // Handle close action
    Navigator.of(context).pop();
  }
}
