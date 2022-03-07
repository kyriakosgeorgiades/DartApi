import 'dart:async' show Future;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'test.dart';
import 'register.dart';
import 'package:mysql1/mysql1.dart';

class HomeRoute {
  Handler get handler {
    final router = Router();

    router.get('/', (Request request) {
      return Response.ok('Test home');
    });

    router.mount('/register', Register().router);
    router.mount('/test', Test().router);

    return router;
  }
}
