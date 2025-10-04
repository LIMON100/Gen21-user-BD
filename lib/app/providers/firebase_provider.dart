// import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class FirebaseProvider extends GetxService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseProvider> init() async {
    return this;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return await signUpWithEmailAndPassword(email, password);
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> verifyPhone(String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(verificationId: Get.find<AuthService>().user.value.verificationId, smsCode: smsCode);
      print("sjdnfjksa cred ${credential.toString()}");
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        print("sjdnfjksa userCredential ${userCredential.toString()}");
        Get.find<AuthService>().user.value.verifiedPhone = true;
      } on FirebaseAuthException catch (e) {
        print("sjdnfjksa error: ${e.toString()} e.code: ${e.code}");
        String error = "Unknown error occurred!";
        if (e.code == 'invalid-verification-code') {
          error = "Please enter right otp";
        }else if (e.code == "session-expired"){
          error = "The sms code has expired. Please re-send the verification code to try again.";
        }
        Get.find<AuthService>().user.value.verifiedPhone = false;
        throw Exception(error);
      }
    } catch (e) {
      print("sjdnfjksa verifyPhone() error: ${e.toString()}");
      Get.find<AuthService>().user.value.verifiedPhone = false;
      throw Exception(e.toString());
    }
  }

  Future<void> sendCodeToPhone() async {
    Get.find<AuthService>().user.value.verificationId = '';
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {};
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      Get.find<AuthService>().user.value.verificationId = verId;
    };
    final PhoneVerificationCompleted _verifiedSuccess = (AuthCredential auth) async {};
    final PhoneVerificationFailed _verifyFailed = (FirebaseAuthException e) {
      throw Exception(e.message);
    };

    print("sjdnfjksa sendingOtp ${Get.find<AuthService>().user.value.countryCode}${Get.find<AuthService>().user.value.phoneNumber}");
    await _auth.verifyPhoneNumber(
      phoneNumber: "${Get.find<AuthService>().user.value.countryCode}${Get.find<AuthService>().user.value.phoneNumber}",
      timeout: const Duration(seconds: 30),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future signOut() async {
    return await _auth.signOut();
  }
}
