import 'package:crypto_simple/crypto_simple.dart';
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
      CryptoSimple.instance.resetObject();

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
      // Restarting the CryptoSimple object in here ,
      // because it has already been created and the test will encounter an error.
      CryptoSimple.instance.resetObject();

      final crypto = CryptoSimple(
        superKey: 123,
        subKey: 22,
        secretKey: 'mySecretKey',
        encryptionMode: EncryptionMode.Normal,
      );
      final originalText = 'hello world';

      final encryptedText = crypto.encrypting(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decrypting(encrypted: encryptedText);
      expect(decryptedText, originalText);
    });

    test(
        'Decrypting an encrypted text should return the original text in EncryptionMode.Randomized',
        () {
      // Restarting the CryptoSimple object in here ,
      // because it has already been created and the test will encounter an error.
      CryptoSimple.instance.resetObject();

      final crypto = CryptoSimple(
        superKey: 123,
        subKey: 10,
        secretKey: 'mySecretKey',
        encryptionMode: EncryptionMode.Randomized,
      );
      final originalText = 'hello world';
      final encryptedText = crypto.encrypting(inputString: originalText);
      final decryptedText = crypto.decrypting(encrypted: encryptedText);
      expect(decryptedText, originalText);
    });

    test(
        'Decrypting an encrypted text should return the original text without set secretKey & encryptionMode',
        () {
      // Restarting the CryptoSimple object in here ,
      // because it has already been created and the test will encounter an error.
      CryptoSimple.instance.resetObject();
      final originalText = 'hello';

      final crypto = CryptoSimple(superKey: 123, subKey: 10);
      final encryptedText = crypto.encrypting(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decrypting(encrypted: encryptedText);
      expect(decryptedText, equals(originalText));
    });

    test(
        'Decrypting an encrypted text should return the original text , by set EncryptionMode.Randomized without set superKey & subKey',
        () {
      // Restarting the CryptoSimple object in here ,
      // because it has already been created and the test will encounter an error.
      CryptoSimple.instance.resetObject();
      final originalText = 'hello world';
      final crypto = CryptoSimple(
          secretKey: 'mySecretKey', encryptionMode: EncryptionMode.Randomized);
      final encryptedText = crypto.encrypting(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decrypting(encrypted: encryptedText);
      expect(originalText, decryptedText);
    });

    test(
        'Decrypting an encrypted text should return the original text , by set secretKey without set superKey & subKey',
        () {
      // Restarting the CryptoSimple object in here ,
      // because it has already been created and the test will encounter an error.
      CryptoSimple.instance.resetObject();

      final crypto = CryptoSimple(secretKey: 'mySecretKey');
      final originalText = 'hello world';

      final encryptedText = crypto.encrypting(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decrypting(encrypted: encryptedText);
      expect(originalText, decryptedText);
    });

    test(
        'Decrypting an encrypted text should return the original text , by set secretKey & EncryptionMode.Normal without set superKey & subKey',
        () {
      // Restarting the CryptoSimple object in here ,
      // because it has already been created and the test will encounter an error.
      CryptoSimple.instance.resetObject();

      final crypto = CryptoSimple(
          secretKey: 'mySecretKey', encryptionMode: EncryptionMode.Normal);
      final originalText = 'hello world';

      final encryptedText = crypto.encrypting(inputString: originalText);
      expect(encryptedText, isNotNull);
      expect(encryptedText, isNotEmpty);
      expect(encryptedText, isNot(originalText));
      final decryptedText = crypto.decrypting(encrypted: encryptedText);
      expect(originalText, decryptedText);
    });
  });
}
