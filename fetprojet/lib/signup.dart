import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'login.dart'; // Ensure this imports your login page

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController controlerPassword = TextEditingController();
  final TextEditingController controlerPassword2 = TextEditingController();
  final TextEditingController controlerEmail = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void iniState() {
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
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
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
                          label: "Email", Icons.email, controlerEmail)),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: makeInput(
                          label: "Password",
                          Icons.lock,
                          obscureText: true,
                          controlerPassword)),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: makeInput(
                          label: "Confirm Password",
                          Icons.password,
                          controlerPassword2,
                          obscureText: true)),
                ],
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
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
                    onPressed: () {
                      print("le valeur de text $controlerEmail");
                    },
                    color: const Color.fromARGB(255, 25, 28, 184),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "Sign up",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
              ),
              // FadeInUp(child: Text("or")),
              FadeInUp(
                  child: SignInButton(Buttons.google,
                      text: "Sign up with google", onPressed: () {
                _handelgooglesignup;
              })), FadeInUp(
                  child: SignInButton(Buttons.facebook,
                      text: "Sign up with google", onPressed: () {
                _handelgooglesignup;
              })),
               FadeInUp(
                  child: SignInButton(Buttons.gitHub,
                      text: "Sign up with google", onPressed: () {
                _handelgooglesignup;
              })),
              FadeInUp(
                duration: const Duration(milliseconds: 1600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    InkWell(
                      onTap: () {
                        // Navigate to the login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginPage()), // Replace with your actual LoginPage widget
                        );
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors
                              .blue, // Optional: Change color to indicate it's clickable
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

  Widget makeInput(IconData icon, TextEditingController controllername,
      {label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /* Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),*/
        const SizedBox(height: 5),
        TextField(
          controller: controllername,
          obscureText: obscureText,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(12)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Icon(icon),
              //suffixStyle: ,
              suffixIconColor: Colors.black,
              labelStyle: const TextStyle(color: Colors.black),
              label: Text(label)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  void _handelgooglesignup() {
    try {
      GoogleAuthProvider _googleauthprovider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleauthprovider);
    } catch (error) {
      print(error);
    }
  }
}
