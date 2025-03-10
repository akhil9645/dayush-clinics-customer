import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dayush_clinic/services/api_endpoints.dart';
import 'package:dayush_clinic/utils/dio_handler.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/authpages/otp_screen.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Authcontroller extends GetxController {
  Rx<bool> isPhoneSelected = true.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isobscured = false.obs;
  Rx<bool> isobscuredForConfirm = false.obs;

  userRegistration(
    String username,
    String email,
    String password,
    String phonenumber,
    String confirmpassword,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      var body = {
        "username": username.trim(),
        "email": email.trim(),
        "password": password,
        "password_confirmation": confirmpassword,
        "phone_number": phonenumber.trim(),
      };

      var response = await DioHandler.dioPOSTNoAuth(
          body: jsonEncode(body), endpoint: 'accounts/register/');

      if (response != null) {
        log(jsonEncode(response));

        // Check response for OTP navigation
        if (response.containsKey("detail") &&
            response["detail"] ==
                "User already exists but is inactive. OTP resent to email.") {
          // Navigate to OTP screen
          isLoading.value = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyOtp(userEmail: response["email"]),
              ));
        } else if (response.containsKey("message") &&
            response["message"] ==
                "User successfully created. OTP sent to email.") {
          // Navigate to OTP screen for newly created user
          isLoading.value = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyOtp(userEmail: response["email"]),
              ));
        } else {
          isLoading.value = false;
          // Show error message if no expected response is found
          ScaffoldMessenger.of(context).showSnackBar(
            CommonWidgets()
                .snackBarinfo(response["message"] ?? "Something went wrong"),
          );
        }
      } else {
        log("Response is null");
        isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(CommonWidgets()
            .snackBarinfo("Failed to register. Please try again."));
      }
    } catch (e) {
      log("Error: $e");
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(CommonWidgets().snackBarinfo(
          "An error occurred. Please check your internet connection."));
    } finally {
      isLoading.value = false;
    }
  }

  userLogin(String email, String password, BuildContext context) async {
    try {
      isLoading.value = true;

      var body = {
        "email": email,
        "password": password,
      };

      log('Request Body: $body');

      var response = await DioHandler.dioPOSTNoAuth(
        body: jsonEncode(body),
        endpoint: ApiEndpoints.login,
      );

      if (response != null && response['access'] != null) {
        log("Login Success: ${response.toString()}");
        isLoading.value = false;
        return true;
      } else {
        log("Login Failed: ${response.toString()}");
        isLoading.value = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(CommonWidgets().snackBarinfo(response['message']));
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      log("Exception: $e");
      return false;
    }
  }

  Future<void> validateOtp(
      String officialMailId, String otp, BuildContext context) async {
    try {
      isLoading.value = true;
      final response = await DioHandler.dioPOSTNoAuth(
        endpoint: 'accounts/verify-otp/',
        body: json.encode({'email': officialMailId, 'otp': otp}),
      );

      if (response != null) {
        log(jsonEncode(response));

        if (response.containsKey("message") &&
            response["message"] == "Account successfully activated.") {
          // ✅ Navigate to login screen on successful activation
          isLoading.value = false;
          Get.toNamed(PageRoutes.login);
        } else {
          // ❌ Show error message if OTP is invalid or another issue occurs
          isLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            CommonWidgets().snackBarinfo(response["message"] ?? "Invalid OTP."),
          );
        }
      } else {
        isLoading.value = false;
        log("Response is null");
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets()
              .snackBarinfo("Something went wrong. Please try again."),
        );
      }
    } catch (e) {
      isLoading.value = false;
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets()
            .snackBarinfo("An error occurred. Please check your connection."),
      );
    }
  }
}
