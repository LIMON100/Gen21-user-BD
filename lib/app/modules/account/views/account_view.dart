import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../WebView/custom_webview.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../help_privacy/views/CombinedPage.dart';
import '../../help_privacy/views/CustomerSupportPage.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    var _currentUser = Get.find<AuthService>().user;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Account".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Get.theme.primaryColor),
            onPressed: () => {Scaffold.of(context).openDrawer()},
          ),
          elevation: 0,
          actions: [
            NotificationsButtonWidget(
              iconColor: Get.theme.primaryColor,
              labelColor: Get.theme.hintColor,
            )
          ],
        ),
        body: ListView(
          primary: true,
          children: [
            Obx(() {
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 150,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _currentUser.value.name ?? '',
                            style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                          ),
                          SizedBox(height: 10),
                          Text(_currentUser.value.email ?? '',
                              style: Get.textTheme.caption.merge(
                                  TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border:
                          Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        imageUrl: _currentUser.value.avatar?.thumb ?? '',
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                ],
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.person_outline,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Profile".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.PROFILE);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.assignment_outlined,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("My Bookings".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(1);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.notifications_outlined,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Notifications".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.NOTIFICATIONS);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.chat_outlined,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Messages".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(2);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.settings_outlined,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Settings".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS);
                    },
                  ),
                  // AccountLinkWidget(
                  //   icon: Icon(Icons.translate_outlined, color: Get.theme.colorScheme.secondary),
                  //   text: Text("Languages".tr),
                  //   onTap: (e) {
                  //     Get.toNamed(Routes.SETTINGS_LANGUAGE);
                  //   },
                  // ),
                  AccountLinkWidget(
                    icon: Icon(Icons.brightness_6_outlined,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Theme Mode".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_THEME_MODE);
                    },
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.support_outlined,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Help & FAQ".tr),
                    onTap: (e) {
                      // Get.toNamed(Routes.HELP);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CombinedPage()),
                      );
                    },
                  ),

                  AccountLinkWidget(
                    icon: Icon(Icons.sms,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Customer Support".tr),
                    onTap: (e) {
                      // Get.toNamed(Routes.HELP);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CustomerSupportPage()),
                      );
                    },
                  ),

                  AccountLinkWidget(
                    icon: Icon(Icons.logout,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Logout".tr),
                    onTap: (e) async {
                      Get.dialog(LogoutDialog());
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.delete_outline_outlined,
                        color: Get.theme.colorScheme.secondary),
                    text: Text("Delete Account".tr),
                    onTap: (e) async {
                      Get.dialog(DeleteAccountDialog());
                    },
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}

class LogoutDialog extends GetView<AccountController> {
  const LogoutDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SimpleDialog(
      titlePadding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.logout,
                      size: 24, color: Get.theme.colorScheme.primary),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Logout'.tr,
                    style: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            width: double.infinity,
            height: 1,
            color: Get.theme.colorScheme.primary,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Text(
              'Are you sure you want to logout?'.tr,
              style: TextStyle(
                  color: Get.theme.colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w200),
            ),
          ),
        ],
      ),
      children: <Widget>[
        SimpleDialogOption(
          // onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  await Get.find<AuthService>().removeCurrentUser();
                  Get.find<RootController>().changePage(0);
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.only(right: 25),
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.only(right: 25),
                  child: Text(
                    "No",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        ),
        // SimpleDialogOption(
        //   onPressed: () async {
        //     await Get.find<AuthService>().removeCurrentUser();
        //     Get.find<RootController>().changePage(0);
        //
        //   },
        //   child: Container(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text("Yes")
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class DeleteAccountDialog extends GetView<AccountController> {
  const DeleteAccountDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.delete_outline,
                      size: 24, color: Get.theme.colorScheme.primary),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Delete'.tr,
                    style: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            width: double.infinity,
            height: 1,
            color: Get.theme.colorScheme.primary,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Text(
              'Are you sure you want to delete?'.tr,
              style: TextStyle(
                  color: Get.theme.colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w200),
            ),
          ),
        ],
      ),
      children: <Widget>[
        SimpleDialogOption(
          // onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  await Get.find<AuthService>().removeCurrentUser();
                  Get.find<RootController>().changePage(0);
                  Get.back();
                  Get.toNamed(Routes.CUSTOM_WEBVIEW, arguments: {
                    "url": "https://app.gen21.com.au/delete-account", "title":"Delete Account"
                  }
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(right: 25),
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.only(right: 25),
                  child: Text(
                    "No",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        ),
        // SimpleDialogOption(
        //   onPressed: () async {
        //     await Get.find<AuthService>().removeCurrentUser();
        //     Get.find<RootController>().changePage(0);
        //
        //   },
        //   child: Container(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text("Yes")
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await canLaunch(url)) {
      throw Exception('Could not launch $url');
    } else {
      launch(url, forceWebView: true);
    }
  }
}
