import 'index.dart';

void main() {
  /// Instantiate a CryptoSimple object with recommended parameters.
  CryptoSimple(
      superKey: 2023,
      subKey: 47,
      secretKey: "M8tFjsv5tFH&#1e3vC",
      encryptionMode: EncryptionMode.Randomized);
  runApp(CryptoSimpleDemo());
}

class CryptoSimpleDemo extends StatelessWidget {
  const CryptoSimpleDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _title = 'CryptoSimple Demo';
    return MaterialApp(
        title: _title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: CryptoSimpleDemoPage(title: _title));
  }
}

class CryptoSimpleDemoPage extends StatefulWidget {
  const CryptoSimpleDemoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CryptoSimpleDemoPage> createState() => _CryptoSimpleDemoPageState();
}

class _CryptoSimpleDemoPageState extends State<CryptoSimpleDemoPage> {
  late String token;
  late String encodeResult;
  late String decodeResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: CryptoSimpleShadowContainer(
          child: FloatingActionButton(
              child: Icon(Icons.refresh), onPressed: () => restart()),
        ),
        appBar: AppBar(title: Text(widget.title), centerTitle: true),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ItemWidget(title: 'Token:', data: token),
              ItemWidget(title: 'Encoding:', data: encodeResult),
              ItemWidget(title: 'Decoding:', data: decodeResult),
            ]));
  }

  @override
  void initState() {
    initialValues();
    super.initState();
  }

  /// The [initialValues] method sets the initial values of [token] , [encodeResult] , and [decodeResult] .
  void initialValues() {
    token = 'bearer 5@1#fGa';
    encodeResult = CryptoSimple.instance.encrypting(inputString: token);
    decodeResult = CryptoSimple.instance.decrypting(encrypted: encodeResult);
  }

  /// The [restart] method calls the [initialValues] method to reset the values of [token] , [encodeResult] , and [decodeResult] .
  /// It then calls the [setState] method to update the widget's state with the new values.
  void restart() {
    initialValues();
    setState(() {});
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {required this.data, required this.title, Key? key, this.color})
      : super(key: key);

  final String title;
  final String data;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CryptoSimpleDecoratedContainer(
      child: Wrap(children: [
        CryptoSimpleDecoratedText(text: title, isBold: true),
        SizedBox(width: 8),
        CryptoSimpleDecoratedText(text: data, isItalic: true)
      ]),
    );
  }
}
