/// File responsible for all the hashing related to passwords of users

import 'package:crypt/crypt.dart';
import 'dart:math';
import 'dart:convert';

class Hashing {
  /// Generating the salt of [int] set to 25
  /// Returning the salt in base64 encoded
  String salt([int lenght = 25]) {
    final Random rnd = Random.secure();
    var saltGen = List<int>.generate(lenght, (i) => rnd.nextInt(256));
    print("salting");
    print(saltGen);

    return base64Url.encode(saltGen);
  }

  /// Generating the new hash [password] with the [salt] added to it
  /// Returning the [newPass] of secure password
  String hashed(String password, String salt) {
    final newPass = Crypt.sha512(password, rounds: 10000, salt: salt);
    return newPass.toString();
  }

  /// Validating if an [enteredPassword] matches the [cryptFormatHash] password
  /// that is stored in the database
  /// Returns [bool] based on the match
  bool isValid(String cryptFormatHash, String enteredPassword) =>
      Crypt(cryptFormatHash).match(enteredPassword);
}
