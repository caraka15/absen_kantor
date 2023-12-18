import 'dart:convert';
import 'package:absen_kantor/material/color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'employee_detail_page.dart'; // File yang akan dibuat untuk halaman detail

class Employee {
  final String nip;
  final String nama;
  final String noTlp;
  final String email;
  final String isactive;
  final String password;
  final String role;
  final String jabatan;
  final String muserId;

  Employee({
    required this.nip,
    required this.nama,
    required this.noTlp,
    required this.email,
    required this.isactive,
    required this.password,
    required this.role,
    required this.jabatan,
    required this.muserId,
  });
}

class EmployeeListWidget extends StatefulWidget {
  @override
  _EmployeeListWidgetState createState() => _EmployeeListWidgetState();
}

class _EmployeeListWidgetState extends State<EmployeeListWidget> {
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployeeList();
  }

  Future<void> _fetchEmployeeList() async {
    try {
      final response = await http.get(
        Uri.parse('http://123.100.226.157:8282/user/getAll'),
      );

      final bodyJson = json.decode(response.body);

      if (bodyJson['status'] == true) {
        List<dynamic> employeeData = bodyJson['data'];

        setState(() {
          employees = employeeData.map((data) {
            return Employee(
              nip: data['nip'],
              nama: data['nama'],
              noTlp: data['noTlp'],
              email: data['email'],
              isactive: data['isactive'],
              password: data['password'],
              role: data['role'],
              jabatan: data['jabatan'],
              muserId: data['muserId'],
            );
          }).toList();
        });
      } else {
        // Handle API error if needed
        print('API request failed: ${bodyJson['message']}');
      }
    } catch (error) {
      // Handle network error if needed
      print('Error fetching employee list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Daftar Karyawan'),
        ),
        body: ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            return Card(
              color: greengood,
              child: ListTile(
                title: Text(employees[index].nama),
                subtitle: Text(employees[index].jabatan),
                onTap: () {
                  // Menggunakan Navigator untuk berpindah ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EmployeeDetailPage(employee: employees[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
