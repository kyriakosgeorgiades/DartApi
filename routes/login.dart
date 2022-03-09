import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';

import '../auth/jwt.dart';
import '../models/login.dart';

class Login {
  Router get router {
    final router = Router();
    router.post('/', (Request request) async {
      try {
        final payload = await request.readAsString();
        var data = json.decode(payload);
        var log = LoginModel();
        // Checking if passwords match with inputpassword
        // Returning response based on match case
        var result = await log.logIn(data['username'], data['password']);
        int statusCode = result['statusCode'];
        Map<String, dynamic> dataResponse = {};
        // Mathced preparing the map data to be encoded json
        if (statusCode == 200) {
          // Creating the JWT for auth
          var jwt = JWT();
          var token = jwt.signToken(result['id']);
          dataResponse = {
            'id': result['id'],
            'username': result['userName'],
            'token': token,
            'message': result['message']
          };
          // Failed to login just retuning a message to inform user
        } else if (statusCode == 401) {
          dataResponse = {'message': result['message']};
        }

        String jsonData = jsonEncode(dataResponse);
        return Response(statusCode,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } catch (e) {
        print(e);
        return Response.internalServerError();
      }
    });

    return router;
  }
}
