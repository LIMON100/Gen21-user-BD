import 'package:get/get.dart';

import 'parents/model.dart';

class Providers extends Model{
  bool success;
  List<Data> data;
  String message;

  Providers({this.success, this.data, this.message});

  Providers.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data extends Model{
  String id;
  Name name;
  // double price;
  // double discountPrice;
  // String priceUnit;
  // int minimumUnit;
  // QuantityUnit quantityUnit;
  String duration;
  String subtypeHeading;
  Name description;
  String faq;
  bool featured;
  bool enableBooking;
  bool available;
  String eProviderId;
  bool hasMedia;
  int totalReviews;
  bool isFavorite;
  double rate;
  // double minPrice;
  // double maxPrice;
  bool hasSubType;
  List<EProvider> eProvider;
  var selectedIndex = "-1".obs;

  Data(
      {this.id,
        this.name,
        // this.price,
        // this.discountPrice,
        // this.priceUnit,
        // this.minimumUnit,
        // this.quantityUnit,
        this.duration,
        this.subtypeHeading,
        this.description,
        this.faq,
        this.featured,
        this.enableBooking,
        this.available,
        this.eProviderId,
        this.hasMedia,
        this.totalReviews,
        this.isFavorite,
        this.rate,
        // this.minPrice,
        // this.maxPrice,
        this.hasSubType,
        this.eProvider});

  Data.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = stringFromJson(json, 'id');
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    // price = doubleFromJson(json, 'price');
    // discountPrice = doubleFromJson(json, 'discount_price');
    // priceUnit = stringFromJson(json, 'price_unit');
    // minimumUnit = intFromJson(json, 'minimum_unit');
    // quantityUnit = json['quantity_unit'] != null
    //     ? new QuantityUnit.fromJson(json['quantity_unit'])
    //     : null;
    duration = json['duration'];
    subtypeHeading = json['subtype_heading'];
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    faq = json['faq'];
    featured = json['featured'];
    enableBooking = json['enable_booking'];
    available = json['available'];
    eProviderId = stringFromJson(json, 'e_provider_id');

    hasMedia = json['has_media'];
    totalReviews = intFromJson(json, 'total_reviews');
    isFavorite = json['is_favorite'];
    rate = doubleFromJson(json, 'rate');
    // minPrice = doubleFromJson(json, 'min_price');
    // maxPrice = doubleFromJson(json, 'max_price');
    hasSubType = json['has_sub_type'];
    if (json['e_provider'] != null) {
      eProvider = <EProvider>[];
      json['e_provider'].forEach((v) {
        eProvider.add(new EProvider.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    // data['price'] = this.price;
    // data['discount_price'] = this.discountPrice;
    // data['price_unit'] = this.priceUnit;
    // data['minimum_unit'] = this.minimumUnit;
    // if (this.quantityUnit != null) {
    //   data['quantity_unit'] = this.quantityUnit.toJson();
    // }
    data['duration'] = this.duration;
    data['subtype_heading'] = this.subtypeHeading;
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['faq'] = this.faq;
    data['featured'] = this.featured;
    data['enable_booking'] = this.enableBooking;
    data['available'] = this.available;
    data['e_provider_id'] = this.eProviderId;

    data['has_media'] = this.hasMedia;
    data['total_reviews'] = this.totalReviews;
    data['is_favorite'] = this.isFavorite;
    data['rate'] = this.rate;
    // data['min_price'] = this.minPrice;
    // data['max_price'] = this.maxPrice;
    data['has_sub_type'] = this.hasSubType;
    if (this.eProvider != null) {
      data['e_provider'] = this.eProvider.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Name {
  String en;

  Name({this.en});

  Name.fromJson(Map<String, dynamic> json) {
    en = json['en'];
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
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

class EProvider extends Model{
  String id;
  Name name;
  int eProviderTypeId;
  Name description;
  String phoneNumber;
  String mobileNumber;
  double availabilityRange;
  bool available;
  bool featured;
  bool accepted;
  bool hasMedia;
  double rate;
  int totalReviews;
  List<Users> users;
  List<AvailabilityHours> availabilityHours;
  List<Media> media;

  EProvider(
      {this.id,
        this.name,
        this.eProviderTypeId,
        this.description,
        this.phoneNumber,
        this.mobileNumber,
        this.availabilityRange,
        this.available,
        this.featured,
        this.accepted,
        this.hasMedia,
        this.rate,
        this.totalReviews,
        this.users,
        this.availabilityHours,
        this.media});


  @override
  String toString() {
    return 'EProvider{id: $id, name: $name, eProviderTypeId: $eProviderTypeId, description: $description, phoneNumber: $phoneNumber, mobileNumber: $mobileNumber, availabilityRange: $availabilityRange, available: $available, featured: $featured, accepted: $accepted, hasMedia: $hasMedia, rate: $rate, totalReviews: $totalReviews, users: $users, availabilityHours: $availabilityHours, media: $media}';
  }

  EProvider.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = stringFromJson(json, 'id');
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    eProviderTypeId = intFromJson(json, 'e_provider_type_id');
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    phoneNumber = json['phone_number'];
    mobileNumber = json['mobile_number'];
    availabilityRange = doubleFromJson(json, 'availability_range');
    available = json['available'];
    featured = json['featured'];
    accepted = json['accepted'];
    hasMedia = json['has_media'];
    rate = doubleFromJson(json, 'rate');
    totalReviews = intFromJson(json, 'total_reviews');
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    if (json['availability_hours'] != null) {
      availabilityHours = <AvailabilityHours>[];
      json['availability_hours'].forEach((v) {
        availabilityHours.add(new AvailabilityHours.fromJson(v));
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
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['e_provider_type_id'] = this.eProviderTypeId;
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['availability_range'] = this.availabilityRange;
    data['available'] = this.available;
    data['featured'] = this.featured;
    data['accepted'] = this.accepted;
    data['has_media'] = this.hasMedia;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.availabilityHours != null) {
      data['availability_hours'] =
          this.availabilityHours.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int id;
  String name;
  String email;
  String phoneNumber;
  String stripeId;
  String cardBrand;
  String cardLastFour;
  String trialEndsAt;
  String paypalEmail;
  String createdAt;
  String updatedAt;
  // CustomFields customFields;
  bool hasMedia;
  List<Media> media;


  @override
  String toString() {
    return 'Users{id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, stripeId: $stripeId, cardBrand: $cardBrand, cardLastFour: $cardLastFour, trialEndsAt: $trialEndsAt, paypalEmail: $paypalEmail, createdAt: $createdAt, updatedAt: $updatedAt,  hasMedia: $hasMedia, media: $media}';
  }

  Users(
      {this.id,
        this.name,
        this.email,
        this.phoneNumber,
        this.stripeId,
        this.cardBrand,
        this.cardLastFour,
        this.trialEndsAt,
        this.paypalEmail,
        this.createdAt,
        this.updatedAt,
        // this.customFields,
        this.hasMedia,
        this.media});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    stripeId = json['stripe_id'];
    cardBrand = json['card_brand'];
    cardLastFour = json['card_last_four'];
    trialEndsAt = json['trial_ends_at'];
    paypalEmail = json['paypal_email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // customFields = json['custom_fields'] != null
    //     ? new CustomFields.fromJson(json['custom_fields'])
    //     : null;
    hasMedia = json['has_media'];
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
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['stripe_id'] = this.stripeId;
    data['card_brand'] = this.cardBrand;
    data['card_last_four'] = this.cardLastFour;
    data['trial_ends_at'] = this.trialEndsAt;
    data['paypal_email'] = this.paypalEmail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    // if (this.customFields != null) {
    //   data['custom_fields'] = this.customFields.toJson();
    // }
    data['has_media'] = this.hasMedia;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomFields {
  Bio bio;
  Bio address;

  CustomFields({this.bio, this.address});

  CustomFields.fromJson(Map<String, dynamic> json) {
    bio = json['bio'] != null ? new Bio.fromJson(json['bio']) : null;
    address =
    json['address'] != null ? new Bio.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bio != null) {
      data['bio'] = this.bio.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Bio {
  String value;
  String view;
  String name;

  Bio({this.value, this.view, this.name});

  Bio.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    view = json['view'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['view'] = this.view;
    data['name'] = this.name;
    return data;
  }
}

class Media extends Model{
  String id;
  String name;
  String fileName;
  String mimeType;
  String disk;
  String size;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  Media(
      {this.id,
        this.name,
        this.fileName,
        this.mimeType,
        this.disk,
        this.size,
        this.url,
        this.thumb,
        this.icon,
        this.formatedSize});

  Media.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    name = json['name'];
    fileName = json['file_name'];
    mimeType = json['mime_type'];
    disk = json['disk'];
    size =  stringFromJson(json, 'size');
    url = json['url'];
    thumb = json['thumb'];
    icon = json['icon'];
    formatedSize =  stringFromJson(json, 'formated_size');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['mime_type'] = this.mimeType;
    data['disk'] = this.disk;
    data['size'] = this.size;
    data['url'] = this.url;
    data['thumb'] = this.thumb;
    data['icon'] = this.icon;
    data['formated_size'] = this.formatedSize;
    return data;
  }
}

class AvailabilityHours {
  int id;
  String day;
  String startAt;
  String endAt;
  Name data;
  int eProviderId;

  AvailabilityHours(
      {this.id,
        this.day,
        this.startAt,
        this.endAt,
        this.data,
        this.eProviderId
      }
      );

  AvailabilityHours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    data = json['data'] != null ? new Name.fromJson(json['data']) : null;
    eProviderId = json['e_provider_id'];

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
    return data;
  }
}

// class Media {
//   int id;
//   String modelType;
//   String modelId;
//   String collectionName;
//   String name;
//   String fileName;
//   String mimeType;
//   String disk;
//   String size;
//   CustomProperties customProperties;
//   String url;
//   String thumb;
//   String icon;
//   String formatedSize;
//
//   Media(
//       {this.id,
//         this.modelType,
//         this.modelId,
//         this.collectionName,
//         this.name,
//         this.fileName,
//         this.mimeType,
//         this.disk,
//         this.size,
//         this.customProperties,
//         this.url,
//         this.thumb,
//         this.icon,
//         this.formatedSize});
//
//   Media.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modelType = json['model_type'];
//     modelId = json['model_id'];
//     collectionName = json['collection_name'];
//     name = json['name'];
//     fileName = json['file_name'];
//     mimeType = json['mime_type'];
//     disk = json['disk'];
//     size = json['size'];
//
//     customProperties = json['custom_properties'] != null
//         ? new CustomProperties.fromJson(json['custom_properties'])
//         : null;
//     url = json['url'];
//     thumb = json['thumb'];
//     icon = json['icon'];
//     formatedSize = json['formated_size'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['file_name'] = this.fileName;
//     data['mime_type'] = this.mimeType;
//     data['disk'] = this.disk;
//     data['size'] = this.size;
//
//     data['url'] = this.url;
//     data['thumb'] = this.thumb;
//     data['icon'] = this.icon;
//     data['formated_size'] = this.formatedSize;
//     return data;
//   }
// }

class CustomProperties {
  String uuid;
  int userId;
  GeneratedConversions generatedConversions;

  CustomProperties({this.uuid, this.userId, this.generatedConversions});

  CustomProperties.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    userId = json['user_id'];
    generatedConversions = json['generated_conversions'] != null
        ? new GeneratedConversions.fromJson(json['generated_conversions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['user_id'] = this.userId;
    if (this.generatedConversions != null) {
      data['generated_conversions'] = this.generatedConversions.toJson();
    }
    return data;
  }
}

class GeneratedConversions {
  bool thumb;
  bool icon;

  GeneratedConversions({this.thumb, this.icon});

  GeneratedConversions.fromJson(Map<String, dynamic> json) {
    thumb = json['thumb'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumb'] = this.thumb;
    data['icon'] = this.icon;
    return data;
  }
}