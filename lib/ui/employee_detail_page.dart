import 'package:absen_kantor/ui/listkaryawan.dart';
import 'package:flutter/material.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee employee;

  EmployeeDetailPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Karyawan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nama: ${employee.name}'),
            Text('Posisi: ${employee.position}'),
            // Tambahan informasi atau fungsi lainnya sesuai kebutuhan
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk mengunduh data absensi karyawan
                // Misalnya, panggil fungsi atau tampilkan dialog pengunduhan
                print('Mengunduh data absensi untuk ${employee.name}');
              },
              child: Text('Unduh Data Absensi'),
            ),
          ],
        ),
      ),
    );
  }
}
