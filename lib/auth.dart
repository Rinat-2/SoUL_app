//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:ui/screens/welcome_screen.dart';
import 'package:ui/services/settings.dart';

import 'services/auth.dart';
import 'user.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return Padding(
        padding: EdgeInsets.all(100),
        child: Container(
          child: Align(
            child: Row(
              children: [
                Icon(
                  Icons.school,
                  color: Colors.grey,
                  size: 50,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "SoUL",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obscure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white30,
              ),
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 3),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54, width: 1),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: IconTheme(
                    data: IconThemeData(color: Colors.white), child: icon),
              )),
        ),
      );
    }

    Widget _button(String text, void func()) {
      return RaisedButton(
        splashColor: Colors.red,
        highlightColor: Colors.red,
        color: Colors.white,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 20,
          ),
        ),
        onPressed: () {
          func();
        },
      );
    }

    Widget _signInButton() {
      return OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          _authService.googleSignIn().then((user) {
            if (user != null) {
              //найти способ отличить авторизированного юзера по gmail, вместо это костыля
              SettingsController().init().then((settings) => settings
                  .authWithGmail(true)
                  .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WelcomeScreen()))));
            } else {
              print("Auth error");
            }
          }).catchError((error) {
            print(error);
            _authService.logOut();
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget _form(String label, void func()) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child:
                  _input(Icon(Icons.email), "EMAIL", _emailController, false),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: _input(
                  Icon(Icons.lock), "PASSWORD", _passwordController, true),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: _button(label, func),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            _signInButton()
          ],
        ),
      );
    }

    void _loginUser() async {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) return;

      User user = await _authService.signInWithEmailAndPassword(
          _email.trim(), _password.trim());
      if (user == null) {
        Fluttertoast.showToast(
            msg: "Проблема входа, пожалуйста проверьте логин или пароль",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _passwordController.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          _logo(),
          _form(
            'Войти',
            _loginUser,
          )
        ],
      ),
    );
  }
}
