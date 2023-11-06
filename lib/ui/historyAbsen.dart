import 'package:absen_kantor/widget/sidebar.dart';
import 'package:flutter/material.dart';

class AbsenRecord {
  final String tanggal;
  final String jamMasuk;
  final String jamPulang;

  AbsenRecord({required this.tanggal, required this.jamMasuk, required this.jamPulang});
}

class HistoryAbsenPage extends StatelessWidget {
  final List<AbsenRecord> absenRecords = [
    AbsenRecord(tanggal: '2023-11-01', jamMasuk: '08:00 AM', jamPulang: '05:00 PM'),
    AbsenRecord(tanggal: '2023-11-02', jamMasuk: '08:30 AM', jamPulang: '05:15 PM'),
    AbsenRecord(tanggal: '2023-11-03', jamMasuk: '09:00 AM', jamPulang: '05:30 PM'),
    // Tambahkan data absen lainnya sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('History Absen'),
      ),
      body: ListView.builder(
        itemCount: absenRecords.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal: ${absenRecords[index].tanggal}'),
                Text('Jam Masuk: ${absenRecords[index].jamMasuk}'),
                Text('Jam Pulang: ${absenRecords[index].jamPulang}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
