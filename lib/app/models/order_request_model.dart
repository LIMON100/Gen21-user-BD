import 'package:home_services/app/models/address_model.dart';
import 'package:home_services/app/models/parents/model.dart';
class OrderRequest extends Model {
  String coupon_code;
  Address address;
  String note;
  List<dynamic> service;

  OrderRequest(String coupon_code, String note, Address address, List<dynamic> service) {
    this.coupon_code = coupon_code;
    this.note = note;
    this.address = address;
    this.service = service;
  }
  @override
  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["coupon_code"] = coupon_code;
    map["note"] = note;
    map['address'] = address;
    map["service"] = service;

    return map;
  }
}
