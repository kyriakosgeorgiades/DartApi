/// This file handles the request of the route /games
/// All cases return an approriate response

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/games.dart';
import '../auth/utils.dart';

/// Games Object with handler router being return from the pipeline inside handler
class Games {
  Handler get router {
    final router = Router();

    /// Sends the data to the model to add the game to the database
    ///
    /// Returns Response of [jsonData] in body
    /// on FromatException catches error of EMPTY inputs
    /// on TypeError catches error of wrong type of inputs given
    addGame(Request request) async {
      try {
        final payload = await request.readAsString();
        var data = json.decode(payload);
        var game = GamesModel();
        // Calling the model function to add the game in the database
        var result = await game.add(data['name'], data['publisher'],
            data['cover'], data['description'], data['year'], data['user_id']);
        // Setting the status based on the success of the model
        int statusCode = result['statusCode'];
        result.remove('statusCode');
        String jsonData = jsonEncode(result);
        return Response(statusCode,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } on FormatException catch (e) {
        print(e.message);
        String jsonData =
            jsonEncode({'message': 'ERROR: Empty username or password'});
        return Response.internalServerError(body: jsonData);
      } on TypeError catch (e) {
        print(e);
        String jsonData = jsonEncode(
            {'message': 'ERROR: Wrong type given in one of the inputs'});
        return Response.internalServerError(body: jsonData);
      }
    }

    /// Sends the request to the model to fetch all the Games from the DB
    ///
    /// Returns Response of [jsonData] in body
    /// Catches unknown error.
    allGames(Request request) async {
      try {
        var all = GamesModel();
        // Call to the model function to fetch all the games
        var result = await all.allGames();
        String jsonData = jsonEncode(result);
        return Response.ok(jsonData, headers: {
          'content-type': 'application/json',
        });
      } catch (e) {
        print(e);
        return Response.internalServerError();
      }
    }

    /// Fetches a single game by [name] from the database
    ///
    /// Returns Response of [jsonData] in body
    /// Catches unknown error.
    singleGame(Request requst, String name) async {
      try {
        name = Uri.decodeFull(name);
        var game = GamesModel();
        // Call to the model function to fetch the single Game
        var singleView = await game.singleGame(name);
        int statusCode = singleView[1];
        var jsonData = jsonEncode(singleView[0]);
        return Response(statusCode,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } catch (e) {
        print("ERROR $e");
        return Response.internalServerError();
      }
    }

    /// Sends the data to the model to add a review of a game to the database
    ///
    /// Returns Response of [jsonData] in body
    /// on FromatException catches error of EMPTY inputs
    /// on TypeError catches error of wrong type of inputs given
    addReview(Request request, String name) async {
      try {
        name = Uri.decodeFull(name);
        final payload = await request.readAsString();
        var data = json.decode(payload);
        data.addAll({"name": name});
        var game = GamesModel();
        var reviewAdded = await game.addReview(data);
        int statusCode = reviewAdded['statusCode'];
        reviewAdded.remove('statusCode');
        // Creating the URI link of the created new review
        // Adding to the MAP to be jsonEncoded
        if (statusCode == 201) {
          Uri uri = request.requestedUri;
          String stringUri = uri.toString();
          String reviewID = reviewAdded['reviewID'].toString();
          stringUri = stringUri + '/' + reviewID;
          reviewAdded.addAll({'URI': stringUri});
        }
        var jsonData = jsonEncode(reviewAdded);
        return Response(statusCode,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } on FormatException catch (e) {
        print(e.message);
        String jsonData = jsonEncode({'message': 'ERROR: Missing input/s'});
        return Response.internalServerError(body: jsonData);
      } on TypeError catch (e) {
        print(e);
        String jsonData =
            jsonEncode({'message': 'ERROR: Not correct types given'});
        return Response.internalServerError(body: jsonData);
      } catch (e) {
        return Response.internalServerError();
      }
    }

    /// Requests from the model to fetch all reviews of a specific [name] game
    ///
    /// Returns Response of [jsonData] in body
    /// Catches unknown error.
    viewReviews(Request request, String name) async {
      try {
        name = Uri.decodeFull(name);
        var game = GamesModel();
        var viewAllReviews = await game.allReviews(name);
        int statusCode = viewAllReviews[1];
        var jsonData = jsonEncode(viewAllReviews[0]);
        return Response(statusCode,
            body: jsonData, headers: {'Content-Type': 'application/json'});
      } catch (e) {
        print(e.toString());
        return Response.internalServerError();
      }
    }

    router.post('/', addGame);
    router.get('/', allGames);
    router.get('/<game>', singleGame);
    router.post('/<game>/reviews', addReview);
    router.get('/<game>/reviews', viewReviews);
    // Pipeline to handle some of the methods with authorization of being logined in
    final handler =
        Pipeline().addMiddleware(checkAuthorisation()).addHandler(router);
    return handler;
  }
}
