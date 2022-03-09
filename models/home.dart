import "../database/connection.dart";

class HomeModel {
  allGames() async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      var results =
          await conn.query('select id_game, game_name, cover, year from games');
      Map<String, Map> games = Map();
      for (var row in results) {
        games["${row[1]}"] = Map();
        games["${row[1]}"].addAll({
          "id_game": row[0],
          "name": row[1],
          "cover": row[2].toString(),
          "year": row[3]
        });
      }
      return games;
    } catch (e) {
      print(e);
      return e;
    }
  }

  singleGame(String name) async {
    try {
      print("I AM THE NAME");
      print(name);
      var db = Mysql();
      String date;
      int idUser;
      Map<String, dynamic> gameInfo = {};
      dynamic conn = await db.getConnection();
      var result = await conn.query(
          'select cover, year, publisher, description, upload_date_time, id_user from games where game_name = ?',
          [name]);
      for (var row in result) {
        date = row[4].toString();
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
      result =
          await conn.query('select username from users where id = ?', [idUser]);
      for (var row in result) {
        gameInfo.addAll({"uploader": row[0]});
      }

      conn.close();
      return gameInfo;
    } catch (e) {
      print(e);
      return e;
    }
  }
}
