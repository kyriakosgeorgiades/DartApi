import "../database/connection.dart";
import 'package:mysql1/mysql1.dart';
import 'dart:async';


class RegisterModel{
    
    
    addNew(String username, String password) async{
        print(username);
        print(password);
        var db =  new Mysql();
        dynamic conn = await db.getConnection();
        print("after con");
        var results =  await conn.query('select * from users');
        for (var row in results){
            print('${row[0]}');
        }
        // var result =  await conn.query('INSERT INTO users (username, password, salt) VALUES(?,?,?)',['Kakos','123','1551']);          
        // print(result);
        print("INSIDE THE MODEL");
        return results;
    }
}