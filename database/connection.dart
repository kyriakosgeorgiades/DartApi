import 'package:dotenv/dotenv.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async' show Future;

class Mysql {
  static String host = env['DB_HOSTNAME'],
      user = env['DB_USERNAME'],
      password = env['DB_PASSWORD'],
      db = env['DATABASE'];
  static int port = int.parse(env['DB_PORT']);
  Mysql();

  Future<MySqlConnection> getConnection() async {
    // ignore: unnecessary_new
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    var conn = await MySqlConnection.connect(settings);
    return conn;
  }
}
