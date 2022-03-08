import 'package:mysql1/mysql1.dart';

import '../auth/hashing.dart';
import "../database/connection.dart";

class RegisterModel {
  addNew(String username, String password) async {
    try {
      var security = Hashing();
      var salt = security.salt();
      var newPass = security.hashed(password, salt);
      // ignore: unnecessary_new
      var db = new Mysql();
      dynamic conn = await db.getConnection();
      await conn.query('INSERT INTO users (username, pass, salt) VALUES(?,?,?)',
          [username, newPass, salt]);
      var info = await conn
          .query('select * from users where username = ?', [username]);
      print(info);
      return info;
    } catch (e) {
      print(e);
      return e;
    }
  }
}
