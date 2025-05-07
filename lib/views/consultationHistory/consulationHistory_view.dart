import 'package:dayush_clinic/controller/consultation_history%20&%20scheduled%20appointmentsController/consultationHistoryScheduledAppointmentscontroller.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ConsultationHistoryView extends StatefulWidget {
  const ConsultationHistoryView({super.key});

  @override
  State<ConsultationHistoryView> createState() =>
      _ConsultationHistoryViewState();
}

class _ConsultationHistoryViewState extends State<ConsultationHistoryView> {
  final ConsultationController consultationController =
      Get.put(ConsultationController());

  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    consultationController.getConsulationHistory();
  }

  // Helper methods for filtering based on start_time
  bool _isToday(DateTime startTime) {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  bool _isThisWeek(DateTime startTime) {
    final now = DateTime.now();
    // Find the start of the week (Sunday)
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    // Find the end of the week (Saturday)
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    return startTime.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
        startTime.isBefore(endOfWeek.add(Duration(days: 1)));
  }

  bool _isThisMonth(DateTime startTime) {
    final now = DateTime.now();
    return startTime.year == now.year && startTime.month == now.month;
  }

  bool _isOther(DateTime startTime) {
    final now = DateTime.now();
    // "Other" means consultations not in the current month (past or future months)
    return startTime.year != now.year || startTime.month != now.month;
  }

  // Filter the consultations based on the selected filter
  List<Map<String, dynamic>> _filterConsultations(
      List<Map<String, dynamic>> consultations) {
    if (selectedFilter == null || selectedFilter == 'Clear Filter') {
      return consultations; // Show all consultations
    }

    return consultations.where((data) {
      final startTime = DateTime.parse(data['start_time']).toLocal();
      switch (selectedFilter) {
        case 'Today':
          return _isToday(startTime);
        case 'This Week':
          return _isThisWeek(startTime);
        case 'This Month':
          return _isThisMonth(startTime);
        case 'Other':
          return _isOther(startTime);
        default:
          return true; // Fallback: show all
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          'Consultation History',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10.r),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12).r,
                ),
                shadowColor: Colors.black.withValues(alpha: 0.3),
              ),
            ),
            child: PopupMenuButton<String>(
              color: Colors.white,
              padding: EdgeInsets.zero,
              icon: Padding(
                padding: const EdgeInsets.only(right: 10).r,
                child: SvgPicture.asset(
                  'assets/svg/filter_icon.svg',
                  width: 35.w,
                  height: 35.h,
                ),
              ),
              onSelected: (String result) {
                setState(() {
                  if (result == 'Clear Filter') {
                    selectedFilter = null; // Clear the filter
                  } else {
                    selectedFilter = result; // Set the selected filter
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Today',
                  child: Text(
                    selectedFilter == 'Today' ? 'Today ✓' : 'Today',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'This Week',
                  child: Text(
                    selectedFilter == 'This Week' ? 'This Week ✓' : 'This Week',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'This Month',
                  child: Text(
                    selectedFilter == 'This Month'
                        ? 'This Month ✓'
                        : 'This Month',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Other',
                  child: Text(
                    selectedFilter == 'Other' ? 'Other ✓' : 'Other',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Clear Filter',
                  child: Text(
                    selectedFilter == null ? 'Clear Filter ✓' : 'Clear Filter',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15).r,
          child: Obx(
            () => consultationController.isLoading.value == true
                ? Center(
                    child: CircularProgressIndicator(
                    color: Constants.buttoncolor,
                  ))
                : consultationController.appointmentList.isEmpty
                    ? Center(
                        child: Text('No consultation History available'),
                      )
                    : () {
                        // Apply the filter to the list of consultations
                        final filteredConsultations = _filterConsultations(
                            consultationController.appointmentList);

                        if (filteredConsultations.isEmpty) {
                          return Center(
                            child: Text('No consultations for this filter'),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredConsultations.length,
                          itemBuilder: (context, index) {
                            final data = filteredConsultations[index];
                            final startTime =
                                DateTime.parse(data['start_time']).toLocal();
                            final formattedDate = DateFormat('dd MMM yyyy')
                                .format(startTime); // e.g., 29 Apr 2025
                            final formattedTime = DateFormat('hh:mm a')
                                .format(startTime); // e.g., 12:30 PM

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildAppointmentCard(
                                  date: formattedDate,
                                  time: formattedTime,
                                  amount: data['amount'],
                                  status: data['status'],
                                  patientName: data['patient_name'],
                                  categoryName: data['category_name'],
                                  doctorName: data['doctor_name'],
                                  specialization: data['category_name'],
                                  disease: data['disease_description'],
                                  isPrescriptionAvailable:
                                      data['prescription_url'] != null
                                          ? true
                                          : false),
                            );
                          },
                        );
                      }(),
          )),
    );
  }

  Widget _buildAppointmentCard({
    required String date,
    required String time,
    required String doctorName,
    required String patientName,
    required String categoryName,
    required String status,
    required String specialization,
    required String disease,
    required var amount,
    required bool isPrescriptionAvailable,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: EdgeInsets.all(16).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12.sp)),
                Text(time,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12.sp)),
              ],
            ),
            SizedBox(height: 8),
            _buildInfoRow('Doctor : ', doctorName),
            SizedBox(height: 4),
            _buildInfoRow('Patient : ', patientName),
            SizedBox(height: 4),
            _buildInfoRow('Category : ', categoryName),
            SizedBox(height: 4),
            _buildInfoRow('Specialization : ', specialization),
            SizedBox(height: 4),
            _buildInfoRow('Disease : ', disease),
            SizedBox(height: 4),
            _buildInfoRow('Amount : ', amount.toString()),
            SizedBox(height: 4),
            _buildInfoRow('Status : ', status),
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
                : _buildInfoRow(
                    'Prescription : ', 'Prescription is not yet available'),
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
          width: 90.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: value == 'Completed'
                    ? Constants.buttoncolor
                    : Colors.black),
          ),
        ),
      ],
    );
  }
}
