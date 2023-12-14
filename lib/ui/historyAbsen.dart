import 'package:absen_kantor/material/widgetLogout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenRecord {
  final String tanggal;
  final String jamMasuk;
  final String jamPulang;

  AbsenRecord(
      {required this.tanggal, required this.jamMasuk, required this.jamPulang});
}


class HistoryAbsenPage extends StatefulWidget {

  const HistoryAbsenPage({Key? key});

  @override
_HistoryAbsenState createState() => _HistoryAbsenState();

}

class _HistoryAbsenState extends State<HistoryAbsenPage> {
  final List<AbsenRecord> absenRecords = [
    AbsenRecord(
        tanggal: '2023-11-01', jamMasuk: '08:00 AM', jamPulang: '05:00 PM')
    // Tambahkan data absen lainnya sesuai kebutuhan
  ];

  @override
  void initState() {
    super.initState();
    // Panggil metode async terpisah untuk inisialisasi
    _initializeStatusPage();
  }

  Future<void> _initializeStatusPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('statusPage', '1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('History Absen'),
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
      body: ListView.builder(
        itemCount: absenRecords.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 67, 155, 146),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${absenRecords[index].tanggal}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text('Absen Masuk: ${absenRecords[index].jamMasuk}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text('Absen Pulang: ${absenRecords[index].jamPulang}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
 }
