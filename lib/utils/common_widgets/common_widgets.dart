import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonWidgets {
  ElevatedButton commonbutton(
      {required String? title,
      required void Function()? ontap,
      int fontsize = 12,
      double buttonwidth = double.infinity,
      double buttonheight = 30}) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.buttoncolor,
        minimumSize: Size(buttonwidth.w, buttonheight.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8).r,
        ),
      ),
      child: Text(
        title!,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontsize.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextFormField commontextformfield(
      {TextEditingController? txtcontroller,
      String? hinttext,
      Widget? icon,
      bool? obscuretext = false,
      TextInputType? inputtype = TextInputType.text}) {
    return TextFormField(
      controller: txtcontroller,
      cursorColor: Constants.buttoncolor,
      keyboardType: inputtype,
      obscureText: obscuretext!,
      decoration: InputDecoration(
        prefixIcon: icon,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Constants.buttoncolor)),
        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  AppBar commonappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      forceMaterialTransparency: true,
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
    );
  }
}
