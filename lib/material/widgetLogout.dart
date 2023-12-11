import 'package:flutter/material.dart';
import 'package:absen_kantor/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutHandler {
  static void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                // Memanggil metode untuk membersihkan SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Navigasi ke halaman home dan hapus stack navigasi sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
