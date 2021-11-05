import 'dart:convert';

import 'package:auth_with_shared_preferences/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _emailController = TextEditingController();

  var _passwordController = TextEditingController();

  var login = false;
  var nama = '';
  var token = '';

@override
  void initState() {
    super.initState();
    cekToken();
  }

  void cekToken()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String val = await pref.getString("login")!;
    // ignore: unnecessary_null_comparison
    if (val != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>MainPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.email),
                labelText: "Email",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.lock),
                labelText: "Password",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
              onPressed: () {
                masuk();
              },
              icon: Icon(Icons.login),
              label: login ? Text("Loading...") : Text("Login"),
            )
          ],
        ),
      )),
    );
  }

  void masuk() async {
    login = true;
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("http://192.168.1.7:8000/api/login"),
          body: ({
            'email': _emailController.text,
            'password': _passwordController.text
          }));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("berhasil login dengan nama : ${data['name']}" );
        nama = data['name'];
        print(response.body.toString());
        cekTokens(data['name']);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
        login = false;
      } else {
        print(response.body.toString());
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Akun yand anda masukkan tidak terdaftar")));
        login = false;
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email dan Password kosong")));
      login = false;
    }
    setState(() {
      
    });
  }
  void cekTokens(String token) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("login", token);
  }
}
