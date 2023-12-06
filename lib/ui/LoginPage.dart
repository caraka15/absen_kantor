import 'package:absen_kantor/material/color.dart';
import 'package:absen_kantor/ui/RegisterPage.dart';
import 'package:absen_kantor/ui/homeAuth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String selectedRole = 'PEGAWAI'; // Default value

  @override
  void initState() {
    super.initState();
    // Panggil metode async terpisah untuk inisialisasi
    _initializeLogin();
  }

  Future<void> _initializeLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String initialNip = prefs.getString('nip') ?? '';
    String initialPassword = prefs.getString('password') ?? '';
    String initialRole = prefs.getString('role') ?? '';

    print('Initial NIP: $initialNip');
    print('Initial Password: $initialPassword');
    print('Initial Role: $initialRole');

    await loginUser(initialNip, initialPassword, initialRole);
  }

  Future<void> loginUser(String nip, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('http://123.100.226.157:8282/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{'nip': nip, 'password': password, 'role': role},
        ),
      );

      final bodyJson = json.decode(response.body);

      bool status = bodyJson['status'];

      if (status == true) {
        // Login berhasil, kembalikan muserId
        String muserId = bodyJson['data']['user']['muserId'];

        // Cek apakah ada token dalam response
        String? token = bodyJson['data']['token'];

        if (token != null && token.isNotEmpty) {
          // Simpan token ke shared preferences
          await saveTokenToSharedPreferences(token);

          // Token ada, langsung menuju HomePageAuth
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePageAuth(muserId: muserId),
            ),
          );
        } else {
          // Token tidak ada, mungkin implementasinya berbeda
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        }
      } else {
        // Login gagal, handle sesuai kebutuhan
        // Contoh: tampilkan pesan error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Gagal'),
              content: Text('Email atau password salah'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  Future<void> saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

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
                Text(
                  "Role",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedRole,
                  items: ['PEGAWAI', 'ADMIN'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await loginUser(
                          emailController.text,
                          passwordController.text,
                          selectedRole,
                        );
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
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                          fontSize: 16,
                          color: greengood,
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
}
