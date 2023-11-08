import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profil Saya'),
        ),
        body: ProfileForm(),
      ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  bool isEditing = false;
  TextEditingController nameController = TextEditingController(text: 'Nama Anda');
  TextEditingController birthDateController = TextEditingController(text: 'Tanggal Lahir Anda');
  TextEditingController positionController = TextEditingController(text: 'Jabatan Anda');
  TextEditingController emailController = TextEditingController(text: 'alamat@email.com');
  TextEditingController phoneNumberController = TextEditingController(text: 'Nomor Anda');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Nama Anda'),
            enabled: isEditing,
          ),
          TextFormField(
            controller: birthDateController,
            decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            enabled: isEditing,
          ),
          TextFormField(
            controller: positionController,
            decoration: InputDecoration(labelText: 'Jabatan Anda'),
            enabled: isEditing,
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email Anda'),
            enabled: isEditing,
          ),
          TextFormField(
            controller: phoneNumberController,
            decoration: InputDecoration(labelText: 'Nomor HP Anda'),
            enabled: isEditing,
          ),
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
}
