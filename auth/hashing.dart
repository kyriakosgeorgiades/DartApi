import 'package:crypt/crypt.dart';
import 'dart:math';
import 'dart:convert';

class Hashing {
  String salt([int lenght = 25]) {
    final Random rnd = Random.secure();
    var saltGen = List<int>.generate(lenght, (i) => rnd.nextInt(256));
    print("salting");
    print(saltGen);

    return base64Url.encode(saltGen);
  }

  String hashed(String password, String salt) {
    final newPass = Crypt.sha512(password, rounds: 10000, salt: salt);
    return newPass.toString();
  }

  bool isValid(String cryptFormatHash, String enteredPassword) =>
      Crypt(cryptFormatHash).match(enteredPassword);
}
