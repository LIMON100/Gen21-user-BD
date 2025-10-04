
import '../../common/sqf_lite_key.dart';

class AddToCart {
  int id;
  String type;
  String service_name;
  String service_id;
  String name;
  String image_url;
  String price;
  String discount_price;
  String minimum_unit;
  String added_unit;

  Map toJson() => {
    'id': id,
    'service_type': type,
    'service_name': service_name,
    'e_service_id': service_id,
    'name': name,
    'image_url': image_url,
    'price': price,
    'discount_price': discount_price,
    'minimum_unit': minimum_unit,
    'added_unit': added_unit,
    // 'option_id': service_id
  };


  @override
  String toString() {
    return 'AddToCart{id: $id, type: $type, service_name: $service_name, service_id: $service_id, name: $name, image_url: $image_url, price: $price, discount_price: $discount_price, minimum_unit: $minimum_unit, added_unit: $added_unit}';
  }

  Map<String, Object> toMap() {
    var map = <String, Object>{
      SqfLiteKey.columnType: type,
      SqfLiteKey.columnServiceName: service_name,
      SqfLiteKey.columnServiceId: service_id,
      SqfLiteKey.columnName: name,
      SqfLiteKey. columnImageUrl: image_url,
      SqfLiteKey.columnPrice: price,
      SqfLiteKey.columnDiscountPrice: discount_price,
      SqfLiteKey.columnMinimumUnit: minimum_unit,
      SqfLiteKey.columnAddedUnit:added_unit,
    };
    if (id != null) {
      map[SqfLiteKey.columnId] = id;
    }
    return map;
  }

  // AddToCart();

  AddToCart({this.type, this.service_name, this.service_id, this.name, this.image_url,
      this.price, this.discount_price, this.minimum_unit, this.added_unit});

  AddToCart.fromMap(Map<String, Object> map) {
    id = map[SqfLiteKey.columnId];
    type = map[SqfLiteKey.columnType];
    service_name = map[SqfLiteKey.columnServiceName];
    service_id = map[SqfLiteKey.columnServiceId].toString();
    name = map[SqfLiteKey.columnName];
    image_url = map[SqfLiteKey.columnImageUrl];
    price = map[SqfLiteKey.columnPrice].toString();
    discount_price = map[SqfLiteKey.columnDiscountPrice].toString();
    minimum_unit = map[SqfLiteKey.columnMinimumUnit].toString();
    added_unit = map[SqfLiteKey.columnAddedUnit].toString();
  }
}
