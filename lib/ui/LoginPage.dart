import 'package:absen_kantor/material/color.dart';
import 'package:absen_kantor/ui/RegisterPage.dart';
import 'package:absen_kantor/ui/homeAuth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: greengood,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: greengood,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Meletakkan teks "Daftar" dan tombol "Masuk" di sebelah kanan
                  children: [
                    ElevatedButton(
                      onPressed: () async {

                        String? resultResponse = await loginUser(emailController.text, passwordController.text);
                        final bodyJson = json.decode(resultResponse);
                        print('JSON: ${bodyJson}');

                        bool status = bodyJson['status'];
                        print('Status: $status');

                        if(status == true) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomePageAuth(), // Gantilah dengan nama kelas halaman pendaftaran Anda
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(greengood),
                      ),
                    ),
                    SizedBox(
                        width:
                            10), // Jarak antara tombol "Masuk" dan teks "Daftar"
                    TextButton(
                      // Teks "Daftar" sebagai tautan ke halaman pendaftaran
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                RegisterPage(), // Gantilah dengan nama kelas halaman pendaftaran Anda
                          ),
                        );
                      },
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                          fontSize: 16,
                          color: greengood, // Warna teks tautan
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> loginUser(String nip, String password) {
    try {
      final response = http.post(
        Uri.parse('http://123.100.226.157:8282/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nip': nip,
          'password': password
        }),
      );

      return response.then((http.Response response) {
        print('Response body: ${response.body}');
          return response.body;
      }).catchError((error) {
        print('Error: $error');
        throw "Server Down";
      });
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }
}
