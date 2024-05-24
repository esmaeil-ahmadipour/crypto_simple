///[SecurityMode] : Contains three modes for security of data encryption.
/// [SUPER] : Used superKey and subKey without using secretKey.
/// [XOR] : Used secretKey and EncryptionMode without using superKey and subKey.
/// [SUPER_XOR] : Used secretKey and EncryptionMode and superKey and subKey.
enum SecurityMode { SUPER, XOR, SUPER_XOR }

///[EncryptionMode] : Contains two modes for data encryption.
/// [Randomized] : Used to generate a random encryption result.
/// [Normal] : Used to create a permanent encryption result.
enum EncryptionMode { Randomized, Normal }
