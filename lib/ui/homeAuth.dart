import 'package:absen_kantor/material/color.dart';
import 'package:absen_kantor/ui/listkaryawan.dart';
import 'package:flutter/material.dart';
import 'package:absen_kantor/ui/absen.dart';
import 'package:absen_kantor/ui/historyAbsen.dart';
import 'package:absen_kantor/ui/profile.dart';

class HomePageAuth extends StatefulWidget {
  final String muserId;
  final int selectMenuIndex;

  const HomePageAuth({
    Key? key,
    required this.muserId,
    required this.selectMenuIndex,
  }) : super(key: key);

  @override
  _HomePageAuthState createState() => _HomePageAuthState();
}

class _HomePageAuthState extends State<HomePageAuth> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectMenuIndex;
  }

  static List<Widget> _widgetOptions(String muserId) => <Widget>[
        AbsenPage(muserId: muserId),
        HistoryAbsenPage(muserId: muserId),
        ProfilePage(muserId: muserId),
        EmployeeListWidget(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions(widget.muserId).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Tetap menampilkan semua item
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Absen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Rekap Absen',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: greengood,
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
        onTap: _onItemTapped,
      ),
    );
  }
}
