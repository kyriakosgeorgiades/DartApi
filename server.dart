/* server.dart */

/* query strings example */

import 'dart:io' show InternetAddress;

import 'package:shelf/shelf.dart' show Request, Response;
import 'package:shelf/shelf_io.dart'  show serve;
import 'package:shelf_router/shelf_router.dart' show Router;
import './routes/home.dart';

void main() async {


  final home = HomeRoute();
  final server = await serve(
    home.handler,
    InternetAddress.anyIPv4,
    8080,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}
