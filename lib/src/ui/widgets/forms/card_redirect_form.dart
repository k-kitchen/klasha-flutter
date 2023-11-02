import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardRedirectForm extends StatefulWidget {
  final String redirectUrl;
  final String flwRef;
  final Function(bool) onClose;

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
            print('URL: $url ${Uri.parse(url).queryParameters}');
            final queryParams = Uri.parse(url).queryParameters;

            if (queryParams['ref'] == widget.flwRef &&
                queryParams['message']?.toLowerCase().contains('successful') ==
                    true) {
              widget.onClose(true);
            } else {
              setState(() {
                isLoading = false;
              });
            }
          },
        ),
      )
      ..setOnConsoleMessage((message) {
        print('JS MESSAGE: ${message.message}');
      })
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 30,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => widget.onClose(false),
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
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
