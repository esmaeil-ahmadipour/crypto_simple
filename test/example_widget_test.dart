import 'package:crypto_simple/src/utils/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import '../example/lib/index.dart';
import '../example/lib/main.dart';

void main() {
  List<String> titleList = ["Token", "Encoding", "Decoding"];
  late List<String> dataList = [];

  setUpAll(() async {
    late String token;
    late String encode;
    late String decode;
    late CryptoSimpleSingleton cryptoSimpleSingleton;
    cryptoSimpleSingleton = CryptoSimpleSingleton(
      superKey: 2023,
      subKey: 44,
      secretKey: "MySecretKey! ;)",
      encryptionMode: EncryptionMode.Randomized,
    );
    token = 'bearer 5@1#fGa';
    encode = cryptoSimpleSingleton.encryption(inputString: token);
    decode = cryptoSimpleSingleton.decryption(encryptedString: encode);
    dataList = [token, encode, decode];
  });

  group('Test ItemWidgets at CryptoSimpleSingletonDemoPage', () {
    for (var i = 0; i < titleList.length; ++i) {
      testWidgets('ItemWidget displays ${titleList[i]} and data',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: ItemWidget(title: titleList[i], data: dataList[i]),
        ));

        final titleFinder = find.text(titleList[i]);
        final dataFinder = find.text(dataList[i]);

        expect(titleFinder, findsOneWidget);
        expect(dataFinder, findsOneWidget);
      });
    }
  });
}
