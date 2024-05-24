// MIT License that can be found in the LICENSE.md file.

/// Library for the Cryptography features.
///
/// The class [CryptoSimple] provide access to the Cryptography  features.
library crypto_simple;

export 'dart:convert';
export 'dart:io';
export 'dart:math';
export 'dart:typed_data';

export 'package:crypto_simple/src/crypto/interfaces/crypto_simple_decryption_interface.dart';
export 'package:crypto_simple/src/crypto/strategies/crypto_simple_decryption_strategy.dart';
export 'package:crypto_simple/src/crypto/interfaces/crypto_simple_encryption_interface.dart';
export 'package:crypto_simple/src/crypto/strategies/crypto_simple_encryption_strategy.dart';
export 'package:crypto_simple/src/crypto/manager/crypto_simple_manager.dart';
export 'package:crypto_simple/src/utils/constants.dart';
export 'package:crypto_simple/src/utils/enums.dart';

export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';
