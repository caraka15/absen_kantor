import 'package:absen_kantor/material/color.dart';
import 'package:absen_kantor/material/widgetLogout.dart';
import 'package:absen_kantor/ui/homeAuth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AbsenPage extends StatefulWidget {
  final String muserId;

  const AbsenPage({Key? key, required this.muserId}) : super(key: key);

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class AbsenRecord {
  final String tanggal;
  final String absenMasuk;
  final String absenKeluar;

  AbsenRecord({
    required this.tanggal,
    required this.absenMasuk,
    required this.absenKeluar,
  });
}

class _AbsenPageState extends State<AbsenPage> {
  late Future<Map<String, dynamic>> userData;
  bool isAbsenMasukEnabled = false;
  bool isAbsenKeluarEnabled = false;
  List<AbsenRecord> absenRecords = [];

  @override
  void initState() {
    super.initState();
    userData = _fetchUserData();
    _initializeStatusPage();
    _fetchStatusAbsenMasuk();
    _fetchStatusAbsenKeluar();
    _getDataHistory();
  }

  Future<void> _initializeStatusPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('statusPage', '0');
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final response = await http.get(
      Uri.parse('http://123.100.226.157:8282/user/getByOne/${widget.muserId}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>?> _fetchStatus(String tipe) async {
    String api =
        'http://123.100.226.157:8282/absen/cekStatus?mUserId=${widget.muserId}&tipe=$tipe';

    final response = await http.get(
      Uri.parse(api),
    );

    if (response.statusCode == 200) {
      final bodyJson = json.decode(response.body);
      String message = bodyJson['message'];
      bool status = bodyJson['status'];

      return {
        'enabled': message == "BELUM",
        'status': status,
      };
    } else {
      print('Error: ${response.reasonPhrase}');
      return null;
    }
  }

  Future<void> _fetchStatusAbsenMasuk() async {
    final statusMasuk = await _fetchStatus('MASUK');

    if (statusMasuk != null) {
      setState(() {
        isAbsenMasukEnabled = statusMasuk['enabled'] ?? false;
      });

      // Jika sudah absen masuk, maka fetch status absen keluar
      if (!isAbsenMasukEnabled) {
        _fetchStatusAbsenKeluar();
      }
    }
  }

  Future<void> _fetchStatusAbsenKeluar() async {
    final statusKeluar = await _fetchStatus('KELUAR');

    if (statusKeluar != null) {
      setState(() {
        isAbsenKeluarEnabled = statusKeluar['enabled'] ?? false;
      });
    }
  }

  Future<void> _getDataHistory() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://123.100.226.157:8282/absen/getList?mUserId=${widget.muserId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        absenRecords.clear();

        String? jamMasuk;
        String? jamKeluar;
        String? tanggal;

        for (var item in data) {
          DateTime createdDateTime = DateTime.parse(item['created']);
          DateTime adjustedDateTime = createdDateTime.add(Duration(hours: 7));
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(adjustedDateTime);
          String formattedTime = DateFormat('HH:mm').format(adjustedDateTime);

          if (item['tipe'] == 'MASUK') {
            jamMasuk = formattedTime;
            tanggal = formattedDate;
          } else if (item['tipe'] == 'KELUAR') {
            jamKeluar = formattedTime;
            tanggal = formattedDate;
          }

          if (jamMasuk != null && jamKeluar != null && tanggal != null) {
            AbsenRecord absenRecord = AbsenRecord(
              tanggal: tanggal,
              absenMasuk: jamMasuk,
              absenKeluar: jamKeluar,
            );
            absenRecords.add(absenRecord);

            // Reset untuk absen selanjutnya
            jamMasuk = null;
            jamKeluar = null;
            tanggal = null;
          }
        }

        setState(() {});
      } else {
        print("Gagal mendapatkan data: ${response.statusCode}");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> _fetchCurrentTime() async {
    final response = await http.get(
      Uri.parse('http://worldtimeapi.org/api/ip'),
    );

    if (response.statusCode == 200) {
      final bodyJson = json.decode(response.body);
      DateTime utcTime = DateTime.parse(bodyJson['utc_datetime']);
      DateTime wibTime = utcTime.add(Duration(hours: 7));

      return {
        'utc_datetime': wibTime.toUtc().toIso8601String(),
      };
    } else {
      throw Exception('Failed to load current time');
    }
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
            builder: (context) => HomePageAuth(
              muserId: widget.muserId,
              selectMenuIndex: 0,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Absensi Kantor"),
        actions: [
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FutureBuilder<Map<String, dynamic>>(
                                  future: _fetchCurrentTime(),
                                  builder: (context, snapshotTime) {
                                    if (snapshotTime.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshotTime.hasError) {
                                      return Text(
                                          'Error: ${snapshotTime.error}');
                                    } else {
                                      final time = DateTime.parse(
                                          snapshotTime.data!['utc_datetime']);
                                      final formattedDate =
                                          "${time.day.toString()} "
                                          "${_getMonthName(time.month)} "
                                          "${time.year}";

                                      final formattedTime =
                                          "${time.hour.toString().padLeft(2, '0')}:"
                                          "${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";

                                      return Column(
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
                                                    absenRecords.isNotEmpty
                                                        ? absenRecords
                                                            .last.absenMasuk
                                                        : "08:00",
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
                                                width: 20,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    absenRecords.isNotEmpty
                                                        ? absenRecords
                                                            .last.absenKeluar
                                                        : "17:00",
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
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: isAbsenMasukEnabled,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _absen(widget.muserId, "MASUK");
                                  _fetchStatusAbsenMasuk(); // Perbarui status setelah absen masuk
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: greengood,
                                ),
                                child: Text("Absen Masuk"),
                              ),
                            ),
                            SizedBox(width: 20),
                            Visibility(
                              visible:
                                  !isAbsenMasukEnabled && isAbsenKeluarEnabled,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _absen(widget.muserId, "KELUAR");
                                  _fetchStatusAbsenKeluar(); // Perbarui status setelah absen keluar
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: greengood,
                                ),
                                child: Text("Absen Keluar"),
                              ),
                            ),
                            SizedBox(width: 20),
                            Visibility(
                              visible:
                                  !isAbsenMasukEnabled && !isAbsenKeluarEnabled,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Tambahkan fungsi untuk tombol "Sudah Absen" jika diperlukan
                                  // Contoh: Menampilkan pesan bahwa sudah absen
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Informasi'),
                                        content:
                                            Text('Anda sudah absen hari ini.'),
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
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                ),
                                child: Text("Sudah Absen"),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
