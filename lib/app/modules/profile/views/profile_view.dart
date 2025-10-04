import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/media_model.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/phone_number_field_with_country_code_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final bool hideAppBar;

  ProfileView({this.hideAppBar = false}) {
    // controller.profileForm = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    controller.profileForm = new GlobalKey<FormState>();
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Profile".tr,
                  style: context.textTheme.headline6,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () => Get.back(),
                ),
                elevation: 0,
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    controller.saveProfileForm();
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                ),
              ),
              SizedBox(width: 10),
              MaterialButton(
                onPressed: () {
                  controller.resetProfileForm();
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.hintColor.withOpacity(0.1),
                child: Text("Reset".tr, style: Get.textTheme.bodyText2),
                elevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.profileForm,
          child: ListView(
            primary: true,
            children: [
              Text("Profile details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              Text("Change the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
              Obx(() {
                return ImageFieldWidget(
                  label: "Image".tr,
                  field: 'avatar',
                  tag: controller.profileForm.hashCode.toString(),
                  initialImage: controller.avatar.value,
                  uploadCompleted: (uuid) {
                    controller.avatar.value = new Media(id: uuid);
                  },
                  reset: (uuid) {
                    controller.avatar.value = new Media(thumb: controller.user.value.avatar.thumb);
                  },
                );
              }),
              TextFieldWidget(
                onSaved: (input) => controller.user.value.name = input,
                validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                initialValue: controller.user.value.name,
                hintText: "John Doe".tr,
                labelText: "Full Name".tr,
                iconData: Icons.person_outline,
              ),
              TextFieldWidget(
                onSaved: (input) => controller.user.value.address = input,
                validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                initialValue: controller.user.value.address,
                hintText: "123 Street, City 136, State, Country".tr,
                labelText: "Address".tr,
                iconData: Icons.map_outlined,
              ),
              TextFieldWidget(
                onSaved: (input) => controller.user.value.bio = input,
                initialValue: controller.user.value.bio,
                hintText: "Your short biography here".tr,
                labelText: "Short Biography".tr,
                iconData: Icons.article_outlined,
              ),

              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   decoration: BoxDecoration(
              //     color: Get.theme.primaryColor,
              //     borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              //     boxShadow: [
              //       BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: MaterialButton(
              //           onPressed: () {
              //             controller.saveProfileForm();
              //           },
              //           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //           color: Get.theme.colorScheme.secondary,
              //           child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
              //           elevation: 0,
              //           highlightElevation: 0,
              //           hoverElevation: 0,
              //           focusElevation: 0,
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       MaterialButton(
              //         onPressed: () {
              //           controller.resetProfileForm();
              //         },
              //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //         color: Get.theme.hintColor.withOpacity(0.1),
              //         child: Text("Reset".tr, style: Get.textTheme.bodyText2),
              //         elevation: 0,
              //         highlightElevation: 0,
              //         hoverElevation: 0,
              //         focusElevation: 0,
              //       ),
              //     ],
              //   ).paddingSymmetric(vertical: 10, horizontal: 20),
              // ),
              // Divider(height: 1,thickness: 1,color: Get.theme.colorScheme.secondary),
              TextFieldWidget(
                onSaved: (input) {
                  // print("jsndsdfsans oldEmail: ${controller.user.value.email} newEmail: $input   input !=  controller.user.value.email: ${input != controller.user.value.email}");
                  // if (input != controller.user.value.email) {
                  //   controller.isPhoneVerificationNeeded.value = true;
                  // }
                  if (input != controller.tempUser.value.email) {
                    controller.isPhoneVerificationNeeded.value = true;
                  }
                  print("jsndjfnjs tempUserEmail: ${controller.tempUser.value.phoneNumber} input: $input  input !=  controller.user.value.email: ${input != controller.user.value.phoneNumber}");

                  controller.user.value.email = input;
                },
                validator: (input) => !input.contains('@') ? "Should be a valid email" : null,
                initialValue: controller.user.value.email,
                hintText: "johndoe@gmail.com",
                labelText: "Email".tr,
                iconData: Icons.alternate_email,
              ),
              PhoneNumberFieldWithCountryCodeWidget(
                keyboardType: TextInputType.phone,
                // onSaved: (input) {
                //   // if (input.startsWith("00")) {
                //   //   input = "+" + input.substring(2);
                //   // }
                //   // print("jsndsdfsans oldPhone: ${controller.user.value.phoneNumber} newPhone: $input   input !=  controller.user.value.phoneNumber: ${input != controller.user.value.phoneNumber}");
                //   // if (input != controller.user.value.phoneNumber) {
                //   //   controller.isPhoneVerificationNeeded.value = true;
                //   // }
                //   if (input != controller.tempUser.value.phoneNumber || input != controller.tempUser.value.countryCode) {
                //     controller.isPhoneVerificationNeeded.value = true;
                //   }
                //   print("jsndjfnjs tempUserEmail: ${controller.tempUser.value.phoneNumber} input: $input  input !=  controller.user.value.email: ${input != controller.user.value.phoneNumber}");
                //   return controller.user.value.phoneNumber = input;
                // },
                onSaved: (input) {
                  // if (input.startsWith("00")) {
                  //   input = "+" + input.substring(2);
                  // }
                  if (input != controller.tempUser.value.phoneNumber ||  controller.user.value.countryCode != controller.tempUser.value.countryCode) {
                    controller.isPhoneVerificationNeeded.value = true;
                  }
                  print("jsndjfnjs tempphoneNumber: ${controller.tempUser.value.phoneNumber} input: $input  input != controller.tempUser.value.phoneNumber ${input != controller.tempUser.value.phoneNumber}  controller.user.value.countryCode != controller.tempUser.value.countryCode: ${controller.user.value.countryCode != controller.tempUser.value.countryCode}");

                  return controller.user.value.phoneNumber = input;
                },
                // validator: (input) => !input.startsWith('+') && !input.startsWith('00') ? "Phone number must start with country code!".tr : null,
                validator: (input) => input.length < 7 ? "Please enter valid phone number".tr : null,
                initialValue: controller.user.value.phoneNumber,
                hintText: "+1 223 665 7896".tr,
                labelText: "Phone number".tr,
                iconData: Icons.phone_android_outlined,
                suffix: controller.user.value.verifiedPhone
                    ? Text(
                        "Verified".tr,
                        style: Get.textTheme.caption.merge(TextStyle(color: Colors.green)),
                      )
                    : Text(
                        "Not Verified".tr,
                        style: Get.textTheme.caption.merge(TextStyle(color: Colors.redAccent)),
                      ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   decoration: BoxDecoration(
              //     color: Get.theme.primaryColor,
              //     borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              //     boxShadow: [
              //       BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: MaterialButton(
              //           onPressed: () {
              //             controller.saveProfileForm();
              //           },
              //           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //           color: Get.theme.colorScheme.secondary,
              //           child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
              //           elevation: 0,
              //           highlightElevation: 0,
              //           hoverElevation: 0,
              //           focusElevation: 0,
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       MaterialButton(
              //         onPressed: () {
              //           controller.resetProfileForm();
              //         },
              //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //         color: Get.theme.hintColor.withOpacity(0.1),
              //         child: Text("Reset".tr, style: Get.textTheme.bodyText2),
              //         elevation: 0,
              //         highlightElevation: 0,
              //         hoverElevation: 0,
              //         focusElevation: 0,
              //       ),
              //     ],
              //   ).paddingSymmetric(vertical: 10, horizontal: 20),
              // ),
              // Divider(height: 1,thickness: 1,color: Get.theme.colorScheme.secondary),

              Text("Change password".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              Text("Fill your old password and type new password and confirm it".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
              Obx(() {
                // TODO verify old password
                return TextFieldWidget(
                  labelText: "Old Password".tr,
                  hintText: "••••••••••••".tr,
                  onSaved: (input) {
                    // print("jsndsdfsans oldPassOld: ${controller.oldPassword.value} oldPassNew: $input   input !=  controller.oldPassword.value: ${input != controller.oldPassword.value}");
                    // if (input != controller.oldPassword.value) {
                    //   controller.isPhoneVerificationNeeded.value = true;
                    // }
                    if (input.length > 0) {
                      controller.isPhoneVerificationNeeded.value = true;
                    }
                    controller.oldPassword.value = input;
                  },
                  onChanged: (input) => controller.oldPassword.value = input,
                  validator: (input) => input.length > 0 && input.length < 3 ? "Should be more than 3 letters".tr : null,
                  initialValue: controller.oldPassword.value,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.hidePassword.value = !controller.hidePassword.value;
                    },
                    color: Theme.of(context).focusColor,
                    icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  ),
                  isFirst: true,
                  isLast: false,
                );
              }),
              Obx(() {
                return TextFieldWidget(
                  labelText: "New Password".tr,
                  hintText: "••••••••••••".tr,
                  onSaved: (input) {
                    // print("jsndsdfsans newPasswordOld: ${controller.newPassword.value} newPasswordNew: $input   input !=  controller.newPassword.value: ${input != controller.newPassword.value}");
                    // if (input != controller.newPassword.value) {
                    //   controller.isPhoneVerificationNeeded.value = true;
                    // }
                    if (input.length > 0) {
                      controller.isPhoneVerificationNeeded.value = true;
                    }
                    controller.newPassword.value = input;
                  },
                  onChanged: (input) {
                    if (input.length > 0) {
                      controller.isPhoneVerificationNeeded.value = true;
                    }
                    controller.newPassword.value = input;
                  },
                  validator: (input) {
                    if (input.length > 0 && input.length < 3) {
                      return "Should be more than 3 letters".tr;
                    } else if (input != controller.confirmPassword.value) {
                      return "Passwords do not match".tr;
                    } else {
                      return null;
                    }
                  },
                  initialValue: controller.newPassword.value,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isFirst: false,
                  isLast: false,
                );
              }),
              Obx(() {
                return TextFieldWidget(
                  labelText: "Confirm New Password".tr,
                  hintText: "••••••••••••".tr,
                  onSaved: (input) {
                    print("jsndsdfsans ConfirmnewPasswordOld: ${controller.confirmPassword.value} ConfirmnewPasswordNew: $input   input !=  controller.confirmPassword.value: ${input != controller.confirmPassword.value}");
                    // if (input != controller.confirmPassword.value) {
                    //   controller.isPhoneVerificationNeeded.value = true;
                    // }
                    if (input.length > 0) {
                      controller.isPhoneVerificationNeeded.value = true;
                    }
                    controller.confirmPassword.value = input;
                  },
                  onChanged: (input) {
                    if (input.length > 0) {
                      controller.isPhoneVerificationNeeded.value = true;
                    }
                    controller.confirmPassword.value = input;
                  },
                  validator: (input) {
                    if (input.length > 0 && input.length < 3) {
                      return "Should be more than 3 letters".tr;
                    } else if (input != controller.newPassword.value) {
                      return "Passwords do not match".tr;
                    } else {
                      return null;
                    }
                  },
                  initialValue: controller.confirmPassword.value,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isFirst: false,
                  isLast: true,
                );
              }),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   decoration: BoxDecoration(
              //     color: Get.theme.primaryColor,
              //     borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              //     // boxShadow: [
              //     //   BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
              //     // ],
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: MaterialButton(
              //           onPressed: () {
              //             controller.saveProfileForm();
              //           },
              //           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //           color: Get.theme.colorScheme.secondary,
              //           child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
              //           elevation: 0,
              //           highlightElevation: 0,
              //           hoverElevation: 0,
              //           focusElevation: 0,
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       MaterialButton(
              //         onPressed: () {
              //           controller.resetProfileForm();
              //         },
              //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //         color: Get.theme.hintColor.withOpacity(0.1),
              //         child: Text("Reset".tr, style: Get.textTheme.bodyText2),
              //         elevation: 0,
              //         highlightElevation: 0,
              //         hoverElevation: 0,
              //         focusElevation: 0,
              //       ),
              //     ],
              //   ).paddingSymmetric(vertical: 10, horizontal: 20),
              // )
            ],
          ),
        ));
  }
}
