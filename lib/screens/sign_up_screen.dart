import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _obscurePassword = true;

  void _signUp() async {
    final prefs = await SharedPreferences.getInstance();
    final name = _fullnameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Semua field wajib diisi');
      return;
    }

    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#\\\$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorText =
        'Minimal 8 karakter, kombinasi [A-Z], [a-z], [0-9], simbol';
      });
      return;
    }

    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    prefs.setString('fullname', encrypter.encrypt(name, iv: iv).base64);
    prefs.setString('username', encrypter.encrypt(username, iv: iv).base64);
    prefs.setString('password', encrypter.encrypt(password, iv: iv).base64);
    prefs.setString('key', key.base64);
    prefs.setString('iv', iv.base64);

    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _fullnameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _errorText.isEmpty ? null : _errorText,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: const Text('Sign Up')),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Sudah punya akun? ',
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Login',
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Navigator.pushReplacementNamed(context, '/signin'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}