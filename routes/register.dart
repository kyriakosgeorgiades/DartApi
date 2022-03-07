import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';

import '../models/register.dart';

class Register {
  Router get router {
    final router = Router();
    router.post('/', (Request request) async {
      try {
        final payload = await request.readAsString();
        var data = json.decode(payload);
        // ignore: unnecessary_new
        var add = new RegisterModel();
        var result = await add.addNew(data['username'], data['password']);
        return Response(201,
            body: result, headers: {'Content-Type': 'application/json'});
      } catch (e) {
        print(e);
        print(e);
        return Response.internalServerError();
      }
    });

    return router;
  }
}
