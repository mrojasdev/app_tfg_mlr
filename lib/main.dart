import 'dart:async';

import 'package:app_tfg_mlr/models/story.dart';
import 'package:app_tfg_mlr/screens/create_story_screen.dart';
import 'package:app_tfg_mlr/screens/screens.dart';
import 'package:app_tfg_mlr/services/mysql.dart';
import 'package:app_tfg_mlr/services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'models/place.dart';
import 'models/user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cicerone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.user});

  final String title;
  final User user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final db = Mysql();
  var placename = '';
  var detail = '';
  var image = '';
  List<Widget> screens = [];
  List<Place> currentPlaces = [];
  List<Story> currentStories = [];

  void _getPlaceNotificationInfo(){
    db.getConnection().then((conn) {
      String sql = 'select title, detail, image from places where id = 1;';
      conn.query(sql).then((results){
        for(var row in results){
          setState(() {
            placename = row[0];
            detail = row[1];
            image = row[2];
          });
        }
      });
      conn.close();
    });
  }

  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getPlaceNotificationInfo();
    _startLocationUpdates();

    this.screens = [
      PlacesVisitedScreen(user: widget.user,),
      StoriesCollectedScreen(user: widget.user,),
      AchievementsScreen(user: widget.user,),
      ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _stopLocationUpdates();
    super.dispose();
  }

  Future<void> _startLocationUpdates() async {

    _positionStreamSubscription = Geolocator.getPositionStream(
    ).listen((position) {
      _updatePosition(position);
    });
  }

  void _stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
  }

  Future<void> _updatePosition(Position pos) async {
    _receiveClosePlaces(pos.latitude, pos.longitude);
    _receiveCloseStories(pos.latitude, pos.longitude);
    //print(currentPlaces);
    //print(currentStories);
    currentPlaces.forEach((element) async {
      double distanceInMeters = await Geolocator.distanceBetween(pos.latitude, pos.longitude, element.latitude, element.longitude);
      if(distanceInMeters < element.radius){
        _addPlaceToUser(element, widget.user.username);
      }
    });
    currentStories.forEach((story) async {
      double distanceInMeters = await Geolocator.distanceBetween(pos.latitude, pos.longitude, story.latitude, story.longitude);
      if(distanceInMeters < story.radius){
        _addStoryToUser(story, widget.user.username);
      }
    });
    
  }

  _receiveClosePlaces(double latitude, double longitude) {
    List<Place> placesList = [];
    db.getConnection().then((conn) {
      String sql = 'SELECT * FROM places WHERE (longitude BETWEEN (? - 0.0500) AND (? + 0.0500)) AND (latitude BETWEEN (? - 0.0500) AND (? + 0.0500)) AND id NOT IN ( SELECT place_id FROM user_place WHERE username = ? );';
      conn.query(sql, [longitude, longitude, latitude, latitude, widget.user.username]).then((results){
        for(var row in results){
          placesList.add(
            Place(id: row[0], latitude: row[1], longitude: row[2], radius: row[3], title: row[4], detail: row[5], body: row[6].toString(), image: row[7], city: row[8])
          );
          setState(() {
            currentPlaces = placesList;
          });
        }
      }).whenComplete(() => conn.close());
    });
  }

  _receiveCloseStories(double latitude, double longitude) {
    List<Story> storiesList = [];
    db.getConnection().then((conn) {
      String sql = 'SELECT * FROM stories WHERE (longitude BETWEEN (? - 0.0500) AND (? + 0.0500)) AND (latitude BETWEEN (? - 0.0500) AND (? + 0.0500)) AND id NOT IN ( SELECT story_id FROM user_story WHERE username = ? );';
      conn.query(sql, [longitude, longitude, latitude, latitude, widget.user.username]).then((results){
        for(var row in results){
          storiesList.add(
            Story(id: row[0], latitude: row[1], longitude: row[2], radius: row[3], title: row[4], detail: row[5], body: row[6].toString(), views: row[7], likes: row[8], username: row[9])
          );
          setState(() {
            currentStories = storiesList;
          });
        }
      }).whenComplete(() => conn.close());
    });
  }
  
  _addPlaceToUser(Place place, String username) {
    try{
      bool isPlaceAdded = false;
      db.getConnection().then((conn) {
        String sql = 'SELECT * FROM user_place WHERE (username = ? AND place_id = ?);';
        conn.query(sql, [widget.user.username, place.id]).then((results){
          for(var row in results){
            isPlaceAdded = true;
          }
        }).whenComplete((){
          conn.close();
          if(!isPlaceAdded){
            db.getConnection().then((conn) {
              String sql = 'INSERT INTO user_place VALUES (?, ?, ?);';
              conn.query(sql, [widget.user.username, place.id, DateTime.now().toUtc()],).whenComplete(() => conn.close()); 
              NotificationService.showNotification(
                title: place.title,
                body: place.detail,
                notificationLayout: NotificationLayout.BigPicture,
                bigPicture: place.image,
                largeIcon: place.image,
            );
            });
          }
        });
      });

    }catch(e){
      print(e);
      return;
    }
  }

  _addStoryToUser(Story story, String username) {
    try{
      bool isStoryAdded = false;
      db.getConnection().then((conn) {
        String sql = 'SELECT * FROM user_story WHERE (username = ? AND story_id = ?);';
        conn.query(sql, [widget.user.username, story.id]).then((results){
          for(var row in results){
            isStoryAdded = true;
          }
        }).whenComplete((){
          conn.close();
          if(!isStoryAdded){
            db.getConnection().then((conn) {
              String sql = 'INSERT INTO user_story VALUES (?, ?, ?, 0);';
              conn.query(sql, [widget.user.username, story.id, DateTime.now().toUtc()],).whenComplete(() => conn.close()); 
              NotificationService.showNotification(
                title: "Historia Recogida: "+story.title,
                body: story.body,
                notificationLayout: NotificationLayout.BigText,
            );
            });
          }
        });
      });

    }catch(e){
      print(e);
      return;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      appBar: AppBar(
        title: Text(
          'Cicerone',
          style: TextStyle(
            fontFamily: 'KaushanScript',
            fontWeight: FontWeight.w500
          ),
        ),
        elevation: 1.5,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,

        actions: [
          IconButton(
            onPressed: () {
               final route = MaterialPageRoute(
                  builder: (context) =>
                    CreateStoryScreen(user: widget.user,));
                    Navigator.push(context, route);
            },
            icon: Icon(Icons.add_location_alt_outlined)
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.black,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "Lugares",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            label: "Historias",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.military_tech_outlined),
            label: "Logros",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
