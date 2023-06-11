import 'package:app_tfg_mlr/main.dart';
import 'package:app_tfg_mlr/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/user.dart';
import '../services/mysql.dart';
import '../themes/app_themes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  var db = Mysql();
  String email = '';
  String passwd = '';

  _checkUserLogin(String email, String passwd) async {
    List<User> userList = [];
    db.getConnection().then((conn) {
      String sql = 'SELECT * FROM users WHERE email = ? AND passwd = ?;';
      conn.query(sql, [email, passwd],).then((results){
        for(var row in results){
          userList.add(
            User(username: row[0], passwd: row[1], firstname: row[2], lastname: row[3], age: row[4], email: row[5])
          );
          print(userList[0].username);
          if(userList.isNotEmpty){
            final route = MaterialPageRoute(
                  builder: (context) =>
                    MyHomePage(title: "Cicerone", user: userList[0],));
                    Navigator.pushReplacement(context, route);
          } else {
            alertaCoincidencia(context);
          }
        }
      });
    });
  }

    return Scaffold
    (
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'ejemplo@gmail.com',
                    labelText: 'Email',
                  ),
                  onChanged: (value) => email = value,
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = RegExp(pattern);
    
                    return regExp.hasMatch(value ?? '')
                        ? null
                        : 'El email no es válido';
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
                    labelText: 'Contraseña',
                  ),
                  onChanged: (value) => passwd = value,
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
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    disabledColor: Colors.grey,
                    elevation: 0,
                    color: AppThemes.primary,
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(color: Colors.white),
                        )),
                    onPressed: () async {
    
                            if (formKey.currentState?.validate() == false) {
                              alertaCoincidencia(context);
                            } else {
                              return _checkUserLogin(email, passwd);
                            }
                              
                          }),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    final route = MaterialPageRoute(
                        builder: (context) => const RegisterScreen());
                    Navigator.push(context, route);
                  },
                  child: Container(
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text(
                        '¿No tienes una cuenta?',
                        style: TextStyle(decoration: TextDecoration.underline),
                      )),
                ),
              ],
            )),
      ),
    );
  }
}

void alertaCoincidencia(BuildContext context) {
  showDialog(
      barrierDismissible: false, // Nos permite pulsar fuera de la alerta
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text('¡Atención!'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'El email o la contraseña son incorrectos',
                style: TextStyle(fontSize: 20)
                ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'))
          ],
        );
      }));
}
