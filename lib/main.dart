import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = 'No message yet';

  @override
  void initState() {
    super.initState();

    html.window.onMessage.listen((event) {
      if (event.origin != html.window.location.origin) {
        setState(() {
          _message = 'Message received from a different origin';
        });
        return;
      }

      if (event.data is! Map ||
          !event.data.containsKey('obcMessage') ||
          event.data['obcMessage'] != true) {
        setState(() {
          _message = 'Unexpected message format received';
        });
        return;
      }

      var message = event.data['message'];
      setState(() {
        _message = message;
      });
    });
  }

  void openWindow() {
    var newWindow =
        js.context.callMethod('open', ['external_page.html', 'external_page']);

    if (newWindow == null) {
      setState(() {
        _message = 'Pop-up is blocked by the browser!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Web Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_message),
            ElevatedButton(
              onPressed: openWindow,
              child: const Text('Open Window'),
            ),
          ],
        ),
      ),
    );
  }
}
