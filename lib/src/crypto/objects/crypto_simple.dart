import 'objects.dart';

class CryptoSimple
    implements
        CryptoSimpleDecryptionInterface,
        CryptoSimpleEncryptionInterface {
  /// [superKey] A positive integer that is not divisible by [maxCharLimit].
  final int? superKey;

  /// [subKey] An integer between 10 and 99 .
  final int? subKey;

  /// [securityMode] A string that serves as a secret key for encryption and decryption .
  SecurityMode? securityMode;

  /// [encryptionMode]  An instance of the [EncryptionMode] enumeration that specifies the type of encryption to be used.
  /// The default value is [EncryptionMode.Normal] .
  final EncryptionMode? encryptionMode;

  /// [_secretKey] : A secret key used to further enhance the security of the encryption process.
  final String? secretKey;

  /// [CryptoSimple] factory constructor :
  /// A factory constructor that creates and returns a new instance of the [CryptoSimple] class.
  /// It takes several optional parameters, such as [superKey], [subKey], [secretKey],
  /// and [encryptionMode], and performs input validation before setting the values of the corresponding instance variables.
  CryptoSimple(
      {this.superKey,
      this.subKey,
      this.secretKey,
      this.securityMode = SecurityMode.XOR,
      this.encryptionMode = EncryptionMode.Normal}) {
    // Determine security mode based on input values
    if (secretKey != null && superKey != null && subKey != null) {
      securityMode = SecurityMode.SUPER_XOR;
    } else if (secretKey != null && superKey == null && subKey == null) {
      securityMode = SecurityMode.XOR;
    } else if (superKey != null && subKey != null) {
      securityMode = SecurityMode.SUPER;
    } else {
      throw ArgumentError("Error in initial data.");
    }

    // Check for valid input values
    assert(secretKey == null || secretKey!.trim().isNotEmpty,
        "Secret key must not be an empty string.");
    assert(!(secretKey == null && encryptionMode == EncryptionMode.Randomized),
        "EncryptionMode on `Randomized` mode need secretKey.");
    assert(subKey == null || (subKey! >= 10 && subKey! <= 99),
        "Sub-key must be an integer between 10 and 99.");
    assert(superKey == null || (superKey! > 0 && superKey! % maxCharLimit != 0),
        "Super-key must be a positive integer not divisible by $maxCharLimit.");
  }

  @override
  String decryption({required String encryptedString}) {
    CryptoSimpleManager cryptoSimpleManager = CryptoSimpleManager(
        encryptionMode: this.encryptionMode!,
        securityMode: this.securityMode!,
        secretKey: this.secretKey,
        subKey: this.subKey,
        superKey: this.superKey);
    return cryptoSimpleManager.decryption(encryptedString: encryptedString);
  }

  @override
  String encryption({required String inputString}) {
    CryptoSimpleManager cryptoSimpleManager = CryptoSimpleManager(
        encryptionMode: this.encryptionMode!,
        securityMode: this.securityMode!,
        secretKey: this.secretKey,
        subKey: this.subKey,
        superKey: this.superKey);
    return cryptoSimpleManager.encryption(inputString: inputString);
  }
}
