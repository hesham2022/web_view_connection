import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RaisedButton(
              child: Text('Refresh Page'),
              onPressed: () {
                setState(() {});
              })
        ],
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
            // future builder used to call future data or  promises like js
            //
            future: _checkConnection(),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                // check if connection state is waiting
                return CircularProgressIndicator();
              }
              // default data should display
              return snapShot.data;
            }),
      ),
      floatingActionButton: RaisedButton(
          child: Text('Go To Another  website'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => MyWebView(
                      title: "Alligator.io",
                      selectedUrl: "https://alligator.io",
                    )));
          }),
    );
  }

  Future<Widget> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return MyWebView(
        title: 'google ',
        selectedUrl: 'https://www.google.com',
      );
    } else {
      return Container(
        child: Text('No Interner'),
      );
    }
  }
}

class MyWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  MyWebView({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: WebView(
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ));
  }
}
