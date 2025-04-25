import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConsultationHistoryView extends StatelessWidget {
  const ConsultationHistoryView({super.key});

  final List<Map<String, dynamic>> appointmentList = const [
    {
      'date': '30/04/2001',
      'time': '10:40',
      'doctorName': 'Dr. Anjali Raj',
      'specialization': 'Sr Consultant-Ayurveda',
      'disease': 'Sugar',
      'isPrescriptionAvailable': true,
    },
    {
      'date': '01/05/2001',
      'time': '09:30',
      'doctorName': 'Dr. Ravi Kumar',
      'specialization': 'General Physician',
      'disease': 'Fever',
      'isPrescriptionAvailable': false,
    },
    {
      'date': '02/05/2001',
      'time': '11:15',
      'doctorName': 'Dr. Sneha Gupta',
      'specialization': 'Dermatologist',
      'disease': 'Skin Allergy',
      'isPrescriptionAvailable': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('Consultation History'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15).r,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: appointmentList.length,
          itemBuilder: (context, index) {
            final data = appointmentList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildAppointmentCard(
                date: data['date'],
                time: data['time'],
                doctorName: data['doctorName'],
                specialization: data['specialization'],
                disease: data['disease'],
                isPrescriptionAvailable: data['isPrescriptionAvailable'],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildAppointmentCard({
  required String date,
  required String time,
  required String doctorName,
  required String specialization,
  required String disease,
  required bool isPrescriptionAvailable,
}) {
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
          isPrescriptionAvailable
              ? CommonWidgets().commonbutton(
                  ontap: () {},
                  title: Text(
                    'Download Prescription',
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
