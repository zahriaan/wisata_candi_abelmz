import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //TODO: 1. Deklarasikan variabel
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  String _errorText = '';
  bool _obscurePassword = true;

  // TODO: 1. Membuat fungsi signup
  void _signup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = _usernamecontroller.text.trim();
    final String name = _namecontroller.text.trim();
    final String password = _passwordcontroller.text.trim();

    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#$%^&*(),.?"{}|<>]'))) {
      setState(() {
        _errorText =
        'Minimal m8 karakter, kombinasi [A-Z], [a-z], [0-9], [!@#\\\$%^&*(),.?"{}:<>]';
      });
      return;
    }
    // Simpan data  pengguna di SharedPreferences
    prefs.setString('username', username);
    prefs.setString('name', name);
    prefs.setString('password', password);

    // Buat navigasi ke halaman SignIn Screen
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  void dispose() {
    _usernamecontroller.dispose();
    _namecontroller.dispose();
    _passwordcontroller.dispose();
    // TODO: Implementasi dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: 2. Pasang AppBar
      appBar: AppBar(
        title: Text(
          'Sign up',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Membuat Teks judul di Appbar Ke tengah
        // centerTitle: true,
        // Membuat Warna Appbar Menjadi biru
        // backgroundColor: Colors.blue,
        // Membuat Bayangan di Appbar
        elevation: 10,
      ),
      //TODO: 3. Pasang body
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                //TODO: 4. Atur mainAxisAlignment dan crossAxisAlignment
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //TODO: 5. Pasang TextFormField nama pengguna
                  TextFormField(
                    controller: _usernamecontroller,
                    decoration: InputDecoration(
                      labelText: 'Nama Pengguna',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //TODO: 6. Pasang TextFormField Nama Lengkap
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _namecontroller,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //TODO: 7. Pasang TextFormField kata sandi
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordcontroller,
                    decoration: InputDecoration(
                      labelText: 'Kata sandi',
                      errorText: _errorText.isNotEmpty ? _errorText : null,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),

                  //TODO:8. Pasangkan Elevatedbutton Sign Up
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                    child: Text("Sign Up"),
                  ),

                  //TODO: 9. Pasang elevatedbutton Sign In
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Sudah Punya Akun? ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/signin');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
