import 'dart:async';

import 'package:app_tfg_mlr/services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
      title: 'Location Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Location Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _latitude = "";
  var _longitude = "";
  var _distanceInMeters = "";
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
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
    double distanceInMeters = await Geolocator.distanceBetween(pos.latitude, pos.longitude, 37.205179, -3.5960214);
    setState(() {
      _latitude = pos.latitude.toString();
      _longitude = pos.longitude.toString();
      _distanceInMeters = distanceInMeters.toString();
    });
    if(distanceInMeters < 155){
      await NotificationService.showNotification(
        title: "Título",
        body: "Cuerpo",
        summary: "summary",
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: "https://i.kym-cdn.com/entries/icons/original/000/026/489/crying.jpg",
      );
    }
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Latitude: " + _latitude,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "Longitude: " + _longitude,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "Distance to objective: " + _distanceInMeters,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
