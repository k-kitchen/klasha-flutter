import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/klasha_checkout_v2.dart';
import 'package:klasha_checkout_v2/src/shared/debouncer.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardRedirectResponse {
  final bool? status;
  final String? error;

  CardRedirectResponse({this.status, this.error});
}

class CardRedirectForm extends StatefulWidget {
  final String redirectUrl;
  final String flwRef;
  final Function(CardRedirectResponse) onClose;

  const CardRedirectForm({
    super.key,
    required this.redirectUrl,
    required this.onClose,
    required this.flwRef,
  });

  @override
  State<CardRedirectForm> createState() => _CardRedirectFormState();
}

class _CardRedirectFormState extends State<CardRedirectForm>
    with TickerProviderStateMixin {
  var key = GlobalKey<ScaffoldState>();
  late WebViewController controller;
  final bool done = true;
  final _debouncer = Debouncer(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    if (widget.redirectUrl.isEmpty) {
      return;
    }
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _debouncer.run(() {
              _processUrlResponse(url);
              if (isLoading && mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  bool isLoading = true;

  void _processUrlResponse(String url) {
    try {
      if (!url.startsWith(ApiUrls.cardRedirectUrl)) {
        return;
      }
      final uri = Uri.parse(url);
      final response = jsonDecode('${uri.queryParameters['response']}');
      if (response['flwRef'].toString() != widget.flwRef) {
        return;
      }
      switch (response['status'].toString().toLowerCase()) {
        case final a when a.contains('fail') == true:
          widget.onClose(
            CardRedirectResponse(
              status: false,
              error:
                  '${response['vbvrespmessage'] ?? response['processor_response']}',
            ),
          );
          break;
        case final a when a.contains('success') == true:
          widget.onClose(CardRedirectResponse(status: true));
          break;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColors.primary,
          elevation: 0.0,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              widget.onClose(CardRedirectResponse());
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Opacity(
                  opacity: isLoading ? 0 : 1,
                  child: WebViewWidget(controller: controller),
                ),
                if (isLoading)
                  Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation(appColors.primary),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
