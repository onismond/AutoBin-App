import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebPayment extends StatefulWidget {
  final Map<String, dynamic> data;
  const WebPayment({super.key, required this.data});

  @override
  State<WebPayment> createState() => _WebPaymentState();
}

class _WebPaymentState extends State<WebPayment> {
  late final WebViewController _controller;

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    data = widget.data;

    // Initialize WebViewController properly
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000)) // Optional: Transparent background
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint("Loading progress: $progress%");
          },
          onPageStarted: (String url) {
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Error: ${error.description}");
          },
        ),
      );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final htmlString = _getHtmlForPostRequest();
      debugPrint("Generated HTML: $htmlString");
      await _controller.loadHtmlString(htmlString);
      // await _controller.loadRequest(Uri.parse('https://flutter.dev'));
    });
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }

  String _getHtmlForPostRequest() {
    return '''
    <html>
      <body onload="document.forms[0].submit();">
        <form method="POST" action="${data!['url']}">
          <input type="hidden" name="x-app-key" value="${data!['x-app-key']}">
          <input type="hidden" name="x-nonce" value="${data!['x-nonce']}">
          <input type="hidden" name="x-timestamp" value="${data!['x-timestamp']}">
          <input type="hidden" name="x-signature" value="${data!['x-signature']}">
          <input type="hidden" name="amount" value="${data!['amount']}">
          <input type="hidden" name="firstName" value="${data!['firstName']}">
          <input type="hidden" name="lastName" value="${data!['lastName']}">
          <input type="hidden" name="email" value="${data!['email']}">
          <input type="hidden" name="address" value="${data!['address']}">
          <input type="hidden" name="city" value="${data!['city']}">
          <input type="hidden" name="state" value="${data!['state']}">
          <input type="hidden" name="country" value="${data!['country']}">
          <input type="hidden" name="phone" value="${data!['phone']}">
          <input type="hidden" name="returnUrl" value="${data!['returnUrl']}">
          <input type="hidden" name="cancelUrl" value="${data!['cancelUrl']}">
          <input type="hidden" name="invoice" value="${data!['invoice']}">
          <input type="hidden" name="orderId" value="${data!['orderId']}">
        </form>
      </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Payment")
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
