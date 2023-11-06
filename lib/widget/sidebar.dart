import 'package:absen_kantor/ui/LoginPage.dart';
import 'package:absen_kantor/ui/absen.dart';
import 'package:absen_kantor/ui/historyAbsen.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text("Caraka, Bagas"),
              accountEmail: Text("NIP : 17210390, 17210256")),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Absen"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AbsenPage()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.history_edu),
            title: Text("Riwayat Absensi"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryAbsenPage()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text("Keluar"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
    );
  }
}
