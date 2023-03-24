import 'index.dart';

/// The [CryptoSimple] class provides a simple encryption and decryption mechanism that relies on two keys: a [superKey] and a [subKey].
/// The [superKey] is used to shift the Unicode value of each character in the input string,
/// while the [subKey] is used to obscure the shifted value .
/// The class also supports a [secretKey] that can be used to further enhance the security of the encryption process.
class CryptoSimple {
  static final CryptoSimple _crypto = CryptoSimple._internal();

  void resetObject() {
    if (kIsWeb == false && Platform.environment.containsKey('FLUTTER_TEST')) {
      _crypto._lock = false;
    }
  }

  static final int _maxCharLimit = 1114111;

  /// [_internal] private constructor :
  /// A private constructor that's called from the factory constructor to ..
  /// create a new instance of the [CryptoSimple] class.
  CryptoSimple._internal();

  /// [_superKey] A positive integer that is not divisible by 1114111.
  int? _superKey;

  /// [_subKey] An integer between 10 and 99 .
  int? _subKey;

  /// [_securityMode] A string that serves as a secret key for encryption and decryption .
  SecurityMode? _securityMode;

  /// [_encryptionMode]  An instance of the [EncryptionMode] enumeration that specifies the type of encryption to be used.
  /// The default value is [EncryptionMode.Normal] .
  EncryptionMode? _encryptionMode;

  /// [_secretKey]  .
  String? _secretKey;

  /// [_lock]  .
  bool _lock = false;

  /// [CryptoSimple] factory constructor :
  /// A factory constructor that creates and returns a new instance of the [CryptoSimple] class.
  /// It takes several optional parameters, such as [superKey], [subKey], [secretKey],
  /// and [encryptionMode], and performs input validation before setting the values of the corresponding instance variables.
  factory CryptoSimple(
      {int? superKey,
      int? subKey,
      String? secretKey,
      EncryptionMode? encryptionMode = EncryptionMode.Normal}) {
    assert(!_crypto._lock, "CryptoSimple class has already been instantiated.");

    // Check for valid input values
    assert(secretKey == null || secretKey.trim().isNotEmpty,
        "Secret key must not be an empty string.");
    assert(!(secretKey == null && encryptionMode == EncryptionMode.Randomized),
        "EncryptionMode on `Randomized` mode need secretKey.");
    assert(subKey == null || (subKey >= 10 && subKey <= 99),
        "Sub-key must be an integer between 10 and 99.");
    assert(superKey == null || (superKey > 0 && superKey % _maxCharLimit != 0),
        "Super-key must be a positive integer not divisible by $_maxCharLimit.");

    // Set instance variables
    _crypto._superKey = superKey;
    _crypto._subKey = subKey;
    _crypto._secretKey = secretKey;
    _crypto._encryptionMode = encryptionMode;
    _crypto._lock = true;

    // Determine security mode based on input values
    if (_crypto._secretKey != null &&
        _crypto._superKey != null &&
        _crypto._subKey != null) {
      _crypto._securityMode = SecurityMode.SUPER_XOR;
    } else if (_crypto._secretKey != null &&
        _crypto._superKey == null &&
        _crypto._subKey == null) {
      _crypto._securityMode = SecurityMode.XOR;
    } else if (_crypto._superKey != null && _crypto._subKey != null) {
      _crypto._securityMode = SecurityMode.SUPER;
    } else {
      throw ArgumentError("Error in initial data.");
    }

    return _crypto;
  }

  /// [instance] getter method :
  /// A getter method that returns the singleton instance of the [CryptoSimple] class.
  static CryptoSimple get instance => _crypto;

  /// [_encryptCharWithSubKey] private method :
  /// A private method that takes a single character of the input text and its index as arguments, and encrypts the character using the sub key.
  /// It first calculates the shifted Unicode value of the character using the superKey instance variable, then obscures the shifted value using the subKey instance variable.
  /// Finally, it returns the encrypted character as a string.
  String _encryptCharWithSubKey({
    required String char,
    required int charIndex,
  }) {
    final textInputCode = char.codeUnitAt(0);
    final shiftedCode = textInputCode + _crypto._superKey!;
    final resultCharCode = shiftedCode > 1114111
        ? _obscureAtEncrypt(
            charCode: '${shiftedCode % 1114111}',
            characterIndex: charIndex,
            subKey: _crypto._subKey!,
          )
        : _obscureAtEncrypt(
            charCode: '$shiftedCode',
            characterIndex: charIndex,
            subKey: _crypto._subKey!,
          );
    return resultCharCode;
  }

  /// [_encryptTextWithSuperKey] private method :
  /// A private method that's used internally to encrypt a string using the superKey and subKey instance variables.
  /// It splits the input string into individual characters and calls the _encryptCharWithSubKey method on each character to encrypt it.
  /// Finally, it then concatenates the encrypted characters and returns the resulting string.
  String _encryptTextWithSuperKey({required String inputText}) {
    String result = inputText
        .split('')
        .asMap()
        .map((charIndex, char) => MapEntry(charIndex,
            _encryptCharWithSubKey(char: char, charIndex: charIndex)))
        .values
        .join('');

    return _reverseString(inputText: result);
  }

  /// [_decryptCharWithSubKey] private method :
  /// A private method that takes a single character of the input text and its index as arguments, and decrypts the character using the sub key.
  /// It first obscures the shifted Unicode value of the character using the subKey instance variable, then calculates the original Unicode value of the character using the superKey instance variable.
  /// Finally, it returns the decrypted character as a string.
  String _decryptCharWithSubKey(
      {required String char, required int charIndex}) {
    int? resultCharCode;
    String textInputCode = char;
    if (int.parse(char) - CryptoSimple._crypto._superKey! >= 0) {
      // if positive number
      textInputCode = _obscureAtDecrypt(
          subKey: _crypto._subKey!,
          characterIndex: charIndex,
          charCode: "$char");
      resultCharCode =
          (int.parse(textInputCode) - CryptoSimple._crypto._superKey!);
    } else {
      // when negative number
      textInputCode = _obscureAtDecrypt(
          subKey: _crypto._subKey!,
          characterIndex: charIndex,
          charCode: "$char");
      resultCharCode =
          (int.parse(textInputCode) - CryptoSimple._crypto._superKey!) %
              1114111;
    }
    return String.fromCharCode(resultCharCode);
  }

  /// [_decryptTextWithSuperKey] private method :
  /// A private method that takes a list of encrypted characters as input and decrypts the characters using the superKey instance variable.
  /// It returns the decrypted text as a string.
  String _decryptTextWithSuperKey({required String encryptedText}) {
    final reversed = _reverseString(inputText: encryptedText);

    final listCode = [
      for (int i = 0; i < encryptedText.length; i += 4)
        reversed.substring(i, i + 4)
    ];

    final result = listCode
        .map((code) => _decryptCharWithSubKey(
            char: code, charIndex: listCode.indexOf(code)))
        .join();

    return result;
  }

  /// [_reverseString] private method :
  /// A private method that's used internally to reverse a string.
  String _reverseString({required String inputText}) =>
      String.fromCharCodes(inputText.runes.toList().reversed);

  /// [_obscureAtDecrypt] method :
  /// A private method that is used to obscure the shifted value of the input character during the decryption process.
  /// It takes the shifted Unicode value of a character, its index, and the sub-key as arguments and returns the obscured value.
  String _obscureAtDecrypt(
      {required String charCode,
      required int characterIndex,
      required int subKey}) {
    String result = "";
    for (int i = 0; i < "$charCode".length; i++) {
      int resultStep1 = (int.parse("$charCode"[i]) - int.parse("$subKey"[0])) -
          characterIndex;
      if (!(resultStep1 >= 0)) resultStep1 = (resultStep1) % 10;
      int resultStep2 =
          (resultStep1 - int.parse("$subKey"[1])) - characterIndex;
      if (!(resultStep2 >= 0)) resultStep2 = (resultStep2) % 10;
      result = ("$result$resultStep2");
    }
    return result;
  }

  /// [_obscureAtEncrypt] private method :
  /// A private method that is used to obscure the shifted value of the input character during the encryption process.
  /// It takes the shifted Unicode value of a character, its index, and the sub-key as arguments and returns the obscured value.
  String _obscureAtEncrypt(
      {required String charCode,
      required int characterIndex,
      required int subKey}) {
    String result = "";
    for (int i = 0; i < "$charCode".length; i++) {
      int resultStep1 = (int.parse("$charCode"[i]) + int.parse("$subKey"[0])) +
          characterIndex;
      if (resultStep1 > 9) resultStep1 = resultStep1 % 10;
      int resultStep2 = resultStep1 + int.parse("$subKey"[1]) + characterIndex;
      if (resultStep2 > 9) resultStep2 = resultStep2 % 10;
      result = ("$result$resultStep2");
    }
    return result;
  }

  /// [encrypting] method :
  /// This method encrypts the input text using the superKey and subKey instance variables.
  /// It takes a plain text as input and returns the encrypted text after performing encryption.
  String encrypting({required String inputString}) {
    final securityMode = _crypto._securityMode;
    switch (securityMode) {
      case SecurityMode.SUPER_XOR:
        final secretKey =
            _encryptTextWithSuperKey(inputText: _crypto._secretKey!);
        return _encryptXOR(
          plainText: inputString,
          secretKey: secretKey,
        );
      case SecurityMode.XOR:
        return _encryptXOR(
          plainText: inputString,
          secretKey: _crypto._secretKey!,
        );
      default:
        return _encryptTextWithSuperKey(inputText: inputString);
    }
  }

  /// [decrypting] method :
  /// This method decrypts the encrypted text using the superKey and subKey instance variables.
  /// It takes an encrypted text as an input and returns the decrypted text after performing decryption.
  String decrypting({required String encrypted}) {
    final securityMode = _crypto._securityMode;

    switch (securityMode) {
      case SecurityMode.SUPER_XOR:
        final secret = _crypto._secretKey!;
        final encryptedSuperKey = _encryptTextWithSuperKey(inputText: secret);
        return _decryptXOR(cipherText: encrypted, secretKey: encryptedSuperKey);
      case SecurityMode.XOR:
        final key = _crypto._secretKey!;
        return _decryptXOR(cipherText: encrypted, secretKey: key);
      default:
        return _decryptTextWithSuperKey(encryptedText: encrypted);
    }
  }

  /// [_encryptXOR] private method :
  /// A private method that is used to encrypt a character of the input text using the XOR encryption mode.
  /// It takes a character and its index as arguments and returns the encrypted character.
  String _encryptXOR({required String plainText, required String secretKey}) {
    List<int> plainBytes = utf8.encode(plainText);
    List<int> keyBytes = utf8.encode(secretKey);
    List<int> ivBytes;
    if (_crypto._encryptionMode == EncryptionMode.Randomized) {
      ivBytes = _generateSecureRandomBytes(16);
    } else {
      ivBytes = List.filled(16, 0);
    }
    List<int> result = Uint8List(plainBytes.length);

    for (int i = 0; i < plainBytes.length; i++) {
      result[i] = plainBytes[i] ^
          keyBytes[i % keyBytes.length] ^
          ivBytes[i % ivBytes.length];
    }

    return base64.encode(ivBytes + result);
  }

  /// [_decryptXOR] private method :
  /// A private method that is used to decrypt a character of the input text using the XOR encryption mode.
  /// It takes an encrypted character and its index as arguments and returns the decrypted character.
  String _decryptXOR({required String cipherText, required String secretKey}) {
    List<int> cipherBytes = base64.decode(cipherText);
    List<int> keyBytes = utf8.encode(secretKey);
    List<int> ivBytes;
    if (_crypto._encryptionMode == EncryptionMode.Randomized) {
      ivBytes = cipherBytes.sublist(0, 16);
    } else {
      ivBytes = List.filled(16, 0);
    }
    List<int> result = Uint8List(cipherBytes.length - 16);

    for (int i = 0; i < result.length; i++) {
      result[i] = cipherBytes[i + 16] ^
          keyBytes[i % keyBytes.length] ^
          ivBytes[i % ivBytes.length];
    }

    return utf8.decode(result);
  }

  /// [_generateSecureRandomBytes] private method:
  /// This method generates a list of secure random bytes, which can be used as a secure key in cryptographic algorithms.
  /// It takes an integer length as input and returns a list of secure random bytes of the given length.
  static List<int> _generateSecureRandomBytes(int length) {
    final random = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }

  /// [encrypt] method :
  /// A method is used to encrypt the input text using the given keys.
  /// It takes the input text as an argument and returns the encrypted text after performing the encryption process.
  @Deprecated(
      'Users before version 2.0.0 can still use this method, but it is\n'
      'recommended to migrate to this new version after\n'
      'checking and testing and preparing their applications.')
  String encrypt({required String inputText}) {
    assert(!(_crypto._superKey == null),
        "\n[ERROR:CryptoSimple not correctly initialized , please see documents or example.]\n");
    String result = "";
    for (int i = 0; i < inputText.length; i++) {
      result =
          "$result${_encryptCharWithSubKey(char: inputText[i], charIndex: i)} ";
    }
    return _reverseString(inputText: result);
  }

  /// [decrypt] method:
  /// This method is used to decrypt the encrypted text.
  /// It takes an encrypted text as an input and returns the decrypted text after performing the decryption process.
  @Deprecated(
      'Users before version 2.0.0 can still use this method, but it is\n'
      'recommended to migrate to this new version after\n'
      'checking and testing and preparing their applications.')
  String decrypt({required String encryptedText}) {
    assert(!(_crypto._superKey == null),
        "\n[ERROR:CryptoSimple not correctly initialized , please see documents or example .\n");

    String result = "";
    List<String> listCode = _reverseString(inputText: encryptedText).split(" ");
    listCode.removeLast();
    for (int i = 0; i < listCode.length; i++) {
      result =
          "$result${_decryptCharWithSubKey(char: (listCode[i]), charIndex: i)}";
    }
    return result;
  }
}

enum SecurityMode {
  SUPER,
  XOR,
  SUPER_XOR,
  SUPER_XOR_RANDOMIZED,
  XOR_RANDOMIZED
}

enum EncryptionMode { Randomized, Normal }
