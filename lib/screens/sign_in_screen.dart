import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _obscurePassword = true;

  Future<void> _signIn() async {
    final prefs = await SharedPreferences.getInstance();

    final encryptedUsername = prefs.getString('username');
    final encryptedPassword = prefs.getString('password');
    final keyString = prefs.getString('key');
    final ivString = prefs.getString('iv');

    if (encryptedUsername == null ||
        encryptedPassword == null ||
        keyString == null ||
        ivString == null) {
      setState(() => _errorText = 'Akun belum terdaftar');
      return;
    }

    final key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final savedUsername =
    encrypter.decrypt64(encryptedUsername, iv: iv);
    final savedPassword =
    encrypter.decrypt64(encryptedPassword, iv: iv);

    if (_usernameController.text == savedUsername &&
        _passwordController.text == savedPassword) {
      prefs.setBool('isSignedIn', true);
      Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() => _errorText = 'Username atau password salah');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton(onPressed: _signIn, child: const Text('Sign In')),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Belum punya akun? ',
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Daftar',
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Navigator.pushReplacementNamed(context, '/signup'),
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