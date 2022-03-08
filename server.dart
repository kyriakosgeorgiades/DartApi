/* server.dart */

/* query strings example */

import 'dart:io' show InternetAddress;

import 'package:shelf/shelf.dart' show Pipeline, Request, Response, logRequests;
import 'package:shelf/shelf_io.dart' show serve;
import 'package:shelf_router/shelf_router.dart' show Router;
import 'routes/login.dart';
import 'routes/register.dart';
import 'routes/test.dart';
import 'utils.dart';

void main() async {
  final app = Router();
  app.mount('/register', Register().router);
  app.mount('/test', Test().router);
  app.mount('/login', Login().router);
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
