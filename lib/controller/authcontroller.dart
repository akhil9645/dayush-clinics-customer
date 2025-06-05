import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dayush_clinic/services/api_endpoints.dart';
import 'package:dayush_clinic/services/tokenstorage_Service.dart';
import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/authpages/otp_screen.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Authcontroller extends GetxController {
  Rx<bool> isPhoneSelected = true.obs;
  Rx<bool> isLoading = true.obs;
  Rx<bool> isobscured = true.obs;
  Rx<bool> isobscuredForConfirm = true.obs;
  var countdown = 300.obs;
  String? fcmtoken;
  Rx<bool> isChecked = false.obs;

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel(); // Stop timer when it reaches 0
      }
    });
  }

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
        body: jsonEncode(body),
        endpoint: 'accounts/register/',
      );

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
              builder: (context) =>
                  VerifyOtp(email: response["email"], from: 'userverify'),
            ),
          );
        } else if (response.containsKey("message") &&
            response["message"] ==
                "User successfully created. OTP sent to email.") {
          // Navigate to OTP screen for newly created user
          isLoading.value = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerifyOtp(email: response["email"], from: 'userverify'),
            ),
          );
        } else {
          isLoading.value = false;
          // Show error message if no expected response is found
          ScaffoldMessenger.of(context).showSnackBar(
            CommonWidgets().snackBarinfo(
              response["message"] ?? "Something went wrong",
            ),
          );
        }
      } else {
        log("Response is null");
        isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets().snackBarinfo("Failed to register. Please try again."),
        );
      }
    } catch (e) {
      log("Error: $e");
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets().snackBarinfo(
          "An error occurred. Please check your internet connection.",
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  userLogin(String email, String password, BuildContext context) async {
    try {
      isLoading.value = true;

      var body = {"email": email, "password": password, "fcm_token": fcmtoken};

      log('Request Body: $body');

      var response = await DioHandler.dioPOSTNoAuth(
        body: jsonEncode(body),
        endpoint: ApiEndpoints.login,
      );

      if (response != null && response['access'] != null) {
        log("Login Success: ${response.toString()}");
        isLoading.value = false;
        await TokenStorageService().storeToken(response['access']);
        await TokenStorageService().storeRefreshToken(response['refresh']);
        return true;
      } else {
        log("Login Failed: ${response.toString()}");
        isLoading.value = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CommonWidgets().snackBarinfo(response['message']));
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      log("Exception: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> validateOtp(
    String officialMailId,
    String otp,
    BuildContext context,
  ) async {
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
          CommonWidgets().snackBarinfo(
            "Something went wrong. Please try again.",
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets().snackBarinfo(
          "An error occurred. Please check your connection.",
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  forgetPassword(String emailId, BuildContext context) async {
    try {
      isLoading.value = true;
      final response = await DioHandler.dioPOSTNoAuth(
        endpoint: 'accounts/forgot-password/',
        body: json.encode({'email': emailId}),
      );

      if (response != null) {
        log(jsonEncode(response));

        if (response.containsKey("message") &&
            response["message"] == "OTP sent to your email.") {
          // ✅ Navigate to login screen on successful activation
          isLoading.value = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerifyOtp(email: emailId, from: 'forgetpass'),
            ),
          );
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
          CommonWidgets().snackBarinfo(
            "Something went wrong. Please try again.",
          ),
        );
      }
    } catch (e) {
      log("Exception : $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetPassvalidateOtp(
    String officialMailId,
    String otp,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      final response = await DioHandler.dioPOSTNoAuth(
        endpoint: 'accounts/forgot-pass-otp/',
        body: json.encode({'email': officialMailId, 'otp': otp}),
      );

      if (response != null) {
        log(jsonEncode(response));

        if (response.containsKey("message") &&
            response["message"] ==
                "OTP verified. You can now reset your password.") {
          // ✅ Navigate to login screen on successful activation
          isLoading.value = false;
          Get.toNamed(
            PageRoutes.createnewpassword,
            arguments: {'email': officialMailId},
          );
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
          CommonWidgets().snackBarinfo(
            "Something went wrong. Please try again.",
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets().snackBarinfo(
          "An error occurred. Please check your connection.",
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetResetPassword(
    String email,
    String password,
    String confirmpassword,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      final response = await DioHandler.dioPOSTNoAuth(
        endpoint: 'accounts/reset-password/',
        body: json.encode({
          'email': email,
          'new_password': password,
          'confirm_password': confirmpassword,
        }),
      );

      if (response != null) {
        log(jsonEncode(response));

        if (response.containsKey("message") &&
            response["message"] == "Password reset successfully.") {
          // ✅ Navigate to login screen on successful activation
          isLoading.value = false;
          Get.toNamed(PageRoutes.login);
        } else {
          // ❌ Show error message if OTP is invalid or another issue occurs
          isLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            CommonWidgets().snackBarinfo(
              response["message"] ?? "Something went wrong.",
            ),
          );
        }
      } else {
        isLoading.value = false;
        log("Response is null");
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets().snackBarinfo(
            "Something went wrong. Please try again.",
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets().snackBarinfo(
          "An error occurred. Please check your connection.",
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  updateFcmToken() async {
    try {
      if (fcmtoken != null && fcmtoken!.isNotEmpty) {
        var body = {"fcm_token": fcmtoken};
        var response = await DioHandler.dioPOSTWithAuth(
            endpoint: 'accounts/update-fcm-token/', body: body);
        if (response != null &&
            response['message'] == 'FCM token updated successfully.') {
          log("Update Fcm response ${response.toString()}");
        } else {
          log("Failed to update fcm token ${response.toString()}");
        }
      } else {
        log("Fcm token is empty");
      }
    } catch (e) {
      log("Exception: $e");
    }
  }
}
