import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:absen_kantor/material/widgetLogout.dart';

class AbsenRecord {
  final String tanggal;
  final String absen;
  final String tipe;

  AbsenRecord({
    required this.tanggal,
    required this.absen,
    required this.tipe,
  });
}

class HistoryAbsenPage extends StatefulWidget {
  final String muserId;

  const HistoryAbsenPage({Key? key, required this.muserId}) : super(key: key);

  @override
  _HistoryAbsenState createState() => _HistoryAbsenState();
}

class _HistoryAbsenState extends State<HistoryAbsenPage> {
  final List<CombinedAbsenRecord> combinedAbsenRecords = [];

  @override
  void initState() {
    super.initState();
    // Panggil metode async terpisah untuk inisialisasi
    _initializeStatusPage();
    // Panggil metode untuk mendapatkan data absen
    _getDataHistory();
  }

  Future<void> _initializeStatusPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('statusPage', '1');
  }

  Future<void> _getDataHistory() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://123.100.226.157:8282/absen/getList?mUserId=${widget.muserId}'),
      );

      if (response.statusCode == 200) {
        // Jika permintaan berhasil, kita dapat memproses data dari respons
        final List<dynamic> data = json.decode(response.body)['data'];

        // Menghapus data sebelumnya (jika ada)
        combinedAbsenRecords.clear();

        // Mengisi daftar CombinedAbsenRecord dengan data dari API
        List<AbsenRecord> masukRecords = [];
        List<AbsenRecord> keluarRecords = [];

        for (var item in data) {
          DateTime createdDateTime = DateTime.parse(item['created']);
          DateTime adjustedDateTime = createdDateTime.add(Duration(hours: 7));
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(adjustedDateTime);
          String formattedTime = DateFormat('HH:mm').format(adjustedDateTime);

          AbsenRecord absenRecord = AbsenRecord(
            tanggal: formattedDate,
            absen: item['tipe'] == 'MASUK'
                ? formattedTime
                : item['tipe'] == 'KELUAR'
                    ? formattedTime
                    : '-',
            tipe: item['tipe'] == 'MASUK' ? 'Masuk' : 'Keluar',
          );

          if (item['tipe'] == 'MASUK') {
            masukRecords.add(absenRecord);
          } else if (item['tipe'] == 'KELUAR') {
            keluarRecords.add(absenRecord);
          }
        }

        // Gabungkan absen masuk dan keluar pada tanggal yang sama
        for (var masukRecord in masukRecords) {
          for (var keluarRecord in keluarRecords) {
            if (masukRecord.tanggal == keluarRecord.tanggal) {
              combinedAbsenRecords.add(
                CombinedAbsenRecord(
                  tanggal: masukRecord.tanggal,
                  jamMasuk: masukRecord.absen,
                  jamKeluar: keluarRecord.absen,
                ),
              );
            }
          }
        }

        // Mengatur ulang tampilan setelah mendapatkan data baru
        setState(() {});
      } else {
        // Jika permintaan tidak berhasil, Anda dapat menangani kesalahan di sini
        print("Gagal mendapatkan data: ${response.statusCode}");
      }
    } catch (error) {
      throw error;
    }
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
        itemCount: combinedAbsenRecords.length,
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
                    '${combinedAbsenRecords[index].tanggal}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Jam Masuk: ${combinedAbsenRecords[index].jamMasuk}'),
                      Text(
                          'Jam Keluar: ${combinedAbsenRecords[index].jamKeluar}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CombinedAbsenRecord {
  final String tanggal;
  final String jamMasuk;
  final String jamKeluar;

  CombinedAbsenRecord({
    required this.tanggal,
    required this.jamMasuk,
    required this.jamKeluar,
  });
}
