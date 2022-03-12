import 'dart:convert';
import 'dart:io' show InternetAddress;

import 'package:shelf/shelf.dart' show Pipeline, Request, Response, logRequests;
import 'package:shelf/shelf_io.dart' show serve;
import 'package:shelf_router/shelf_router.dart' show Router;
import 'routes/games.dart';
import 'routes/users.dart';
import 'auth/utils.dart';

void main() async {
  final app = Router();
  app.get('/', (Request reques) async {
    String json = jsonEncode({
      'users': 'http://localhost:8080/users/',
      'games': 'http://localhost:8080/games'
    });
    return Response.ok(json);
  });
  app.mount('/games', Games().router);
  app.mount('/users', User().router);
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addMiddleware(handleAuth())
      .addHandler(app);
  final server = await serve(
    handler,
    InternetAddress.anyIPv4,
    8080,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}
