import 'dart:developer';

import 'package:dayush_clinic/controller/doctor_category_controller/doctor_category_controller.dart';
import 'package:dayush_clinic/controller/patient_info_controller.dart/patient_info_controller.dart';
import 'package:dayush_clinic/controller/profile_controller/profile_controller.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/utils/validation_helper.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientInfoView extends StatefulWidget {
  final dynamic arguments;
  PatientInfoView({super.key}) : arguments = Get.arguments;

  @override
  State<PatientInfoView> createState() => _PatientInfoViewState();
}

class _PatientInfoViewState extends State<PatientInfoView> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController agecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController phonenumcontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  bool checkBoxValue = false;
  final ProfileController profileController = Get.put(ProfileController());
  Map<String, dynamic>? data;
  final PatientInfoController patientInfoController =
      Get.put(PatientInfoController());
  final DoctorCategoryController doctorCategoryController =
      Get.find<DoctorCategoryController>();
  String? selectedGender = 'Male';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.getUserProfile();
    data = data = widget.arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('Patient Info'),
      body: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20).r,
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      'This patient information will be used for the prescription.',
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  )
                ],
              ),
              Constants().h10,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: checkBoxValue,
                      onChanged: (value) {
                        setState(() {
                          checkBoxValue = value ?? false;
                          if (checkBoxValue == true) {
                            namecontroller.text =
                                profileController.username.value;
                            phonenumcontroller.text =
                                profileController.phonenum.value;
                            emailcontroller.text =
                                profileController.email.value;
                          } else {
                            namecontroller.clear();
                            phonenumcontroller.clear();
                            emailcontroller.clear();
                          }
                        });
                      },
                      activeColor: Constants.buttoncolor,
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text(
                    'Same as Profile Information',
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  )
                ],
              ),
              Constants().h10,
              formHeadingTile('Patient Name'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: namecontroller,
                  validator: (p0) => ValidationHelper.nameValidation(p0 ?? ''),
                  keyboardtype: TextInputType.name,
                  hintText: 'Enter Patient Name'),
              SizedBox(height: 20.h),
              formHeadingTile('Patient Age'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: agecontroller,
                  validator: (p0) =>
                      ValidationHelper.normalValidation(p0 ?? ''),
                  keyboardtype: TextInputType.number,
                  hintText: 'Enter Patient Age'),
              SizedBox(height: 20.h),
              formHeadingTile('Patient Phone Number'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: phonenumcontroller,
                  validator: (p0) =>
                      ValidationHelper.phoneNumberValidation(p0 ?? ''),
                  keyboardtype: TextInputType.phone,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ).r,
                    child: Text(
                      '+91',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                  ),
                  hintText: 'Enter Patient Phone Number'),
              SizedBox(height: 20.h),
              formHeadingTile('Patient Email'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: emailcontroller,
                  validator: (p0) => ValidationHelper.emailValidation(p0 ?? ''),
                  keyboardtype: TextInputType.emailAddress,
                  hintText: 'Enter Patient Email'),
              SizedBox(height: 20.h),
              formHeadingTile('Patient Gender'),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        'Male',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      activeColor: Constants.buttoncolor,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        'Female',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      activeColor: Constants.buttoncolor,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Disease Description',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Text(
                    ' (Optional)',
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  )
                ],
              ),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: descriptioncontroller,
                  keyboardtype: TextInputType.text,
                  maxLines: 4,
                  hintText: 'Enter patient disease description'),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => Checkbox(
                      value: patientInfoController.isCheckedAgreement.value,
                      onChanged: (value) {
                        patientInfoController.isCheckedAgreement.value = value!;
                      },
                      activeColor: Constants.buttoncolor,
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: Constants.buttoncolor,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "I read and agree to the ",
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                                PageRoutes.termsandconditionsprivacypolicy,
                                arguments: {
                                  'appbartitle': "Terms & Conditions",
                                  'pdffilepath':
                                      "assets/pdf/privacy policy telemedicine.pdf"
                                });
                          },
                          child: Text(
                            "Terms & Conditions",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "of Dayush Clinics",
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 30).r,
        child: Obx(
          () => CommonWidgets().commonbutton(
            buttonColor: patientInfoController.isCheckedAgreement.value
                ? Constants.buttoncolor
                : Colors.grey,
            title: Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            ontap: () async {
              if (formkey.currentState!.validate() &&
                  patientInfoController.isCheckedAgreement.value) {
                var status = await patientInfoController.addPatientInfo(
                    patientAge: agecontroller.text,
                    patientName: namecontroller.text,
                    phoneNum: phonenumcontroller.text,
                    doctorId: data?['doctor']['id'],
                    email: emailcontroller.text,
                    gender: selectedGender,
                    categoryId: data?['selectedCategoryId'],
                    amount: data?['doctor']['consultation_fee'],
                    directConsultation:
                        data?['from'] == 'consultnow' ? true : false,
                    patientDescription: descriptioncontroller.text);
                if (status is int && status > 1) {
                  Get.toNamed(PageRoutes.bookappointment, arguments: {
                    'from': data?['from'],
                    'doctor': data?['doctor'],
                    'selectedCategoryId': data?['selectedCategoryId'],
                    'bookingId': status
                  });
                }
              } else if (patientInfoController.isCheckedAgreement.value ==
                  false) {
                ScaffoldMessenger.of(context).showSnackBar(CommonWidgets()
                    .snackBarinfo(
                        'Please read and accept the Terms & Conditions to continue.'));
              }
            },
          ),
        ),
      ),
    );
  }

  Row formHeadingTile(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        Text(
          '*',
          style: TextStyle(color: Color(0xFFED4713), fontSize: 14.sp),
        )
      ],
    );
  }
}
