import 'package:shelf/shelf.dart';

import 'auth/jwt.dart';

Middleware handleCors() {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  };

  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders);
      }
      return null;
    },
    responseHandler: (Response response) {
      return response.change(headers: corsHeaders);
    },
  );
}

Middleware handleAuth() {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];
      var token;
      var jwt = false;
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7);
        jwt = isValidToken(token);
        print("I AM INSIDE THE HANDLE LOL");
        print(jwt);
      }
      print(jwt);
      final updateRequest = request.change(context: {
        'tokenValidation': jwt,
      });
      return await innerHandler(updateRequest);
    };
  };
}

Middleware checkAuthorisation() {
  return createMiddleware(
    requestHandler: (Request request) {
      print("BEFORE IF");
      if (request.context['tokenValidation'] == false) {
        return Response.forbidden('Not authorised for this action');
      } else {
        return null;
      }
    },
  );
}
