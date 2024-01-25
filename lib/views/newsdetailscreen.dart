import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatefulWidget {
  String newsUrl;

  NewsDetail({required this.newsUrl});

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('See'),
            Text('News',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          child: WebViewWidget(controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(widget.newsUrl)))
      ),
    );
  }
}
