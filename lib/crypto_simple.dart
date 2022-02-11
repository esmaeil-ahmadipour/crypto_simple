library crypto_simple;

class CryptoSimple {
  static final CryptoSimple _crypto = CryptoSimple._internal();
  static final int _maxCharLimit = 1114111;

  CryptoSimple._internal();

  int? _superKey;
  int? _subKey;
  bool _lock = false;

  factory CryptoSimple({required int superKey, required int subKey}) {
    ///  if the selected number for subKey not in range 10~99 then failed encryption .
    assert((subKey < 100 && subKey > 9),
        "\n[ERROR:set subKey value to $subKey and failed encryption.please change the subKey value.]\n");

    /// set lock for sometimes user trying to create duplicate object from this class.
    assert(!_crypto._lock,
        "\n[ERROR:it's a unique class , that can't re-defined.]\n");

    ///  if the selected number for superKey was divisible by 1114111 then then failed encryption .
    assert(!(superKey % _maxCharLimit == 0),
        "\n[ERROR:set superKey value to $superKey and failed encryption.please change the superKey value.]\n");

    /// when user set zero for superKey , then failed encryption .
    assert(!(superKey <= 0),
        "\nset superKey value to $superKey and failed encryption.please change the superKey value.\n");
    print("create instance from CryptoSimple class.");
    _crypto._superKey = superKey;
    _crypto._subKey = subKey;
    _crypto._lock = true;
    return _crypto;
  }

  static CryptoSimple get instance => _crypto;

  /// Use this method to encrypting all your text characters.
  String _characterEncrypting({required String char, required int charIndex}) {
    String? resultCharCode;
    int? textInputCode = char.codeUnits[0];
    if (textInputCode + CryptoSimple._crypto._superKey! > 1114111) {
      resultCharCode = _obscureAtEncrypt(
          charCode:
              "${(textInputCode + CryptoSimple._crypto._superKey!) % 1114111}",
          characterIndex: charIndex,
          subKey: _crypto._subKey!);
    } else {
      resultCharCode = _obscureAtEncrypt(
          charCode: "${textInputCode + CryptoSimple._crypto._superKey!}",
          characterIndex: charIndex,
          subKey: _crypto._subKey!);
    }
    return "$resultCharCode ";
  }

  /// using this method for encrypting your text .
  String encrypt({required String inputText}) {
    assert(!(_crypto._superKey == null),
        "\n[ERROR:CryptoSimple not correctly initialized , please see documents or example.]\n");
    String result = "";
    for (int i = 0; i < inputText.length; i++) {
      result =
          "$result${_characterEncrypting(char: inputText[i], charIndex: i)}";
    }
    return _reverseStringInList(inputText: result);
  }

  /// Use this method to decrypting all your text characters.
  String _characterDecrypting({required String char, required int charIndex}) {
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

  /// Use this method to decrypting your text .
  String decrypt({required String encryptedText}) {
    assert(!(_crypto._superKey == null),
        "\n[ERROR:CryptoSimple not correctly initialized , please see documents or example .\n");

    String result = "";
    List<String> listCode =
        _reverseStringInList(inputText: encryptedText).split(" ");
    listCode.removeLast();
    for (int i = 0; i < listCode.length; i++) {
      result =
          "$result${_characterDecrypting(char: (listCode[i]), charIndex: i)}";
    }
    return result;
  }

  String _reverseStringInList({required String inputText}) {
    return inputText.split('').reversed.join();
  }

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
}
