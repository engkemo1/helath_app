import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_health/ui/login_screen/view/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_health/ui/ourService/our_service.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForBiometricAuth();
    });
  }

  Future<void> _checkForBiometricAuth() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      // If user is logged in, prompt for biometric authentication
      bool isAuthenticated = await _authenticateWithBiometrics();
      if (isAuthenticated) {
        Get.off(() => OurService()); // Navigate to OurService screen
      } else {
        Get.off(() => LoginScreen()); // Navigate to LoginScreen if authentication fails
      }
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      // Check if biometric authentication is available on the device
      bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canAuthenticateWithBiometrics || !isDeviceSupported) {
        print('Biometrics not supported');
        return false;
      }

      // Check the available biometric types (face or fingerprint)
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();

      bool useFaceRecognition = availableBiometrics.contains(BiometricType.face);
      bool useFingerprint = availableBiometrics.contains(BiometricType.fingerprint);

      // Display appropriate prompt based on available biometric type
      bool authenticated = await _localAuth.authenticate(
        localizedReason: useFaceRecognition
            ? 'Please use Face Recognition to access the app'
            : 'Please use Fingerprint to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      return authenticated;
    } catch (e) {
      print('Error authenticating with biometrics: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, background: Colors.white),
        useMaterial3: false,
      ),
      home: user != null ? OurService() : LoginScreen(),
    );
  }
}
