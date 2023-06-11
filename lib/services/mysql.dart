import 'package:mysql1/mysql1.dart';

import '../models/place.dart';

class Mysql {
  static String host = 'sql7.freesqldatabase.com',
                user = 'sql7624523',
                password = 'G8nUkci4cx',
                db = 'sql7624523';
  static int port  = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db
    );
    return await MySqlConnection.connect(settings);
  }

  Future<List<Place>> getPlaceInfo() async{
    List<Place> placesList = [];
    getConnection().then((conn) {
      String sql = 'select * from places;';
      conn.query(sql).then((results){
        for(var row in results){
          placesList.add(
            Place(id: row[0], latitude: row[1], longitude: row[2], radius: row[3], title: row[4], detail: row[5], body: row[6].toString(), image: row[7], city: row[8])
          );
          print(placesList[0].body);
        }
      });
      conn.close();
    });
    return placesList;
  }
/*
  Future<List<Place>> getCurrentPlaces(double ) async{
  List<Place> placesList = [];
  getConnection().then((conn) {
    String sql = 'select * from places;';
    conn.query(sql).then((results){
      for(var row in results){
        placesList.add(
          Place(id: row[0], latitude: row[1], longitude: row[2], radius: row[3], title: row[4], detail: row[5], body: row[6].toString(), image: row[7], city: row[8])
        );
        print(placesList[0].body);
      }
    });
    conn.close();
  });
  return placesList;
}
*/
}