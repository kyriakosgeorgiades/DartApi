import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/games.dart';
import '../utils.dart';

class Games {
  Handler get router {
    final authRouter = Router();

    authRouter.post('/add', ((Request request) async {
      try {
        final payload = await request.readAsString();
        var data = json.decode(payload);
        print(data);
        var game = GamesModel();
        var result = await game.add(data['name'], data['publisher'],
            data['cover'], data['description'], data['year'], data['user_id']);
        print("AFTER MODEL FINISHES");
        print(result[0]);
        String date = result[6].toString();
        date = date.substring(0, 16);
        Map<String, dynamic> dataResponse = {
          'message': 'Game sucessfully added!',
          'id': result[0],
          'name': result[1],
          'cover': result[2].toString(),
          'publisher': result[3],
          'year': result[4],
          'description': result[5],
          'added': date,
          'addedBy': result[7]
        };
        print(dataResponse);
        String jsonData = jsonEncode(dataResponse);
        return Response(201,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } catch (e) {
        print(e);
        return Response.internalServerError();
      }
    }));

    final handler =
        Pipeline().addMiddleware(checkAuthorisation()).addHandler(authRouter);
    return handler;
  }
}
