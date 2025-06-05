import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonWidgets {
  ElevatedButton commonbutton(
      {required Widget? title,
      required void Function()? ontap,
      int fontsize = 12,
      Color buttonColor = Constants.buttoncolor,
      double buttonwidth = double.infinity,
      double buttonheight = 30}) {
    return ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: buttonColor,
          minimumSize: Size(buttonwidth.w, buttonheight.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8).r,
          ),
        ),
        child: title);
  }

  TextFormField commonTextfield(
      {TextEditingController? textController,
      String? hintText,
      TextInputType keyboardtype = TextInputType.text,
      Color bordercolor = Colors.grey,
      int maxLines = 1,
      bool readOnly = false,
      Color errorBorderColor = const Color(0xFFFF4D4F),
      String? Function(String?)? validator,
      Widget? prefixIcon,
      Widget? suffixIcon,
      bool? obsureText = false,
      Function(String)? onchanged}) {
    return TextFormField(
      keyboardType: keyboardtype,
      readOnly: readOnly,
      controller: textController,
      maxLines: maxLines,
      obscureText: obsureText!,
      validator: validator,
      onChanged: onchanged,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0, // Top and Bottom padding
          horizontal: 20.0, // Left and Right padding
        ).r,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0).r, // Radius as specified
          borderSide: BorderSide(
            color: bordercolor, // Grey border color
            width: 1.0.w, // Border width
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0).r,
          borderSide: BorderSide(
            color: bordercolor, // Grey color on focus
            width: 1.0.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0).r,
          borderSide: BorderSide(
            color: bordercolor, // Grey color when not focused
            width: 1.0.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: errorBorderColor,
            width: 1.w,
          ),
        ),
      ),
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
    );
  }

  AppBar commonappbar(
    String title,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      forceMaterialTransparency: true,
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
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
    );
  }

  SnackBar snackBarinfo(String content, {Color color = Colors.red}) {
    return SnackBar(
      duration: Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            content,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
