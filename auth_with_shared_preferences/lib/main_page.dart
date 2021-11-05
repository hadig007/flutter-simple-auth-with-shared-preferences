import 'package:auth_with_shared_preferences/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  // const MainPage({Key? key}) : super(key: key);


  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String token = '';
  void ceklogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = (await pref.getString("login"))!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ceklogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                onSelected: (int select) async{
                  print(select);
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.clear();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => HomePage()));
                },
                itemBuilder: (_) =>
                    [PopupMenuItem(value: 1, child: Text("  Logout"))])
          ],
          title: Text("Main Page"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hi, ${token}, selamat datang"),
              Text("token : ${token}"),
            ],
          ),
        ),
      ),
    );
  }
}
