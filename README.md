# crypto_simple

A library for encrypt and decrypt string , very light & simple and fast.

## Get started


### Add dependency

```yaml
dependencies:
  crypto_simple: ^1.1.0
```

### Add import
```yaml
import 'package:crypto_simple/crypto_simple.dart';
```


### Super simple to use
Initialize Package  ..
```dart
import 'package:crypto_simple/crypto_simple.dart';
void main () {
  CryptoSimple(superKey: 2022 , subKey: 99); ///this part is mandatory
  runApp(MyApp());
}
```
Using  ..
```dart
    String? _token = 'bearer 5@1#fG!';
    String? _encodeResult =
      CryptoSimple.instance.encrypt(inputText: _token!); /// easy encrypt !
    String? _decodeResult =
      CryptoSimple.instance.decrypt(encryptedText: _encodeResult!);/// easy decrypt !
```


