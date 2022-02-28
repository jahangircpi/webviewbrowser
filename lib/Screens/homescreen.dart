import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webviewflutter/Screens/inputscreen.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print', onMessageReceived: (JavascriptMessage message) {}),
].toSet();

class MyHomePage extends StatefulWidget {
  final selectedUrl;
  MyHomePage({this.selectedUrl});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;
  double progressof = 0.0;
  final _history = [];
  bool isLoading = false;
  String url;
  @override
  void initState() {
    url = widget.selectedUrl;
    super.initState();

    flutterWebViewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      setState(() {
        isLoading = true;
      });

      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');

          isLoading = false;
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (progress == 0.1) {
        isLoading = true;
      } else if (progress == 1.0) {
        isLoading = false;
      }

      progressof = progress;

      if (mounted) {
        setState(() {
          _history.add('onProgressChanged: $progress');
        });
      }
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      isLoading = true;

      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });

        isLoading = false;
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() async {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        height: size.height * 0.06,
        width: size.width,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            InkWell(
              onTap: () {
                flutterWebViewPlugin.goBack();
              },
              splashColor: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: size.width * 0.12,
                  height: size.height * 0.045,
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
              child: InkWell(
                onTap: () {
                  flutterWebViewPlugin.goForward();
                },
                splashColor: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: size.width * 0.12,
                    height: size.height * 0.045,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                flutterWebViewPlugin.reload();
              },
              splashColor: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: size.width * 0.12,
                  height: size.height * 0.045,
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            InkWell(
              onTap: () {
                _onDestroy.cancel();
                _onUrlChanged.cancel();
                _onStateChanged.cancel();
                _onHttpError.cancel();
                _onProgressChanged.cancel();
                _onScrollXChanged.cancel();
                _onScrollYChanged.cancel();

                flutterWebViewPlugin.dispose();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => InputScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Icon(
                  Icons.edit,
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 0,
                  child: progressof < 0.1 || progressof < 1.0
                      ? Container(
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(
                              value: progressof,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                Expanded(
                  child: WebviewScaffold(
                    url: "https://${url ?? "www.google.com"}",
                    javascriptChannels: jsChannels,
                    mediaPlaybackRequiresUserGesture: false,
                    withZoom: true,
                    withLocalStorage: true,
                    hidden: true,
                    initialChild: Container(
                      // color: Colors.redAccent,
                      child: const Center(
                        child: Text('loading.....'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
