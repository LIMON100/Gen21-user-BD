import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/constant.dart';
import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../root/controllers/root_controller.dart';

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  UserRepository _userRepository;

  // final selectedCountryCode = "${predefinedCountryCode}".obs;

  int secondsRemaining = 30;
  bool enableResend = false;
  Timer timer;
  var isTramsConditionChecked = false.obs;

  AuthController() {
    _userRepository = UserRepository();
    print("sjdnfjksa 1 in AuthController() phoneNumber: ${Get.find<AuthService>().user.value.phoneNumber} countryCode ${Get.find<AuthService>().user.value.countryCode}");
    if (!(Get.find<AuthService>().user.value.countryCode != null && Get.find<AuthService>().user.value.countryCode.length >= 3)) {
      // Get.find<AuthService>().user.value.countryCode = selectedCountryCode.value;
      Get.find<AuthService>().user.value.countryCode = predefinedCountryCode;
    }
    print("sjdnfjksa 2 in AuthController() phoneNumber: ${Get.find<AuthService>().user.value.phoneNumber} countryCode ${Get.find<AuthService>().user.value.countryCode}");
  }

  // void login() async {
  //   Get.focusScope.unfocus();
  //   if(!isTramsConditionChecked.value){
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: "Please check the Terms & Conditions first"));
  //   }
  //   else if (loginFormKey.currentState.validate()) {
  //     loginFormKey.currentState.save();
  //     loading.value = true;
  //     try {
  //       await Get.find<FireBaseMessagingService>().setDeviceToken();
  //       currentUser.value = await _userRepository.login(currentUser.value);
  //       try {
  //         await _userRepository.signInWithEmailAndPassword(
  //             currentUser.value.email, currentUser.value.apiToken);
  //       }catch(e){
  //
  //       }
  //       // await Get.find<RootController>().changePage(0);
  //       await Get.offAllNamed(Routes.ROOT, arguments: 0);
  //     } catch (e) {
  //       // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //       Get.showSnackbar(Ui.ErrorSnackBar(message: "Something Wrong! Please try again."));
  //     } finally {
  //       loading.value = false;
  //     }
  //   }
  // }
  void login() async {
    Get.focusScope.unfocus();
    if(!isTramsConditionChecked.value){
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please check the Terms & Conditions first"));
    }
    else if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        currentUser.value = await _userRepository.login(currentUser.value);
        try {
          await _userRepository.signInWithEmailAndPassword(
              currentUser.value.email, currentUser.value.apiToken);
        }catch(e){

        }

        // Check if the user has seen the onboarding screen before
        final prefs = await SharedPreferences.getInstance();
        final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

        // Navigate to the appropriate screen based on whether the user has seen the onboarding screen
        if (hasSeenOnboarding) {
          await Get.offAllNamed(Routes.ROOT, arguments: 0);
        } else {
          await Get.offAllNamed(Routes.ONBOARDING);
        }

      } catch (e) {
        // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Something Wrong! Please try again."));
      } finally {
        loading.value = false;
      }
    }
  }


  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      loading.value = true;
      try {
        print("sjdnfjksa called1");
        await _userRepository.sendCodeToPhone();
        loading.value = false;
        await Get.toNamed(Routes.PHONE_VERIFICATION);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
      await Get.find<RootController>().changePage(0);
    } catch (e) {
      // Get.back();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    try {
      await _userRepository.sendCodeToPhone();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "OTP Resend done, Please wait for the Otp".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(message: "The Password reset link has been sent to your email: ".tr + currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
}
