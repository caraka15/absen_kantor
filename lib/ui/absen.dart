import 'package:absen_kantor/material/widgetLogout.dart';
import 'package:absen_kantor/ui/homeAuth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AbsenPage extends StatefulWidget {
  final String muserId;

  const AbsenPage({Key? key, required this.muserId}) : super(key: key);

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  late Future<Map<String, dynamic>> userData;
  late Future<Map<String, dynamic>> currentTime;
  bool isAbsenMasukEnabled = false;
  bool isAbsenKeluarEnabled = false;

  @override
  void initState() {
    super.initState();
    userData = _fetchUserData();
    currentTime = _fetchCurrentTime();
    _initializeStatusPage();
    _fetchStatusAbsenMasuk();
    _fetchStatusAbsenKeluar();
  }

  Future<void> _initializeStatusPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('statusPage', '0');
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final response = await http.get(
      Uri.parse('http://123.100.226.157:8282/user/getByOne/${widget.muserId}'),
    );
    print('Masuk Absen Berapa Kali');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>?> _fetchStatusAbsenMasuk() async {

    String api = 'http://123.100.226.157:8282/absen/cekStatus?mUserId=${widget.muserId}&tipe=';

    // Cek Absen Masuk
    final responseAbsenMasuk = await http.get(
      Uri.parse(api + 'MASUK'),
    );

    if (responseAbsenMasuk.statusCode == 200) {
      final bodyJson = json.decode(responseAbsenMasuk.body);
      String message = bodyJson['message'];
      print('$message :Pesan');

      if (message == "BELUM") {
        isAbsenMasukEnabled = true;
      } else if (message == "SUDAH") {
        isAbsenMasukEnabled = false;
      }

      } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>?> _fetchStatusAbsenKeluar() async {

    String api = 'http://123.100.226.157:8282/absen/cekStatus?mUserId=${widget.muserId}&tipe=';

    // Cek Absen Keluar
    final responseAbsenKeluar = await http.get(
      Uri.parse(api + 'KELUAR'),
    );

    if (responseAbsenKeluar.statusCode == 200) {

      final bodyJson = json.decode(responseAbsenKeluar.body);
      String message = bodyJson['message'];

      if(message == "BELUM"){
        print('$message :Pesan');
        isAbsenKeluarEnabled = true;
      } else if (message == "SUDAH"){

        isAbsenKeluarEnabled = false;
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> _fetchCurrentTime() async {
    final response = await http.get(
      Uri.parse('http://worldtimeapi.org/api/ip'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current time');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Absensi Kantor"),
        actions: [
          // Tombol Logout di AppBar
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              LogoutHandler.showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: userData,
                builder: (context, snapshotUser) {
                  if (snapshotUser.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshotUser.hasError) {
                    return Text('Error: ${snapshotUser.error}');
                  } else {
                    final user = snapshotUser.data!['data'];
                    return FutureBuilder<Map<String, dynamic>>(
                      future: currentTime,
                      builder: (context, snapshotTime) {
                        if (snapshotTime.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshotTime.hasError) {
                          return Text('Error: ${snapshotTime.error}');
                        } else {
                          final time = DateTime.parse(
                              snapshotTime.data!['utc_datetime']);
                          final formattedDate = "${time.day.toString()} "
                              "${_getMonthName(time.month)} "
                              "${time.year}";

                          final formattedTime =
                              "${time.hour.toString().padLeft(2, '0')}:"
                              "${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";

                          return Column(
                            children: [
                              Text(
                                "Hello, ${user['nama']}",
                                style: TextStyle(fontSize: 32),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 67, 155, 146),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "08.00",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "MASUK",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                              width:
                                                  20), // Jarak antara masuk dan keluar
                                          Column(
                                            children: [
                                              Text(
                                                "16.00",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "KELUAR",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Buttons for Absen Masuk and Absen Keluar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: isAbsenMasukEnabled
                                        ? () async {
                                      await _absen(
                                        widget.muserId,
                                        "MASUK"
                                      );
                                    } : null,
                                    style: ElevatedButton.styleFrom(
                                      primary: isAbsenMasukEnabled ? Colors.green : Colors.grey,
                                    ),
                                    child: Text("Absen Masuk"),
                                  ),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: isAbsenKeluarEnabled
                                        ? () {} : null,
                                    style: ElevatedButton.styleFrom(
                                      primary: isAbsenKeluarEnabled ? Colors.green : Colors.grey,
                                    ),
                                    child: Text("Absen Keluar"),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _absen(String mUserId, String tipe) async {
    try {
      final response = await http.post(
        Uri.parse('http://123.100.226.157:8282/absen/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'muserId': mUserId,
            'tipe': tipe,
          },
        ),
      );

      final bodyJson = json.decode(response.body);

      bool status = bodyJson['status'];
      String messageError = bodyJson['message'];
      if (status == true) {

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePageAuth(muserId: widget.muserId, selectMenuIndex: 0),
            ),
          );

      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Absen Gagal'),
              content: Text(messageError),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      throw error;
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }
}
