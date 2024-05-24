abstract class CryptoSimpleDecryptionStrategy {
  String decryptCharWithSubKey({required String char, required int charIndex});

  String decryptTextWithSuperKey({required String encryptedText});

  String decryptXOR({required String cipherText, required String secretKey});

  String obscureAtDecrypt(
      {required String charCode,
      required int characterIndex,
      required int subKey});
}
