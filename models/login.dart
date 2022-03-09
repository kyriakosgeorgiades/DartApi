import '../auth/hashing.dart';
import "../database/connection.dart";

class LoginModel {
  logIn(String username, String password) async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      var results = await conn.query(
          'select id,username,pass from users where username = ?', [username]);
      Map<String, dynamic> info = {};
      for (var row in results) {
        info.addAll({'id': row[0], 'userName': row[1], 'shaPass': row[2]});
      }
      int statusCode;
      String result;
      var security = Hashing();
      bool doesMatch = security.isValid(info['shaPass'], password);
      if (doesMatch) {
        result = "Credentials match!";
        statusCode = 200;
      } else {
        result = "Wrong username or password";
        statusCode = 401;
      }
      
      info.addAll({'message': result, 'statusCode': statusCode});

      return info;
    } catch (e) {
      print(e);
      return e;
    }
  }
}
