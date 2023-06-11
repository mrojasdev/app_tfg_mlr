import 'dart:async';

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
  //List<Place> currentPlaces = [];

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

  var _latitude = "";
  var _longitude = "";
  var _distanceInMeters = "";
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getPlaceNotificationInfo();
    _startLocationUpdates();

    this.screens = [
      PlacesVisitedScreen(user: widget.user,),
      StoriesCollectedScreen(user: widget.user,),
      AchievementsScreen(),
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
    List<Placemark> pm = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    //currentPlaces = 
    double distanceInMeters = await Geolocator.distanceBetween(pos.latitude, pos.longitude, 37.241263573, -3.560461439);
    setState(() {
      _latitude = pos.latitude.toString();
      _longitude = pos.longitude.toString();
      _distanceInMeters = distanceInMeters.toString();
    });
    if(distanceInMeters < 155){
      await NotificationService.showNotification(
        title: placename,
        body: detail,
        summary: "summary",
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: image,
        largeIcon: image,
      );
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
                    Navigator.pushReplacement(context, route);
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
