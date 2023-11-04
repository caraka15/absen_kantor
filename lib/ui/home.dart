import 'package:flutter/material.dart';
import '../widget/sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(title: Text("HomePage")),
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
