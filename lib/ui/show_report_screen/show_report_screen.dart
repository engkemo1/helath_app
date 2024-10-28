import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowReportScreen extends StatelessWidget {
  final int id;

  const ShowReportScreen({super.key, required this.id});

  // Method to fetch data from Firebase based on userId and widget id
  Stream<QuerySnapshot> getUserReports() {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    // Determine dataset type based on widget id
    String dataset;
    if (id == 1) {
      dataset = 'heart';
    } else if (id == 2) {
      dataset = 'blood_sugar';
    } else {
      dataset = 'diabetes';
    }

    // Query Firestore based on userId and dataset type
    return FirebaseFirestore.instance
        .collection('predictions')
        .where('userId', isEqualTo: userId)
        .where('dataset', isEqualTo: dataset) // Filter by dataset type
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          id == 1
              ? "Heartbeat Monitor"
              : id == 2
              ? "Blood Sugar Monitor"
              : "Blood Pressure Monitor",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: getUserReports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No reports available'));
            }

            // Extract data from the snapshot
            final List<QueryDocumentSnapshot> reports = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Make table scrollable
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.grey.shade200,
                ),
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Prediction Result')),
                ],
                rows: reports.map((report) {
                  final reportData = report.data() as Map<String, dynamic>;
                  final timestamp = reportData['timestamp'] as Timestamp;
                  final dateTime = timestamp.toDate();
                  final result = reportData['prediction_result'] ?? 'Unknown';

                  return DataRow(
                    cells: [
                      DataCell(Text(
                        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}",
                      )),
                      DataCell(Text(
                        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}",
                      )),
                      DataCell(Text(result)),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
