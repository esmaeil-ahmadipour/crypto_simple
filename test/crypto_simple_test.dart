import 'package:crypto_simple/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CryptoSimple', () {
    test('Creating a CryptoSimple with valid input values should succeed', () {
      expect(
        () => CryptoSimple(
          superKey: 123,
          subKey: 10,
          secretKey: 'mySecretKey',
          encryptionMode: EncryptionMode.Normal,
        ),
        returnsNormally,
      );
    });

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

    test('Encrypting a text should succeed', () {
      // Restarting the CryptoSimple object in here ,
      // because it has already been created and the test will encounter an error.
      CryptoSimple.instance.resetObject();

      final crypto2 = CryptoSimple(
        superKey: 123,
        subKey: 10,
        secretKey: 'mySecretKey',
        encryptionMode: EncryptionMode.Normal,
      );
      final encryptedText = crypto2.encrypting(inputString: 'hello world');
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot('hello world'));
    });

    test('Decrypting an encrypted text should return the original text', () {
      // Restarting the CryptoSimple object in here ,
      // because it has already been created and the test will encounter an error.
      CryptoSimple.instance.resetObject();

      final crypto = CryptoSimple(
        superKey: 123,
        subKey: 10,
        secretKey: 'mySecretKey',
        encryptionMode: EncryptionMode.Normal,
      );
      final originalText = 'hello world';
      final encryptedText = crypto.encrypting(inputString: originalText);
      final decryptedText = crypto.decrypting(encrypted: encryptedText);
      expect(decryptedText, equals(originalText));
    });
  });
}
