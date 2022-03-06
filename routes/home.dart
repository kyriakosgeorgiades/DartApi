import 'dart:async' show Future;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'test.dart';
import 'register.dart';
import 'package:mysql1/mysql1.dart';


class HomeRoute{
    Handler get handler{
        final router = Router();

        router.get('/', (Request request) async{
            // var settings = new ConnectionSettings(
            //     host: '0.0.0.0', 
            //     port: 8080,
            //     user: 'root',
            //     password: 'passDart',
            //     db: 'games_reviews'
            //     );
            //  var conn = await MySqlConnection.connect(settings);
            //  dynamic results = await conn.query('select * from users');
            //  for (var row in results){
            //      print(row[0]);
            //  }
            return Response.ok('Test home');
        });

        
        router.mount('/register', Register().router);
        router.mount('/test', Test().router);


        return router;
    }    
}