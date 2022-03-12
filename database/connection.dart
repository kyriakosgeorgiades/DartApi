import 'package:mysql1/mysql1.dart';
import 'dart:async' show Future;

class Mysql {
  static String host =
          'i54jns50s3z6gbjt.chr7pe7iynqr.eu-west-1.rds.amazonaws.com',
      user = 'uhs4ben3uddktjwv',
      password = 'a7z16zmvimbgmoa1',
      db = 'xh9itjv2z2wexp2o';
  static int port = 3306; //FILL VALUES
  Mysql();

  Future<MySqlConnection> getConnection() async {
    // ignore: unnecessary_new
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    var conn = await MySqlConnection.connect(settings);
    return conn;
  }
}
