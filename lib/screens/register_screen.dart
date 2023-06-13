
import 'package:app_tfg_mlr/models/user.dart';
import 'package:app_tfg_mlr/screens/screens.dart';
import 'package:flutter/material.dart';

import '../services/mysql.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    var db = Mysql();
    String username = '';
    String passwd = '';
    String checkPasswd = '';
    String firstname = '';
    String lastname = '';
    String age = '';
    String email = '';

    _registerUser(String username, String passwd, String firstname, String lastname, int age,  String email) async {
    db.getConnection().then((conn) {
      String sql = 'INSERT INTO users VALUES (?, ?, ?, ?, ?, ?);';
      conn.query(sql, [username, passwd, firstname, lastname, age, email],).whenComplete(() => conn.close()).whenComplete(() => conn.close());       
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(1500),
                  child: Image.asset(
                    'assets/loading-gif.gif',
                    fit: BoxFit.cover,
                    width: 150,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: InputDecoration(hintText: 'Nombre de usuario'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La longitud no es válida';
                    }

                    if (value.length > 20) {
                      return 'La longitud no puede ser mayor a 20';
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onChanged: (value) {
                    firstname = value;
                  },
                  decoration: InputDecoration(hintText: 'Nombre'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La longitud no es válida';
                    }

                    if (value.length > 20) {
                      return 'La longitud no puede ser mayor a 20';
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onChanged: (value) {
                    lastname = value;
                  },
                  decoration: InputDecoration(hintText: 'Apellidos'),
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
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'ejemplo@gmail.com',
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = new RegExp(pattern);

                    return regExp.hasMatch(value ?? '')
                        ? null
                        : 'El email no es válido';
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    age = value;
                  },
                  decoration: InputDecoration(hintText: 'Edad'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La edad no es válida';
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: '*****',
                    labelText: 'Contraseña',
                  ),
                  onChanged: (value) {
                    passwd = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La contraseña no es válida';
                    } else if (value.length < 4) {
                      return 'La longitud mínima es de 4 caracteres';
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: '*****',
                    labelText: 'Repetir Contraseña',
                  ),
                  onChanged: (value) {
                    checkPasswd = value;
                  },
                  validator: (value) {
                    if (value != passwd) {
                      return 'Las contraseñas no coinciden';
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
                    _registerUser(username, passwd, firstname, lastname, int.parse(age), email).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const SizedBox(
                      width: double.infinity,
                      child: Center(child: Text('Registrarse'))),
                ),
              ],
            )),
      ),
    );
  }
}
