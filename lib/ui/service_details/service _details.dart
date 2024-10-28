import 'package:flutter/material.dart';
import 'package:my_health/ui/aad_reading/add_reading.dart';
import 'package:my_health/utiles/component/navigation_utiles.dart';
import 'package:my_health/utiles/constants/app_colors/app_colors.dart';

import '../show_report_screen/show_report_screen.dart';

class ServiceDetails extends StatelessWidget {
  final String image;
  final String title;
  final int id;

  const ServiceDetails(
      {super.key, required this.image, required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
actions: [],
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column
            (
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

SizedBox(height: 50,),
                  Container(
                    padding: const EdgeInsets.all(14),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: id == 1
                          ? Colors.redAccent.withOpacity(0.5)
                          : id == 2
                              ? Colors.red.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Image.asset(image)),
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
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 45,

                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor)),
                    onPressed: () {
                    NavigationUtils.push(context, AddReading(id: id));
                    },
                    child: const Center(
                      child: Text("Enter Reading"),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor)),

                    onPressed: () {
                      NavigationUtils.push(context, ShowReportScreen(id: id));

                    },
                    child: const Center(
                      child: Text("Show Report"),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
