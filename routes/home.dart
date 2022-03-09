import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Home {
  Handler get router {
    final router = Router();

    router.get('/', ((Request request) {
      print("TSEIRES");
      return Response.ok('{"users":["LOL","fa"]}', headers: {
        'content-type': 'application/json',
      });
    }));

    final handler = Pipeline().addHandler(router);
    return handler;
  }
}
