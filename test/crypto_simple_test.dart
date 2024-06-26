import 'package:crypto_simple/src/crypto/objects/crypto_simple.dart';
import 'package:crypto_simple/src/utils/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CryptoSimple', () {
    test(
        'Creating a CryptoSimple with an empty secret key should throw an exception',
        () {
      expect(
        () => CryptoSimple(
          superKey: 123,
          subKey: 10,
          secretKey: '',
          encryptionMode: EncryptionMode.Normal,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'Creating a CryptoSimple with encryption mode set to Randomized and no secret key should throw an exception',
        () {
      expect(
        () => CryptoSimple(
          superKey: 123,
          subKey: 10,
          secretKey: null,
          encryptionMode: EncryptionMode.Randomized,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'Creating a CryptoSimple with subKey set to an integer outside the range [10, 99] should throw an exception',
        () {
      expect(
        () => CryptoSimple(
          superKey: 123,
          subKey: 100,
          secretKey: 'mySecretKey',
          encryptionMode: EncryptionMode.Normal,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'Creating a CryptoSimple with superKey set to a value that is divisible by 1114111 should throw an exception',
        () {
      expect(
        () => CryptoSimple(
          superKey: 1114111,
          subKey: 10,
          secretKey: 'mySecretKey',
          encryptionMode: EncryptionMode.Normal,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'Creating a CryptoSimple without secretKey and try set encryptionMode to EncryptionMode.Randomized , should throw an exception',
        () {
      expect(
        () => CryptoSimple(
            superKey: 123,
            subKey: 10,
            encryptionMode: EncryptionMode.Randomized),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'Decrypting an encrypted text should return the original text in EncryptionMode.Normal',
        () {
      final crypto = CryptoSimple(
        superKey: 123,
        subKey: 22,
        secretKey: 'mySecretKey',
        encryptionMode: EncryptionMode.Normal,
      );
      final originalText = 'hello world';

      final encryptedText = crypto.encryption(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decryption(encryptedString: encryptedText);
      expect(decryptedText, originalText);
    });

    test(
        'Decrypting an encrypted text should return the original text in EncryptionMode.Randomized',
        () {
      final crypto = CryptoSimple(
        superKey: 123,
        subKey: 10,
        secretKey: 'mySecretKey',
        encryptionMode: EncryptionMode.Randomized,
      );
      final originalText = 'hello world';
      final encryptedText = crypto.encryption(inputString: originalText);
      final decryptedText = crypto.decryption(encryptedString: encryptedText);
      expect(decryptedText, originalText);
    });

    test(
        'Decrypting an encrypted text should return the original text without set secretKey & encryptionMode',
        () {
      final originalText = 'hello';

      final crypto = CryptoSimple(superKey: 123, subKey: 10);
      final encryptedText = crypto.encryption(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decryption(encryptedString: encryptedText);
      expect(decryptedText, equals(originalText));
    });

    test(
        'Decrypting an encrypted text should return the original text , by set EncryptionMode.Randomized without set superKey & subKey',
        () {
      final originalText = 'hello world';
      final crypto = CryptoSimple(
          secretKey: 'mySecretKey', encryptionMode: EncryptionMode.Randomized);
      final encryptedText = crypto.encryption(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decryption(encryptedString: encryptedText);
      expect(originalText, decryptedText);
    });

    test(
        'Decrypting an encrypted text should return the original text , by set secretKey without set superKey & subKey',
        () {
      final crypto = CryptoSimple(secretKey: 'mySecretKey');
      final originalText = 'hello world';

      final encryptedText = crypto.encryption(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decryption(encryptedString: encryptedText);
      expect(originalText, decryptedText);
    });

    test(
        'Decrypting an encrypted text should return the original text , by set secretKey & EncryptionMode.Normal without set superKey & subKey',
        () {
      final crypto = CryptoSimple(
          secretKey: 'mySecretKey', encryptionMode: EncryptionMode.Normal);
      final originalText = 'hello world';

      final encryptedText = crypto.encryption(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decryption(encryptedString: encryptedText);
      expect(originalText, decryptedText);
    });
  });
}
