import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:absen_kantor/material/color.dart';
import 'package:absen_kantor/ui/absen.dart';
import 'package:absen_kantor/ui/historyAbsen.dart';
import 'package:absen_kantor/ui/profile.dart';
import 'package:absen_kantor/ui/listkaryawan.dart';

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
  late int _selectedIndex;
  late List<BottomNavigationBarItem> _bottomNavBarItems;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectMenuIndex;
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://123.100.226.157:8282/user/getByOne/${widget.muserId}'),
      );

      final bodyJson = json.decode(response.body);

      if (bodyJson['status'] == true) {
        // Setelah mendapatkan role, atur BottomNavigationBarItems
        String userRole = bodyJson['data']['role'];

        setState(() {
          _bottomNavBarItems = (userRole == 'ADMIN')
              ? const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Rekap Absen',
                  ),
                ]
              : const <BottomNavigationBarItem>[
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
                ];
        });
      } else {
        // Handle API error if needed
        print('API request failed: ${bodyJson['message']}');
      }
    } catch (error) {
      // Handle network error if needed
      print('Error fetching user role: $error');
    }
  }

  List<Widget> _widgetOptions(String muserId) {
    if (_bottomNavBarItems == null) {
      return [CircularProgressIndicator()];
    }

    if (_bottomNavBarItems[0].label == 'Profile') {
      // Role ADMIN
      return [
        ProfilePage(muserId: muserId),
        EmployeeListWidget(),
      ];
    } else {
      // Role PEGAWAI
      return [
        AbsenPage(muserId: muserId),
        HistoryAbsenPage(muserId: muserId),
        ProfilePage(muserId: muserId),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions(widget.muserId).elementAt(_selectedIndex),
      bottomNavigationBar: (_bottomNavBarItems != null)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: _bottomNavBarItems,
              currentIndex: _selectedIndex,
              selectedItemColor: greengood,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
            )
          : CircularProgressIndicator(), // Tampilkan loader selama FutureBuilder berlangsung
    );
  }
}
