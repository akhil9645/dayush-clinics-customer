import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Scheduledappointmentspage extends StatelessWidget {
  const Scheduledappointmentspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar('Scheduled Appointments'),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Today:'),
                _buildAppointmentCard(
                  tab: 'SH',
                  isConsultnow: true,
                  date: '30/04/2001',
                  time: '10:40',
                  doctorName: 'Dr. Anjali Raj',
                  specialization: 'Sr Consultant-Ayurveda',
                  disease: 'Sugar',
                  isHistory: false,
                ),
                SizedBox(height: 16),
                _buildSectionTitle('Tomorrow:'),
                _buildAppointmentCard(
                  tab: 'SH',
                  isConsultnow: false,
                  date: '30/04/2001',
                  time: '10:40',
                  doctorName: 'Dr. Anjali Raj',
                  specialization: 'Sr Consultant-Ayurveda',
                  disease: 'Sugar',
                  isHistory: false,
                ),
                SizedBox(height: 16),
                _buildSectionTitle('This Week:'),
                _buildAppointmentCard(
                  tab: 'SH',
                  isConsultnow: false,
                  date: '30/04/2001',
                  time: '10:40',
                  doctorName: 'Dr. Anjali Raj',
                  specialization: 'Sr Consultant-Ayurveda',
                  disease: 'Sugar',
                  isHistory: false,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildAppointmentCard(
      {required String date,
      required String time,
      required String doctorName,
      required String specialization,
      required String disease,
      required bool isHistory,
      required String tab,
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
                      isConsultnow == true && tab == 'SH'
                          ? Get.toNamed(PageRoutes.videocallmainpage)
                          : null;
                    },
                    title: Text(
                      tab != 'CH' ? 'Consult Now' : 'Download Prescription',
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
