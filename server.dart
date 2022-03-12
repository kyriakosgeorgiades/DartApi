import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dotenv/dotenv.dart' show load, clean, isEveryDefined, env;
import 'package:shelf/shelf.dart' show Pipeline, Request, Response, logRequests;
import 'package:shelf/shelf_io.dart' show serve;
import 'package:shelf_router/shelf_router.dart' show Router;
import 'routes/games.dart';
import 'routes/users.dart';
import 'auth/utils.dart';

void main() async {
  load();
  final app = Router();
  const _hostname = '0.0.0.0';
  final port = int.parse(Platform.environment['PORT'] ?? '8085');

  app.get('/', (Request reques) async {
    String json = jsonEncode({
      'users': 'https://games-reviews-coursework.herokuapp.com/users/',
      'games': 'https://games-reviews-coursework.herokuapp.com/games/'
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
    _hostname,
    port,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}
