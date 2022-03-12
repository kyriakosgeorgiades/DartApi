/// This file is handling the routes of the users resource

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';

import '../models/users.dart';

class User {
  Router get router {
    final router = Router();

    /// Adding a new user from the [request]
    /// Returns [Response] of the action
    /// on FormatException returns Response of Missing username or password
    addUser(Request request) async {
      try {
        final payload = await request.readAsString();
        var data = json.decode(payload);
        var add = UserModel();
        // Calling the model to add the user
        var result = await add.addNew(data['username'], data['password']);
        // Initialize the statusCode
        int statusCode = result['statusCode'];
        // Removing the statusCode from the MAP that will be json encoded
        result.remove('statusCode');
        String jsonData = jsonEncode(result);
        return Response(statusCode,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } on FormatException {
        String jsonData =
            jsonEncode({'message': 'ERROR: Missing username or password'});
        return Response.internalServerError(body: jsonData);
      }
    }

    /// Login user by [request]
    /// Return [Response] of the request
    /// on FormatException returns [Response] for missing value on either inputs
    loginUser(Request request) async {
      try {
        final payload = await request.readAsString();
        var data = json.decode(payload);
        var log = UserModel();
        // Calling the model to login
        var result = await log.logIn(data['username'], data['password']);
        // Initialize the statusCode
        int statusCode = result['statusCode'];
        // Removing the statusCode and the hashedPassword from the MAP
        result.remove('statusCode');
        result.remove('shaPass');
        String jsonData = jsonEncode(result);
        return Response(statusCode,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } on FormatException catch (e) {
        print(e.message);
        String jsonData =
            jsonEncode({'message': 'ERROR: Missing username or password'});
        return Response.internalServerError(body: jsonData);
      }
    }

    router.post('/', addUser);
    router.post('/user', loginUser);

    return router;
  }
}
