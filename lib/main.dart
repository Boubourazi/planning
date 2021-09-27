import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:planning/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emploi du temps',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Emploi du temps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setPrefs() async {
    var p = await SharedPreferences.getInstance();
    setState(() {
      _prefs = p;
    });
  }

  InAppWebViewController? webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute<SettingsPage>(
                    builder: (context) => SettingsPage(_prefs),
                  ),
                )
                    .then((_) {
                  setPrefs();
                }).then((_) {
                  webViewController?.reload();
                });
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: InAppWebView(
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                incognito: false,
                userAgent:
                    "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Mobile Safari/537.36")),
        onLoadStop: (InAppWebViewController controller, Uri? uri) async {
          await controller
              .evaluateJavascript(
                  source:
                      'var x = document.getElementById("GInterface.Instances[1].Instances[1].bouton_Edit");x.value = "${_prefs.getString('search')}"; var change = new Event("change");x.dispatchEvent(change);')
              .then((_) async {
            await Future.delayed(const Duration(milliseconds: 600));
          }).then((_) {
            controller.evaluateJavascript(
                source:
                    'var y = document.getElementById("GInterface.Instances[1].Instances[1]_0");y.click();');
          });
        },
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://steeunivpau-edt2021-22.hyperplanning.fr/hp/invite")),
      ),
    );
  }
}
