
import '../../common/sqf_lite_key.dart';

class RequestedService {
  int id;
  String type;
  String service_name;
  String service_id;
  String name;
  String image_url;
  String price;
  String minimum_unit;
  String added_unit;
  String booking_at;


  RequestedService({this.id, this.type, this.service_name, this.service_id, this.name, this.image_url, this.price, this.minimum_unit, this.added_unit, this.booking_at});

  Map toJson() => {
    'id': id,
    'service_type': type,
    'service_name': service_name,
    'e_service_id': service_id,
    'name': name,
    'image_url': image_url,
    'price': price,
    'minimum_unit': minimum_unit,
    'added_unit': added_unit,
    'booking_at': booking_at,
    // 'option_id': service_id
  };

}
