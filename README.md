# crypto_simple

A library for encrypt and decrypt string , very light & simple and fast.

## Get started

### Add dependency

```yaml
dependencies:
  crypto_simple: ^2.0.0
```

### Add import

```yaml
import 'package:crypto_simple/crypto_simple.dart';
```

### Super simple to use

Initialize Package ..

```dart
import 'package:crypto_simple/crypto_simple.dart';

void main() {
  CryptoSimple(
    superKey: 2023,
    subKey: 44,
    secretKey: "MySecretKey! ;)",
    encryptionMode: EncryptionMode.Randomized,
  );

  ///this part is mandatory
  runApp(MyApp());
}
```

Using ..

```dart

String? _token = 'bearer 5@1#fG!';
String? _encodeResult =
CryptoSimple.instance.encrypting(inputString: _token!);

/// easy encrypt !
String? _decodeResult =
CryptoSimple.instance.decrypting(encrypted: _encodeResult!);

/// easy decrypt !
```


