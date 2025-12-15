import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:wisata_candi_abel/widgets/profile_info_item.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: 1 DEKLARASIKAN VARIABEL YANG DIBUTUHKAN
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoriteCandiCount = 5;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _pickImage(ImageSource source) async {
    final PickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70
    );

    if(PickedFile == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', PickedFile.path);

    setState(() {
      _profileImage = File(PickedFile.path);
    });
  }

  void _showImageSourceDialog(){
    showModalBottomSheet(
        context: context,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: (){
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galeri'),
                onTap: (){
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              )
            ],
          ),
        )
    );
  }


  // TODO: Ambil & dekripsi data dari SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    final signedIn = prefs.getBool('isSignedIn') ?? false;
    if (!signedIn) return;

    final encryptedName = prefs.getString('fullname');
    final encryptedUsername = prefs.getString('username');
    final keyBase64 = prefs.getString('key');
    final ivBase64 = prefs.getString('iv');

    if (encryptedName == null ||
        encryptedUsername == null ||
        keyBase64 == null ||
        ivBase64 == null) return;

    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromBase64(ivBase64);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final imagePath = prefs.getString('profile_image_path');
    if(imagePath != null && imagePath.isNotEmpty){
      setState(() {
        _profileImage = File(imagePath);
      });
    }

    setState(() {
      isSignedIn = true;
      fullName = encrypter.decrypt64(encryptedName, iv: iv);
      userName = encrypter.decrypt64(encryptedUsername, iv: iv);
    });
  }

  // TODO 5: Implementasi FUNGSI SIGN IN
  void signIn() {
    Navigator.pushNamed(context, '/signin');
  }

  // TODO 6: IMPLEMENTASI FUNGSI SIGN OUT
  void signOut() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isSignedIn', false);
    await prefs.setString('fullname', '');
    await prefs.setString('username', '');
    await prefs.setString('password', '');

    setState(() {
      isSignedIn = false;
      fullName = '';
      userName = '';
    });
  }

  // TODO: Implementasi editFullName (terenkripsi)
  Future<void> editFullName(String newName) async {
    final prefs = await SharedPreferences.getInstance();

    final keyBase64 = prefs.getString('key');
    final ivBase64 = prefs.getString('iv');

    if (keyBase64 == null || ivBase64 == null) return;

    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromBase64(ivBase64);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encryptedName = encrypter.encrypt(newName, iv: iv);

    await prefs.setString('fullname', encryptedName.base64);

    setState(() {
      fullName = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // TODO: 2 BUAT BAGIAN PROFILEHEADER
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.deepPurple, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage('images/placeholder_image.png') as ImageProvider,
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: _showImageSourceDialog,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.deepPurple[50],
                            ),
                          )
                      ],
                    ),
                  ),
                ),

                // TODO: 3 BUAT BAGIAN PROFILEINFO
                const SizedBox(height: 20),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  icon: Icons.lock,
                  label: "Pengguna",
                  value: userName,
                  iconColor: Colors.amber,
                  showEditIcon: isSignedIn,
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  icon: Icons.lock,
                  label: "Name",
                  value: fullName,
                  iconColor: Colors.blue,
                  showEditIcon: isSignedIn,
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  icon: Icons.favorite,
                  label: "Favorit Candi",
                  value: favoriteCandiCount > 0
                      ? favoriteCandiCount.toString()
                      : '',
                  iconColor: Colors.red,
                ),

                // TODO: 4 PROFILE ACTION
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 20),
                isSignedIn
                    ? TextButton(onPressed: signOut, child: const Text('Sign Out'))
                    : TextButton(onPressed: signIn, child: const Text('Sign in')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}