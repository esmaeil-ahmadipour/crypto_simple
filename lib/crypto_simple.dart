library crypto_simple;

class CryptoSimple {
  static final CryptoSimple _crypto = CryptoSimple._internal();
  static final int _maxCharLimit = 1114111;

  CryptoSimple._internal();

  int? _superKey;
  bool _lock = false;

  factory CryptoSimple({required int superKey}) {
    print("create instance from CryptoSimple class");

    /// set lock for sometimes user trying to create duplicate object from this class.
    assert(!_crypto._lock, "it's a unique class , that can't re-defined");

    ///  if the selected number for superKey was divisible by 1114111 then actually don't completed encryption .
    assert(!(superKey % _maxCharLimit == 0),
        "unchanged superKey value and disabled encryption.");

    /// when user set zero , actually don't completed encryption .
    assert(
        !(superKey <= 0), "unchanged superKey value and disabled encryption.");
    _crypto._superKey = superKey;
    _crypto._lock = true;
    return _crypto;
  }

  static CryptoSimple get instance => _crypto;

  /// Use this method to encrypting all your text characters.
  String _characterEncrypting({required String char}) {
    int? resultCharCode;
    int? textInputCode = char.codeUnits[0];
    if (textInputCode + CryptoSimple._crypto._superKey! > 1114111) {
      resultCharCode =
          (textInputCode + CryptoSimple._crypto._superKey!) % 1114111;
    } else {
      resultCharCode = textInputCode + CryptoSimple._crypto._superKey!;
    }
    return "$resultCharCode ";
  }

  /// using this method for encrypting your text .
  String encrypt({required String inputText}) {
    assert(!(_crypto._superKey == null),
        "CryptoSimple not correctly initialized , please see documents or example .");
    String result = "";

    for (int i = 0; i < inputText.length; i++) {
      result = "$result${_characterEncrypting(char: inputText[i])}";
    }
    return _reverseStringInList(inputText: result);
  }

  /// Use this method to decrypting all your text characters.
  String _characterDecrypting({required int char}) {
    int? resultCharCode;
    int? textInputCode = char;
    if (textInputCode - CryptoSimple._crypto._superKey! >= 0) {
      // if positive number
      resultCharCode = (textInputCode - CryptoSimple._crypto._superKey!);
    } else {
      // when negative number
      resultCharCode =
          (textInputCode - CryptoSimple._crypto._superKey!) % 1114111;
    }
    return String.fromCharCode(resultCharCode);
  }

  /// Use this method to decrypting your text .
  String decrypt({required String encryptedText}) {
    assert(!(_crypto._superKey == null),
        "CryptoSimple not correctly initialized , please see documents or example .");

    String result = "";
    List<String> listCode =
        _reverseStringInList(inputText: encryptedText).split(" ");
    listCode.removeLast();
    for (int i = 0; i < listCode.length; i++) {
      result = "$result${_characterDecrypting(char: int.parse(listCode[i]))}";
    }
    return result;
  }

  String _reverseStringInList({required String inputText}) {
    return inputText.split('').reversed.join();
  }
}
