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
        var result = await log.logIn(data['username'], data['password']);
        var jwt = JWT();
        var token = jwt.signToken(result[2]);
        Map<String, dynamic> dataResponse = {
          'id': result[2],
          'username': result[3],
          'token': token,
          'message': result[0]
        };
        int statusCode = result[1];

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
