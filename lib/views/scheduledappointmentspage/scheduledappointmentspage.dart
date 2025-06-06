import 'package:dayush_clinic/controller/consultation_history%20&%20scheduled%20appointmentsController/consultationHistoryScheduledAppointmentscontroller.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Scheduledappointmentspage extends StatefulWidget {
  const Scheduledappointmentspage({super.key});

  @override
  State<Scheduledappointmentspage> createState() =>
      _ScheduledappointmentspageState();
}

class _ScheduledappointmentspageState extends State<Scheduledappointmentspage> {
  final ConsultationController consultationController =
      Get.put(ConsultationController());
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    consultationController.getScheduledAppointments();
  }

  bool _isWithinAppointmentSlot(String appointmentDate, String timeSlot) {
    final now = DateTime.now();
    final currentDate = DateFormat('yyyy-MM-dd').format(now);

    final scheduledDate = DateFormat('yyyy-MM-dd').parse(appointmentDate);

    if (currentDate != appointmentDate) {
      return false;
    }

    final timeSlotParts = timeSlot.split('-');
    final startTimeStr = timeSlotParts[0];
    final endTimeStr = timeSlotParts[1];

    final startTime = DateFormat('HH:mm').parse(startTimeStr);
    final endTime = DateFormat('HH:mm').parse(endTimeStr);

    final appointmentStart = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      startTime.hour,
      startTime.minute,
    );
    final appointmentEnd = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      endTime.hour,
      endTime.minute,
    );

    return now.isAfter(appointmentStart) && now.isBefore(appointmentEnd);
  }

  String _formatScheduledAt(String appointmentDate, String timeSlot) {
    final parsedDate = DateFormat('yyyy-MM-dd').parse(appointmentDate);
    final formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);

    final timeSlotParts = timeSlot.split('-');
    final startTimeStr = timeSlotParts[0].trim();
    final endTimeStr = timeSlotParts[1].trim();

    final startTime = DateFormat('HH:mm').parse(startTimeStr);
    final endTime = DateFormat('HH:mm').parse(endTimeStr);

    final formattedStartTime = DateFormat('h:mm a').format(startTime);
    final formattedEndTime = DateFormat('h:mm a').format(endTime);

    return '$formattedDate, $formattedStartTime - $formattedEndTime';
  }

  // Helper methods for filtering
  bool _isToday(DateTime appointmentDate) {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;
  }

  bool _isThisWeek(DateTime appointmentDate) {
    final now = DateTime.now();
    // Find the start of the week (Sunday)
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    // Find the end of the week (Saturday)
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    return appointmentDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
        appointmentDate.isBefore(endOfWeek.add(Duration(days: 1)));
  }

  bool _isThisMonth(DateTime appointmentDate) {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
        appointmentDate.month == now.month;
  }

  bool _isOther(DateTime appointmentDate) {
    final now = DateTime.now();
    // "Other" means appointments in future months (next month or later)
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);
    return appointmentDate.isAfter(nextMonthStart.subtract(Duration(days: 1)));
  }

  // Filter the appointments based on the selected filter
  List<Map<String, dynamic>> _filterAppointments(
      List<Map<String, dynamic>> appointments) {
    if (selectedFilter == null || selectedFilter == 'Clear Filter') {
      return appointments; // Show all appointments
    }

    return appointments.where((data) {
      final appointmentDate = DateFormat('yyyy-MM-dd').parse(data['date']);
      switch (selectedFilter) {
        case 'Today':
          return _isToday(appointmentDate);
        case 'This Week':
          return _isThisWeek(appointmentDate);
        case 'This Month':
          return _isThisMonth(appointmentDate);
        case 'Other':
          return _isOther(appointmentDate);
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
          'Scheduled Appointments',
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
                : consultationController.scheduledAppointMentList.isEmpty
                    ? Center(
                        child: Text('No bookings'),
                      )
                    : () {
                        // Apply the filter to the list of appointments
                        final filteredAppointments = _filterAppointments(
                            consultationController.scheduledAppointMentList);

                        if (filteredAppointments.isEmpty) {
                          return Center(
                            child: Text('No bookings for this filter'),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final data = filteredAppointments[index];
                            final startTime =
                                DateTime.parse(data['created_at']).toLocal();
                            final formattedDate =
                                DateFormat('dd MMM yyyy').format(startTime);
                            final formattedTime =
                                DateFormat('hh:mm a').format(startTime);
                            // final showConsultNowButton =
                            //     _isWithinAppointmentSlot(
                            //         data['date'], data['time_slot']);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildAppointmentCard(
                                appointmentBookedDate: formattedDate,
                                appointmentBookedTime: formattedTime,
                                treatmentCategory: data['category_name'],
                                patientName: data['patient_name'],
                                appointmentDate: data['date'],
                                appointmentTimeSlot: data['time_slot'],
                                doctorName: data['doctor_name'],
                                doctorSpecialization:
                                    data['doctor_specialization'] ?? 'N/A',
                                disease: data['disease'],
                                // showConsultNowButton: showConsultNowButton,
                              ),
                            );
                          },
                        );
                      }(),
          )),
    );
  }

  Widget _buildAppointmentCard({
    required String appointmentBookedDate,
    required String appointmentBookedTime,
    required String patientName,
    required String treatmentCategory,
    required String appointmentDate,
    required String appointmentTimeSlot,
    required String doctorName,
    required String doctorSpecialization,
    required String disease,
    // required bool showConsultNowButton,
  }) {
    final formattedScheduledAt =
        _formatScheduledAt(appointmentDate, appointmentTimeSlot);
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
                Text(appointmentBookedDate,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12.sp)),
                Text(appointmentBookedTime,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12.sp)),
              ],
            ),
            SizedBox(height: 8),
            _buildInfoRow('Doctor : ', doctorName),
            SizedBox(height: 4),
            _buildInfoRow('Patient : ', patientName),
            SizedBox(height: 4),
            _buildInfoRow('Category : ', treatmentCategory),
            SizedBox(height: 4),
            _buildInfoRow('Specialization : ', doctorSpecialization),
            SizedBox(height: 4),
            _buildInfoRow('Disease : ', disease),
            SizedBox(height: 4),
            _buildInfoRow('Scheduled At : ', formattedScheduledAt),
            SizedBox(height: 12),
            // showConsultNowButton
            //     ? CommonWidgets().commonbutton(
            //         ontap: () {
            //           Get.toNamed(PageRoutes.videocallmainpage);
            //         },
            //         title: Text(
            //           'Consult Now',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 12.sp,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       )
            //     : SizedBox(),
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
