import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../database/connection.dart';
import '../models/register.dart';
import 'dart:async';

class Register{
    Router get router{

        final router = Router();
        router.get('/', (Request request) async {
            var add = new RegisterModel();
            var result =  await add.addNew("Kakos", "123");
            print("in route");
            return Response.ok("NEW USER ADDED");
        });

        return router;
    }
}