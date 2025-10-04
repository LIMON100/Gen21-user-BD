import 'package:get/get.dart';
import 'media_model.dart';
import 'parents/model.dart';

class GService extends Model{
  bool success;
  Data data;
  String message;

  GService({this.success, this.data, this.message});

  GService.fromJson(Map<String, dynamic> json) {
    print("sdhbfhbash GService.fromJson ${json.toString()}");

    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data extends Model{
  String id;
  Name name;
  String color;
  Name description;
  String faq;
  int order;
  bool featured;
  int parentId;
  // List<dynamic> customFields;
  bool hasMedia;
  double price;
  double minPrice;
  double maxPrice;
  double avgRating;
  int reviewCount;
  List<EServices> eServices;
  List<Media> media;

  Data(
      {
        this.id,
        this.name,
        this.color,
        this.description,
        this.faq,
        this.order,
        this.featured,
        this.parentId,
        // this.customFields,
        this.hasMedia,
        this.price,
        this.minPrice,
        this.maxPrice,
        this.avgRating,
        this.reviewCount,
        this.eServices,
        this.media
  }
      );

  Data.fromJson(Map<String, dynamic> json) {
    print("fsjfsads Data.fromJson ${json.toString()}");
    // id = json['id'];
    id = stringFromJson(json,'id');

    print("fsjfsads id: ${json['id']}");
    name = Name.fromJson(json['name']);
    print("fsjfsads name: ${json['name']}");
    color = json['color']?? "";
    description = Name.fromJson(json['description']);
    print("fsjfsads description: ${json['description']}");

    faq = json['faq']?? "";
    print("fsjfsads faq: ${json['faq']}");

    order = json['order'];
    featured = json['featured'];
    parentId = json['parent_id'];
    // if (json['custom_fields'] != null) {
    //   customFields = <Null>[];
    //   json['custom_fields'].forEach((v) {
    //     customFields!.add(new Null.fromJson(v));
    //   });
    // }
    hasMedia = json['has_media'];
    price = doubleFromJson(json, 'price') ;

    // minPrice = json['min_price'];

    minPrice = doubleFromJson(json, 'min_price') ;
    print("sdnkjfnajk minPrice:  $minPrice doubleFromJson(json, 'min_price'): ${doubleFromJson(json, 'min_price')} ");

    // maxPrice = json['max_price'];
    maxPrice = doubleFromJson(json, 'max_price') ;
    print("sdnkjfnajk minPrice:  $maxPrice doubleFromJson(json, 'max_price'): ${doubleFromJson(json, 'max_price')} ");


    // avgRating = json['avg_rating'];
    avgRating = doubleFromJson(json, 'avg_rating') ;


    reviewCount = json['review_count'];
    if (json['e_services'] != null) {
      eServices = <EServices>[];
      json['e_services'].forEach((v) {
        eServices.add(new EServices.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['description'] = this.description;
    data['faq'] = this.faq;
    // if (this.faq != null) {
    //   data['user_id'] = this.faq;
    // }
    data['order'] = this.order;
    data['featured'] = this.featured;
    data['parent_id'] = this.parentId;
    // if (this.customFields != null) {
    //   data['custom_fields'] =
    //       this.customFields.map((v) => v.toJson()).toList();
    // }
    data['has_media'] = this.hasMedia;
    data['price'] = this.price;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['avg_rating'] = this.avgRating;
    data['review_count'] = this.reviewCount;
    if (this.eServices != null) {
      data['e_services'] = this.eServices.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EServices extends Model{
  String id;
  Name  name;
  double  price;
  double discountPrice;
  String priceUnit;
  QuantityUnit quantityUnit;
  String duration;
  Name description;
  bool featured;
  bool enableBooking;
  bool available;
  // int eProviderId;
  // List<Null>? customFields;
  bool hasMedia;
  int totalReviews;
  bool isFavorite;
  double rate;
  double minPrice;
  double maxPrice;
  bool hasSubType;
  int minimumUnit;
  // Pivot pivot;
  // EProvider eProvider;
  List<Media> media;

  EServices(
      {
        this.id,
        this.name,
        this.price,
        this.discountPrice,
        this.priceUnit,
        this.quantityUnit,
        this.duration,
        this.description,
        this.featured,
        this.enableBooking,
        this.available,
        // this.eProviderId,
        // this.customFields,
        this.hasMedia,
        this.totalReviews,
        this.isFavorite,
        this.rate,
        this.minPrice,
        this.maxPrice,
        this.hasSubType,
        this.minimumUnit,
        // this.pivot,
        // this.eProvider,
        this.media});

  EServices.fromJson(Map<String, dynamic> json) {
    print("skdmfnasjd  EServices.fromJson ${json.toString()}");
    // id = json['id'];
    id = stringFromJson(json, "id");

    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    // price = json['price'];
    price = doubleFromJson(json, "price");
    // discountPrice = json['discount_price'];
    discountPrice = doubleFromJson(json, "discount_price");

    priceUnit = json['price_unit']?? "";
    quantityUnit = json['quantity_unit'] != null
        ? new QuantityUnit.fromJson(json['quantity_unit'])
        : null;
    duration = json['duration']??"";
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    featured = json['featured'];
    enableBooking = json['enable_booking'];
    available = json['available'];
    // eProviderId = json['e_provider_id'];
    // if (json['custom_fields'] != null) {
    //   customFields = <Null>[];
    //   json['custom_fields'].forEach((v) {
    //     customFields!.add(new Null.fromJson(v));
    //   });
    // }
    hasMedia = json['has_media'];
    totalReviews = json['total_reviews'];
    isFavorite = json['is_favorite'];
    // rate = json['rate'];
    rate = doubleFromJson(json, "rate");

    // minPrice = json['min_price'];
    minPrice = doubleFromJson(json, "min_price");

    // maxPrice = json['max_price'];
    maxPrice = doubleFromJson(json, "max_prince");

    hasSubType = json['has_sub_type']?? "";

    // minimumUnit = json['minimum_unit'];
    minimumUnit = intFromJson(json, "minimumUnit");

    // pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    // eProvider = json['e_provider'] != null
    //     ? new EProvider.fromJson(json['e_provider'])
    //     : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['price_unit'] = this.priceUnit;
    if (this.quantityUnit != null) {
      data['quantity_unit'] = this.quantityUnit.toJson();
    }
    data['duration'] = this.duration;
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['featured'] = this.featured;
    data['enable_booking'] = this.enableBooking;
    data['available'] = this.available;
    // data['e_provider_id'] = this.eProviderId;
    // if (this.customFields != null) {
    //   data['custom_fields'] =
    //       this.customFields!.map((v) => v.toJson()).toList();
    // }
    data['has_media'] = this.hasMedia;
    data['total_reviews'] = this.totalReviews;
    data['is_favorite'] = this.isFavorite;
    data['rate'] = this.rate;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['has_sub_type'] = this.hasSubType;
    data['minimum_unit'] = this.minimumUnit;
    // if (this.pivot != null) {
    //   data['pivot'] = this.pivot.toJson();
    // }
    // if (this.eProvider != null) {
    //   data['e_provider'] = this.eProvider.toJson();
    // }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Name {
  String en;

  Name({this.en});

  Name.fromJson(Map<String, dynamic> json) {
    print("Name.fromJson ${json.toString()}}");
    en = json['en']?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

class QuantityUnit {
  String en;

  QuantityUnit({this.en});

  QuantityUnit.fromJson(Map<String, dynamic> json) {
    en = json['en']?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

class Pivot {
  int categoryId;
  int eServiceId;

  Pivot({this.categoryId, this.eServiceId});

  Pivot.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    eServiceId = json['e_service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['e_service_id'] = this.eServiceId;
    return data;
  }
}

// class EProvider {
//   int id;
//   Name name;
//   int eProviderTypeId;
//   Name description;
//   String phoneNumber;
//   String mobileNumber;
//   double availabilityRange;
//   bool available;
//   bool featured;
//   bool accepted;
//   // List<Null> customFields;
//   bool hasMedia;
//   double rate;
//   int totalReviews;
//   List<AvailabilityHours> availabilityHours;
//   List<Null> media;
//
//   EProvider(
//       {this.id,
//         this.name,
//         this.eProviderTypeId,
//         this.description,
//         this.phoneNumber,
//         this.mobileNumber,
//         this.availabilityRange,
//         this.available,
//         this.featured,
//         this.accepted,
//         // this.customFields,
//         this.hasMedia,
//         this.rate,
//         this.totalReviews,
//         this.availabilityHours,
//         this.media});
//
//   EProvider.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'] != null ? new Name.fromJson(json['name']) : null;
//     eProviderTypeId = json['e_provider_type_id'];
//     description = json['description'] != null
//         ? new Name.fromJson(json['description'])
//         : null;
//     phoneNumber = json['phone_number'];
//     mobileNumber = json['mobile_number'];
//     availabilityRange = json['availability_range'];
//     available = json['available'];
//     featured = json['featured'];
//     accepted = json['accepted'];
//     // if (json['custom_fields'] != null) {
//     //   customFields = <Null>[];
//     //   json['custom_fields'].forEach((v) {
//     //     customFields!.add(new Null.fromJson(v));
//     //   });
//     }
//     // hasMedia = json['has_media'];
//     // rate = json['rate'];
//     // totalReviews = json['total_reviews'];
//     // if (json['availability_hours'] != null) {
//     //   availabilityHours = <AvailabilityHours>[];
//     //   json['availability_hours'].forEach((v) {
//     //     availabilityHours!.add(new AvailabilityHours.fromJson(v));
//     //   });
//     // }
//     // if (json['media'] != null) {
//     //   media = <Null>[];
//     //   json['media'].forEach((v) {
//     //     media!.add(new Null.fromJson(v));
//     //   });
//     // }
//   // }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     if (this.name != null) {
//       data['name'] = this.name.toJson();
//     }
//     data['e_provider_type_id'] = this.eProviderTypeId;
//     if (this.description != null) {
//       data['description'] = this.description.toJson();
//     }
//     data['phone_number'] = this.phoneNumber;
//     data['mobile_number'] = this.mobileNumber;
//     data['availability_range'] = this.availabilityRange;
//     data['available'] = this.available;
//     data['featured'] = this.featured;
//     data['accepted'] = this.accepted;
//     // if (this.customFields != null) {
//     //   data['custom_fields'] =
//     //       this.customFields!.map((v) => v.toJson()).toList();
//     // }
//     data['has_media'] = this.hasMedia;
//     data['rate'] = this.rate;
//     data['total_reviews'] = this.totalReviews;
//     if (this.availabilityHours != null) {
//       data['availability_hours'] =
//           this.availabilityHours.map((v) => v.toJson()).toList();
//     }
//     // if (this.media != null) {
//     //   data['media'] = this.media.map((v) => v.toJson()).toList();
//     // }
//     return data;
//   }
// }

class AvailabilityHours {
  int id;
  String day;
  String startAt;
  String endAt;
  Name data;
  int eProviderId;
  List<Null> customFields;

  AvailabilityHours(
      {this.id,
        this.day,
        this.startAt,
        this.endAt,
        this.data,
        this.eProviderId,
        this.customFields});

  AvailabilityHours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    data = json['data'] != null ? new Name.fromJson(json['data']) : null;
    eProviderId = json['e_provider_id'];
    // if (json['custom_fields'] != null) {
    //   customFields = <Null>[];
    //   json['custom_fields'].forEach((v) {
    //     customFields!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['e_provider_id'] = this.eProviderId;
    // if (this.customFields != null) {
    //   data['custom_fields'] =
    //       this.customFields!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Media extends Model{
  String id;
  String modelType;
  int modelId;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  int size;
  List<Null> manipulations;
  // CustomProperties customProperties;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  Media(
      {this.id,
        this.modelType,
        this.modelId,
        this.collectionName,
        this.name,
        this.fileName,
        this.mimeType,
        this.disk,
        this.size,
        this.manipulations,
        // this.customProperties,
        this.url,
        this.thumb,
        this.icon,
        this.formatedSize});

  Media.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    modelType = json['model_type'];
    modelId = intFromJson(json, 'id');
    collectionName = json['collection_name'];
    name = json['name'];
    fileName = json['file_name'];
    mimeType = json['mime_type'];
    disk = json['disk'];
    size = intFromJson(json, 'size');
    // if (json['manipulations'] != null) {
    //   manipulations = <Null>[];
    //   json['manipulations'].forEach((v) {
    //     manipulations.add(new Null.fromJson(v));
    //   });
    // }
    // customProperties = json['custom_properties'] != null
    //     ? new CustomProperties.fromJson(json['custom_properties'])
    //     : null;
    url = json['url'];
    thumb = json['thumb'];
    icon = json['icon'];
    formatedSize = json['formated_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['collection_name'] = this.collectionName;
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['mime_type'] = this.mimeType;
    data['disk'] = this.disk;
    data['size'] = this.size;
    // if (this.manipulations != null) {
    //   data['manipulations'] =
    //       this.manipulations.map((v) => v.toJson()).toList();
    // }
    // if (this.customProperties != null) {
    //   data['custom_properties'] = this.customProperties!.toJson();
    // }
    data['url'] = this.url;
    data['thumb'] = this.thumb;
    data['icon'] = this.icon;
    data['formated_size'] = this.formatedSize;
    return data;
  }

}
 double checkDouble(dynamic value) {
if (value is int) {
return value.toDouble();
} else {
return value;
}
}



// class CustomProperties {
//   String? uuid;
//   int? userId;
//   GeneratedConversions? generatedConversions;
//
//   CustomProperties({this.uuid, this.userId, this.generatedConversions});
//
//   CustomProperties.fromJson(Map<String, dynamic> json) {
//     uuid = json['uuid'];
//     userId = json['user_id'];
//     generatedConversions = json['generated_conversions'] != null
//         ? new GeneratedConversions.fromJson(json['generated_conversions'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['uuid'] = this.uuid;
//     data['user_id'] = this.userId;
//     if (this.generatedConversions != null) {
//       data['generated_conversions'] = this.generatedConversions!.toJson();
//     }
//     return data;
//   }
// }
//
// class GeneratedConversions {
//   bool? thumb;
//   bool? icon;
//
//   GeneratedConversions({this.thumb, this.icon});
//
//   GeneratedConversions.fromJson(Map<String, dynamic> json) {
//     thumb = json['thumb'];
//     icon = json['icon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['thumb'] = this.thumb;
//     data['icon'] = this.icon;
//     return data;
//   }
// }


