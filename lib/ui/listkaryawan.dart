import 'package:flutter/material.dart';
import 'employee_detail_page.dart'; // File yang akan dibuat untuk halaman detail


class Employee {
  final String name;
  final String position;

  Employee({required this.name, required this.position});
}

class EmployeeListWidget extends StatelessWidget {
  final List<Employee> employees = [
    Employee(name: 'Kautsar', position: 'Network Engineer'),
    Employee(name: 'Bagas', position: 'UI/UX Designer'),
    Employee(name: 'Caraka', position: 'Project Manager'),
    // Tambahkan data karyawan lainnya sesuai kebutuhan
  ];

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
              child: ListTile(
                title: Text(employees[index].name),
                subtitle: Text(employees[index].position),
                  onTap: () {
                  // Menggunakan Navigator untuk berpindah ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeDetailPage(employee: employees[index]),
                    ),
                  );
                },
                // Tambahan informasi atau fungsi lainnya sesuai kebutuhan
              ),
            );
          },
        ),
      ),
    );
  }
}
