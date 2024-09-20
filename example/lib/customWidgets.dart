import 'package:flutter/material.dart';

class CryptoSimpleDecoratedContainer extends StatelessWidget {
  const CryptoSimpleDecoratedContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black38, offset: Offset(1.0, -1.0))
            ],
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: child);
  }
}

class CryptoSimpleDecoratedText extends StatelessWidget {
  const CryptoSimpleDecoratedText({
    Key? key,
    required this.text,
    this.isItalic = false,
    this.isBold = false,
  }) : super(key: key);

  final String text;
  final bool? isItalic;
  final bool? isBold;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 18,
            fontWeight: isBold! ? FontWeight.bold : FontWeight.normal,
            fontStyle: isItalic! ? FontStyle.italic : FontStyle.normal));
  }
}

class CryptoSimpleShadowContainer extends StatelessWidget {
  const CryptoSimpleShadowContainer({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black38, offset: Offset(1.0, -1.0))
        ],
      ),
    );
  }
}
