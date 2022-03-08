import 'package:mysql1/mysql1.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';

import '../auth/jwt.dart';
import '../models/register.dart';

class Register {
  Router get router {
    final router = Router();
    // final handler = const Pipeline().addMiddleware(logRequests())
    // .addHandler((request) => null)
    router.post('/', (Request request) async {
      try {
        final payload = await request.readAsString();
        var data = json.decode(payload);
        var add = RegisterModel();
        var result = await add.addNew(data['username'], data['password']);
        Map<String, dynamic> dataResponse = {};
        for (var row in result) {
          print('${row[0]} and ${row[1]} ${row[2]}');
          dataResponse.addAll({'id': row[0], 'username': row[1]});
        }
        var jwt = JWT();
        var token = jwt.signToken(dataResponse['id']);
        dataResponse.addAll({'token': token});
        String jsonData = jsonEncode(dataResponse);

        return Response(201,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } catch (e) {
        print(e);
        return Response.internalServerError();
      }
    });

    return router;
  }
}
