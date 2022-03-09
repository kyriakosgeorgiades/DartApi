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
          'addedBy': addedBy
        });
      }
      conn.close();
      return info;
    } catch (e) {
      print(e);
      return e;
    }
  }
}
