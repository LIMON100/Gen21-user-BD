
import '../../common/sqf_lite_key.dart';

class ManualOrder {
  int id;
  String type;
  String service_name;
  String service_id;
  String name;
  String image_url;
  String price;
  String minimum_unit;
  String added_unit;
  String provider_id;
  String booking_at;

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
    'provider_id': provider_id,
    'booking_at': booking_at
  };


  @override
  String toString() {
    return 'ManualOrder{id: $id, type: $type, service_name: $service_name, service_id: $service_id, name: $name, image_url: $image_url, price: $price, minimum_unit: $minimum_unit, added_unit: $added_unit, provider_id: $provider_id, booking_at: $booking_at}';
  } // Map<String, Object> toMap() {
  //   var map = <String, Object>{
  //     SqfLiteKey.columnType: type,
  //     SqfLiteKey.columnServiceName: service_name,
  //     SqfLiteKey.columnServiceId: service_id,
  //     SqfLiteKey.columnName: name,
  //     SqfLiteKey. columnImageUrl: image_url,
  //     SqfLiteKey.columnPrice: price,
  //     SqfLiteKey.columnMinimumUnit: minimum_unit,
  //     SqfLiteKey.columnAddedUnit:added_unit,
  //   };
  //   if (id != null) {
  //     map[SqfLiteKey.columnId] = id;
  //   }
  //   return map;
  // }

  // AddToCart();

  ManualOrder({this. id, this.type, this.service_name, this.service_id, this.name, this.image_url,
    this.price, this.minimum_unit, this.added_unit, this.provider_id, this.booking_at});

  // AddToCart.fromMap(Map<String, Object> map) {
  //   id = map[SqfLiteKey.columnId];
  //   type = map[SqfLiteKey.columnType];
  //   service_name = map[SqfLiteKey.columnServiceName];
  //   service_id = map[SqfLiteKey.columnServiceId].toString();
  //   name = map[SqfLiteKey.columnName];
  //   image_url = map[SqfLiteKey.columnImageUrl];
  //   price = map[SqfLiteKey.columnPrice].toString();
  //   minimum_unit = map[SqfLiteKey.columnMinimumUnit].toString();
  //   added_unit = map[SqfLiteKey.columnAddedUnit].toString();
  // }
}
