import 'package:absen_kantor/material/widgetLogout.dart';
import 'package:absen_kantor/ui/homeAuth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final String muserId;

  const ProfilePage({Key? key, required this.muserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil Saya'),
        actions: [
          // Tombol Logout di AppBar
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              LogoutHandler.showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: ProfileForm(muserId: muserId),
    );
  }
}

class ProfileForm extends StatefulWidget {
  final String muserId;

  const ProfileForm({Key? key, required this.muserId}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  bool isEditing = false;
  late Future<Map<String, dynamic>> userData;

  List<String> jabatanList = []; // Daftar nama jabatan dari API

  Future<void> _fetchUserDataJabatan() async {
    try {
      final response = await http.get(
        Uri.parse('http://123.100.226.157:8282/jabatan/getAll'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> jabatanDataList = jsonData['data'];

        // Mendapatkan daftar nama jabatan dari data API
        List<String> namaJabatan = jabatanDataList
            .map((jabatan) => jabatan['nama'].toString())
            .toList();

        setState(() {
          jabatanList = namaJabatan;
          // Set nilai default jika diperlukan
          // selectedJabatan = jabatanList.isNotEmpty ? jabatanList[0] : '';
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error fetching user data: $error');
      // Handle error, mungkin tampilkan pesan kesalahan ke pengguna
    }
  }

  @override
  void initState() {
    super.initState();
    userData = _fetchUserData();
    _fetchUserDataJabatan();
    _initializeStatusPage();
  }

  Future<void> _initializeStatusPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('statusPage', '2');
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final response = await http.get(
      Uri.parse('http://123.100.226.157:8282/user/getByOne/${widget.muserId}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  TextEditingController namaController = TextEditingController();
  TextEditingController nomorTlpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController jabatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final user = snapshot.data!['data'];

          namaController.text = user['nama'];
          nomorTlpController.text = user['noTlp'];
          emailController.text = user['email'];

          if (jabatanController.text.isEmpty) {
            jabatanController.text = user['jabatan'];
          }

          return SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16),
                  _buildProfileField("Nama", user['nama']),
                  _buildProfileField("NIP", user['nip']),
                  _buildProfileField("Email", user['email']),
                  _buildProfileField("No. HP", user['noTlp']),
                  _buildJabatanDropdown("Jabatan", user['jabatan']),
                  _buildProfileField("Role", user['role']),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (isEditing) {
                        await updateUser(
                          widget.muserId,
                          user['nip'],
                          namaController.text,
                          nomorTlpController.text,
                          emailController.text,
                          user['password'],
                          jabatanController.text,
                        );
                      }

                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    child: Text(isEditing ? 'Simpan' : 'Edit'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildProfileField(String label, String value) {
    TextEditingController controller = TextEditingController(text: value);
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        // Panggil ini ketika nilai berubah
        // Pastikan untuk memastikan bahwa `controller` mengacu pada controller yang benar
        if (label == "No. HP") {
          nomorTlpController.text = value;
        }

        if (label == "Nama") {
          namaController.text = value;
        }

        if (label == "Email") {
          emailController.text = value;
        }
      },
      decoration: InputDecoration(
        labelText: label,
        enabled: isEditing && label != "Role" && label != 'NIP',
      ),
    );
  }

  Widget _buildJabatanDropdown(String label, String value) {
    return DropdownButtonFormField(
      value: value,
      items: jabatanList
          .map((String jabatan) => DropdownMenuItem(
                value: jabatan,
                child: Text(jabatan),
              ))
          .toList(),
      onChanged: isEditing
          ? (newValue) {
              setState(() {
                jabatanController.text = newValue.toString();
              });
            }
          : null, // nonaktifkan dropdown jika tidak sedang diedit
      decoration: InputDecoration(
        labelText: label,
        enabled: isEditing,
      ),
    );
  }

  Future<void> updateUser(String muserId, String nip, String nama,
      String nomorTlp, String email, String password, String jabatan) async {
    final response = await http.put(
      Uri.parse('http://123.100.226.157:8282/user/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'muserId': muserId,
          'nip': nip,
          'nama': nama,
          'noTlp': nomorTlp,
          'email': email,
          'password': password,
          'role': 'PEGAWAI',
          'jabatan': jabatan,
          'updatedBy': muserId,
          'isactive': 'Y',
        },
      ),
    );

    Object jsonObject = {
      'muserId': muserId,
      'nip': nip,
      'nama': nama,
      'noTlp': nomorTlp,
      'email': email,
      'password': password,
      'role': 'PEGAWAI',
      'jabatan': jabatan,
      'updatedBy': muserId,
      'isactive': 'Y',
    };

    print('JSON: $jsonObject');

    int statusCode = response.statusCode;

    print('StatusCode: $statusCode');
    // final bodyJson = json.decode(response.body);

    // bool status = bodyJson['status'];

    if (statusCode == 200) {
      print('Succes');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              HomePageAuth(muserId: muserId, selectMenuIndex: 2),
        ),
      );
    }
  }
}
