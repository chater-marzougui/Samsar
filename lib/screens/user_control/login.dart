import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samsar/Widgets/additional_info_dialog.dart';
import 'package:samsar/values/app_routes.dart';

import '../../Widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  String errorMessage = '';


  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      String firstName = '';
      String middleName = '';
      String lastName = '';

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        List<String> nameParts = user.displayName!.split(' ');
        if (nameParts.length == 1) {
          firstName = nameParts[0];
        } else if (nameParts.length == 2) {
          firstName = nameParts[0];
          lastName = nameParts[1];
        } else if (nameParts.length == 3) {
          firstName = nameParts[0];
          middleName = nameParts[1];
          lastName = nameParts[2];
        } else if (nameParts.length > 3) {
          firstName = nameParts[0];
          lastName = nameParts.last;
          middleName = nameParts.sublist(1, nameParts.length - 1).join(' ');
        }

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'displayName': user.displayName,
            'firstName': firstName,
            'middleName': middleName,
            'lastName': lastName,
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
            'profileImage': user.photoURL,
            'houses': [],
            'favouriteHouses': [],
            'ratedHouses': [],

            'phoneNumber': "",
            'birthDate': DateTime.now(),
            'gender': 'other',
          });
          showAdditionalInfoDialog(context, user.uid);
        }
        if (userDoc.exists){
          navigateToHomePage();
        }
      } else {
        if(mounted) showSnackBar(context, "No User Found");
        return;
      }
    } catch (e) {
      if(mounted) showSnackBar(context, "Error occurred during Google Sign-In: $e");
    }
  }


  void navigateToHomePage() {
    Navigator.pushReplacementNamed(context, AppRoutes.homePage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            heightFactor: 1.2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Logo/logo.png',
                    height: 150,
                    width: 150,
                  ),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: _isObscure,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.signup);
                        },
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(color: Colors.blueAccent),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Image.asset('assets/icons/google_logo.png', height: 24),
                    label: Text(
                      'Sign in with Google',
                      style: theme.textTheme.titleMedium,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.cardColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // TODO save auth data

      navigateToHomePage();
    } on FirebaseAuthException catch (e) {
      if(mounted) showSnackBar(context, "Error occurred during login: $e");
    }
  }
}