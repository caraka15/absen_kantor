import 'package:absen_kantor/material/color.dart';
import 'package:absen_kantor/ui/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nipController = TextEditingController();
  TextEditingController nomorTeleponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.green, // Assuming greengood is a Color variable
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // Assuming greengood is a Color variable
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // SizedBox(height: 20),
                    Text(
                      "NIP",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    // SizedBox(height: 15),
                    TextFormField(
                      controller: nipController,
                      decoration: InputDecoration(
                        hintText: "Masukkan NIP Anda",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIP wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Nama",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    // SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Masukkan nama Anda",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    // SizedBox(height: 20),
                    Text(
                      "Nomor Hp",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    // SizedBox(height: 15),
                    TextFormField(
                      controller: nomorTeleponController,
                      decoration: InputDecoration(
                        hintText: "Masukkan Nomor Hp Anda",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor Hp wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    // SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Masukkan email Anda",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email wajib diisi';
                        } else if (!isValidEmail(value)) {
                          return 'Email tidak valid';
                        }
                        // Validasi email tambahan jika diperlukan
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    // SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Masukkan password Anda",
                        border: UnderlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }
                        // Validasi password tambahan jika diperlukan
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Konfirmasi Password",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: "Konfirmasi password Anda",
                        border: UnderlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi Password wajib diisi';
                        } else if (value != passwordController.text) {
                          return 'Password tidak valid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Validasi form sebelum melanjutkan
                            if (_formKey.currentState?.validate() ?? false) {
                              // Semua bidang valid, navigasi ke halaman berikutnya
                             createUser(nipController.text,
                                 nameController.text,
                                 nomorTeleponController.text,
                                 emailController.text,
                                 passwordController.text);
                            }
                          },
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
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
        ),
      ),
    );
  }

  Future<void> createUser(String nip, String nama, String nomorTlp, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://123.100.226.157:8282/user/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'nip': nip,
          'nama': nama,
          'noTlp': nomorTlp,
          'email': email,
          'password': password,
          'role': 'PEGAWAI',
        },
      ),
    );

    int statusCode = response.statusCode;
    // final bodyJson = json.decode(response.body);

    // bool status = bodyJson['status'];

    if (statusCode == 200) {
      // Show a pop-up
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Akun Berhasil Dibuat'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the pop-up
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    final bodyJson = json.decode(response.body);
    String message = bodyJson['message'];
    if (statusCode == 400){
      // Show a pop-up
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      return null;
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

}
