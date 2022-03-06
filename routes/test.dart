import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

class Test{
    Router get router{
        final router = Router();


        router.get('/', (Request request){
            return Response.ok("INSIDE TEST");
        });

        return router;
    }
}