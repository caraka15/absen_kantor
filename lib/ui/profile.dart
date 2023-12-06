import 'package:absen_kantor/material/widgetLogout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    userData = _fetchUserData();
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                _buildProfileField("Nama", user['nama']),
                _buildProfileField("NIP", user['nip']),
                _buildProfileField("Email", user['email']),
                _buildProfileField("No. HP", user['noTlp']),
                _buildProfileField("Role", user['role']),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: Text(isEditing ? 'Simpan' : 'Edit'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildProfileField(String label, String value) {
    return TextFormField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        enabled: isEditing,
      ),
    );
  }
}
