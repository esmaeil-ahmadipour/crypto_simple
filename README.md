![Screenshot](https://github.com/esmaeil-ahmadipour/esmaeil-ahmadipour/blob/main/upload/packages/crypto_simple/banner.png?raw=true "Flutter Glass Banner")

# Crypto Simple plugin
A library for encrypt and decrypt string , very light & simple and fast.

### Install Package
```yaml
dependencies:
  crypto_simple: ^2.2.0
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

  // set configuration for [CryptoSimple] object , this part is mandatory
  // this object is singleton and easy to used 
  CryptoSimple(
    superKey: 2023,
    subKey: 47,
    secretKey: "MySecretKey! ;)",
    encryptionMode: EncryptionMode.Randomized,
  );

  runApp(MyApp());
}
```

Using ..

```dart
// Your instance string value.
String? _token = 'bearer 5@1#fG!';

// easy encrypt !
String? _encodeResult = CryptoSimple.instance.encrypting(inputString: _token!);

// easy decrypt !
String? _decodeResult = CryptoSimple.instance.decrypting(encrypted: _encodeResult!);

```


