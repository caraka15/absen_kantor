import 'package:absen_kantor/material/color.dart';
import 'package:absen_kantor/ui/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:absen_kantor/widget/sidebar.dart';

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
      drawer: Sidebar(),
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
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: greengood,
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
                      onPressed: () {
                        // Logika untuk tombol "Masuk" di sini
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
}
