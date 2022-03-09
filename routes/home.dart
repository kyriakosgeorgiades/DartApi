import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/home.dart';

class Home {
  Handler get router {
    final router = Router();

    router.get('/', ((Request request) async {
      try {
        var all = HomeModel();
        var result = await all.allGames();
        String jsonData = jsonEncode(result);
        return Response.ok(jsonData, headers: {
          'content-type': 'application/json',
        });
      } catch (e) {
        return Response.internalServerError();
      }
    }));

    router.get('/game/<name>', ((Request request, String name) async {
      try {
        name = Uri.decodeFull(name);
        print("IS THE PARAM DECODED?");
        print(name);
        var game = HomeModel();
        var singleView = await game.singleGame(name);
        var jsonData = jsonEncode(singleView);
        return Response(200,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError();
      }
    }));

    final handler = Pipeline().addHandler(router);
    return handler;
  }
}
