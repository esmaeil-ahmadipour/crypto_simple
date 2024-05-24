import 'package:crypto_simple/crypto_simple.dart';

class CryptoSimpleSingleton
    implements
        CryptoSimpleDecryptionInterface,
        CryptoSimpleEncryptionInterface {
  static final CryptoSimpleSingleton _crypto =
      CryptoSimpleSingleton._internal();

  /// The [resetObject] method resets the [_lock] instance variable to false.
  /// It is used internally within the class to reset the lock after unit tests are run.
  void resetObject() {
    if (kIsWeb == false && Platform.environment.containsKey('FLUTTER_TEST')) {
      _crypto._lock = false;
    }
  }

  /// [_internal] private constructor :
  /// A private constructor that's called from the factory constructor to ..
  /// create a new instance of the [CryptoSimple] class.
  CryptoSimpleSingleton._internal();

  /// [_superKey] A positive integer that is not divisible by [maxCharLimit].
  int? _superKey;

  /// [_subKey] An integer between 10 and 99 .
  int? _subKey;

  /// [_securityMode] A string that serves as a secret key for encryption and decryption .
  SecurityMode? _securityMode;

  /// [_encryptionMode]  An instance of the [EncryptionMode] enumeration that specifies the type of encryption to be used.
  /// The default value is [EncryptionMode.Normal] .
  EncryptionMode? _encryptionMode;

  /// [_secretKey] : A secret key used to further enhance the security of the encryption process.
  String? _secretKey;

  /// [_lock] : A boolean that is used to ensure that only one instance of the class is created.
  bool _lock = false;

  /// [CryptoSimple] factory constructor :
  /// A factory constructor that creates and returns a new instance of the [CryptoSimple] class.
  /// It takes several optional parameters, such as [superKey], [subKey], [secretKey],
  /// and [encryptionMode], and performs input validation before setting the values of the corresponding instance variables.
  factory CryptoSimpleSingleton(
      {int? superKey,
      int? subKey,
      String? secretKey,
      SecurityMode? securityMode = SecurityMode.XOR,
      EncryptionMode? encryptionMode = EncryptionMode.Normal}) {
    assert(!_crypto._lock, "CryptoSimple class has already been instantiated.");

    // Check for valid input values
    assert(secretKey == null || secretKey.trim().isNotEmpty,
        "Secret key must not be an empty string.");
    assert(!(secretKey == null && encryptionMode == EncryptionMode.Randomized),
        "EncryptionMode on `Randomized` mode need secretKey.");
    assert(subKey == null || (subKey >= 10 && subKey <= 99),
        "Sub-key must be an integer between 10 and 99.");
    assert(superKey == null || (superKey > 0 && superKey % maxCharLimit != 0),
        "Super-key must be a positive integer not divisible by $maxCharLimit.");

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
  static CryptoSimpleSingleton get instance => _crypto;

  @override
  String decryption({required String encryptedString}) {
    CryptoSimpleManager cryptoSimpleManager = CryptoSimpleManager(
        encryptionMode: _crypto._encryptionMode!,
        securityMode: _crypto._securityMode!,
        secretKey: _crypto._secretKey,
        subKey: _crypto._subKey,
        superKey: _crypto._superKey);
    return cryptoSimpleManager.decryption(encryptedString: encryptedString);
  }

  @override
  String encryption({required String inputString}) {
    CryptoSimpleManager cryptoSimpleManager = CryptoSimpleManager(
        encryptionMode: _crypto._encryptionMode!,
        securityMode: _crypto._securityMode!,
        secretKey: _crypto._secretKey,
        subKey: _crypto._subKey,
        superKey: _crypto._superKey);
    return cryptoSimpleManager.encryption(inputString: inputString);
  }
}
