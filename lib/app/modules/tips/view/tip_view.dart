import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../bookings/controllers/booking_controller_new.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../new_payment_ui/TipsPayment.dart';
import '../tip_controller.dart';


class TipsView extends GetView<BookingControllerNew> {
  const TipsView({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final TipController tipController = Get.find<TipController>();
    double tipValue = double.tryParse(tipController.tipText.toString()) ?? 0.0;
    var _booking = controller.booking;
    _booking.value.total_payable_amount = tipValue;
    return Obx(() {
      if (_booking.value.status == null) {
        return SizedBox(height: 0);
      }
      if (_booking.value.status.order == Get.find<GlobalService>().global.value.onTheWay) {
        return SizedBox(height: 0);
      } else {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Column(
              children:
              [
                SizedBox(height: 230),
                Container(
                    child: Text(
                      "Tips Amount".tr,
                      style: Get.textTheme.headline6,
                    ),
                ),
                Container(
                  child: Text(
                    _booking.value.total_payable_amount.toString(),
                    style: Get.textTheme.headline6,
                  ),
                ),
                SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.only(right: 50, left: 50),
                      child: BlockButtonWidget(
                          text: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Pay Tips".tr,
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.headline6.merge(
                                    TextStyle(color: Get.theme.primaryColor),
                                  ),
                                ),
                              ),
                              Icon(Icons.attach_money_outlined, color: Get.theme.primaryColor, size: 22)
                            ],
                          ),
                          color: Get.theme.colorScheme.secondary,
                          onPressed: () {
                            if(_booking.value.total_payable_amount > 0) {
                              // controller.initiateEway(_booking.value);
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TipsPayment(id: _booking.value.id, name: _booking.value.user.name, email: _booking.value.user.email, address: _booking.value.address.address, mobile: _booking.value.user.phoneNumber, coupon: _booking.value.coupon.toString(), amount: _booking.value.total_payable_amount.toString()),
                                ),
                              );
                            }
                            else{
                              Get.showSnackbar(Ui.ErrorSnackBar(message: "Total payable amount can't be 0!".tr));
                            }
                          }),
                    ),
              ])
        );
      }
    });
  }
}
