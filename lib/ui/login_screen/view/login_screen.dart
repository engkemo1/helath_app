import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_health/ui/ourService/our_service.dart';
import 'package:my_health/ui/register_screen/register_screen.dart';
import 'package:my_health/utiles/component/custom_button.dart';
import 'package:my_health/utiles/component/custom_clickable_Text.dart';
import 'package:my_health/utiles/component/custom_text_field.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Import Facebook Auth
import '../../../utiles/component/navigation_utiles.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePass = true;
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: nameController.text.trim(),
        password: passController.text.trim(),
      );

      if (userCredential.user != null) {
        NavigationUtils.push(context, OurService());
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'An error occurred.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Facebook login function
  Future<void> _loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Create a new credential
        final credential = FacebookAuthProvider.credential(accessToken.token);

        // Sign in to Firebase with the Facebook credential
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          NavigationUtils.push(context, OurService());
        }
      } else {
        _showError('Failed to login with Facebook.');
      }
    } catch (e) {
      _showError('Error: $e');
      print(e);

    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/icons/logo.png",
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  controller: nameController,
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  hintText: "Enter Your Email",
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  obscureText: _obscurePass,
                  controller: passController,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        _obscurePass = !_obscurePass;
                      });
                    },
                    child: Icon(
                      _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline_sharp),
                  hintText: "Enter Your Password",
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                label: "Sign In",
                onPressed: _signIn,
              ),
              const SizedBox(height: 10),
              // Add Facebook login button
              CustomButton(
                label: "Login with Facebook",
                onPressed: _loginWithFacebook,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  CustomClickableText(
                    text: ' Sign Up',
                    onTap: () {
                      NavigationUtils.push(context, RegisterScreen());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
