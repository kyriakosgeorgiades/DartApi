import '../auth/hashing.dart';
import "../database/connection.dart";

class LoginModel {
  logIn(String username, String password) async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      var results = await conn.query(
          'select id,username,pass from users where username = ?', [username]);
      String shaPass;
      String userName;
      int id;
      for (var row in results) {
        id = row[0];
        userName = row[1];
        shaPass = row[2];
      }
      int statusCode = 0;
      String result;
      var security = Hashing();
      bool doesMatch = security.isValid(shaPass, password);
      if (doesMatch) {
        result = "Credentials match!";
        statusCode = 200;
      } else {
        result = "Wrong username or password";
        statusCode = 401;
      }

      return [result, statusCode, id, userName];
    } catch (e) {
      print(e);
      return e;
    }
  }
}
