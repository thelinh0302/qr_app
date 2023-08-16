import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'package:qr_app/scanner_web.dart';
import 'package:qr_app/web3home.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Flutter QR code application',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    initBarcodeSDK();
  }

  late FlutterBarcodeSdk _barcodeReader;
  bool _isSDKLoaded = false;

  Future<void> initBarcodeSDK() async {
    _barcodeReader = FlutterBarcodeSdk();
    await _barcodeReader.setLicense(
        'DLS2eyJoYW5kc2hha2VDb2RlIjoiMjAwMDAxLTE2NDk4Mjk3OTI2MzUiLCJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSIsInNlc3Npb25QYXNzd29yZCI6IndTcGR6Vm05WDJrcEQ5YUoifQ==');
    await _barcodeReader.init();
    await _barcodeReader.setBarcodeFormats(BarcodeFormat.ALL);
    // int ret = await _barcodeReader.setParameters(Template.balanced);
    // print('Set parameters: $ret');
    setState(() {
      _isSDKLoaded = true;
    });
  }

  _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget createLayout() {
    if (kIsWeb) {
      if (!_isSDKLoaded) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: 'Loading ',
                style: const TextStyle(fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Dynamsoft Barcode Reader',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrlString(
                            'https://www.dynamsoft.com/barcode-reader/sdk-javascript/');
                      },
                  ),
                  const TextSpan(
                      text:
                          ' js and wasm files...The first time may take a few seconds.'),
                ],
              ),
            ),
          ],
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_isSDKLoaded == false) {
              _showDialog('Error', 'Barcode SDK is not loaded.');
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScannerScreenWeb(
                        barcodeReader: _barcodeReader,
                      )),
            );
          },
          child: const Text('Barcode Scanner'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: createLayout()),
    );
  }
}
