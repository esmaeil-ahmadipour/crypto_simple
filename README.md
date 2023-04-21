![Screenshot](https://github.com/esmaeil-ahmadipour/esmaeil-ahmadipour/blob/main/upload/packages/crypto_simple/banner.png?raw=true "Flutter Glass Banner")

# Crypto Simple plugin
A library for encrypt and decrypt string , very light & simple and fast.

### Install Package
```yaml
dependencies:
  crypto_simple: ^2.1.0
```

### Add import

```yaml
import 'package:crypto_simple/src/crypto_simple.dart';
```

### Super simple to use

Initialize Package ..

```dart
import 'package:crypto_simple/src/crypto_simple.dart';

void main() {
  CryptoSimple(
    superKey: 2023,
    subKey: 47,
    secretKey: "MySecretKey! ;)",
    encryptionMode: EncryptionMode.Randomized,
  );

  ///this part is mandatory
  runApp(MyApp());
}
```

Using ..

```dart
// Your instance string value.
String? _token = 'bearer 5@1#fG!';

// easy encrypt !
String? _encodeResult = CryptoSimple.encrypt(inputString: _token!);

// easy decrypt !
String? _decodeResult = CryptoSimple.decrypti(encrypted: _encodeResult!);

```


