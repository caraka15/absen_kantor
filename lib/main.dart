import 'package:absen_kantor/ui/LoginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hallo, Caraka Widi"),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 500,
              decoration: BoxDecoration(color: Colors.lightGreen),
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
                            "07.00",
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
                            "07.00",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "MASUK",
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
