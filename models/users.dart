/// This file is responsible of sql queries related to the users

import 'package:mysql1/mysql1.dart';

import '../auth/hashing.dart';
import '../auth/jwt.dart';
import "../database/connection.dart";
import 'package:jwt_decoder/jwt_decoder.dart';

class UserModel {
  /// Adding a new user by [username] and [password]
  /// MySqlException returns map [message,statusCode] on a duplicated entry
  /// Returns MAP [dataResponse] of new user
  addNew(String username, String password) async {
    try {
      var security = Hashing();
      var salt = security.salt();
      // Creating the hash password
      var newPass = security.hashed(password, salt);
      var db = Mysql();
      dynamic conn = await db.getConnection();
      await conn.query('INSERT INTO users (username, pass, salt) VALUES(?,?,?)',
          [username, newPass, salt]);
      // Fetching the new entry of the user
      var result = await conn
          .query('select * from users where username = ?', [username]);
      var jwt = JWT();

      Map<String, dynamic> dataResponse = {};
      // Generating a JWT for the user and adding the relevant info to for the
      // response
      for (var row in result) {
        var token = jwt.signToken(row[0]);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        dataResponse.addAll({
          'id': row[0],
          'username': row[1],
          'token': token,
          'issuedAt': decodedToken['iat'],
          'expires': decodedToken['exp'],
          'message': 'User Created!',
          'statusCode': 201
        });
      }
      conn.close();

      return dataResponse;
    } on MySqlException catch (e) {
      if (e.errorNumber == 1062) {
        print(e.message);
        return ({
          'message': 'ERROR: Username already exists.',
          'statusCode': 200
        });
      }
    }
  }

  /// User login with [username] and [password]
  /// Returning MAP [info] of outcome of the match
  /// Catches unknown mysql error
  logIn(String username, String password) async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      // Fetching the user that is trying to login
      var results = await conn.query(
          'select id,username,pass from users where username = ?', [username]);
      // If the user does not exist returns message to the user
      if (results.isEmpty) {
        Map<String, dynamic> info =
            ({'statusCode': 404, 'message': 'User not found'});
        return info;
      }
      // Setting all the relative data to a map from the fetched user
      Map<String, dynamic> info = {};
      for (var row in results) {
        info.addAll({'id': row[0], 'userName': row[1], 'shaPass': row[2]});
      }
      conn.close();
      int statusCode;
      String result;
      var security = Hashing();
      bool doesMatch = security.isValid(info['shaPass'], password);
      // When the passwords match a new JWT is generated to the user
      if (doesMatch) {
        var jwt = JWT();
        var token = jwt.signToken(info['id']);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        result = "User login sucessfully";
        statusCode = 200;
        info.addAll({
          'token': token,
          'issuedAt': decodedToken['iat'],
          'expires': decodedToken['exp'],
          'message': result,
          'statusCode': statusCode
        });
        // User exists but wrong password given
      } else {
        result = "Wrong username or password";
        statusCode = 401;
        info.addAll({'message': result, 'statusCode': statusCode});
      }

      return info;
    } catch (e) {
      print(e);
      return e;
    }
  }
}
