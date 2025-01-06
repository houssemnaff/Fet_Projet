import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:fetprojet/authservice.dart';
import 'package:fetprojet/pages/admin/session/session.dart';
import 'package:fetprojet/pages/etudiant/dashboardetudiant.dart';
import 'package:fetprojet/pages/prof/dashbordprof.dart';
import 'package:fetprojet/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final AuthService _authService = AuthService();

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildHeader(),
                      _buildInputs(),
                      _buildLoginButton(),
                      _buildGoogleSignInButton(),
                      _buildSignupLink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 1200),
          child: const Text(
            "Login to your account",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildInputs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: <Widget>[
          _buildTextInput(
            label: "Email",
            controller: controllerEmail,
            icon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              if (!RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                  .hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
            onSaved: (value) => _email = value,
          ),
          _buildTextInput(
            label: "Password",
            controller: controllerPassword,
            icon: Icons.lock,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
            onSaved: (value) => _password = value,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {
                  if (_email == null || _email!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please enter your email to reset your password')),
                    );
                  } else {
                    await _authService.resetPassword(_email!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password reset email has been sent')),
                    );
                  }
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    IconData? icon,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: Icon(icon),
            labelText: label,
          ),
          validator: validator,
          onSaved: onSaved,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        child: const Text("Login", style: TextStyle(fontSize: 18)),
      ),
    );
  }

 Future<void> _login() async {
        final String apiUrl =  'http://10.0.2.2:8081';

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        User? user =
            await _authService.signInWithEmailAndPassword(_email!, _password!);
        if (user != null) {
          
          final SharedPreferences prefs = await SharedPreferences.getInstance();
        final Uri url = Uri.parse('$apiUrl/roles/${user.uid}'); // Access id directly
          final response = await http.get(url);
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['roleUser'] == 'Admin') {
              await prefs.setString('role', 'Admin');
              await prefs.setString('userId', user.uid);
               await prefs.setString('userEmail', user.email!);
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Session()));
            } else if (data['roleUser'] == 'Teacher') {
              await prefs.setString('role', 'Teacher');
              await prefs.setString('userId', user.uid);
              await prefs.setString('userEmail', user.email!);
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Session()));
            } else if (data['roleUser'] == 'student') {
              await prefs.setString('role', 'student');
              await prefs.setString('userId', user.uid);
              await prefs.setString('userEmail', user.email!);
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Session()));
            }
          } else {
            throw Exception(
                'Failed to load articles. Status code: ${response.statusCode}');
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  Widget _buildGoogleSignInButton() {
        final String apiUrl =  'http://10.0.2.2:8081';

    return SignInButton(
      Buttons.google,
      onPressed: () async {
        try {
          User? user = await _authService.signInWithGoogle();
          if (user != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
final Uri url = Uri.parse('$apiUrl/roles/${user.uid}'); // Assurez-vous que le port correspond à celui utilisé par votre backend
          final response = await http.get(url);
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['roleUser'] == 'Admin') {
              await prefs.setString('role', 'Admin');
              await prefs.setString('userId', user.uid);
                await prefs.setString('userEmail', user.email!);

              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Session()));
            } else if (data['roleUser'] == 'Teacher') {
              await prefs.setString('role', 'Teacher');
              await prefs.setString('userId', user.uid);
                             await prefs.setString('userEmail', user.email!);

              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MyWidget()));
            } else if (data['roleUser'] == 'student') {
              await prefs.setString('role', 'student');
              await prefs.setString('userId', user.uid);
                             await prefs.setString('userEmail', user.email!);

              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashEtudiant()));
            }
          } else {
            throw Exception(
                'Failed to load articles. Status code: ${response.statusCode}');
          }
        }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error signing in with Google: $e')),
          );
        }
      },
    );
  }

  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          child: const Text(
            " Sign up",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
