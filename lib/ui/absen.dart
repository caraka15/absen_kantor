import 'package:absen_kantor/widget/sidebar.dart';
import 'package:flutter/material.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({super.key});

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text("Absensi Kantor"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hallo, Bagas"),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 500,
              decoration: BoxDecoration(color: Color.fromARGB(255, 67, 155, 146)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Text(
                    "15 April 2023",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "08.00",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "MASUK",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "16.00",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "KELUAR",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      )
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      )),
    );
  }
}