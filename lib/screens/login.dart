import 'package:flutter/material.dart';
import 'package:companion/screens/bottom_Nav.dart';


class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final email_Controller = TextEditingController();
  final password_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final logo = Hero(
      tag: 'hero',
      child:  
      CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/companion-01.png'),
      ),
    );

    final email = TextFormField(
      controller: email_Controller,
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: password_Controller,
      style: TextStyle(color: Colors.white),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          print(email_Controller.text);
          print(password_Controller.text);
          if (password_Controller.text=="mohamed1234" && email_Controller.text=="mohamed@gmail.com")
          {
            print("Wal33334444444444444444444444444");
            Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            // return new DataPage(data: 'Home');
            return PassDataToPagesBottomNav();
            }));
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body:  Stack(
        children: <Widget>[
          Center(
            child: new Image.asset('assets/background.png',
            width: size.width, height: size.height, fit: BoxFit.fill),
          ),
        Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
      ]
    ));
  }
}