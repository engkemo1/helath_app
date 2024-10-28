import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_health/utiles/component/custom_drop_down_search.dart';
import 'package:my_health/utiles/component/custom_text_field.dart';
import 'package:my_health/utiles/constants/app_colors/app_colors.dart';

class AddReading extends StatefulWidget {
  final int id;

  AddReading({super.key, required this.id});

  @override
  State<AddReading> createState() => _AddReadingState();
}

class _AddReadingState extends State<AddReading> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? _selectedOption = "Yes"; // Initial value
  String? _selectedOption2 = "Yes"; // Initial value
  String? _selectedOption3 = "Yes"; // Initial value
  TextEditingController systoleController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController diastoleController = TextEditingController(); // Use for diastole
  var selectedItem;

  bool isLoading = false; // Loading state

  // Function to save the data to Firebase
  Future<void> saveDataToFirebase(Map<String, dynamic> data, String result) async {
    try {
      await FirebaseFirestore.instance.collection('predictions').add({
        ...data,
        'prediction_result': result,
        "userId": FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _showError("Failed to save data to Firebase: $e");
    }
  }

  // Modified function to handle prediction and Firebase saving
  Future<void> sendPredictionRequest() async {
    setState(() {
      isLoading = true; // Start loading
    });

    final url = Uri.parse('http://192.168.1.54:5000/predict');
    Map<String, dynamic> data = {};

    if (widget.id == 1) {
      data = {
        "dataset": "heart",
        "age_category": 1,
        "gender": 1,
        "exercised_morning": _selectedOption3 == 'Yes' ? 1 : 0,
        "exercised_night": 0,
        "morning_heart_reading": selectedItem == "Morning" ? int.parse(heartRateController.text) : 108,
        "night_heart_reading": selectedItem == "Night" ? int.parse(heartRateController.text) : 108,
        "manipulated": 1
      };
    } else if (widget.id == 2) {
      data = {
        "dataset": "blood_sugar",
        "age": 24,
        "gender": 0,
        "fasting_morning": _selectedOption == 'Yes' ? 1 : 0,
        "fasting_night": _selectedOption2 == 'Yes' ? 1 : 0,
        "exercised_morning": _selectedOption3 == 'Yes' ? 1 : 0,
        "exercised_night": 0,
        "sugar_consumed_morning": 1,
        "sugar_consumed_night": 0,
        "morning_sugar_reading": selectedItem == "Morning" ? int.parse(heartRateController.text) : 120,
        "night_sugar_reading": selectedItem == "Night" ? int.parse(heartRateController.text) : 120,
        "manipulated": 0
      };
    } else if (widget.id == 3) {
      data = {
        "dataset": "diabetes",
        "age": 30,
        "morning_pressure_systole": selectedItem == "Morning" ? double.parse(systoleController.text) : 120,
        "morning_pressure_diastole": selectedItem == "Morning" ? double.parse(diastoleController.text) : 80,
        "exercised_morning": _selectedOption3 == 'Yes' ? 1 : 0,
        "exercised_night": 0,
        "night_pressure_systole": selectedItem == "Night" ? double.parse(systoleController.text) : 120,
        "night_pressure_diastole": selectedItem == "Night" ? double.parse(diastoleController.text) : 80, // Fixed
        "gender": 1,
        "manipulated": 0
      };
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var result ;
        if(widget.id==1){
     result=     jsonDecode(response.body)['heart_disease_risk'];
        }else if(widget .id ==3){
          result=     jsonDecode(response.body)['diabetes_risk'];

        }else if(widget .id ==2){
          result=     jsonDecode(response.body)['blood_sugar_risk'];

        }
        print(result);
        _showPredictionResult(result);

        // Save input data and result to Firebase
        await saveDataToFirebase(data, result);
      } else {
        _showError("Failed to get prediction");
      }
    } catch (e) {
      _showError("Error: $e");
      print(e);
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  // Show result in a dialog
  void _showPredictionResult(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          title: const Text("Prediction Result"),
          content: Text("Your Result is: $result"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show error in a dialog
  void _showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: widget.id == 1
                                ? Colors.redAccent.withOpacity(0.5)
                                : widget.id == 2
                                ? Colors.red.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Image.asset(widget.id == 1
                                  ? "assets/images/blood-pressure.png"
                                  : widget.id == 2
                                  ? "assets/images/blood_sugar.png"
                                  : "assets/images/bloood.png")),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.id == 1
                              ? "Heartbeat Monitor"
                              : widget.id == 2
                              ? "Blood Sugar Monitor"
                              : "Blood Pressure Monitor",
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
                                offset: Offset(2.0, 2.0),
                                // Add a slight shadow effect
                                blurRadius: 3.0,
                                color: Colors.black26, // Shadow color
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomDropdown(
                        items: const ["Morning", "Night"],
                        selectedItem: selectedItem,
                        onChanged: (value) {
                          setState(() {
                            selectedItem = value;
                          });
                        },
                        hint: "Select the time you read from the device",
                        labelText: "Please select the time you read from the device:",
                        hasSearch: false,
                        itemHeight: 110),
                    const SizedBox(
                      height: 20,
                    ),
                    if(widget.id==3)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Are You suffering from high blood pressure ?",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text('Yes'),
                                  leading: Radio<String>(
                                    value: "Yes",
                                    groupValue: _selectedOption,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('No'),
                                  leading: Radio<String>(
                                    value: "No",
                                    groupValue: _selectedOption,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if(widget.id==2)

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Are you Fasting ?",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text('Yes'),
                                  leading: Radio<String>(
                                    value: "Yes",
                                    groupValue: _selectedOption,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('No'),
                                  leading: Radio<String>(
                                    value: "No",
                                    groupValue: _selectedOption,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "Did you eat Sugar ?",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text('Yes'),
                                  leading: Radio<String>(
                                    value: "Yes",
                                    groupValue: _selectedOption2,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption2 = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('No'),
                                  leading: Radio<String>(
                                    value: "No",
                                    groupValue: _selectedOption2,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption2 = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Did you make any physical effort ?",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: const Text('Yes'),
                                leading: Radio<String>(
                                  value: "Yes",
                                  groupValue: _selectedOption3,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption3 = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: const Text('No'),
                                leading: Radio<String>(
                                  value: "No",
                                  groupValue: _selectedOption3,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption3 = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (widget.id == 1)
                      CustomTextField(
                        controller: heartRateController,
                        hintText: "Heart rate reading",
                        labelText: "Enter heart rate reading",
                      )
                    else if (widget.id == 2)
                      CustomTextField(
                        controller: heartRateController,
                        hintText: "Sugar reading",
                        labelText: "Enter the sugar reading",
                      )
                    else
                      Column(
                        children: [
                          CustomTextField(
                            controller: systoleController,
                            hintText: "Systole reading",
                            labelText: "Enter pressure systole reading",
                          ),
                          CustomTextField(
                            controller: diastoleController, // Correct controller
                            hintText: "Diastole reading",
                            labelText: "Enter pressure diastole reading",
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    isLoading?
                      const Center(
                        child: CircularProgressIndicator(),
                      ):
                    ElevatedButton(
                      onPressed: sendPredictionRequest,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                      ),
                      child: const Text("Get Result"),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
