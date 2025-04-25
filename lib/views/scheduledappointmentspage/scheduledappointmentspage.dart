import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Scheduledappointmentspage extends StatelessWidget {
  const Scheduledappointmentspage({super.key});

  // Sample appointment list
  final List<Map<String, dynamic>> appointmentList = const [
    {
      'date': '2025-04-25',
      'time': '10:40',
      'doctorName': 'Dr. Anjali Raj',
      'specialization': 'Sr Consultant-Ayurveda',
      'disease': 'Sugar',
    },
    {
      'date': '2025-04-26',
      'time': '11:00',
      'doctorName': 'Dr. Ravi Kumar',
      'specialization': 'General Physician',
      'disease': 'Fever',
    },
    {
      'date': '2025-04-28',
      'time': '12:15',
      'doctorName': 'Dr. Sneha Gupta',
      'specialization': 'Dermatologist',
      'disease': 'Acne',
    },
    {
      'date': '2025-05-10',
      'time': '09:00',
      'doctorName': 'Dr. Neha Sharma',
      'specialization': 'Cardiologist',
      'disease': 'Hypertension',
    },
  ];

  // Grouping logic
  Map<String, List<Map<String, dynamic>>> groupAppointments(
      List<Map<String, dynamic>> appointments) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final endOfWeek = today.add(const Duration(days: 7));
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    Map<String, List<Map<String, dynamic>>> grouped = {
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'This Month': [],
      'Others': [],
    };

    for (var appointment in appointments) {
      final date = DateTime.parse(appointment['date']);
      final cleanDate = DateTime(date.year, date.month, date.day);

      if (cleanDate == today) {
        grouped['Today']!.add(appointment);
      } else if (cleanDate == tomorrow) {
        grouped['Tomorrow']!.add(appointment);
      } else if (cleanDate.isAfter(tomorrow) && cleanDate.isBefore(endOfWeek)) {
        grouped['This Week']!.add(appointment);
      } else if (cleanDate.isAfter(endOfWeek) &&
          cleanDate.isBefore(endOfMonth)) {
        grouped['This Month']!.add(appointment);
      } else {
        grouped['Others']!.add(appointment);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedAppointments = groupAppointments(appointmentList);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('Scheduled Appointments'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15).r,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupedAppointments.entries.map((entry) {
              if (entry.value.isEmpty) return const SizedBox(); // Skip empty

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('${entry.key}:'),
                  ...entry.value.map((data) {
                    final isToday = entry.key == 'Today';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildAppointmentCard(
                        isConsultnow: isToday,
                        date: data['date'],
                        time: data['time'],
                        doctorName: data['doctorName'],
                        specialization: data['specialization'],
                        disease: data['disease'],
                      ),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
      {required String date,
      required String time,
      required String doctorName,
      required String specialization,
      required String disease,
      required bool isConsultnow}) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date),
                Text(time),
              ],
            ),
            SizedBox(height: 8),
            _buildInfoRow('Doctor Name:', doctorName),
            SizedBox(height: 4),
            _buildInfoRow('Specialization:', specialization),
            SizedBox(height: 4),
            _buildInfoRow('Disease:', disease),
            SizedBox(height: 12),
            isConsultnow
                ? CommonWidgets().commonbutton(
                    ontap: () {
                      Get.toNamed(PageRoutes.videocallmainpage);
                    },
                    title: Text(
                      'Consult Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
