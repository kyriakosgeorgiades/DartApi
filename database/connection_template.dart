import 'package:mysql1/mysql1.dart';
import 'dart:async' show Future;

class Mysql {
  static String host = 'topicbonanza-betweenzodiac',
      user = 'kakos',
      password = 'passDart',
      db = 'games_reviews';
  static int port = 3306;
  Mysql();

  Future<MySqlConnection> getConnection() async {
    print("connection called");
    print(host);
    print(user);
    print(password);
    print(db);
    print(port);
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    print("return??");
    var conn = await MySqlConnection.connect(settings);
    print("????");
    return conn;
  }
}
