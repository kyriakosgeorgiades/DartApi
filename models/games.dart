import '../database/connection.dart';

class GamesModel {
  add(String name, String publisher, String cover, String description, int year,
      int userID) async {
    try {
      var db = Mysql();
      dynamic conn = await db.getConnection();
      await conn.query(
          'INSERT INTO games (game_name, cover, publisher, year, description, upload_date_time, id_user) VALUES(?,?,?,?,?,NOW(),?)',
          [name, cover, publisher, year, description, userID]);
      var result =
          await conn.query('select username from users where id=?', [userID]);
      var addedBy;
      for (var row in result) {
        addedBy = row[0];
      }
      print("USER ID ADDED BY");
      print(addedBy);
      result =
          await conn.query('select * from games where game_name=?', [name]);
      List<dynamic> info = [];
      info.clear();
      for (var row in result) {
        info.add(row[0]);
        info.add(row[1]);
        info.add(row[2]);
        info.add(row[3]);
        info.add(row[4]);
        info.add(row[5]);
        info.add(row[6]);
      }

      info.add(addedBy);
      print("I AM INFO LIST STILL");
      print(info);
      print("END");

      conn.close();
      return info;
    } catch (e) {
      print(e);
      return e;
    }
  }
}
