/// File handling all the requests related to the database of anything related
/// to games
import 'package:mysql1/mysql1.dart';

import '../database/connection.dart';

class GamesModel {
  /// Fetching all the games from the database for display
  /// Returns [games] of type MAP back to the route
  /// Catches unknown errors related to MySQL
  allGames() async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      var results = await conn.query(
          'select id_game, game_name, cover, year, file_name from games');
      Map<String, Map> games = {};
      // Adding all the values in a MAP inside the MAP with the name of the game
      // being the key of each new game entry to the map
      // row[x] represents the selected values from the query for each iteration
      for (var row in results) {
        games["${row[1]}"] = {};
        games["${row[1]}"].addAll({
          "id_game": row[0],
          "name": row[1],
          "cover": row[2].toString(),
          "year": row[3],
          "file_name": row[4]
        });
      }
      conn.close();
      return games;
    } catch (e) {
      print(e.toString());
      return 'ERROR DB: $e';
    }
  }

  /// Fetches a single game from the database of [name]
  /// Returns a LIST of [gameInfo, statusCode] or [message, statusCode]
  /// based of the SQL query outcome
  singleGame(String name) async {
    try {
      var db = Mysql();
      String date;
      int idUser;
      Map<String, dynamic> gameInfo = {};
      dynamic conn = await db.getConnection();
      var result = await conn.query(
          'select cover, year, publisher, description, upload_date_time, id_user from games where game_name = ?',
          [name]);
      // Checking if its empty it means there was not a match
      if (!result.isEmpty) {
        for (var row in result) {
          date = row[4].toString();
          // Fixing the date to the requirments of the client
          date = date.substring(0, 10);
          idUser = row[5];
          gameInfo.addAll({
            "name": name,
            "cover": row[0].toString(),
            "publisher": row[2],
            "year": row[1],
            "description": row[3],
            "date": date
          });
        }
        // Once ID of the user is fetched getting the name of the user who
        // uploaded the game
        result = await conn
            .query('select username from users where id = ?', [idUser]);
        for (var row in result) {
          gameInfo.addAll({"uploader": row[0]});
        }

        conn.close();
        return [gameInfo, 200];
      } else {
        conn.close();
        return [
          {'message': 'Game not found'},
          404
        ];
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  /// Adding a new game by [name], [publisher], [cover], [description], [year]
  /// and [userID]
  /// MYSQLExpection on an duplicated entry of the same game returns MAP of [message] and [error]
  /// Returns MAP [info] of the added game
  add(String name, String publisher, String cover, String description, int year,
      int userID, String fileName) async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      await conn.query(
          'INSERT INTO games (game_name, cover, publisher, year, description, upload_date_time, id_user, file_name) VALUES(?,?,?,?,?,NOW(),?,?)',
          [name, cover, publisher, year, description, userID, fileName]);
      // Fetching the username of who added it
      var result =
          await conn.query('select username from users where id=?', [userID]);
      var addedBy;
      for (var row in result) {
        addedBy = row[0];
      }
      // Fetching the added game so it can be returned back as response
      result =
          await conn.query('select * from games where game_name=?', [name]);
      Map<String, dynamic> info = {};
      for (var row in result) {
        String date = row[6].toString();
        date = date.substring(0, 16);
        info.addAll({
          'message': 'Game sucessfully added',
          'id': row[0],
          'name': row[1],
          'cover': row[2].toString(),
          'publisher': row[3],
          'year': row[4],
          'description': row[5],
          'added': date,
          'addedBy': addedBy,
          'statusCode': 201
        });
      }
      conn.close();
      return info;
    } on MySqlException catch (e) {
      if (e.errorNumber == 1062) {
        print(e.errorNumber);
        return ({'message': 'ERROR: Game already exists', 'statusCode': 200});
      }
    }
  }

  /// Adding a new review of game of MAP [data]
  ///MYSQLExpection on a duplicated review entry of the same user on the same game return MAP [message], [statusCode]
  ///Return MAP [data] of the new review
  addReview(Map<String, dynamic> data) async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      // Fetcing the username of who added the review based on ID
      var result = await conn
          .query('select username from users where id = ?', [data['userID']]);
      String username;
      for (var row in result) {
        username = row[0];
      }
      // Fetching the id of the game that is being reviewed
      result = await conn.query(
          'select id_game from games where game_name = ? ', [data["name"]]);
      int gameID;
      for (var row in result) {
        gameID = row[0];
      }
      // Inserting to the database the review of the game
      result = await conn.query(
          'insert into reviews (id_game, rate, reviewer_nick ,id_reviewer, review_date, description) VALUES(?,?,?,?,NOW(),?)',
          [
            gameID,
            data['rate'],
            username,
            data['userID'],
            data['description']
          ]);
      // Fetching the new entry record to be return as a Response
      result = await conn.query(
          'select review_date, id_review  from reviews where id_reviewer = ?',
          [data['userID']]);
      for (var row in result) {
        var date = row[0].toString();
        date = date.substring(0, 16);
        data.addAll({
          "reviewer": username,
          "at": date,
          "reviewID": row[1],
          "message": "Review ceated!",
          "statusCode": 201
        });
      }

      conn.close();
      return data;
    } on MySqlException catch (e) {
      if (e.errorNumber == 1062) {
        print(e.errorNumber);
        return ({
          'message': 'ERROR: Already added review for this game.',
          'statusCode': 200
        });
      }
    }
  }

  /// Fetching all reviews of a game by [name]
  /// MySqlException when a game is not found returns LIST [message,status]
  /// Returns LIST of the [reviews] and [statusCode]
  allReviews(String name) async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      // Fetching the ID of the game
      var result = await conn
          .query('select id_game from games where game_name = ?', [name]);
      int idGame;
      for (var row in result) {
        idGame = row[0];
      }
      // Fetching all the reviews of the game based on [idGame]
      result = await conn.query(
          'select id_review, rate, reviewer_nick, review_date, description from reviews where id_game = ?',
          [idGame]);
      if (!result.isEmpty) {
        Map<String, Map> reviews = {};
        // Inserting each review in the map
        for (var row in result) {
          String date = row[3].toString();
          date = date.substring(0, 16);
          reviews["${row[0]}"] = {};
          reviews["${row[0]}"].addAll({
            "rating": row[1],
            "reviewer": row[2],
            "date": date,
            "review": row[4].toString(),
          });
        }

        conn.close();
        return [reviews, 200];
      } else {
        conn.close();
        return [
          {'message': 'Game not found'},
          404
        ];
      }
    } on MySqlException catch (e) {
      print("ERROR IN MYSQL");
      print(e.message);
      if (e.errorNumber == 1054) {
        print(e.message);
        return [
          {'message': 'Game not found'},
          404
        ];
      }
    } catch (e) {
      print(e.toString());
      return 'ERROR DB: $e';
    }
  }
}
