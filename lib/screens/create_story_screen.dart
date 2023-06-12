import 'package:app_tfg_mlr/main.dart';
import 'package:app_tfg_mlr/models/user.dart';
import 'package:app_tfg_mlr/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/mysql.dart';

class CreateStoryScreen extends StatelessWidget {
  const CreateStoryScreen({Key? key, required this.user,}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    var db = Mysql();
    String title = '';
    String body = '';
    double latitude;
    double longitude;


  _registerStory(double latitude, double longitude, String title, String body, String username) async {
    db.getConnection().then((conn) {
      String sql = 'INSERT INTO stories VALUES (NULL, ?, ?, 100, ?, "User Story", ?, 0, 0, ?);';
      conn.query(sql, [latitude, longitude, title, body, username],).whenComplete(() => conn.close()); 
    });
  }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_circle_left),
            color: Colors.black87,
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
        backgroundColor: Colors.white,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: InputDecoration(hintText: 'Título de la historia o nombre del lugar'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La longitud no es válida';
                    }

                    if (value.length > 80) {
                      return 'La longitud no puede ser mayor a 80';
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    body = value;
                  },
                  decoration: InputDecoration(hintText: 'Escribe aquí la historia'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El texto no puede estar vacío.';
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () async {
                    if (formKey.currentState?.validate() == false) return;
                    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude;
                    longitude = position.longitude;
                    _registerStory(latitude, longitude, title, body, user.username);

                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                      width: double.infinity,
                      child: Center(child: Text('Publicar Historia'))),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text('Nota: la operación puede tardar unos segundos')
              ],
            )),
      ),
    );
  }
}
