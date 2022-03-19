/// This file is for the creating of Middlewares

import 'package:shelf/shelf.dart';

import 'jwt.dart';

// Middleware for CORS permissions
Middleware handleCors() {
  print("IN CORS");
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
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

// Middleware to handle the authorization on each new request using JWT
Middleware handleAuth() {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];
      var token;
      var jwt = false;
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7);
        jwt = isValidToken(token);
      }
      // Setting the status of the validation of the user
      final updateRequest = request.change(context: {
        'tokenValidation': jwt,
      });
      return await innerHandler(updateRequest);
    };
  };
}

// Middleware to force authorization on a specific method
Middleware checkAuthorisation() {
  return createMiddleware(
    requestHandler: (Request request) {
      // For the required methods a header of 'authcheck' is required to be of
      // value 'needAuth' and a valid token to carry on with the specific
      // requested method
      if (request.context['tokenValidation'] == false &&
          request.headers['authcheck'] == 'needAuth') {
        return Response.forbidden('Not authorised for this action');
      } else {
        // NULL means that is okay to carry on down to the pipeline
        return null;
      }
    },
  );
}
