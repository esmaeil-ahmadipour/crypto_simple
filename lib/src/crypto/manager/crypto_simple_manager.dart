import 'manager.dart';

class CryptoSimpleManager
    implements
        CryptoSimpleDecryptionStrategy,
        CryptoSimpleEncryptionStrategy,
        CryptoSimpleDecryptionInterface,
        CryptoSimpleEncryptionInterface {
  final int? superKey;
  final int? subKey;
  final String? secretKey;
  final SecurityMode securityMode;
  final EncryptionMode encryptionMode;

  CryptoSimpleManager(
      {this.superKey,
      this.subKey,
      this.secretKey,
      required this.securityMode,
      required this.encryptionMode});

  /// [encryptCharWithSubKey] private method :
  /// A private method that takes a single character of the input text and its index as arguments, and encrypts the character using the sub key.
  /// It first calculates the shifted Unicode value of the character using the superKey instance variable, then obscures the shifted value using the subKey instance variable.
  /// Finally, it returns the encrypted character as a string.
  String encryptCharWithSubKey({
    required String char,
    required int charIndex,
  }) {
    final textInputCode = char.codeUnitAt(0);
    final shiftedCode = textInputCode + superKey!;
    final resultCharCode = shiftedCode > maxCharLimit
        ? obscureAtEncrypt(
            charCode: '${shiftedCode % maxCharLimit}',
            characterIndex: charIndex,
            subKey: subKey!,
          )
        : obscureAtEncrypt(
            charCode: '$shiftedCode',
            characterIndex: charIndex,
            subKey: subKey!,
          );
    return resultCharCode;
  }

  /// [encryptTextWithSuperKey] private method :
  /// A private method that's used internally to encrypt a string using the superKey and subKey instance variables.
  /// It splits the input string into individual characters and calls the _encryptCharWithSubKey method on each character to encrypt it.
  /// Finally, it then concatenates the encrypted characters and returns the resulting string.
  String encryptTextWithSuperKey({required String inputText}) {
    String result = inputText
        .split('')
        .asMap()
        .map((charIndex, char) => MapEntry(
            charIndex, encryptCharWithSubKey(char: char, charIndex: charIndex)))
        .values
        .join('');

    return reverseString(inputText: result);
  }

  /// [decryptCharWithSubKey] private method :
  /// A private method that takes a single character of the input text and its index as arguments, and decrypts the character using the sub key.
  /// It first obscures the shifted Unicode value of the character using the subKey instance variable, then calculates the original Unicode value of the character using the superKey instance variable.
  /// Finally, it returns the decrypted character as a string.
  String decryptCharWithSubKey({required String char, required int charIndex}) {
    int? resultCharCode;
    String textInputCode = char;
    if (int.parse(char) - superKey! >= 0) {
      // if positive number
      textInputCode = obscureAtDecrypt(
          subKey: subKey!, characterIndex: charIndex, charCode: "$char");
      resultCharCode = (int.parse(textInputCode) - superKey!);
    } else {
      // when negative number
      textInputCode = obscureAtDecrypt(
          subKey: subKey!, characterIndex: charIndex, charCode: "$char");
      resultCharCode = (int.parse(textInputCode) - superKey!) % maxCharLimit;
    }
    return String.fromCharCode(resultCharCode);
  }

  /// [decryptTextWithSuperKey] private method :
  /// A private method that takes a list of encrypted characters as input and decrypts the characters using the superKey instance variable.
  /// It returns the decrypted text as a string.
  String decryptTextWithSuperKey({required String encryptedText}) {
    final reversed = reverseString(inputText: encryptedText);

    final listCode = [
      for (int i = 0; i < encryptedText.length; i += 3)
        reversed.substring(i, i + 3)
    ];

    final result = listCode
        .map((code) => decryptCharWithSubKey(
            char: code, charIndex: listCode.indexOf(code)))
        .join();

    return result;
  }

  /// [reverseString] private method :
  /// A private method that's used internally to reverse a string.
  String reverseString({required String inputText}) =>
      String.fromCharCodes(inputText.runes.toList().reversed);

  /// [obscureAtDecrypt] method :
  /// A private method that is used to obscure the shifted value of the input character during the decryption process.
  /// It takes the shifted Unicode value of a character, its index, and the sub-key as arguments and returns the obscured value.
  String obscureAtDecrypt(
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

  /// [obscureAtEncrypt] private method :
  /// A private method that is used to obscure the shifted value of the input character during the encryption process.
  /// It takes the shifted Unicode value of a character, its index, and the sub-key as arguments and returns the obscured value.
  String obscureAtEncrypt(
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

  /// [encryption] method :
  /// This method encrypts the input text using the superKey and subKey instance variables.
  /// It takes a plain text as input and returns the encrypted text after performing encryption.
  String encryption({required String inputString}) {
    switch (securityMode) {
      case SecurityMode.SUPER_XOR:
        final secretKey = encryptTextWithSuperKey(inputText: this.secretKey!);
        return encryptXOR(
          plainText: inputString,
          secretKey: secretKey,
        );
      case SecurityMode.XOR:
        return encryptXOR(
          plainText: inputString,
          secretKey: secretKey!,
        );
      default:
        return encryptTextWithSuperKey(inputText: inputString);
    }
  }

  /// [decryption] method :
  /// This method decrypts the encrypted text using the superKey and subKey instance variables.
  /// It takes an encrypted text as an input and returns the decrypted text after performing decryption.
  String decryption({required String encryptedString}) {
    switch (securityMode) {
      case SecurityMode.SUPER_XOR:
        final secret = secretKey!;
        final encryptedSuperKey = encryptTextWithSuperKey(inputText: secret);
        return decryptXOR(
            cipherText: encryptedString, secretKey: encryptedSuperKey);
      case SecurityMode.XOR:
        final key = secretKey!;
        return decryptXOR(cipherText: encryptedString, secretKey: key);
      default:
        return decryptTextWithSuperKey(encryptedText: encryptedString);
    }
  }

  /// [encryptXOR] private method :
  /// A private method that is used to encrypt a character of the input text using the XOR encryption mode.
  /// It takes a character and its index as arguments and returns the encrypted character.
  String encryptXOR({required String plainText, required String secretKey}) {
    List<int> plainBytes = utf8.encode(plainText);
    List<int> keyBytes = utf8.encode(secretKey);
    List<int> ivBytes;
    if (encryptionMode == EncryptionMode.Randomized) {
      ivBytes = generateSecureRandomBytes(16);
    } else {
      ivBytes = List.filled(16, 0);
    }
    List<int> result = Uint8List(plainBytes.length);

    for (int i = 0; i < plainBytes.length; i++) {
      result[i] = plainBytes[i] ^
          keyBytes[i % keyBytes.length] ^
          ivBytes[i % ivBytes.length];
    }

    return base64.encode([...ivBytes, ...result]);
  }

  /// [decryptXOR] private method :
  /// A private method that is used to decrypt a character of the input text using the XOR encryption mode.
  /// It takes an encrypted character and its index as arguments and returns the decrypted character.
  String decryptXOR({required String cipherText, required String secretKey}) {
    List<int> cipherBytes = base64.decode(cipherText);
    List<int> keyBytes = utf8.encode(secretKey);
    List<int> ivBytes;
    if (encryptionMode == EncryptionMode.Randomized) {
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

  /// [generateSecureRandomBytes] private method:
  /// This method generates a list of secure random bytes, which can be used as a secure key in cryptographic algorithms.
  /// It takes an integer length as input and returns a list of secure random bytes of the given length.
  static List<int> generateSecureRandomBytes(int length) {
    final random = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }
}
