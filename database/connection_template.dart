import 'package:mysql1/mysql1.dart';
import 'dart:async' show Future;


class Mysql{
    

    static String host = '',
                user = '',
                password = '',
                db = '';
    static int port = ; //FILL VALUES
    Mysql();

    Future<MySqlConnection> getConnection() async {
        print("connection called");
        print(host);
        print(user);
        print(password);
        print(db);
        print(port);
        var settings = new ConnectionSettings(
            host: host,
            port: port,
            user: user,
            password: password,
            db: db
        );
         print("return??");
         var conn = await MySqlConnection.connect(settings);
         print("????");
         return conn;
    } 
}