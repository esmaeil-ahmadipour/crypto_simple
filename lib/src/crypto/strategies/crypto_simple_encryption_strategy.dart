abstract class CryptoSimpleEncryptionStrategy {
  String encryptCharWithSubKey({
    required String char,
    required int charIndex,
  });

  String encryptTextWithSuperKey({required String inputText});

  String encryptXOR({required String plainText, required String secretKey});

  String obscureAtEncrypt(
      {required String charCode,
      required int characterIndex,
      required int subKey});
}
