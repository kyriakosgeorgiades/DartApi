import '../auth/hashing.dart';
import "../database/connection.dart";

class RegisterModel {
  addNew(String username, String password) async {
    try {
      var security = new Hashing();
      var salt = security.salt();
      var newPass = security.hashed(password);
      // ignore: unnecessary_new
      var db = new Mysql();
      dynamic conn = await db.getConnection();
      var result = await conn.query(
          'INSERT INTO users (username, pass, salt) VALUES(?,?,?)',
          [username, newPass, salt]);
      conn.close();
      print(result);

      return "User has been added succesfully";
    } catch (e) {
      print(e);
      return e;
    }
  }
}
