import 'package:crypto_simple/crypto_simple.dart';
import 'package:crypto_simple_example/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  /// if not initialize CryptoSimple you'll have an error .
  /// It is recommended to define CryptoSimple object at the beginning of the main file.
  /// when set superKey value on zero or a negative number or superKey value was divisible by 1114111 you'll automatically have an assert error .
  CryptoSimple(superKey: 8);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoSimple Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CryptoSimple Home Page'),
    );
  }
}
