import 'package:crypto_simple/crypto_simple.dart';
import 'package:crypto_simple_example/custom_text_wdget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, Key? key}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _token;
  String? _encodeResult;
  String? _decodeResult;

  @override
  void initState() {
    /// this is example .  you can change value in _token variable .
    _token = 'bearer 5@1#fGa';

    ///  use CryptoSimple.instance.encode() to determine the text you want to encrypt.
    _encodeResult = CryptoSimple.instance.encrypt(inputText: _token!);

    ///  use CryptoSimple.instance.decode() to determine the encrypted text you want to decode.
    _decodeResult =
        CryptoSimple.instance.decrypt(encryptedText: _encodeResult!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ItemWidget(string: "Token:$_token"),
          ItemWidget(string: "Encode:$_encodeResult"),
          ItemWidget(string: "Decode:$_decodeResult"),
        ],
      ),
    );
  }
}
