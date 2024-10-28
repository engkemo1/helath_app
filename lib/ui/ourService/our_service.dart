import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/ui/login_screen/view/login_screen.dart';
import 'package:my_health/ui/service_details/service%20_details.dart';
import 'package:my_health/utiles/component/navigation_utiles.dart';
import 'package:my_health/utiles/constants/app_colors/app_colors.dart';

import '../profile_screen/profile_screen.dart';

class OurService extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  OurService({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
        backgroundColor: Colors.white,
        drawer: buildDrawer(context),
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState
                            ?.openDrawer(); // Open the drawer using GlobalKey
                      },
                      icon: Icon(Icons.menu),
                    ),
                    Image.asset(
                      "assets/icons/logo.png",
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Our Services",
                  style: TextStyle(
                    fontSize: 28,
                    // Increase font size
                    fontWeight: FontWeight.bold,
                    // Bolder weight
                    color: AppColors.greenColor,
                    // Custom color
                    letterSpacing: 1.5,
                    // Add spacing between letters
                    fontFamily: 'Roboto',
                    // Custom font family if available
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0), // Position the shadow
                        blurRadius: 3.0, // Blur the shadow
                        color: AppColors.primaryColor, // Shadow color
                      ),
                    ],
                  ),
                )
                ,
                const SizedBox(height: 40),
                CustomMonitorWidget(
                  onTap: () {
                    NavigationUtils.push(context, const ServiceDetails(
                        image: "assets/images/blood-pressure.png",
                        title: "Heartbeat Monitor",
                        id: 1));
                  },
                  imagePath: "assets/images/blood-pressure.png",
                  title: "Heartbeat Monitor",
                  size: 120,
                  backgroundColor: Colors.redAccent.withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                const Divider(),
                CustomMonitorWidget(
                  onTap: () {
                    NavigationUtils.push(context, const ServiceDetails(
                        image: "assets/images/blood_sugar.png",
                        title: "Blood Sugar Monitor",
                        id: 2));
                  },

                  imagePath: "assets/images/blood_sugar.png",
                  title: "Blood Sugar Monitor",
                  size: 130,
                  backgroundColor: Colors.red.withOpacity(0.1),
                ),
                const SizedBox(height: 20),
                const Divider(),
                CustomMonitorWidget(
                  onTap: () {        NavigationUtils.push(context, const ServiceDetails(
                      image: "assets/images/bloood.png",
                      title: "Blood Pressure Monitor",
                      id: 3));},

                  imagePath: "assets/images/bloood.png",
                  title: "Blood Pressure Monitor",
                  size: 130,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset(
            "assets/icons/logo.png",
          ),
          const SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/home-agreement.png",
              height: 35,
            ),
            title: const Text(
              'Our Services',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            onTap: () {
              Navigator.pop(context); // Closes the drawer
              // Add navigation to home page or functionality
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/about-us.png",
              height: 35,
            ),
            title: const Text('About Us',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            onTap: () {
              // Add navigation to about page
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/profile-candidate.png",
              height: 35,
            ),
            title: const Text('Profile',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const UpdateProfileScreen()));
              // Add navigation to contact page
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset(
              "assets/icons/logout.png",
              height: 35,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w600, fontSize: 16),

            ),
            onTap: () async{
              final FirebaseAuth _auth = FirebaseAuth.instance;

              // Logout Function

                try {
                  await _auth.signOut();  // Sign out the user
                  Get.offAll(() => LoginScreen());  // Navigate to the LoginScreen
                } catch (e) {
                  print('Error logging out: $e');
                }

            },
          ),
        ],
      ),
    );
  }
}

class CustomMonitorWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final double size;
  final Color backgroundColor;
  final TextStyle titleStyle;
  final void Function()? onTap;

  const CustomMonitorWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    this.size = 180, // default size
    this.backgroundColor = const Color(0x1AFF0000), // default red with opacity
    this.titleStyle =
    const TextStyle(
        fontSize: 18, fontWeight: FontWeight.w600), required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: Image.asset(imagePath)),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              // Larger font size for better readability
              fontWeight: FontWeight.bold,
              // Bold text to make it stand out
              color: Colors.black,
              // Text color
              letterSpacing: 1.2,
              // Slight letter spacing for a cleaner look
              fontFamily: 'Roboto',
              // Use custom font family if available
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0), // Add a slight shadow effect
                  blurRadius: 3.0,
                  color: Colors.black26, // Shadow color
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
