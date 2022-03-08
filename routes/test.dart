import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import '../auth/jwt.dart';
import '../utils.dart';

class Test {
  Handler get router {
    final router = Router();

    router.get('/', ((Request request) {
      return Response.ok('{"users":["LOL","fa"]}', headers: {
        'content-type': 'application/json',
      });
    }));

    final handler =
        Pipeline().addMiddleware(checkAuthorisation()).addHandler(router);
    return handler;
  }
}
