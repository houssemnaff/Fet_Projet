import 'package:animate_do/animate_do.dart';
import 'package:fetprojet/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In
import 'package:sign_in_button/sign_in_button.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController controlerPassword = TextEditingController();
  final TextEditingController controlerPassword2 = TextEditingController();
  final TextEditingController controlerEmail = TextEditingController();
  bool _obscurePassword = true; // To toggle password visibility
  bool _obscurePassword2 = true; // For confirm password
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // Initialize Google Sign-In

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: const Text(
                      "Sign up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: const Text(
                      "Create an account, It's free",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: makeInput(
                      label: "Email",
                      icon: Icons.email,
                      controller: controlerEmail,
                      obscureText: false,
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: makeInput(
                      label: "Password",
                      icon: Icons.lock,
                      controller: controlerPassword,
                      obscureText: _obscurePassword,
                      toggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1400),
                    child: makeInput(
                      label: "Confirm Password",
                      icon: Icons.lock,
                      controller: controlerPassword2,
                      obscureText: _obscurePassword2,
                      toggleVisibility: () {
                        setState(() {
                          _obscurePassword2 = !_obscurePassword2;
                        });
                      },
                    ),
                  ),
                ],
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: Container(
                  padding: const EdgeInsets.only(top: 3, left: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      await _signUp(context);
                    },
                    color: const Color.fromARGB(255, 25, 28, 184),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              FadeInUp(
                child: SignInButton(
                  Buttons.google,
                  onPressed: () async {
                    _handleGoogleSignup(context);
                  },
                ),
              ),
              FadeInUp(
                child: SignInButton(
                  Buttons.gitHub,
                  onPressed: () async {
                    _handleGithubSignup(context);
                  },
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {required String label,
      required IconData icon,
      required TextEditingController controller,
      bool obscureText = false,
      VoidCallback? toggleVisibility}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: toggleVisibility != null
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: toggleVisibility,
                  )
                : Icon(icon, color: Colors.black),
            labelStyle: const TextStyle(color: Colors.black),
            labelText: label,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Future<void> _handleGoogleSignup(BuildContext context) async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("Error: Missing access token or ID token");
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print("User signed in: ${user.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MergedDashboardScreen(user: user)),
        );
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }

  Future<void> _handleGithubSignup(BuildContext context) async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(githubProvider);
      User? user = userCredential.user;

      Navigator.pop(context); // Close the loading dialog
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MergedDashboardScreen(user: user)),
        );
      }
    } catch (error) {
      Navigator.pop(context); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in with GitHub: $error')),
      );
    }
  }

  Future<void> _signUp(BuildContext context) async {
    String email = controlerEmail.text.trim();
    String password = controlerPassword.text.trim();
    String confirmPassword = controlerPassword2.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        print("User registered: ${user.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MergedDashboardScreen(user: user)),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already in use')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } catch (error) {
      print("Error signing up: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing up: $error')),
      );
    }
  }
}
