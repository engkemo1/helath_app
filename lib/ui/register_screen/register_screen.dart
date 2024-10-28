import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:my_health/ui/login_screen/view/login_screen.dart';
import 'package:my_health/utiles/component/custom_button.dart';
import 'package:my_health/utiles/component/custom_clickable_Text.dart';
import 'package:my_health/utiles/component/custom_drop_down_search.dart';
import 'package:my_health/utiles/component/custom_text_field.dart';
import 'package:my_health/utiles/component/navigation_utiles.dart';

import '../ourService/our_service.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emergencyPhoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _obscurePass = true;
  bool _isLoading = false; // Loading state
  String? selectedItem;



  Future<void> _facebookLogin() async {
  setState(() {
  _isLoading = true; // Show loading indicator
  });

  try {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  if (loginResult.status == LoginStatus.success) {
  // Create a credential from the access token
  final AccessToken accessToken = loginResult.accessToken!;
  final OAuthCredential credential =
  FacebookAuthProvider.credential(accessToken.token);

  // Sign in to Firebase with the Facebook credential
  final UserCredential userCredential =
  await _auth.signInWithCredential(credential);

  if (userCredential.user != null) {
  // Save the user data to Firestore
  await _saveUserData(userCredential.user!);

  // Navigate to the next screen (e.g., OurService)
  NavigationUtils.push(context, OurService());
  }
  } else {
  _showError('Facebook login failed: ${loginResult.message}');
  }
  } catch (e) {
  _showError('An error occurred: $e');
  print(e);
  } finally {
  setState(() {
  _isLoading = false; // Hide loading indicator
  });
  }
  }

  bool _validatePassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.*[0-9])(?=.{8,})',
    );
    return passwordRegExp.hasMatch(password);
  }


  Future<void> _signUp() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Check if the password is valid
    if (!_validatePassword(passController.text.trim())) {
      _showError('Password must be at least 8 characters, contain one uppercase letter, one number, and one special character.');
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      return;
    }

    try {
      // Create a new user with Firebase Authentication
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      if (userCredential.user != null) {
        // Save the user data to Firestore
        await _saveUserData(userCredential.user!);

        // Navigate to another screen (e.g., OurService)
        NavigationUtils.push(context, OurService());
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'An error occurred.');
      print(e.message);
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _saveUserData(User user) async {
    // Save the user details to Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': nameController.text.trim(),
      'age': int.tryParse(ageController.text.trim()) ?? 0,
      'email': user.email,
      'phone': phoneController.text.trim(),
      'emergencyPhone': emergencyPhoneController.text.trim(),
      'weight': double.tryParse(weightController.text.trim()) ?? 0.0,
      'height': double.tryParse(heightController.text.trim()) ?? 0.0,
      'gender': selectedItem,
      'createdAt': DateTime.now(),
      'profileImageUrl': null,
    });
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
                height: MediaQuery.of(context).size.height * 0.1,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),
              const Text(
                "Sign up",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: CustomTextField(
                  controller: nameController,
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  hintText: "Enter Your Name",
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: CustomTextField(
                  controller: ageController,
                  prefixIcon: const Icon(Icons.man_4_rounded),
                  hintText: "Enter Your Age",
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: CustomTextField(
                  controller: emailController,
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "Enter Your Email",
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: CustomTextField(
                  controller: passController,
                  prefixIcon: const Icon(Icons.password),
                  hintText: "Enter Your Password",
                  obscureText: _obscurePass,
                  suffixIcon: _obscurePass==false?IconButton(onPressed: (){
                    setState(() {
                      _obscurePass=!_obscurePass;
                    });
                  }, icon: Icon(Icons.visibility)):IconButton(onPressed: (){
                    setState(() {
                      _obscurePass=!_obscurePass;
                    });
                  }, icon: Icon(Icons.visibility_off_outlined)),
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: CustomTextField(
                  controller: phoneController,
                  prefixIcon: const Icon(Icons.phone_android),
                  hintText: "Enter Your Phone Number",
                  keyboardType: TextInputType.phone,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: CustomTextField(
                  controller: emergencyPhoneController,
                  prefixIcon: const Icon(Icons.phone_in_talk),
                  hintText: "Emergency Contact phone number",
                  keyboardType: TextInputType.phone,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                      child: CustomTextField(
                        controller: weightController,
                        prefixIcon: const Icon(Icons.line_weight_outlined, color: Colors.grey),
                        hintText: "Weight",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                      child: CustomTextField(
                        controller: heightController,
                        prefixIcon: const Icon(Icons.height),
                        hintText: "Height",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: CustomDropdown(
                  items: const ["Male", "Female"],
                  selectedItem: selectedItem,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                  hint: "Gender",
                  labelText: "",
                  hasSearch: false,
                  itemHeight: 100,
                ),
              ),
              const SizedBox(height: 40),
              // Show loading indicator when signing up
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(label: "Sign Up", onPressed: _signUp),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              //   child: CustomButton(
              //     label: "Sign Up with Facebook",
              //     onPressed: _facebookLogin,
              //   ),
              // ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  CustomClickableText(
                    text: ' Sign In',
                    onTap: () {
                      NavigationUtils.push(context, LoginScreen());
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
