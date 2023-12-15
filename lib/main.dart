import 'package:absen_kantor/ui/LoginPage.dart';
import 'package:absen_kantor/ui/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:absen_kantor/ui/home.dart';
import 'package:absen_kantor/ui/homeAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'material/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Map<String, String>>(
        // Membaca token dan user key dari FlutterSecureStorage
        future: _readKeys(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Jika token dan user key sudah ada, membaca nilainya
            if (snapshot.hasData && snapshot.data != null) {
              Map<String, String> values = snapshot.data ?? {};

              String allValue = values['all'] ?? '';
              String statusPage = values['statusPage'] ?? '';
              int angkaStatusPage = 0;

              if (statusPage != "login" && statusPage != "register") {
                angkaStatusPage =
                    statusPage.isNotEmpty ? int.parse(statusPage) : 0;
              }

              String token = "";
              String mUserId = "";
              if (allValue != '') {
                List<String> valueSplit = allValue.split(',');
                token = valueSplit[0];
                mUserId = valueSplit[1];
              }

              // Logika navigasi berdasarkan token dan mUserId
              Widget destinationPage;
              if (token.isNotEmpty && mUserId.isNotEmpty) {
                if (values['role'] == 'ADMIN') {
                  destinationPage = HomePageAuth(
                    muserId: mUserId,
                    selectMenuIndex: angkaStatusPage,
                  );
                } else {
                  destinationPage = HomePageAuth(
                    muserId: mUserId,
                    selectMenuIndex: angkaStatusPage,
                  );
                }
              } else if (statusPage == "login") {
                destinationPage = LoginPage();
              } else if (statusPage == "register") {
                destinationPage = RegisterPage();
              } else {
                destinationPage = HomePage();
              }

              return Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => destinationPage,
                  );
                },
              );
            } else {
              // Jika token atau user key belum ada, navigasi ke halaman home
              return Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => HomePage(),
                  );
                },
              );
            }
          } else {
            // Tampilkan loader atau widget lain selama pemeriksaan token berlangsung
            return CircularProgressIndicator();
          }
        },
      ),
      theme: ThemeData(
        primarySwatch: greengood,
      ),
    );
  }

  Future<Map<String, String>> _readKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String all = prefs.getString('all') ?? '';
    String statusPage = prefs.getString('statusPage') ?? '';

    Map<String, String> result = {'all': all, 'statusPage': statusPage};

    return result;
  }
}
