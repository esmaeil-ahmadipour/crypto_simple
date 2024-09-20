![Screenshot](https://github.com/esmaeil-ahmadipour/esmaeil-ahmadipour/blob/main/upload/packages/crypto_simple/banner.png?raw=true "crypto simple banner")

# Crypto Simple plugin
A library for encrypt and decrypt string , very light & simple and fast.

### Install Package
```yaml
dependencies:
  crypto_simple: ^3.0.1
```

### Add import

```yaml
import 'package:crypto_simple/crypto_simple.dart';
```

### Super simple to use in `Singleton` & `Classic` objects.

---

#### 1️⃣ . How to using package as `Singleton Object` ?


###### - Define/Config Object:

```dart
import 'package:crypto_simple/crypto_simple.dart';

void main() {

  // set configuration for [CryptoSimpleSingleton] object , this part is mandatory
  // this object is singleton and easy to used 
  CryptoSimpleSingleton(
    superKey: 2023,
    subKey: 47,
    secretKey: "MySecretKey! ;)",// *Recommended
    encryptionMode: EncryptionMode.Randomized,
  );

  runApp(MyApp());
}
```

###### - Consume Object:
```dart
// Your string value.
String token = 'bearer 5@1#fG!';

// easy encrypt 🛡️ !
String encodeResult = CryptoSimpleSingleton.instance.encryption(inputString: token);

// easy decrypt 🕵️‍♂️ !
String decodeResult = CryptoSimpleSingleton.instance.decryption(encryptedString: encodeResult);

```

---

#### 2️⃣ . How to using package as `Classic Object` ?


```dart

// Define `CryptoSimple` object and set encode/decode configurations
final CryptoSimple normalCrypto = CryptoSimple(
  superKey: 123,
  subKey: 22,
  secretKey: 'mySecretKey',
  encryptionMode: EncryptionMode.Randomized,
);

// Your string value.
String token = 'bearer 5@1#fG!';

// do encryption 🛡️ !
String encodeResult = normalCrypto.encryption(inputString: token);

// do decryption 🕵️‍♂️ !
String decodeResult = normalCrypto.decryption(encryptedString: encodeResult);

```


