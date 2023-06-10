import 'package:app_tfg_mlr/models/place.dart';
import 'package:app_tfg_mlr/screens/details_screen.dart';
import 'package:flutter/material.dart';

import '../services/mysql.dart';

class PlacesVisitedScreen extends StatefulWidget {
  const PlacesVisitedScreen({super.key});

  @override
  State<PlacesVisitedScreen> createState() => _PlacesVisitedScreenState();
}

class _PlacesVisitedScreenState extends State<PlacesVisitedScreen> {
  var db = Mysql();
  List<Place> placeList = [];

  _getPlaceInfo() {
    List<Place> placesList = [];
    db.getConnection().then((conn) {
      String sql = 'select * from user_place where username = "mrojasdev";';
      conn.query(sql).then((results){
        for(var row in results){
          placesList.add(
            Place(id: row[0], latitude: row[1], longitude: row[2], radius: row[3], title: row[4], detail: row[5], body: row[6].toString(), image: row[7], city: row[8])
          );
          setState(() {
            placeList = placesList;
          });
          print(placesList[0].body);
        }
      });
      conn.close();
    });
  }
  


  @override
  Widget build(BuildContext context) {
    _getPlaceInfo();
    return Container(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: ListView.builder(
          itemCount: placeList.length,
          itemBuilder: (BuildContext context, int index){
            final place = placeList[index]; // TODO: Change the variable to the list of places retrieved from the database
            return Container(
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Ink.image(
                          image: NetworkImage(
                            place.image
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(place: place)));
                            },
                          ),
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          place.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
      
    );
  }
}


